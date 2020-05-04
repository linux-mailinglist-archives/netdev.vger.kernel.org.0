Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 12B831C4A02
	for <lists+netdev@lfdr.de>; Tue,  5 May 2020 01:04:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728309AbgEDXEZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 May 2020 19:04:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728182AbgEDXEZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 May 2020 19:04:25 -0400
Received: from mail-qt1-x844.google.com (mail-qt1-x844.google.com [IPv6:2607:f8b0:4864:20::844])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E42BBC061A0E
        for <netdev@vger.kernel.org>; Mon,  4 May 2020 16:04:24 -0700 (PDT)
Received: by mail-qt1-x844.google.com with SMTP id o10so493498qtr.6
        for <netdev@vger.kernel.org>; Mon, 04 May 2020 16:04:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=UokQRbi80BC9ekM9D+zmyLH/FUVBnlx91dFtdhfAQVU=;
        b=Usn38V3ZPYHhJR58y0xLzkptgrYM6nZAij/keEXqdjamIIm8IC8ySsU4H6BD1fUe7y
         oBhshCGugEV5jyB5cL2uBo+UpTgAnL6Ibgm3LAnmf0U4WmHcZhYNFBOvBQdM1Zr9JVkC
         D9tgkglhMTi8r/pW0+ts0RdODK+XUAKQs/fVkoBst3Jc7f+sYjFC/NeWr1E+/NBjtoVl
         ApUMgvWulLjwwVGX9cj3YNLr0IIf4h12tn3ihz/18pOUFFxuoLzoP6004TQZg3RIjppr
         k+fkMRNnop2s0oO3y1NJ92HGK5UZ/p/tIxoL2y+k8MYxIpFId7bJYKBiVTouu8atx+hE
         KYWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=UokQRbi80BC9ekM9D+zmyLH/FUVBnlx91dFtdhfAQVU=;
        b=Q4uMwAFXvLYhXiYoafNZrOW1bvRyXSrws/5Uq6EZ87yh8TtFLdEhZh+wNUd5n+7lEv
         nRjPUtBvwNQ5cFNkxQgxcdz/cDoY0t4S18yjh1qxN6dMM/3/xJDLxU7QHSqVwCHK55BG
         daCeH11r6RavX7VxN1HkXninOALPvahM1h9MKIZ5I89xz2OeSSSGDafWRiftry28W1dW
         txFTcgZ3BuMuUaj1Syy2uUICyYw16qLPpGO8ax0VcM4JI2Ld2XuKU25we6qQINkJuPeR
         bCQgGitHvXtgjMSftSEuXYMSrqj+bN74BhrBBbcBzTbGnzze10pQpSwjrLdt0H5uH+zB
         4pqw==
X-Gm-Message-State: AGi0PubnZutMl5eGkJCu0Okk6ygbp5D4H7hvSaioiUhD0hAxlruz0GFG
        bngeJZOdguElshzAMAP92gV9eRB8
X-Google-Smtp-Source: APiQypJf1F0A6Gp5PsH/2+7o+F1B4m4Eg+rjrzxN+CzRhTBlt454GwtMLKNRUnB5gsr0z0CODQgGpw==
X-Received: by 2002:ac8:3874:: with SMTP id r49mr52966qtb.66.1588633463752;
        Mon, 04 May 2020 16:04:23 -0700 (PDT)
Received: from ?IPv6:2601:282:803:7700:4fe:5250:d314:f77b? ([2601:282:803:7700:4fe:5250:d314:f77b])
        by smtp.googlemail.com with ESMTPSA id w134sm423548qkb.47.2020.05.04.16.04.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 04 May 2020 16:04:22 -0700 (PDT)
Subject: Re: max channels for mlx5
To:     Saeed Mahameed <saeedm@mellanox.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <198081c2-cb0d-e1d5-901c-446b63c36706@gmail.com>
 <2f5110e579a21737e5c13b23482eff6fdb6f3808.camel@mellanox.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <f11d1ff2-b16b-37d3-0e17-4a051c29a9b5@gmail.com>
Date:   Mon, 4 May 2020 17:04:21 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <2f5110e579a21737e5c13b23482eff6fdb6f3808.camel@mellanox.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/4/20 3:46 PM, Saeed Mahameed wrote:
> what is the amount of msix avaiable for eth0 port ?
> 
> businfo=$(ethtool -i eth0 | grep bus-info | cut -d":" -f2-)
> cat /proc/interrupts | grep $businfo | wc -l

64

> 
> So if number of msix is 64, we can only use 63 for data path
> completions .. 
> 
> do you have sriov enabled ? 

no

> 
> what is the FW version you have ?

$ ethtool -i eth0
driver: mlx5_core
version: 5.0-0
firmware-version: 14.27.1016 (MT_2420110034)

> we need to figure out if this is a system MSIX limitation or a FW
> limitation.
> 
>> A side effect of this limit is XDP_REDIRECT drops packets if a vhost
>> thread gets scheduled on cpus 64 and up since the tx queue is based
>> on
>> processor id:
>>
>> int mlx5e_xdp_xmit(struct net_device *dev, int n, struct xdp_frame
>> **frames,
>>                    u32 flags)
>> {
>> 	...
>>         sq_num = smp_processor_id();
>>         if (unlikely(sq_num >= priv->channels.num))
>>                 return -ENXIO;
>>
>> So in my example if the redirect happens on cpus 64-95, which is 1/3
>> of
>> my hardware threads, the packet is just dropped.
>>
> 
> Know XDP redirect issue,  you need to tune the RSS and affinity on RX
> side and match TX count and affinity on TX side, so you won't end up on
> a wrong CPU on the TX side

Understood for port to port redirect.

This use case is a virtual machine with a tap device + vhost bypassing
host kernel stack and redirecting to a port. Losing a third of the cpus
for vhost threads is a huge limitation.
