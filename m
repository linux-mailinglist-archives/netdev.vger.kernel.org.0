Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7753E30B7F9
	for <lists+netdev@lfdr.de>; Tue,  2 Feb 2021 07:45:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232142AbhBBGn5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Feb 2021 01:43:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231538AbhBBGnx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Feb 2021 01:43:53 -0500
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0DD0C061573;
        Mon,  1 Feb 2021 22:43:12 -0800 (PST)
Received: by mail-ej1-x629.google.com with SMTP id i8so11754364ejc.7;
        Mon, 01 Feb 2021 22:43:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=FTh/W3OROSEf6Q+1HA8WlPBCNi0WlLCmWMpf4ClFrLA=;
        b=LFvwY8NZqzRB9hrNvznrbE+oIv592vdSG6olL1IDsVh6V3K6scsuRsSszmg7ZWJzP3
         mTZ2WYEb6GbXJai12bdzeDd0sXPC9Nh0gJstG16KDdt8dR26Tf6qRuKoOq8mUjPLH/hm
         hdq6A0noWJbjIjCEqS/pak8OlzTB7KId/Cyi4H3Lawy9TumBrAIMrnTjMXj3PdpCcxPm
         jLVlQbTQLeQAz3MclAQtYVk/7v0XO1+G55mnHUgtDqZJ4+PYZF/8oQzQC1FgRPRieHg8
         V4gYj1bXZDfdmqHMWNvnOa0h9lPLpZt6zQxtYFXnfBIXdyWwBNyF+1h4EakH5qpEr2Iw
         glGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=FTh/W3OROSEf6Q+1HA8WlPBCNi0WlLCmWMpf4ClFrLA=;
        b=e6p5S8TtAIoPK691hPvvSbk/PU/N/SrFnJa4tP1vprGdEnX0+9sZKlmVElJsQ3Jsr9
         j3kqOpg5FauoWYgE1T+3UvQJDsSEEn8Xp0o6Gbm5QHhdQMlp/PPIkCP60v+daJ+YYziZ
         fReuh1URjvoOa6P8nsNi1n3IiXX+Q2SWBdUYMzxObrCqwO1kYVENz8Jvrr5b9bXkPpVn
         iMJH06RVKGc7xjd/8JKtQki1RC6TsIT9YjQ+r3Zhq6pUYMIok4tegdqjwT7qBGzzmnAC
         lsJZFSHe4G20wx4ZEuxwwEGmRgDiV9aYRuAzsrzBTwtpoqdY9W2aXkgdph1e8n2lNv2E
         EFbw==
X-Gm-Message-State: AOAM5308tUm4S5e8d7SBovKvIn55CNWrZA6pkr2m5gAMLxk2e7xvNQaQ
        722J0sZUzIoTPfIfnM3B0zgZjStV+P4=
X-Google-Smtp-Source: ABdhPJzfsQ1sutNJVimmWdW506GbTcNIkDkZMfCTi9Tn5tVgObn4cMyzGZzKdZcT0LvH+6p5P7PjaA==
X-Received: by 2002:a17:906:c0d7:: with SMTP id bn23mr13621140ejb.94.1612248190243;
        Mon, 01 Feb 2021 22:43:10 -0800 (PST)
Received: from ?IPv6:2003:ea:8f1f:ad00:4da7:c31c:5e0d:9c73? (p200300ea8f1fad004da7c31c5e0d9c73.dip0.t-ipconnect.de. [2003:ea:8f1f:ad00:4da7:c31c:5e0d:9c73])
        by smtp.googlemail.com with ESMTPSA id lz12sm8894476ejb.71.2021.02.01.22.43.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 01 Feb 2021 22:43:09 -0800 (PST)
Subject: Re: [PATCH v2] r8169: Add support for another RTL8168FP
To:     Kai-Heng Feng <kai.heng.feng@canonical.com>
Cc:     "maintainer:8169 10/100/1000 GIGABIT ETHERNET DRIVER" 
        <nic_swsd@realtek.com>, "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "open list:8169 10/100/1000 GIGABIT ETHERNET DRIVER" 
        <netdev@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>
References: <20210202044813.1304266-1-kai.heng.feng@canonical.com>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <81e965d2-63bf-ae6b-abf1-a683b4459254@gmail.com>
Date:   Tue, 2 Feb 2021 07:43:02 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210202044813.1304266-1-kai.heng.feng@canonical.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 02.02.2021 05:48, Kai-Heng Feng wrote:
> According to the vendor driver, the new chip with XID 0x54b is
> essentially the same as the one with XID 0x54a, but it doesn't need the
> firmware.
> 
> So add support accordingly.
> 
> Signed-off-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
> ---
> v2:
>  - Add phy support.
>  - Rebase on net-next.
> 
>  drivers/net/ethernet/realtek/r8169.h            |  1 +
>  drivers/net/ethernet/realtek/r8169_main.c       | 17 +++++++++++------
>  drivers/net/ethernet/realtek/r8169_phy_config.c |  1 +
>  3 files changed, 13 insertions(+), 6 deletions(-)
> 

for net-next

Reviewed-by: Heiner Kallweit <hkallweit1@gmail.com>
