Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E235D3064F2
	for <lists+netdev@lfdr.de>; Wed, 27 Jan 2021 21:21:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231968AbhA0UTF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jan 2021 15:19:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231138AbhA0US7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jan 2021 15:18:59 -0500
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D088C061573;
        Wed, 27 Jan 2021 12:18:19 -0800 (PST)
Received: by mail-pj1-x102a.google.com with SMTP id a20so1932683pjs.1;
        Wed, 27 Jan 2021 12:18:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=PamGUw5KHLIgc/YjUNOZJe/vDQ/rM2z2i/kRyOyz8QE=;
        b=Ko3hstEDBfMQTTBZHGacCZFQb+GOMNvYBmwsM/NNuTx2YkTF+HYmXgV8kS+s36qw+t
         z6Ta02TLF4fi5Z+kOJp341bDTZPdvmCSD4XE/SezSXLL3f5uVZDFH4H3OqTczu0HE9YG
         uQleQ1V9GXbx1huh8yA2xDPF8BHp3qmZqZeGQgadyE1hxEKSGEZ44SCE71NLQYaXAGS+
         kx2/ihE5BdQ56hhoJFrzkFzJOuegNirjTlumox7fsZh/FrtH7uTP/SJw+kLb2Yab+oXL
         jzMoJ36GMox563A3PEc6ajnCl71xGAVChFxcLF87ijcln9AmcQE2uqcNrwzHFLXbpbwa
         fVHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=PamGUw5KHLIgc/YjUNOZJe/vDQ/rM2z2i/kRyOyz8QE=;
        b=DmA8PNL7qgEqKoM29nDwSAombJ4Nx+P0iJOom097Q0alMCSHrI2yugoUH+/7x2nYfs
         GvITzb2egEqYghkH87VUNSvo54E3eBp383dq1rVhavwrShS/towGx2DLyBxFmxTHL+eO
         sZfur0FtyAf99i67fl09ZJC3Deuxcytk8DRq+IJKI7ABT7/U9a62Ktor8FBhSHbt13hU
         JyuDEyGLBkDgsftqKr2S9B4jFe1noI9U8EGWeRkKpPwReEs2JzXIRbA/U7NhbqvmYPeq
         WGKrmruWilAU8Dm1c8y2HRmf51uizTQf4lE/iwmoYCl1HDkIs2K9CM0+Trtu7joeBODp
         TGUg==
X-Gm-Message-State: AOAM531AuaCOyIDKbJ9BrOdbJlMaZ0kRcq+eJuSxldbSM7ksFrK7uf8V
        gt3jtAP0+iDTztHQJzIeIdVdoX+cknc=
X-Google-Smtp-Source: ABdhPJzu771S0SvF5kS0DtPvOPz4i9gVuBb0FOJf+91wX4B01PLn1C9XiLia3zFwt37fJjilPp9RPA==
X-Received: by 2002:a17:90a:8817:: with SMTP id s23mr7468225pjn.67.1611778698654;
        Wed, 27 Jan 2021 12:18:18 -0800 (PST)
Received: from [10.230.29.30] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id a7sm2943302pju.28.2021.01.27.12.18.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 27 Jan 2021 12:18:17 -0800 (PST)
Subject: Re: [PATCH V2 1/1] net: dsa: rtl8366rb: standardize init jam tables
To:     Lorenzo Carletti <lorenzo.carletti98@gmail.com>,
        linus.walleij@linaro.org
Cc:     andrew@lunn.ch, vivien.didelot@gmail.com, olteanv@gmail.com,
        davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20210127010632.23790-1-lorenzo.carletti98@gmail.com>
 <20210127010632.23790-2-lorenzo.carletti98@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <b87f3bb5-4a37-9525-91cf-bbff8df80399@gmail.com>
Date:   Wed, 27 Jan 2021 12:18:15 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210127010632.23790-2-lorenzo.carletti98@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 1/26/2021 5:06 PM, Lorenzo Carletti wrote:
> In the rtl8366rb driver there are some jam tables which contain
> undocumented values.
> While trying to understand what these tables actually do,
> I noticed a discrepancy in how one of those was treated.
> Most of them were plain u16 arrays, while the ethernet one was
> an u16 matrix.
> By looking at the vendor's droplets of source code these tables came from,
> I found out that they were all originally u16 matrixes.
> 
> This commit standardizes the jam tables, turning them all into
> jam_tbl_entry arrays. Each entry contains 2 u16 values.
> This change makes it easier to understand how the jam tables are used
> and also makes it possible for a single function to handle all of them,
> removing some duplicated code.
> 
> Signed-off-by: Lorenzo Carletti <lorenzo.carletti98@gmail.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
