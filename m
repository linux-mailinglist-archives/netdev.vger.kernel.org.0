Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DA24716FAD8
	for <lists+netdev@lfdr.de>; Wed, 26 Feb 2020 10:37:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727833AbgBZJhD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Feb 2020 04:37:03 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:44745 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727377AbgBZJhD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Feb 2020 04:37:03 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582709821;
        h=from:from:reply-to:subject:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type;
        bh=05Q/qlazrQBQgStNZTgqIbMF3rU50l1dnIw6ldFHuqo=;
        b=FvhgbXTbaALL87p60TlQeMIKqelJId3Rpd8FHKn2knNOndWIZKUbpikEtNer8DYM1VSZyE
        H5NahyM+LEu1U+tXN1tT1r2HfAlOdSL1rZjkuDdH3kusNGbNdW5tQUBxM8He3+nnflCeCQ
        0w3eeUmCNN4kx43hb/IPrRQ8UgJ2Yj8=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-19-0c0GoxjWM-2d9MU2N1NjaA-1; Wed, 26 Feb 2020 04:33:35 -0500
X-MC-Unique: 0c0GoxjWM-2d9MU2N1NjaA-1
Received: by mail-qk1-f197.google.com with SMTP id c66so3346565qkb.13
        for <netdev@vger.kernel.org>; Wed, 26 Feb 2020 01:33:35 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:mime-version
         :content-disposition;
        bh=05Q/qlazrQBQgStNZTgqIbMF3rU50l1dnIw6ldFHuqo=;
        b=kPh1FVRUClbYfEi7cZLZbeu6zLuSIRoEcgGtpl9g64dM9VU76fmSgZ9PKItimdtsq3
         B4ianvdfGV93C+1W4rZiJ4cggacgvn/8CxPgirTAqpxXEsXnh/j5k1j6T5ZBzFwoAp4x
         PdaEsh3xKDRkTrySEopEQTHrjE2pqzteSmpJU/IL/u1/SJK24rMREicd0/kmEoQnhfxq
         3tug5XkC/8KUx/DX183nWjRMFaPWqHOnB6uWhL7vFGVlHXlGFdirRxLEEk9+Az+6zFlZ
         vNoPFJWDIKQXQyPx8C+9ubuxeU3lIo5IELMrKnWSOy+35Ea17uziKZAjNv7pPY4lX+Qh
         uFJQ==
X-Gm-Message-State: APjAAAVRIdsGAHeeXSfOjfn8+gMBNP+9hloE3c5t8NGYv00ppFTx6xBU
        Elt+QsAB91O1v6ptHNP+r+WaqOfTw5v5j8RzdGU0HPqS1V/BcwRhRId0bGTCVer6r5okd7J1UKc
        /774PPqT675Gj/6vO
X-Received: by 2002:aed:2ac5:: with SMTP id t63mr3770159qtd.315.1582709614767;
        Wed, 26 Feb 2020 01:33:34 -0800 (PST)
X-Google-Smtp-Source: APXvYqxhSm+8kGUuG7I8PAOwYtVo9vMvCK3WLApUZUDftOhMv3ipbXs6XgACJ2Ya8Vhko7yAhKwqNw==
X-Received: by 2002:aed:2ac5:: with SMTP id t63mr3770130qtd.315.1582709614464;
        Wed, 26 Feb 2020 01:33:34 -0800 (PST)
Received: from redhat.com (bzq-79-178-2-214.red.bezeqint.net. [79.178.2.214])
        by smtp.gmail.com with ESMTPSA id w2sm793255qtd.97.2020.02.26.01.33.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Feb 2020 01:33:33 -0800 (PST)
Date:   Wed, 26 Feb 2020 04:33:30 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     David Ahern <dahern@digitalocean.com>
Cc:     Jason Wang <jasowang@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>
Message-ID: <20200226093330.GA711395@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Bcc: 
Subject: Re: virtio_net: can change MTU after installing program
Message-ID: <20200226043257-mutt-send-email-mst@kernel.org>
Reply-To: 
In-Reply-To: <7df5bb7f-ea69-7673-642b-f174e45a1e64@digitalocean.com>

On Tue, Feb 25, 2020 at 08:32:14PM -0700, David Ahern wrote:
> Another issue is that virtio_net checks the MTU when a program is
> installed, but does not restrict an MTU change after:
> 
> # ip li sh dev eth0
> 2: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 xdp qdisc fq_codel
> state UP mode DEFAULT group default qlen 1000
>     link/ether 5a:39:e6:01:a5:36 brd ff:ff:ff:ff:ff:ff
>     prog/xdp id 13 tag c5595e4590d58063 jited
> 
> # ip li set dev eth0 mtu 8192
> 
> # ip li sh dev eth0
> 2: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 8192 xdp qdisc fq_codel
> state UP mode DEFAULT group default qlen 1000
> 
> 

Cc Toke who has tested this on other cards and has some input.

-- 
MST

