Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F2D32DCAE5
	for <lists+netdev@lfdr.de>; Thu, 17 Dec 2020 03:15:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727783AbgLQCMJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Dec 2020 21:12:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725988AbgLQCMJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Dec 2020 21:12:09 -0500
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C743DC06179C
        for <netdev@vger.kernel.org>; Wed, 16 Dec 2020 18:11:28 -0800 (PST)
Received: by mail-pg1-x52e.google.com with SMTP id n7so19268046pgg.2
        for <netdev@vger.kernel.org>; Wed, 16 Dec 2020 18:11:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=JeOT85bA+uGnX2PhfJWvqBgVLtaGIXnPSpXet9V9nYo=;
        b=R+rGvUll/wIin7Il2YMKouC1g9txDO0foXIioVWPB+091NLjQl4JPS2oG8Nvs1pR7B
         vxic2Bgo832bHJp/UbXtMJMteV/KqgCVeuKrFlcq/Dyj1DoGrMdNbyFcmIhT266AJNBx
         glmLcr/3Tio3fSTpERyNlIHgnDlDwn/ePYRMVaPznRQ5PxruBPaWW6QQLyshiDOJxu41
         IxROXBrFK8Bfly3I/GOYu3CZR0M7ZHVgaPrkihRsVjVdzc0aulD0Ptvb1pnOM+iZa1m2
         bcRHzFD+FYzjth6cyvA9+EIaFKxJptXQPCzQHApIuKkgWtijmQm9516zPDJL5jN9eFqz
         1m+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=JeOT85bA+uGnX2PhfJWvqBgVLtaGIXnPSpXet9V9nYo=;
        b=Stn2TjZ0tjIIO4sfXQQ1b3vbErNo3DdGUjm5bhaMS6aMTNVOKkCMziO9Qpafk8QdOw
         2xb73mudU4wBfgk9wbS3Bas9y7/MAEWllRSWHMeTRksI4VE7WdZLJJf6v4ULYWIlscJs
         9B8VF5FtoZpjfnpeOIJ93qMkqxntMH+ZJ/bPuBDyNU2HjUVB/W8sOx/A7/JpZEhMdhn3
         ia0a1sBFpSWHc8VCYPv18wAmoPen/I44t9PLV6iuL4mZGz89+XAtva7vz+vj0Pz2BkX0
         R+m8if+3I/ANb/83r22ats6uiWpr89c41mL4Vfptkzm1nib7UsBH4Q0wTFqI8egFB/ZK
         WTgA==
X-Gm-Message-State: AOAM5302UQMRJQNVYGfuVJdpLq9x5NsJKU0aG85hCWgT4fVher8L1Vbm
        OW1RhKuBuj7wyJh+BTFKkug=
X-Google-Smtp-Source: ABdhPJzhGVs6y3e3cRFmG6eZnCAzYvr3OP1jElOhKBnTePNbTgA112G8jL9/G9P7N8TxBUHy5afXeg==
X-Received: by 2002:a63:5754:: with SMTP id h20mr34824907pgm.378.1608171088411;
        Wed, 16 Dec 2020 18:11:28 -0800 (PST)
Received: from [10.230.29.166] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id d38sm4126038pgd.17.2020.12.16.18.11.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 16 Dec 2020 18:11:27 -0800 (PST)
Subject: Re: [RFC PATCH net-next 7/9] net: dsa: remove obsolete comment about
 switchdev transactions
To:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Woojung Huh <woojung.huh@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Vadym Kochan <vkochan@marvell.com>,
        Taras Chornyi <tchornyi@marvell.com>,
        Jiri Pirko <jiri@nvidia.com>, Ido Schimmel <idosch@nvidia.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Ivan Vecera <ivecera@redhat.com>
References: <20201217015822.826304-1-vladimir.oltean@nxp.com>
 <20201217015822.826304-8-vladimir.oltean@nxp.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <9032c185-fa7b-59f7-7b14-27378b9be77a@gmail.com>
Date:   Wed, 16 Dec 2020 18:11:23 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20201217015822.826304-8-vladimir.oltean@nxp.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 12/16/2020 5:58 PM, Vladimir Oltean wrote:
> Now that all port object notifiers were converted to be non-transactional,
> we can remove the comment that says otherwise.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
