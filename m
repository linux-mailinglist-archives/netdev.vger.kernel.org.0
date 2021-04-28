Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2384D36E009
	for <lists+netdev@lfdr.de>; Wed, 28 Apr 2021 22:00:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241793AbhD1UBI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Apr 2021 16:01:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232291AbhD1UBH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Apr 2021 16:01:07 -0400
Received: from mail-lf1-x136.google.com (mail-lf1-x136.google.com [IPv6:2a00:1450:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BD63C061573;
        Wed, 28 Apr 2021 13:00:21 -0700 (PDT)
Received: by mail-lf1-x136.google.com with SMTP id 4so41281931lfp.11;
        Wed, 28 Apr 2021 13:00:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=WkwP3OmlZfDc9cjbC9rcOBehBa/A6PUdbfUfZAUxnR8=;
        b=tfsElU8Cj3D7e3HPZ3svdY92YWYxn7tffvIaN75+DKQ8pAhhKNkMzhWUMHiGvXwGjC
         PmgW2zWN1GTq0wnOPtmjzBfdntp9tJiCcRjiynLhPlQ7/mVryKIrqXGxnOTOH0PzWyLc
         9TXzpt3ShovOw+KdV8p9xiy4cDCWBeuW5gosIQVlNoUmWUrsXfOMPS8PZKQ04fCXhovE
         L4lLhxruEdoSkhTsdy0GvxVFNCnASv7fxVkBt+qKrwiYs6y/9Ge8qkP/T3a1DXeNNHyv
         1vOS1cxvQZvFmRab1lsEXrbfq4A6lF4DGlpp8cIwUJplGHxM52Hau36mhNruP9WglGJG
         qrGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=WkwP3OmlZfDc9cjbC9rcOBehBa/A6PUdbfUfZAUxnR8=;
        b=V9KgfH/Hf4HM1Z/LVxobhMFsdRJ26LHMhXWTuggpbmsvprN8ro5FjqHykk/aa857k3
         t1IxxUzoq9xYO7LrTeG95ZCZcfm/DyTKvolYDd7xBsWLv96gRS1SQpiSKKQxX/JzvVGM
         nqMAbL7FWvQXo14wkK+r4LPm9QL4Ug86d8POc2J6ClT3n8/ymMW9bvFZrgHhy8KcvR0T
         W2FuMl2WM0WoyAmY/hoUGGb0pm6DPqSMH+2YETXsTqQYxcrJW6bl/kEnsnt+UtYm7sTA
         AKP1RkwogY7s/OJVB+FoEj1S//ubipJSruZNJMh+AY01RNxarGfkfSspLg1EiKTP4CgR
         jwGA==
X-Gm-Message-State: AOAM531n0gcQHkWRR3rvozLu8+iWHttwz/cwS1gG5l13G0S0aj2bcBq0
        qVp/R/aR1cNZ+lEBMC27TDk=
X-Google-Smtp-Source: ABdhPJzaPKVnlK78R8K4uuSg4U5lmKJhRKc5E+AVtGK8NrK4r4O5qk6taEJD/nSULejYW+rjc5SNLg==
X-Received: by 2002:a05:6512:344d:: with SMTP id j13mr4299538lfr.369.1619640020113;
        Wed, 28 Apr 2021 13:00:20 -0700 (PDT)
Received: from localhost.localdomain (ip-194-187-74-233.konfederacka.maverick.com.pl. [194.187.74.233])
        by smtp.googlemail.com with ESMTPSA id y14sm165696ljy.18.2021.04.28.13.00.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 28 Apr 2021 13:00:19 -0700 (PDT)
Subject: Re: [PATCH] brcm: Add a link to enable khadas VIM2's WiFi
To:     Jian-Hong Pan <jhp@endlessos.org>, linux-firmware@kernel.org
Cc:     linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        SHA-cyfmac-dev-list@infineon.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux@endlessos.org
References: <20210428083230.8137-1-jhp@endlessos.org>
From:   =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Message-ID: <c62e9f94-25fc-6791-c328-5454abc403b9@gmail.com>
Date:   Wed, 28 Apr 2021 22:00:17 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <20210428083230.8137-1-jhp@endlessos.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 28.04.2021 10:32, Jian-Hong Pan wrote:
> According to kernel message on khadas VIM2 board equipped with BCM4356:
> 
> brcmfmac: brcmf_fw_alloc_request: using brcm/brcmfmac4356-sdio for chip BCM4356/2
> usbcore: registered new interface driver brcmfmac
> brcmfmac mmc0:0001:1: Direct firmware load for brcm/brcmfmac4356-sdio.khadas,vim2.txt failed with error -2
> brcmfmac mmc0:0001:1: Direct firmware load for brcm/brcmfmac4356-sdio.txt failed with error -2
> 
> System needs the NVRAM file "brcmfmac4356-sdio.khadas,vim2.txt" to enable
> the WiFi. After test, found it can share with the same file
> "brcmfmac4356-sdio.vamrs,rock960.txt".

Please elaborate: what test exactly?
