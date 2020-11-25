Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 73FF62C4740
	for <lists+netdev@lfdr.de>; Wed, 25 Nov 2020 19:10:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732883AbgKYSJC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Nov 2020 13:09:02 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:47222 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732380AbgKYSJC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Nov 2020 13:09:02 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1606327740;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Rj8pm+nQSaWFTSOSQtYB5Wd34YMZOLy1lTAyR9VrKmQ=;
        b=XulTEkHu7JY+ucXZyG5ZQtYtNRJgSuvq2NWcYK3yLoH+FkMmm51iu/W/I3odgUZ1QhcNEG
        y1tEe5KUKuq37FSgQQGZhQGa/K3JA8FGcCYtatc3cX4mxxm0aYTsOPe5nLiI3aqTYJ8Qoi
        6DnZ5eiEG2zxe1ZP1AHuUvAGCJvb1wc=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-106-14BXPOlaPGWYvMc9TB1aag-1; Wed, 25 Nov 2020 13:08:58 -0500
X-MC-Unique: 14BXPOlaPGWYvMc9TB1aag-1
Received: by mail-wm1-f70.google.com with SMTP id y26so642910wmj.7
        for <netdev@vger.kernel.org>; Wed, 25 Nov 2020 10:08:57 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Rj8pm+nQSaWFTSOSQtYB5Wd34YMZOLy1lTAyR9VrKmQ=;
        b=SIv05Uge5AK+h82FA5vTNzT0jcupG9q8XautRijhtT2d3cZbjE0oN+yDNYsapEWM/0
         +CqnsHDmxUKfZXfTAmqv1LuJ4Iv9kbeShXjQYeKBip48pblibsEu5cIQa6uD3VBK07r0
         dgSlsvh7O5qlxvVc837+Wa0J0DKssIVEMZpkFc8ZDyrXY25oQNAOXI95acTJtBdntzzu
         gItCaLJzDct1urn4em8ldkg9pyVfcMjB47jLr+GwNuTftUq/+aamkz4L8CdCM3Rv6jLe
         s514m92GkVomKOLv3jLvf5dwVvZKKBY7UfTQj4jq+X/L1iDX1siqQ5QR7nTm4CRk/fDq
         h5cg==
X-Gm-Message-State: AOAM530FM0C9vJ5/x+tpxDWCVhUxnoG+KuT+WfQm6ox3P24FW1EvmNjv
        mACcKXJ0Gw2V5CPkWRkEwHHoOafEc83aC38M7iazJS5avdTjGGAm05HkLxjKeBAl6QRfez0qF2k
        7hiA7OeLFVVzyFiqbcNEMZd5IvARCnFsu8Vo7moJTkPzoYqZ0bTXWpVlIcBK2aNzf12pZ
X-Received: by 2002:adf:ef4c:: with SMTP id c12mr5540361wrp.242.1606327736152;
        Wed, 25 Nov 2020 10:08:56 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxr+ms6q6YSMPBxk+kd6cVidxefnBIvfyT4mWfT6nuSapnRRjueuuLmnfqST9DIl1NBvcw1gQ==
X-Received: by 2002:adf:ef4c:: with SMTP id c12mr5540332wrp.242.1606327735945;
        Wed, 25 Nov 2020 10:08:55 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id d17sm5450435wro.62.2020.11.25.10.08.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 25 Nov 2020 10:08:55 -0800 (PST)
Subject: Re: [PATCH AUTOSEL 5.9 22/33] vhost scsi: add lun parser helper
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Mike Christie <michael.christie@oracle.com>,
        Jason Wang <jasowang@redhat.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        netdev@vger.kernel.org
References: <20201125153550.810101-1-sashal@kernel.org>
 <20201125153550.810101-22-sashal@kernel.org>
 <25cd0d64-bffc-9506-c148-11583fed897c@redhat.com>
 <20201125180102.GL643756@sasha-vm>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <9670064e-793f-561e-b032-75b1ab5c9096@redhat.com>
Date:   Wed, 25 Nov 2020 19:08:54 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <20201125180102.GL643756@sasha-vm>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 25/11/20 19:01, Sasha Levin wrote:
> On Wed, Nov 25, 2020 at 06:48:21PM +0100, Paolo Bonzini wrote:
>> On 25/11/20 16:35, Sasha Levin wrote:
>>> From: Mike Christie <michael.christie@oracle.com>
>>>
>>> [ Upstream commit 18f1becb6948cd411fd01968a0a54af63732e73c ]
>>>
>>> Move code to parse lun from req's lun_buf to helper, so tmf code
>>> can use it in the next patch.
>>>
>>> Signed-off-by: Mike Christie <michael.christie@oracle.com>
>>> Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
>>> Acked-by: Jason Wang <jasowang@redhat.com>
>>> Link: 
>>> https://lore.kernel.org/r/1604986403-4931-5-git-send-email-michael.christie@oracle.com 
>>>
>>> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
>>> Acked-by: Stefan Hajnoczi <stefanha@redhat.com>
>>> Signed-off-by: Sasha Levin <sashal@kernel.org>
>>
>> This doesn't seem like stable material, does it?
> 
> It went in as a dependency for efd838fec17b ("vhost scsi: Add support
> for LUN resets."), which is the next patch.

Which doesn't seem to be suitable for stable either...  Patch 3/5 in the 
series might be (vhost scsi: fix cmd completion race), so I can 
understand including 1/5 and 2/5 just in case, but not the rest.  Does 
the bot not understand diffstats?

Paolo

