Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ACE25298E4C
	for <lists+netdev@lfdr.de>; Mon, 26 Oct 2020 14:43:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1780413AbgJZNnE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Oct 2020 09:43:04 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:47010 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1774028AbgJZNnE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Oct 2020 09:43:04 -0400
Received: by mail-pg1-f195.google.com with SMTP id n16so6071254pgv.13;
        Mon, 26 Oct 2020 06:43:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=fgWFMA33L1wvVRbeOYuXc7gj+7AZelua6opSAb+G+Hc=;
        b=fOIjnYXQVOfuRo/MdtRMnsMNy5NGagFoJuCz2NulddbeM1dHB2Q7Wm0/gE19Sa9oY0
         Dww3X/lnEnsI2j5vPrmjJHmzrmLciycPPROhhxU/VKkTBDZdww+F6gkovoYsSGP+MSnm
         4y9p00TcGkfCdXddvuGHK9qsBZ9wDWO6HMhmcda6xoumTNzeUCGu6N/SJEiMJlq1GViN
         zq4tt4CJjjCY9VgPHi8MsCrc0pQe+YTmCSiknmvhRtcBKi3/LN9dI0aFL/vJnfvaZNlu
         udifmrrlmA/kxHZOnNMC2XJk6de9kj0DxV9JmGxWEoUlsXo1LOR1ZmhAB2tRPFRJpJ+m
         NyIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=fgWFMA33L1wvVRbeOYuXc7gj+7AZelua6opSAb+G+Hc=;
        b=WfCpo2+S08u4NRAdGd4GPXU1rVkaSe5y7DP6EuCZhm+wA3KT0NoRbUhn/Tw5KSatzN
         6EJdjJlJ+KUp4RJn5nD+6o8azYnScwApiKzlHxiElZtKwQgdcWYnABa9pMvrvc16sks3
         GWt6Y8wXA3XgLGeQlimTW7rXEVhhJbnBLYnCVrBJjCX51iEeD4gcvgliAQznH2eEcaoN
         /EwVjDC7GMacxbh1gZd6fbspnFVCuRyrg82fRl5OCC2tj4Kt5t1DQxbEMJ15ujvU8zNl
         XKuRyjxCAxueKHwi5zVInFu1TzTCzQ2t202ZKcd/k7aqYzHqri89DF+gWTKDuBrBOgsk
         ZOPw==
X-Gm-Message-State: AOAM533XDXWKR7O6YvmzHNEPxGm81QS4mOCSAgEFM/QgBkoRy76URtJI
        9l4F2yfkxftLvhhBGww8JHU=
X-Google-Smtp-Source: ABdhPJxVwznCid7iDM8IYdViDJcHAxHIJAQ1nRyq3A5AE3TEi/QrgGrB5JCpDGMkFeqExIKKdZ3Tlw==
X-Received: by 2002:a63:180f:: with SMTP id y15mr13420281pgl.324.1603719783482;
        Mon, 26 Oct 2020 06:43:03 -0700 (PDT)
Received: from [10.230.28.230] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id j1sm2068724pfa.96.2020.10.26.06.43.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 26 Oct 2020 06:43:02 -0700 (PDT)
Subject: Re: [PATCH v4 2/3] Add phy interface for 5GBASER mode
To:     Pavana Sharma <pavana.sharma@digi.com>, andrew@lunn.ch
Cc:     davem@davemloft.net, gregkh@linuxfoundation.org, kuba@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        vivien.didelot@gmail.com
References: <cover.1603690201.git.pavana.sharma@digi.com>
 <156717e3151d58bd51aef7b0e491ae5c63c07938.1603690202.git.pavana.sharma@digi.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <ea23320a-26bd-96bd-d46b-25eb3582b49e@gmail.com>
Date:   Mon, 26 Oct 2020 06:42:59 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <156717e3151d58bd51aef7b0e491ae5c63c07938.1603690202.git.pavana.sharma@digi.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 10/25/2020 10:58 PM, Pavana Sharma wrote:
> Signed-off-by: Pavana Sharma <pavana.sharma@digi.com>

Please subject this patch properly with "net: phy: Add 5GBASER interface 
mode" and please also consider updating other files that are relevant here:

Documentation/devicetree/bindings/net/ethernet-controller.yaml
drivers/net/phy/phy-core.c
-- 
Florian
