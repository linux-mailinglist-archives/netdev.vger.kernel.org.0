Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 645EC30F1E4
	for <lists+netdev@lfdr.de>; Thu,  4 Feb 2021 12:18:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235717AbhBDLSH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Feb 2021 06:18:07 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:51347 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235594AbhBDLRH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Feb 2021 06:17:07 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612437341;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=qoCXSM3x1453D5cy2M9+HjONE+SF332T3WjcmPo3zwQ=;
        b=LaBUz0HJRJdUYXCKMVDxdHAd7FBt3xMSiGRxsc13FKs7UCPXDHqO/A3OGZhoR4c2KF7j6a
        g01la/v/zmo5AAQnZMR/6TVoHNnKWu4mBZ/Xhh0DR0Xo4AX/qr5CVzAgnRJmGd/s2s6Sag
        t0VCWk0vKbHJFK3WMaRITrF+p0gpqyQ=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-511-1-k9HWCtMBSTDNqGkwmVQw-1; Thu, 04 Feb 2021 06:15:39 -0500
X-MC-Unique: 1-k9HWCtMBSTDNqGkwmVQw-1
Received: by mail-wr1-f72.google.com with SMTP id r5so2478103wrx.18
        for <netdev@vger.kernel.org>; Thu, 04 Feb 2021 03:15:39 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=qoCXSM3x1453D5cy2M9+HjONE+SF332T3WjcmPo3zwQ=;
        b=Gvlfz19BODH0kp4pxRHwEna3txnBpr5NHtsbsbjZDmvMWMxBqUIiUObC0Y+8n/rZnh
         rg/8pbv4jZ4I5TQ5STB3BZDJRAN5/Mv1K9ua8qvuhsztSWVFfPKEak5MatNcCZ6oCkBU
         YwGd6zoFn7iYbQnGoun/kGF8BgUICwfV1TEn7kykF++ZfgC8ex4JvnmcuAkRCCQcrRpq
         7nMckGB2GcAyaP24uLto0iNU7MrGLzfoxQGE4eEqajxUnliDh1Tlu872t34L3h47QIM0
         TTUlCImTVmN7yU/wFAXpznVy1sKACi+M7tYthzrapFLvnApg9E+ha/k1Huv92AqRiXoo
         LQiA==
X-Gm-Message-State: AOAM532RadW/x7D7OcRkKw8n3pzVq/WY9XZIPXM7lICkhDsXjOeh2QIT
        vmoEIANK5xrzOaVqmmIL8SMY9d6SGkAx8mJd+jz2KyJviJqNAHml+sqN1MAPIt7h21XljcpSwfu
        cFeikzja2LcbzaqFf
X-Received: by 2002:a05:600c:4e91:: with SMTP id f17mr6949390wmq.142.1612437338179;
        Thu, 04 Feb 2021 03:15:38 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwoH31eq0xrG5bA5hKL2moTr1CUTmVw/CmmxcHyW3z5rgCB/yN+sHG1ZHGilqu7BS20kfgfPw==
X-Received: by 2002:a05:600c:4e91:: with SMTP id f17mr6949375wmq.142.1612437338004;
        Thu, 04 Feb 2021 03:15:38 -0800 (PST)
Received: from amorenoz.users.ipa.redhat.com ([94.73.56.18])
        by smtp.gmail.com with ESMTPSA id j4sm7741855wru.20.2021.02.04.03.15.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 04 Feb 2021 03:15:37 -0800 (PST)
Subject: Re: [PATCH iproute2-next v3 0/5] Add vdpa device management tool
To:     Jason Wang <jasowang@redhat.com>, Parav Pandit <parav@nvidia.com>,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        dsahern@gmail.com, stephen@networkplumber.org, mst@redhat.com
References: <20210122112654.9593-3-parav@nvidia.com>
 <20210202103518.3858-1-parav@nvidia.com>
 <99106d07-1730-6ed8-c847-0400be0dcd57@redhat.com>
From:   Adrian Moreno <amorenoz@redhat.com>
Message-ID: <1d1ff638-d498-6675-ead5-6e09213af3a8@redhat.com>
Date:   Thu, 4 Feb 2021 12:15:36 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <99106d07-1730-6ed8-c847-0400be0dcd57@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sorry I have not followed this work as close as I would have wanted.
Some questions below.

On 2/4/21 4:16 AM, Jason Wang wrote:
> 
> On 2021/2/2 下午6:35, Parav Pandit wrote:
>> Linux vdpa interface allows vdpa device management functionality.
>> This includes adding, removing, querying vdpa devices.
>>
>> vdpa interface also includes showing supported management devices
>> which support such operations.
>>
>> This patchset includes kernel uapi headers and a vdpa tool.
>>
>> examples:
>>
>> $ vdpa mgmtdev show
>> vdpasim:
>>    supported_classes net
>>
>> $ vdpa mgmtdev show -jp
>> {
>>      "show": {
>>          "vdpasim": {
>>              "supported_classes": [ "net" ]
>>          }
>>      }
>> }
>>

How can a user establish the relationship between a mgmtdev and it's parent
device (pci vf, sf, etc)?

>> Create a vdpa device of type networking named as "foo2" from
>> the management device vdpasim_net:
>>
>> $ vdpa dev add mgmtdev vdpasim_net name foo2
>>

I guess this command will accept a 'type' parameter once more supported_classes
are added?

Also, will this tool also handle the vdpa driver binding or will the user handle
that through the vdpa bus' sysfs interface?

>> Show the newly created vdpa device by its name:
>> $ vdpa dev show foo2
>> foo2: type network mgmtdev vdpasim_net vendor_id 0 max_vqs 2 max_vq_size 256
>>
>> $ vdpa dev show foo2 -jp
>> {
>>      "dev": {
>>          "foo2": {
>>              "type": "network",
>>              "mgmtdev": "vdpasim_net",
>>              "vendor_id": 0,
>>              "max_vqs": 2,
>>              "max_vq_size": 256
>>          }
>>      }
>> }
>>
>> Delete the vdpa device after its use:
>> $ vdpa dev del foo2
>>
>> Patch summary:
>> Patch-1 adds kernel headers for vdpa subsystem
>> Patch-2 adds library routines for indent handling
>> Patch-3 adds library routines for generic socket communication
>> PAtch-4 adds library routine for number to string mapping
>> Patch-5 adds vdpa tool
>>
>> Kernel headers are from the vhost kernel tree [1] from branch linux-next.
>>
>> [1] https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git
>>
>> ---
> 
> 
> Adding Adrian to see if this looks good for k8s integration.
> 
> Thanks
> 

Thanks
-- 
Adrián Moreno

