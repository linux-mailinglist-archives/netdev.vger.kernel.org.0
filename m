Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3EA372FAB74
	for <lists+netdev@lfdr.de>; Mon, 18 Jan 2021 21:29:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437862AbhARU27 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jan 2021 15:28:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2394275AbhARU2D (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jan 2021 15:28:03 -0500
Received: from mail-io1-xd30.google.com (mail-io1-xd30.google.com [IPv6:2607:f8b0:4864:20::d30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FEB7C061573
        for <netdev@vger.kernel.org>; Mon, 18 Jan 2021 12:27:23 -0800 (PST)
Received: by mail-io1-xd30.google.com with SMTP id p72so10514246iod.12
        for <netdev@vger.kernel.org>; Mon, 18 Jan 2021 12:27:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=/ZcvbT6AF0SDt3raTqFmlpYbGZpm2CzZoWz0dyO2R3E=;
        b=H8aqQzIov8ltM4iRkrkRJrUTXpvGB78TW0U+0nDG3mkhKkvkIMVfBCivYcvY9s8fuo
         M+r5BmXld4QY22ED4KAd1KSWq7Cut9PUcll6k9/L3MAphdrfurBqCmfdcbCaJGZkiJDv
         o1/Pr9JxHSO2IeFgucJs8RhnSZBZTTWM+DFtUoADVu0kkoZxoMgNMlErRyeN4zR82AqG
         9il84Gjc+MRLcOs2kFo7tLSMGddj8lyeAoe+dv40xolHVfm1HosCR5JRO3EHe4O+eSdh
         7ufRkWQktcRlP8ATH5+Hi5BCZ9l7YNr+J5edj99HVtocS8rXZtfggrxn+bhwZfsTFJHI
         D+yQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=/ZcvbT6AF0SDt3raTqFmlpYbGZpm2CzZoWz0dyO2R3E=;
        b=EEDjRbe9nqUR6NdpBVQIZWhYBAM9Z+qnv5sWqkDbyXqAApZ6l/4Cskz2HAMtbBo/aZ
         vlw1K4t7BNu0Wwe5a0V3sY9zCKDASidP0PXF9k6F35Z8APseT+RsFtAp2z37fOR8hR+k
         pkK6BejLWVUOh5ygWTP55QCT4YTkOWk4yHPoKbwV7XXemqp6QoRY361J2saeNDrSHOnH
         602KOyoTG8Uw5EqDVlHjIaWasDdfodxV/m78SalpAOl5OG9Ggde4O8IiATGKWEoPU3aT
         57HHTDyCx+QKvefxsQN36lmSdOokrP9nLXVcNybX9hcn9yLDIJU7qvpSnpO/sN2wza/X
         xbbQ==
X-Gm-Message-State: AOAM533jOo5fp8dhDUyZPAe7ruD5nc0oxiSZCWOZdt8PSmKkbssPdXfL
        kU2ucVFSJyh8mus9sT6PxS/jOQ==
X-Google-Smtp-Source: ABdhPJzWifr7Y4zevVpedN+gghkDp67vMvj0w0mZ/sfMDRFiB62OPGk05uqniUq93OOIYfEAOYVsRg==
X-Received: by 2002:a92:1e08:: with SMTP id e8mr768654ile.16.1611001642515;
        Mon, 18 Jan 2021 12:27:22 -0800 (PST)
Received: from [172.22.22.26] (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.googlemail.com with ESMTPSA id k10sm1943640ili.54.2021.01.18.12.27.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 18 Jan 2021 12:27:21 -0800 (PST)
Subject: Re: [PATCH net-next 7/7] net: ipa: allow arbitrary number of
 interconnects
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, evgreen@chromium.org,
        bjorn.andersson@linaro.org, cpratapa@codeaurora.org,
        subashab@codeaurora.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20210115125050.20555-1-elder@linaro.org>
 <20210115125050.20555-8-elder@linaro.org>
 <20210116191207.277a391a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <466069e3-2658-5ba7-7704-2cac3293f79a@linaro.org>
 <20210118115816.149d71f6@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Alex Elder <elder@linaro.org>
Message-ID: <b2c4b28b-bd13-b058-ddf7-737b12641806@linaro.org>
Date:   Mon, 18 Jan 2021 14:27:20 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <20210118115816.149d71f6@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/18/21 1:58 PM, Jakub Kicinski wrote:
> But it does sound a little too much like aligning with the vendor
> driver for the sake of aligning with the vendor driver. This makes 
> the review for someone not familiar with the vendor driver hard, 
> and raises questions like "is this really needed upstream or just
> downstream / out-of-tree". Please try to reorient the work towards
> implementing particular pieces of functionality upstream start to end. 

I have lots of this kind of preparatory work "ready to go" and I'm
eager to get it upstream.  But I'll try to be more patient and wait
to send things out until something justifies the need, rather than
just doing it in support of a longer-term goal.

I would not consider what I'm doing "aligning with the vendor
driver," but maybe I misunderstand your meaning.  The upstream
driver is very different from Qualcomm's driver.  I'm basically
writing all new code now, using the Qualcomm code for reference.

Thank you very much for applying the patches.

					-Alex
