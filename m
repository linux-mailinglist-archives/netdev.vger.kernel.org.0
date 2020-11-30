Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D31D22C8622
	for <lists+netdev@lfdr.de>; Mon, 30 Nov 2020 15:03:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727431AbgK3OCG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Nov 2020 09:02:06 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:22732 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726779AbgK3OCG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Nov 2020 09:02:06 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1606744840;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Z1V5TP+t4YgIIKSdanYDtXXCORZzAdrzBJD0xz3ZJJ4=;
        b=Fx9pWjH0FXaqUqVZMjRi1ZeyLBdweaM4y5uI517SHUO808QwC4tN+9U1PA/8Scekri/vGh
        8+LY9YEPm9UTRVHqxNl82e5kLpFz9qtCzyY0ffCbGVSiT1G2ugpIDus1bFalWvd8eCcXtv
        bPymno1homQOdhgbwQeMM11UICU4snI=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-25-TimD5sprMq6NR8Y0jJjhNw-1; Mon, 30 Nov 2020 09:00:21 -0500
X-MC-Unique: TimD5sprMq6NR8Y0jJjhNw-1
Received: by mail-ed1-f70.google.com with SMTP id bc27so6798089edb.18
        for <netdev@vger.kernel.org>; Mon, 30 Nov 2020 06:00:21 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Z1V5TP+t4YgIIKSdanYDtXXCORZzAdrzBJD0xz3ZJJ4=;
        b=THPPtKra+9B1YU925ZkWf/N4dYyTSNFAYS8lLgXKspPqCmyeoCAvrgozMea6eTnxaN
         rr6m/DifkxIaVoq/xzgrWWZ+/978bpopEUu7auOZfr2jeInug9PQFo0sgENB9Gj/PAdE
         4z/Ov4erKcBjkiIPF5dufQLvguyuF0K3xqVGeQl1RDYQlT7l/hOe54zCgUsuNVJqVvsO
         Xl7pTvisujDmcSZPBj7SXLbB677ajnEWpdkG2NKT6tN6C4PTHEurY89tTCweSAWLPkZz
         5p667NxoJqBw37qlTTbIXiuiNnQJ6u+RVJ8Eu9lMREMevPSwtGDyYga5iwyWJk/h817K
         VwJA==
X-Gm-Message-State: AOAM530FVecMOAJ+wnVmhIJB9v4KwIZesIk+rqINrNDnbXKl363vApDg
        skx0RN4/3rfY2Tlcu6QbLI/75dWGSDzQzokW1jC04S8ujR47n8OWULaQoPcyJax8avL36EplC0L
        gvFcJdlDgV1brr9NPpijIKYUAPwg1a5g2/8M9fAlu0bdvSPjVSDKyxo5CLI4dKF8fFMjy
X-Received: by 2002:a17:906:e093:: with SMTP id gh19mr16467934ejb.510.1606744817864;
        Mon, 30 Nov 2020 06:00:17 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxPMhCAxuB2B/TcTZz4LyxRjBTd2O6WcbKZeK0qo3nFya2kmMSturj18lyD86gg2TrlnvR3iQ==
X-Received: by 2002:a17:906:e093:: with SMTP id gh19mr16467362ejb.510.1606744815303;
        Mon, 30 Nov 2020 06:00:15 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id f25sm8943114edr.53.2020.11.30.06.00.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 30 Nov 2020 06:00:14 -0800 (PST)
Subject: Re: [PATCH AUTOSEL 5.9 22/33] vhost scsi: add lun parser helper
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org,
        Mike Christie <michael.christie@oracle.com>,
        Jason Wang <jasowang@redhat.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        netdev@vger.kernel.org
References: <20201125153550.810101-22-sashal@kernel.org>
 <25cd0d64-bffc-9506-c148-11583fed897c@redhat.com>
 <20201125180102.GL643756@sasha-vm>
 <9670064e-793f-561e-b032-75b1ab5c9096@redhat.com>
 <20201129041314.GO643756@sasha-vm>
 <7a4c3d84-8ff7-abd9-7340-3a6d7c65cfa7@redhat.com>
 <20201129210650.GP643756@sasha-vm>
 <e499986d-ade5-23bd-7a04-fa5eb3f15a56@redhat.com>
 <X8TzeoIlR3G5awC6@kroah.com>
 <17481d8c-c19d-69e3-653d-63a9efec2591@redhat.com>
 <X8T6RWHOhgxW3tRK@kroah.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <8809319f-7c5b-1e85-f77c-bbc3f22951e4@redhat.com>
Date:   Mon, 30 Nov 2020 15:00:13 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <X8T6RWHOhgxW3tRK@kroah.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 30/11/20 14:57, Greg KH wrote:
>> Every patch should be "fixing a real issue"---even a new feature.  But the
>> larger the patch, the more the submitters and maintainers should be trusted
>> rather than a bot.  The line between feature and bugfix_sometimes_  is
>> blurry, I would say that in this case it's not, and it makes me question how
>> the bot decided that this patch would be acceptable for stable (which AFAIK
>> is not something that can be answered).
> I thought that earlier Sasha said that this patch was needed as a
> prerequisite patch for a later fix, right?  If not, sorry, I've lost the
> train of thought in this thread...

Yeah---sorry I am replying to 22/33 but referring to 23/33, which is the 
one that in my opinion should not be blindly accepted for stable kernels 
without the agreement of the submitter or maintainer.

Paolo

