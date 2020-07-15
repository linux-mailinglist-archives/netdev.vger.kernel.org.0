Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EBDB1220DD9
	for <lists+netdev@lfdr.de>; Wed, 15 Jul 2020 15:18:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731603AbgGONRg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jul 2020 09:17:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729900AbgGONRg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jul 2020 09:17:36 -0400
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29E39C061755
        for <netdev@vger.kernel.org>; Wed, 15 Jul 2020 06:17:36 -0700 (PDT)
Received: by mail-ej1-x62e.google.com with SMTP id br7so2122272ejb.5
        for <netdev@vger.kernel.org>; Wed, 15 Jul 2020 06:17:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=X1n514xL7S/zIAOr27GAOQDXHGcI7OlJSmnbUyL7ORA=;
        b=bi3lXrlEYdJzaDDnVlYKdHTE4ebkktI4HhlFB+FWueABmXNG3Mf3zXFIAoF96P0QPV
         p5KWbtGuJ3OGzZS2tKsWFsl6e5JvTiXB+5WO1QiHpVLMH6OBzkKvAFNdwZvZ33DQpI40
         0I9u15TXWY42GE97GNGna6ZWDuqFwMAQ/qRdndn463ozpqxwigeinleNPT6/hqbX+khl
         /zAVo1AgCLX5YWBKvPZWcAVGwcD0Vw85ZCBoV/XVNRA/hM5EHOgUDpRRpFQBJxeruxH1
         Cx0UkJpP6G0A2U5TIHfLa4lwZT4cVppRRYPBtXv2b3umlKv3qEIObPmCqKeJ9MsrijHO
         XqVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=X1n514xL7S/zIAOr27GAOQDXHGcI7OlJSmnbUyL7ORA=;
        b=r10GIuz/aGQJV5JFOrJCgTiwGRGs6QK/zsCFuvFzumE5bmziRoYES0SZV9q0CCjLFe
         uviEY74cuZgk61bGYQBbvM3KFSH8yIftZIbbIhF3AF0pcOuLTgBuzst/nY9dq+gv85k6
         bBUzJBKVnBVKq80Sy/VaDXMcj/i9dde0z9PMoHviyefZ5rhd/zArcMucfkmsNwVSrkJ+
         jLES99EE3/NF6N4/Kj9iubWSMkiWTyTbCIBt4B4gHK0DFCizB/Haxu0LvYThct9s0LSx
         IxmS5SVA78t6nvI+0Aj6hrFaIyxmTsusfKCGUCjOgvfyx1pr/wRwbBXd9F4Xd4Yli3uw
         /DrQ==
X-Gm-Message-State: AOAM532U1dfG7yp1kyA7TEFTztzVYmj6BgSlFxzGx8oG6qONQqUh25gG
        hlcc/AOmH2VnHzbfb+nLjoMB1nH20b8=
X-Google-Smtp-Source: ABdhPJwV7LrPEq309O9X2T1nG/5acqdCq9r/bC1OmOk22Bll+6IdkCfRQv8WwbTX8nDOVbyOp6ydEQ==
X-Received: by 2002:a17:906:1ec3:: with SMTP id m3mr9284099ejj.197.1594819053486;
        Wed, 15 Jul 2020 06:17:33 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f23:5700:3054:ec52:4d7:b1ab? (p200300ea8f2357003054ec5204d7b1ab.dip0.t-ipconnect.de. [2003:ea:8f23:5700:3054:ec52:4d7:b1ab])
        by smtp.googlemail.com with ESMTPSA id p4sm2086081eji.123.2020.07.15.06.17.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 15 Jul 2020 06:17:32 -0700 (PDT)
Subject: Re: wake-on-lan
To:     "Michael J. Baars" <mjbaars1977.netdev@cyberfiber.eu>,
        Michal Kubecek <mkubecek@suse.cz>
Cc:     netdev@vger.kernel.org
References: <309b0348938a475f256cbc8afbbc127c285fec69.camel@cyberfiber.eu>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <b8f9ccd2-e56e-0965-3b4a-ff583a88829c@gmail.com>
Date:   Wed, 15 Jul 2020 15:17:28 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <309b0348938a475f256cbc8afbbc127c285fec69.camel@cyberfiber.eu>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 15.07.2020 11:27, Michael J. Baars wrote:
> Hi Michal,
> 
> This is my network card:
> 
> 01:00.0 Ethernet controller: Realtek Semiconductor Co., Ltd. RTL8111/8168/8411 PCI Express Gigabit Ethernet Controller (rev 0c)
> 	Subsystem: Realtek Semiconductor Co., Ltd. Device 0123
> 	Kernel driver in use: r8169
> 
> On the Realtek website (https://www.realtek.com/en/products/communications-network-ics/item/rtl8168e) it says that both wake-on-lan and remote wake-on-lan are
> supported. I got the wake-on-lan from my local network working, but I have problems getting the remote wake-on-lan to work.
> 
> When I set 'Wake-on' to 'g' and suspend my system, everything works fine (the router does lose the ip address assigned to the mac address of the system). I
> figured the SecureOn password is meant to forward magic packets to the correct machine when the router does not have an ip address assigned to a mac address,
> i.e. port-forwarding does not work.
> 
> Ethtool 'Supports Wake-on' gives 'pumbg', and when I try to set 'Wake-on' to 's' I get:
> 
> netlink error: cannot enable unsupported WoL mode (offset 36)
> netlink error: Invalid argument
> 
> Does this mean that remote wake-on-lan is not supported (according to ethtool)?
> 
> ---
> 
> I also tried to set 'Wake-on' to 'b' and 'bg' but then the systems turns back on almost immediately for both settings.
> 
> ---
> 
> Hope you can help getting the remote wake-on-lan to work,
> 
> Best regards,
> Mischa.
> 
> 
> 
> 
This isn't really a question to Michal. r8169 supports pumbg as mentioned by you.
On DASH-capable systems with Windows more may be supported by the vendor driver.
But Realtek doesn't release any public datasheets, therefore there's no DASH support under Linux.
