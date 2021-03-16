Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D9E933D988
	for <lists+netdev@lfdr.de>; Tue, 16 Mar 2021 17:36:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238736AbhCPQgI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Mar 2021 12:36:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237965AbhCPQf6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Mar 2021 12:35:58 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E85FDC06174A;
        Tue, 16 Mar 2021 09:35:57 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id w8so10918413pjf.4;
        Tue, 16 Mar 2021 09:35:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=X8fm2+DJNwOrNrRx4Rc+KYylfFcsz9kzw4PQZuyYnFI=;
        b=JChg9VM+FvanuEGHktJEjKsXSY3j82spZn2xE3N4jfqadLMtZCrgUwPrlWhbhh9bOH
         0zLdQkoifmXlRBRxlgMf3+cjEwE6TJmowF9XCLdDeVzbo81T3JQOg4v5Z0Rd6ffA+P5N
         EEh7CumBGXtA/FmfoCwkfP9+w9omNjbodzZW0fCVMvaZGH4u2btdJ7JXgU1/hWuh36dU
         VkCJbtxED3sd+vl6vcbxHtdp5HcAGaGpycxZzuBw/yFyKvSS1tyErYFb+vf1DWHSvOHI
         44LQ/bEjPmGkdBA4LEd5pr4/j74RGolDdjk2tCqdW7VA3NCmYLNEBTJMqx+MNPgbUlTi
         ZN3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=X8fm2+DJNwOrNrRx4Rc+KYylfFcsz9kzw4PQZuyYnFI=;
        b=QyvmsP/FuU4dUQuXgOWWAdsmXjdqaNgSF7ffy0idqKO3lwwN8MDG4iX28yDXUFHBvq
         wTVTkkivRJVcjzh2k/KSf+2IRb1tutj/xx4IHKn2DfiNzh64U8ZdIofWiJa5ymQvv4Un
         gxKQxehtWh6ZJYMEmKMO/Rtgimy8prjVJTaQ1NrIMqiBIs5ld8adDmmlrl1sMfoCLjrd
         Al3YAhG487vNB39BXxQ1+d1BiwMj3sgSTCe3EdA5eeFZ1Ug2w7UmbL/kN77zHk88B4oq
         zMkmlhVfpl7EKSMixKSHu0J1wfApZZoksuaOGWUr/AZHXwxVjyh+XAomeuKO6rn4650C
         44fQ==
X-Gm-Message-State: AOAM5315w53AUE7IKNdJD/AjX/7psfI76av53ROtlsxL+qDUUL3qzx/w
        EoD4zvXn1zN4/9YW4NathLtDBcBiJAI=
X-Google-Smtp-Source: ABdhPJxRZNAjJMeEpbQL/mI3f3qZAS2TGkOteRQJwxfHf3fvlppHPrMzozzAoMhKH/eQXX5oySVUoA==
X-Received: by 2002:a17:90b:4395:: with SMTP id in21mr445945pjb.201.1615912556986;
        Tue, 16 Mar 2021 09:35:56 -0700 (PDT)
Received: from [10.230.29.202] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id w15sm10189998pfn.84.2021.03.16.09.35.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 16 Mar 2021 09:35:56 -0700 (PDT)
Subject: Re: [PATCH v2] net: broadcom: BCM4908_ENET should not default to y,
 unconditionally
To:     Geert Uytterhoeven <geert+renesas@glider.be>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <rafal@milecki.pl>
Cc:     bcm-kernel-feedback-list@broadcom.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20210316140341.2399108-1-geert+renesas@glider.be>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <197022d1-dc1c-e471-9b4a-71c0e71c008c@gmail.com>
Date:   Tue, 16 Mar 2021 09:35:53 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210316140341.2399108-1-geert+renesas@glider.be>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 3/16/2021 7:03 AM, Geert Uytterhoeven wrote:
> Merely enabling compile-testing should not enable additional code.
> To fix this, restrict the automatic enabling of BCM4908_ENET to
> ARCH_BCM4908.
> 
> Fixes: 4feffeadbcb2e5b1 ("net: broadcom: bcm4908enet: add BCM4908 controller driver")
> Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>

Acked-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
