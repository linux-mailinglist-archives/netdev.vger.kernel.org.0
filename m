Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6F6351093C0
	for <lists+netdev@lfdr.de>; Mon, 25 Nov 2019 19:52:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727297AbfKYSwI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Nov 2019 13:52:08 -0500
Received: from mail-wr1-f49.google.com ([209.85.221.49]:46439 "EHLO
        mail-wr1-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725946AbfKYSwI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Nov 2019 13:52:08 -0500
Received: by mail-wr1-f49.google.com with SMTP id z7so16026435wrl.13
        for <netdev@vger.kernel.org>; Mon, 25 Nov 2019 10:52:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:cc:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=AkOoJZqZjWXBgark2MjV6U43K/bhGKt+G3ocu91+hEs=;
        b=SxJZmwk78PBcwO+gpldwcbYTKwovKLSihBy/yIySuYMq5rHXqTfua531uHTV0DV8Oo
         rXaPT0YESHG2DYBeIIi2g8H8PE/NKrv6hw1LbIqgEwhX5s9B5AbuHcff/zJk50qhtaRI
         Ojdoa6RmpRswUyKMYD3qian56Uq37NK2Jgr0Ub7RfX3VGndB5F5vGKXFqtIimqLqrbo8
         3DBv9qEb//qyS8wGV7zvieiExfSsIxicbBk1lABpcO2GN3gwFrY9OV7eaMrRDR02MK9w
         9BLT3P/rfeAR/yWM7IfGrAnJooARZAigkOOKBQJ81aN9gn1BpruHv3EwG0ORsR3deTcy
         h2Hw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:cc:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=AkOoJZqZjWXBgark2MjV6U43K/bhGKt+G3ocu91+hEs=;
        b=rH/sUIQBdj+SoqzyE3OnmYvedcMA4aaN8v6j/FvDt8Cne8nKzT50KqLZAqRAmFPM4x
         ewPj1jDCMsEDqpmyM73LXyiyYkZq4zOlZZFSHMo1ccBrbnbfuyVNBIemd5XA/1O0AWWH
         kK/s06iKZefMFwO+ExIq9DauZ80QX7RJrerTpX37m3nBvT9UhTOqLd3PUCX58imXi4pG
         jZTevyUnu7p/Zp7ShXR6zJadoAw2wWXvfi+oT0gweFq+ZegY8hWzTodmK0yXf/GgfNma
         0r8TlBrcVC+J+d1Oq9hrOCXDmkubIy0T8f2EgR4qMbJjcUwnVDKcyXio97TTB2dxN3tR
         bplQ==
X-Gm-Message-State: APjAAAUA3XDqf7Hb9h3IO8NKcvuP4kObckRLTdW2TB5MAyGQ2i1kmaIi
        2492AIPERq1h1zRJbuKonOTLE9x5
X-Google-Smtp-Source: APXvYqzQ0k/JpGPJHkRisEZqM+GMLKJd32+Q+Gq5MAolVfXdmGjDFByeJ2EVGVNlhV1oO/R5FseUUw==
X-Received: by 2002:a5d:4acb:: with SMTP id y11mr12404140wrs.106.1574707924667;
        Mon, 25 Nov 2019 10:52:04 -0800 (PST)
Received: from ?IPv6:2003:ea:8f2d:7d00:4c2b:dce3:f012:16ac? (p200300EA8F2D7D004C2BDCE3F01216AC.dip0.t-ipconnect.de. [2003:ea:8f2d:7d00:4c2b:dce3:f012:16ac])
        by smtp.googlemail.com with ESMTPSA id l4sm237294wme.4.2019.11.25.10.52.04
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 25 Nov 2019 10:52:04 -0800 (PST)
Subject: Re: [RFC] r8169: add experimental RTL8117 support tested successfully
To:     lethbridgejason@gmail.com
References: <7a066a1bcaa78ee4a0d298093a0db062b6b9cfd4.camel@gmail.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <b21719a8-ee3b-8182-9e4a-f62155fa47c6@gmail.com>
Date:   Mon, 25 Nov 2019 19:51:59 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.1
MIME-Version: 1.0
In-Reply-To: <7a066a1bcaa78ee4a0d298093a0db062b6b9cfd4.camel@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 25.11.2019 17:10, lethbridgejason@gmail.com wrote:
> Hello,
> 
> I recently acquired a 'ASUS Pro WS X570-ACE' motherboard and came
> across your patch for the 'Realtek RTL8117 NIC' (
> https://patchwork.ozlabs.org/patch/1173105/) requesting feedback.
> 
> The patch appears to work flawlessly, thank you.
> 
> If you need me to run specific tests or get further details with this
> hardware feel free to contact me.
> 
> 
Thanks a lot for testing, much appreciated!
The patch is included in kernel version 5.5, rc1 should be out in
a few days.
