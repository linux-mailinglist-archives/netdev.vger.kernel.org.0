Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 098F326E515
	for <lists+netdev@lfdr.de>; Thu, 17 Sep 2020 21:10:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726436AbgIQTKI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Sep 2020 15:10:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726409AbgIQTIs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Sep 2020 15:08:48 -0400
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51671C06174A
        for <netdev@vger.kernel.org>; Thu, 17 Sep 2020 12:08:48 -0700 (PDT)
Received: by mail-pf1-x441.google.com with SMTP id k15so1809853pfc.12
        for <netdev@vger.kernel.org>; Thu, 17 Sep 2020 12:08:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=VKv6z07aYQPsxB48QNXJUQzrVe584fxJmB3mzOp7sH8=;
        b=NVSjVijZBRh8G4hBlxfKRnjwyqRk9uT+XDBF3HxP8YjoApin00YX8QVU2eySzc0uEe
         AoNB4OyxAP3zR/L1s9cM6RC+FV/Mi6La+IR2ivp6TZAnIhACwgnebTLVH05QimQRxNSh
         TlAP69lxukYWDI1zdLCiIzcj3I+foMW27cbEuIDVzY/xWmmEr7EaGyDoltcDnT/Nnkmc
         4lPJ9Nn+CAHi8HkdC7WG2iOy27dGOE95AZtoLNdao8zypRgRLd0pz8QM1qGckWl86NEV
         WE3jBZHUuU3Xj8bduENhiHaATuFKhup5Z0w94MuSlXLYod/Dm5E/zkDs1ZxTq2pC+L3d
         /e/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=VKv6z07aYQPsxB48QNXJUQzrVe584fxJmB3mzOp7sH8=;
        b=PVQwFoB0jZh9Xb5+8+WOz9C8rGhoiNA/yrHzPqRcPgZq0ci3ZZfYRwi9lMr2unq3eC
         83O1sih0N5DJRn0qisuDAJRfUQzUj7V6cUER0dGMwZM6sKHV6t4t/UUe5MeM1fyRao/j
         n2aPOBMY73izU93R+32bweyC2rapbzU13EXVi7TQFV/Wms0TQ6OJMe8QldDioFRiC5fz
         EotN3ZxugXc7RNZHiIQoWnJtuoMI65AaOcFQ58YfDVhekMEx2KT37zvE7zwS3YsZReZo
         5HiF3Me4MIjBhfRZdZ8OMwtIKAE9O+yWrR4C1EbIiVFcnkn4H+OOSWA//5sRxbUGIMNt
         vZKg==
X-Gm-Message-State: AOAM530+tNrMYdKQC/HYzCVRcpfN85mc5pR+0mSLGuB48lzocTXi0CG9
        FYFiMKaK2Og7yncC6DcCTDcIPmxUtfXvQw==
X-Google-Smtp-Source: ABdhPJykPsrYID2dHTgW5BkvE0hV1y7RZkg+QNFbGb/EkyyB3qTKE1UvuqKeMwTTKiUHKnZ4Nmp8RQ==
X-Received: by 2002:aa7:82ce:0:b029:142:2501:35cb with SMTP id f14-20020aa782ce0000b0290142250135cbmr12555727pfn.43.1600369727854;
        Thu, 17 Sep 2020 12:08:47 -0700 (PDT)
Received: from Shannons-MacBook-Pro.local (static-50-53-47-17.bvtn.or.frontiernet.net. [50.53.47.17])
        by smtp.gmail.com with ESMTPSA id r4sm421855pjf.4.2020.09.17.12.08.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 17 Sep 2020 12:08:47 -0700 (PDT)
Subject: Re: [PATCH net-next] ionic: add DIMLIB to Kconfig
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net
References: <20200917184243.11994-1-snelson@pensando.io>
 <20200917120243.045975ac@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Shannon Nelson <snelson@pensando.io>
Message-ID: <a17b550c-1db1-d32e-f69c-d51bb4a1ca2b@pensando.io>
Date:   Thu, 17 Sep 2020 12:08:45 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20200917120243.045975ac@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/17/20 12:02 PM, Jakub Kicinski wrote:
> On Thu, 17 Sep 2020 11:42:43 -0700 Shannon Nelson wrote:
>>>> ld.lld: error: undefined symbol: net_dim_get_rx_moderation
>>     >>> referenced by ionic_lif.c:52 (drivers/net/ethernet/pensando/ionic/ionic_lif.c:52)
>>     >>> net/ethernet/pensando/ionic/ionic_lif.o:(ionic_dim_work) in archive drivers/built-in.a
>> --
> This is going to cut off the commit message when patch is applied.

Isn't the trigger a three dash string?  It is only two dashes, not 
three, and "git am" seems to work correctly for me.  Is there a 
different mechanism I need to watch out for?

sln


>
>>>> ld.lld: error: undefined symbol: net_dim
>>     >>> referenced by ionic_txrx.c:456 (drivers/net/ethernet/pensando/ionic/ionic_txrx.c:456)
>>     >>> net/ethernet/pensando/ionic/ionic_txrx.o:(ionic_dim_update) in archive drivers/built-in.a
>>
>> Fixes: 04a834592bf5 ("ionic: dynamic interrupt moderation")
>> Reported-by: kernel test robot <lkp@intel.com>
>> Signed-off-by: Shannon Nelson <snelson@pensando.io>

