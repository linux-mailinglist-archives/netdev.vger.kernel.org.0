Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B2981EEBA6
	for <lists+netdev@lfdr.de>; Thu,  4 Jun 2020 22:16:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729352AbgFDUQD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Jun 2020 16:16:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726666AbgFDUQD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Jun 2020 16:16:03 -0400
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4030C08C5C0
        for <netdev@vger.kernel.org>; Thu,  4 Jun 2020 13:16:02 -0700 (PDT)
Received: by mail-pg1-x541.google.com with SMTP id s10so4059708pgm.0
        for <netdev@vger.kernel.org>; Thu, 04 Jun 2020 13:16:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=WGUeWJOcPgXL28sgyYUTm/TZ3xt4nJk8y15up6E0iFA=;
        b=bAKQ4/PGTx+dDd9QrxjIgYNPGtE0xnuIEIt5LGA5gqkTJv2hxMeRhQs23wcWhf8LeH
         DfFXWfwhcY/bZmoicPWxaGAzemTLnfWAfLSdHaorNVLEUoGosmyeTJj2awD6wa57ETf/
         nsxeEZ3NWd6oRfh92SQO/78NOiIyBev4vuXbPZFY2+O7FE+Ab10ijUiBjkD6X9Nqrhx/
         pykRPKytTjf7S4LE12By/b2lHfMBwYsYeDSP98CycQolygdtBaa8ZWV9XNGAKP0mDRqu
         QwCbf7WX/ALkCe4rSd0PpE4CkIiv7kAU0VLCCSQNx3x/zD7sdxaF5YDMn9dS7LfjWUaY
         2i8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=WGUeWJOcPgXL28sgyYUTm/TZ3xt4nJk8y15up6E0iFA=;
        b=eFmkoChSnFbndq47jEF8iQ3Mc8Folvme6zoS5LzOMzWtkGpfe1Q+MIfFpuqGh1bVf+
         M3mnKbzaravAKlkVibN08bCSy2rXZatMBwYQbxZuyQoJ0kvbxylXvdekg9M2soStJj95
         g0YBzfmzazCGjDpqkiicxwNWmrdu9cctS+zrLLguiUaj7xBz3PurMX+C9V6CcJ0QuMRU
         KK4BZYgDQMUN60NPEg4gtGd+0cmCBlP6+kImu8aQhIGViQNc8xe3GmNzNst8F1L6LMMT
         wVMyy+Ptw/CManNJ6oKX/thfaFWKzjjhpy59kpnS+eUVIl7ulpU1+Inw8wXh8h6AaPab
         RmLA==
X-Gm-Message-State: AOAM5330uH9cZM7QzjpBtJ3Jxh+pCuvd0TgjM7xaHg/BEEQC1T3VVdTw
        VQyNr3MCOyVUivwvnElAfyJ1+twK
X-Google-Smtp-Source: ABdhPJyx43+taKoGrEMu6/M+8I95FLaO2dP3ONiz2tSRBdNs1SJMewV10XDmRNex3UEFTm8Rsevmhw==
X-Received: by 2002:a63:a042:: with SMTP id u2mr5980842pgn.346.1591301762373;
        Thu, 04 Jun 2020 13:16:02 -0700 (PDT)
Received: from [10.230.188.43] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id t22sm6046306pjy.32.2020.06.04.13.16.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 04 Jun 2020 13:16:01 -0700 (PDT)
Subject: Re: ethtool 5.7 released
To:     "John W. Linville" <linville@tuxdriver.com>, netdev@vger.kernel.org
Cc:     Michal Kubecek <mkubecek@suse.cz>, davem@davemloft.net
References: <20200604183539.GC1408312@tuxdriver.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <33d31995-45fc-cf65-9af3-9cf9698dd554@gmail.com>
Date:   Thu, 4 Jun 2020 13:15:58 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Firefox/68.0 Thunderbird/68.8.1
MIME-Version: 1.0
In-Reply-To: <20200604183539.GC1408312@tuxdriver.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 6/4/2020 11:35 AM, John W. Linville wrote:
> ethtool version 5.7 has been released.
> 
> Home page: https://www.kernel.org/pub/software/network/ethtool/
> Download link:
> https://www.kernel.org/pub/software/network/ethtool/ethtool-5.7.tar.xz
> 
> Release notes:
> 
> 	* Feature: ethtool: Add support for Low Latency Reed Solomon
> 	* Fix: ethtool.c: Report transceiver correctly
> 	* Feature: features: accept long legacy flag names when setting features
> 	* Feature: refactor interface between ioctl and netlink code
> 	* Feature: netlink: use genetlink ops information to decide about fallback
> 	* Feature: netlink: show netlink error even without extack
> 	* Feature: ethtool: add support for newer SFF-8024 compliance codes
> 	* Feature: Rewrite printf() due to -Werror=format-security
> 
> This should be my last release as maintainer of ethtool. Michal
> Kubecek has graciously agreed to take-on that responsibility, and I
> have every confidence that he will do a great job in that capacity
> for our community.
> 
> Thanks, Michal!

Thank you John for maintaining ethtool for the past few years and thanks
Michal for stepping up.
-- 
Florian
