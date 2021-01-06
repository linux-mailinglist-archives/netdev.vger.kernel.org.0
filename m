Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 44F5A2EBE99
	for <lists+netdev@lfdr.de>; Wed,  6 Jan 2021 14:29:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726086AbhAFN1k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jan 2021 08:27:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725944AbhAFN1k (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Jan 2021 08:27:40 -0500
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA50BC06134C
        for <netdev@vger.kernel.org>; Wed,  6 Jan 2021 05:26:59 -0800 (PST)
Received: by mail-wr1-x42e.google.com with SMTP id d13so2391219wrc.13
        for <netdev@vger.kernel.org>; Wed, 06 Jan 2021 05:26:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=ttbgOn2Tr7D6L5N2y4xeU7saN3TmZHI0GbkJWAIoNis=;
        b=urKp1r2XTlT8V0i1wU+AAXSZE9Mj3HQXpp1CEg9VgDRzwf0GqHWh2u/vrqCF5fW0Si
         BwGs2bpaJXJV3peY4DgvDk+RNyndpfo9n7paGSYVo4gN9iryuVG6e2oOYJG7MZ2G8yP+
         ob9hlhtULLGtUZLk/CqwvL1116F+H6bstikaMKwGdlqOCaRtEiQlAVitLhYzwua+D1yM
         mdD9e0Zfcz1hEajvdY+uaFf2SmiyxwqgggDCFaQlGMVYB8CUsW/GNKmhx14iPyX/9WCe
         GoydoYumbb07twn1ir6Ij2i/M5ozTndUUDxNbTjW9vRMGjLKD1w2mzUgLDmM57X9kEjB
         LWWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=ttbgOn2Tr7D6L5N2y4xeU7saN3TmZHI0GbkJWAIoNis=;
        b=sCGVst4eq+lPe3DYlKx9RWAnwGMPRIFOBxFrPMl8w0vUh8eJoPap3i3TtIKB5dD4fs
         e5bKIAiNr5EpIWqumSllyr28gdvdu8tUPRxuBECUGYl+DUW4l0WJG9ZD50HXrG4Nckpr
         V6sK1Oi67aK7z9kRYTCtAASgDQN2CrBhXb+VrEVCAc/XWyR1MH0SJV3piGRdSxYEqdMA
         LNTgaVscWTAycs9dzxGWIqvvl5O1Ra6bKfPN380S6QtjL1qMDv9X8Ca5XVeerKpWSd81
         w5H+sxCMdHhHhff1iPZETjtof7h/KDATx1mYdAg6LHsfAeutI+N/fGFAPQv5BNlgXQ0v
         /U0A==
X-Gm-Message-State: AOAM531X4z6J0Qtg58p7rna8u22HRqkifOB3JXvAWwmp02Uk5QgPcWlx
        5SFAn2V/Ks+Ohs6p0MxDTMqKz6/C+8U=
X-Google-Smtp-Source: ABdhPJwBsV4IdPXBdLDql/+o7nSQmJr47UIDcnNItFcW22g1mmy60yEohw+Yxd1m7jr8zQBVA6AvLA==
X-Received: by 2002:a5d:504b:: with SMTP id h11mr4253911wrt.337.1609939618308;
        Wed, 06 Jan 2021 05:26:58 -0800 (PST)
Received: from ?IPv6:2003:ea:8f06:5500:e1db:b990:7e09:f1cf? (p200300ea8f065500e1dbb9907e09f1cf.dip0.t-ipconnect.de. [2003:ea:8f06:5500:e1db:b990:7e09:f1cf])
        by smtp.googlemail.com with ESMTPSA id r13sm3211275wrt.10.2021.01.06.05.26.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 06 Jan 2021 05:26:57 -0800 (PST)
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Realtek linux nic maintainers <nic_swsd@realtek.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: [PATCH net-next 0/3] r8169: small improvements
Message-ID: <f89bf2f3-5324-b635-4253-8a8be316c15b@gmail.com>
Date:   Wed, 6 Jan 2021 14:26:54 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series includes a number of smaller improvements.

Heiner Kallweit (3):
  r8169: replace BUG_ON with WARN in _rtl_eri_write
  r8169: improve rtl_ocp_reg_failure
  r8169: don't wakeup-enable device on shutdown if WOL is disabled

 drivers/net/ethernet/realtek/r8169_main.c | 21 ++++++++-------------
 1 file changed, 8 insertions(+), 13 deletions(-)

-- 
2.30.0

