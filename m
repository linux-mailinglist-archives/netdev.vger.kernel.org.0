Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 797BD12E051
	for <lists+netdev@lfdr.de>; Wed,  1 Jan 2020 20:57:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726792AbgAAT44 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Jan 2020 14:56:56 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:45078 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725871AbgAAT4z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Jan 2020 14:56:55 -0500
Received: by mail-wr1-f65.google.com with SMTP id j42so37517761wrj.12
        for <netdev@vger.kernel.org>; Wed, 01 Jan 2020 11:56:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=tN9FjHivli12Xw2gc8vB16xvnXaogigtA44xz1rIX98=;
        b=K0ZGh9PbmkEastjM/nfAeuUZKhV/hnRcKSzxXTTRSxQGDNUyWgnVcNLMpi3q0qpvhU
         muTMirIOLr+3/nAqc2l4YNMvMgYo3Q+Y3PkFzob2D3ABWUS/4JsA4mmHAY0LoJgd1noy
         EqBuQTQBBaYB7/jrpiVoPqWw7yJo38vtuZuNFij9L5+SRCKZXWgySGHExPu2uBgpvejx
         WzQbW9/rTw0QzEDpEdm1ttpo8AbmD18h7KiHT5IGLBaBwsyO7MZcVmp17nz9MxIglRx1
         HL4cIS6mVd8pS6kCjinmdOadVKweViWoCprDxDwJeYejdx0y3qdxI9IXuDFH2jg7v742
         KCTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=tN9FjHivli12Xw2gc8vB16xvnXaogigtA44xz1rIX98=;
        b=YSgIe5AhPL5aM8tlOHUNFrZKXU3SxHgG1C563m/sfoUbyYd7rw/I8l4SWNahj/Lh1o
         2B2QK6QlfHAlK6omYanmYoyKF7a/fPEwVwbmnaqU9yNXYU4ginw9cUNWAThU6J1iaRGa
         2bpSFQEndPcGuCBKkGzAWd1dFeeee8RhPBl18GN3hUhVSnNeCNEBAcVLeJO2Kffjkomx
         aDtJBmlB0IOE/S6w5CIQ8bS6Z3HvbJt6gLn/XlmCTr99Z771++dMOTh7o5URtjh5VyoG
         s1aiU6jOV/3tfZDyJx2PXb8VbXzKG/55V8XXt/hv6fBSGENjm+o2eRct9xYJGFFg15AM
         biJg==
X-Gm-Message-State: APjAAAXPsp+fPFvgIuWZdD1i9vi5dmiKZAIZ8H+M0Rm3V9xnGw9p/feO
        bz+YzPB7NH1x8TuWhbBhCGzoM1ei
X-Google-Smtp-Source: APXvYqxpLfZtS8LlV/gUjYAs2iJICqwBR7VVZObY4TPxICpoXP+XBMV6vOsESAcxQYh9zOgiiDd7kA==
X-Received: by 2002:adf:ef4e:: with SMTP id c14mr79821060wrp.142.1577908613315;
        Wed, 01 Jan 2020 11:56:53 -0800 (PST)
Received: from [192.168.178.85] (pD9F901D9.dip0.t-ipconnect.de. [217.249.1.217])
        by smtp.googlemail.com with ESMTPSA id a9sm6162531wmm.15.2020.01.01.11.56.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 01 Jan 2020 11:56:52 -0800 (PST)
Subject: Re: Realtek Network Driver - r8168-dkms needed
To:     Winfried Winkler <willi@hobbit.in-berlin.de>, nic_swsd@realtek.com,
        romieu@fr.zoreil.com, netdev@vger.kernel.org
References: <58a8d231-9ef9-47a1-7368-04737237270e@hobbit.in-berlin.de>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <d295ab1a-28ff-234a-eaa5-28df741720cf@gmail.com>
Date:   Wed, 1 Jan 2020 20:56:34 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.1
MIME-Version: 1.0
In-Reply-To: <58a8d231-9ef9-47a1-7368-04737237270e@hobbit.in-berlin.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 29.12.2019 20:04, Winfried Winkler wrote:
> Dear Sirs,
> the Debian ReadMe told to me to write this EMail, sorry if this might be
> considered spam...
> 
> It said:
>  "If no version of the in-kernel driver r8169 supports your NIC,
>   please report this to the r8169 maintainers, so that this can
>   be fixed"
> 
> My new Asus motherboard has an RTL8117 network chip that is NOT working
> with the in-kernel 8169 driver, it needs the external 8168-dkms driver.
> 
Support for RTL8117 was added for 5.5, you can test with any 5.5 release
candidate (latest is 5.5-rc4). Make sure that you also have the latest
linux-firmware package from Dec 15th. It may work w/o it, however there
may be compatibility issues.

> Board:
> https://www.asus.com/Motherboards/Pro-WS-X570-ACE/specifications/
> 
> "lspci" Output is:
> 05:00.1 Ethernet controller: Realtek Semiconductor Co., Ltd.
> RTL8111/8168/8411 PCI Express Gigabit Ethernet Controller (rev 1a)
> 
> Tested with latest stable kernel (5.4.6) at the time of this writing.
> 
> Feel free to request any additional info needed that I might be able to
> supply -- thanks for listening.
> 
> Happy new year and thanks for all the work you're doing,
>  Winfried Winkler
> 
Heiner

