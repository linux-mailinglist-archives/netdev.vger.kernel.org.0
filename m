Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5067F2A3A47
	for <lists+netdev@lfdr.de>; Tue,  3 Nov 2020 03:12:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726773AbgKCCMf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Nov 2020 21:12:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725956AbgKCCMe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Nov 2020 21:12:34 -0500
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF6CFC0617A6;
        Mon,  2 Nov 2020 18:12:34 -0800 (PST)
Received: by mail-pf1-x441.google.com with SMTP id b3so12887025pfo.2;
        Mon, 02 Nov 2020 18:12:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=6/rnPaYkChFur+IgtvNfuGNEzJZ6ACtx6VvGSucnXRs=;
        b=Paq/DxiMPNj/PG1eackov9Q1u9ehr3V+NL0cIyZWaI+qxHlfwFFd4yrCl9vcTBNpvx
         QWPgXv9gS4N1CMOp2v3xNiTBq4cRJbgFoIcyUdKWFwjxvLXkuzPrxfhuQRqHW7rqIBra
         vNzP4gIl1J2k/Q2v9EM9/h+6Os10ZBzLKPnnA6Xm7/cE6c0XvIvmBVWkcNQT4rpOeM+V
         RKidKpmWTBsfXuYVzGyy53vpSpVprQKuheaRiW7PUrokPt7GiMMZesT3UUEemncbOBrr
         iJ4OJ4Weuv8AfVSUfs53R1tAirL2uz9FMxu0yA+B+sbGAyODWHWDyhVOLtQHqIyPTh1z
         46ag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=6/rnPaYkChFur+IgtvNfuGNEzJZ6ACtx6VvGSucnXRs=;
        b=UnUZeFXOl4/uHw1vXhWjN88fanCOpuiWR6kCXTGYJ/8ZibEBWmJJCTgzWjFqDBG4Zy
         nfob7kKfRFAqgay0tfmDhEf+3Vb2RDrJ8LEXmYMtJIPSHaeO9eSTaKYcO7JTlPuZHv5p
         te52XeipFdvsSwgR6gAG9lfA/UBFIIUN5gakPTOtBryQtHFtvk3wbYci2s7zZPhD3mTq
         vkR8ua6Dzs0gU5xy0Icj7kcPhSpigHyEO+ek2aUkAtsxxg4+ZrcNMe7XX3aXGGj3Khqx
         XdSpFX9D82y2vhPc+URmTdaNJ/CgCSscat/rjMzsGaojKdMxwv2f60pc/oivfmP/0yaH
         FtSw==
X-Gm-Message-State: AOAM532A1G7jGuGMmzGnQeEsmLL9jPv9te3VpSVRNX4VSvP9021/I9G6
        1g8P0oZiae9qP4q/UbBKPgCEwi6hPkI=
X-Google-Smtp-Source: ABdhPJyIafS067l0/Wtwfohi7t0NzyDGyp1DpKtPD4HVDGzRlEhBO9OZyKSZov1UpusJWXUPSltFFQ==
X-Received: by 2002:a17:90a:a514:: with SMTP id a20mr1261714pjq.213.1604369554397;
        Mon, 02 Nov 2020 18:12:34 -0800 (PST)
Received: from [10.230.28.234] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id v125sm15226830pfv.75.2020.11.02.18.12.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 02 Nov 2020 18:12:33 -0800 (PST)
Subject: Re: [PATCH v7 2/4] net: phy: Add 5GBASER interface mode
To:     Pavana Sharma <pavana.sharma@digi.com>, andrew@lunn.ch
Cc:     ashkan.boldaji@digi.com, davem@davemloft.net,
        gregkh@linuxfoundation.org, kuba@kernel.org,
        linux-kernel@vger.kernel.org, marek.behun@nic.cz,
        netdev@vger.kernel.org, vivien.didelot@gmail.com
References: <20201102130905.GE1109407@lunn.ch>
 <20201103013446.1220-1-pavana.sharma@digi.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <7aef297e-cbee-6f04-9d74-82cf97579880@gmail.com>
Date:   Mon, 2 Nov 2020 18:12:32 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <20201103013446.1220-1-pavana.sharma@digi.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 11/2/2020 5:34 PM, Pavana Sharma wrote:
>> How many times have i asked for you to add kerneldoc for this new
>> value? How many times have you not done so?
> 
> I have added kerneldoc comment for the new value added.
> 
>> NACK.
> 
>> If you don't understand a comment, please ask.
> 
> Ok, explain what do you expect by that comment.

What Andrew wants you to do is add a comment like this:

https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git/tree/include/linux/phy.h#n88
-- 
Florian
