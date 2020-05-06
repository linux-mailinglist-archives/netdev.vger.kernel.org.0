Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 696811C7B4C
	for <lists+netdev@lfdr.de>; Wed,  6 May 2020 22:32:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728535AbgEFUci (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 May 2020 16:32:38 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:43472 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727102AbgEFUci (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 May 2020 16:32:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588797156;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1VXIoJyVGTqnv0xmGyjiKd0uopuusoRfelVhVxRM1M0=;
        b=dW3kreN06TogibFj3ir5CE4exSsnCRLzFbg4EV2kEC/Jbc9JPmDLRBQSAL1TuOLvyegXmx
        5h8BrPjhsZOO6/WVr66ZdUBTVKdXWJCC61ElRut9342rLlHzFhSq9zIphWRMx+FyYjOj/p
        T8aQlH9LEpnbQ/2evrsYE5ZmCzxhMNk=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-199-W59yRL--OpeQnGv3LKEGIA-1; Wed, 06 May 2020 16:32:34 -0400
X-MC-Unique: W59yRL--OpeQnGv3LKEGIA-1
Received: by mail-wr1-f70.google.com with SMTP id f2so1933419wrm.9
        for <netdev@vger.kernel.org>; Wed, 06 May 2020 13:32:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:content-transfer-encoding:from:mime-version
         :subject:date:message-id:references:cc:in-reply-to:to;
        bh=1VXIoJyVGTqnv0xmGyjiKd0uopuusoRfelVhVxRM1M0=;
        b=MkW1C5dTe50vZ3oRiT6y6lxltB1RHMQkkGgm3dN+V9oSkRnLTHx2pZ5sO2NUfqtW2S
         ZTy7E76Vv06pKJPxHwylJcNH+91GZbkcFkub6Yn9nF7CKPQYssePVW9IQEFD0MdOr9et
         7eaHKALLqxUU9+IQDlhT4AUpNtPQ7uqrvtWyCalP9DVEl7zFgXiOPtIb2A97rz5XmX+o
         VgCT++1hNALaw/m7PsDvqy/PPnjxoDzwczcHrmMLwEemdWPSrJbPAfXStQynxPIbVw7w
         WuxOe1o/jvuAbdjkbxwOiufHPu0rNyJZiFdkWAGhsEKbvuo6QgU8mCKIhcF7HX+6VXv1
         di1A==
X-Gm-Message-State: AGi0Puah1XfoVlqqAZDoa3R+qjuT8S6WPEaXD0/xAc7a28j9gstzq9ot
        /7LFMyfcpkpPwaau7xXbmL4Dyy+VDrvaDUeGrUZ2w6kvKGLfVeLVYdVnaKpymioxvSGlhYfQzBO
        9czmBX1Ny2nZdE92g
X-Received: by 2002:a1c:1985:: with SMTP id 127mr6863941wmz.13.1588797153238;
        Wed, 06 May 2020 13:32:33 -0700 (PDT)
X-Google-Smtp-Source: APiQypJv7PfYup3I6WYvehP//5E0f+r/yzOVi/hf1AH4YTqq+ORSfr5YBr27by97VoXD8zbqpFHwKQ==
X-Received: by 2002:a1c:1985:: with SMTP id 127mr6863918wmz.13.1588797152983;
        Wed, 06 May 2020 13:32:32 -0700 (PDT)
Received: from [192.168.3.122] (p5B0C679D.dip0.t-ipconnect.de. [91.12.103.157])
        by smtp.gmail.com with ESMTPSA id i25sm4449561wml.43.2020.05.06.13.32.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 06 May 2020 13:32:32 -0700 (PDT)
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
From:   David Hildenbrand <david@redhat.com>
Mime-Version: 1.0 (1.0)
Subject: Re: [vhost:vhost 8/22] drivers/virtio/virtio_mem.c:1375:20: error: implicit declaration of function 'kzalloc'; did you mean 'vzalloc'?
Date:   Wed, 6 May 2020 22:32:31 +0200
Message-Id: <37C99432-6290-4130-B0AF-953DDE09D5DC@redhat.com>
References: <20200506162751-mutt-send-email-mst@kernel.org>
Cc:     David Hildenbrand <david@redhat.com>,
        kbuild test robot <lkp@intel.com>, kbuild-all@lists.01.org,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, Pankaj Gupta <pankaj.gupta.linux@gmail.com>
In-Reply-To: <20200506162751-mutt-send-email-mst@kernel.org>
To:     "Michael S. Tsirkin" <mst@redhat.com>
X-Mailer: iPhone Mail (17D50)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> Am 06.05.2020 um 22:28 schrieb Michael S. Tsirkin <mst@redhat.com>:
>=20
> =EF=BB=BFOn Tue, May 05, 2020 at 06:22:51PM +0200, David Hildenbrand wrote=
:
>>> On 05.05.20 18:20, Michael S. Tsirkin wrote:
>>> On Tue, May 05, 2020 at 05:46:44PM +0200, David Hildenbrand wrote:
>>>> On 05.05.20 17:44, Michael S. Tsirkin wrote:
>>>>> On Tue, May 05, 2020 at 04:50:13PM +0200, David Hildenbrand wrote:
>>>>>> On 05.05.20 16:15, kbuild test robot wrote:
>>>>>>> tree:   https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.gi=
t vhost
>>>>>>> head:   da1742791d8c0c0a8e5471f181549c4726a5c5f9
>>>>>>> commit: 7527631e900d464ed2d533f799cb0da2b29cc6f0 [8/22] virtio-mem: P=
aravirtualized memory hotplug
>>>>>>> config: x86_64-randconfig-b002-20200505 (attached as .config)
>>>>>>> compiler: gcc-7 (Ubuntu 7.5.0-6ubuntu2) 7.5.0
>>>>>>> reproduce:
>>>>>>>        git checkout 7527631e900d464ed2d533f799cb0da2b29cc6f0
>>>>>>>        # save the attached .config to linux build tree
>>>>>>>        make ARCH=3Dx86_64=20
>>>>>>>=20
>>>>>>> If you fix the issue, kindly add following tag as appropriate
>>>>>>> Reported-by: kbuild test robot <lkp@intel.com>
>>>>>>>=20
>>>>>>> All error/warnings (new ones prefixed by >>):
>>>>>>>=20
>>>>>>>   drivers/virtio/virtio_mem.c: In function 'virtio_mem_probe':
>>>>>>>>> drivers/virtio/virtio_mem.c:1375:20: error: implicit declaration o=
f function 'kzalloc'; did you mean 'vzalloc'? [-Werror=3Dimplicit-function-d=
eclaration]
>>>>>>>     vdev->priv =3D vm =3D kzalloc(sizeof(*vm), GFP_KERNEL);
>>>>>>>                       ^~~~~~~
>>>>>>>                       vzalloc
>>>>>>>>> drivers/virtio/virtio_mem.c:1375:18: warning: assignment makes poi=
nter from integer without a cast [-Wint-conversion]
>>>>>>>     vdev->priv =3D vm =3D kzalloc(sizeof(*vm), GFP_KERNEL);
>>>>>>>                     ^
>>>>>>>>> drivers/virtio/virtio_mem.c:1419:2: error: implicit declaration of=
 function 'kfree'; did you mean 'vfree'? [-Werror=3Dimplicit-function-declar=
ation]
>>>>>>>     kfree(vm);
>>>>>>>     ^~~~~
>>>>>>>     vfree
>>>>>>>   cc1: some warnings being treated as errors
>>>>>>>=20
>>>>>>> vim +1375 drivers/virtio/virtio_mem.c
>>>>>>=20
>>>>>> Guess we simply need
>>>>>>=20
>>>>>> #include <linux/slab.h>
>>>>>>=20
>>>>>> to make it work for that config.
>>>>>=20
>>>>>=20
>>>>> OK I added that in the 1st commit that introduced virtio-mem.
>>>>=20
>>>> Thanks. I have some addon-patches ready, what's the best way to continu=
e
>>>> with these?
>>>=20
>>> If these are bugfixes, just respin the series (including this fix).
>>=20
>> There are two really minor bugfixes for corner-case error handling and
>> one simplification. I can squash them and resend, makes things easier.
>=20
> OK try to do it ASAP, we don't want to repeat the drama we had with vdpa.
>=20

Yeah, did some more testing today. Will send v3 out tomorrow.

Cheers!=

