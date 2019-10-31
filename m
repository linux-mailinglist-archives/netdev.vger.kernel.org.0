Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4E661EB8B5
	for <lists+netdev@lfdr.de>; Thu, 31 Oct 2019 22:06:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728391AbfJaVGW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Oct 2019 17:06:22 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:45681 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726680AbfJaVGV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 31 Oct 2019 17:06:21 -0400
Received: by mail-wr1-f68.google.com with SMTP id q13so7767523wrs.12
        for <netdev@vger.kernel.org>; Thu, 31 Oct 2019 14:06:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=4HiFERmNRlTiCbF4MMXBAfmbI2j/fTvLAvgI3NA0Ar0=;
        b=EEfE8ltTbMQixi5o0wAwLpY5knR/zoEvECz1xg9JcuL159chJH+Ba4EiMBQWDmx0E/
         7dVQRhZaYMU9qJWnY8my/PvmtNrxpesG/Ab4Uzc30gxQYxnOYI8DDDJvnMuS/SATqI8x
         xJp5+HCINPwQws3VsAuBr++cDtFrq0n/w5N1o/TSZWCfPue64/5gQa6HyMnLFXI3+YGR
         f0fKuxqaK0Lq8LuFv/yzyTVb9H6liJIj++rpn+JhVMppL34Mx5+9lmK5cTDXH//EeknF
         1XgluBhBxc7Yc3Ps5GiDxZLv0GWlewH7eBbR66pF72ciEh3wViSmSRs+mib8R5XcDCBz
         Ad0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=4HiFERmNRlTiCbF4MMXBAfmbI2j/fTvLAvgI3NA0Ar0=;
        b=CtQptDqlPbQPNFahr4T9DUc7QBhKVm4ESr1yAteeS0lS1m5jmPH+zk11OxhnmwE03X
         J9+vOwP5li/ZAhvIKIFzJQdVkwHXJik8cYAzv0SViYbO5+y3L1CXxzXGd5Oo+p677nUO
         XJZAzZu4a6Bhqk2WrLO/4QrEDJtmbMctdHR2y+dTzpIcJd60mYN6gn6lSWYk/ToCa5op
         AsfVL+vuZA/s0NiY5sx018fxxEbABQsm5TRRyi9DEmRd6Aav/xoiaqxcJ0a0hKbxHCSC
         pvg+M0UKLkdhJZfFvwasNliRLYH4zDJrBlt+k71cSevR8zYshL/D7xq2aID1Smf1UcpE
         olkg==
X-Gm-Message-State: APjAAAW2sD7wY5nUcEvlNFxN1S3+bm9puXpv3c6BrFK10iLtOX/57epS
        vzw+UGYDy3At0ZjLcacbBcyWvZSO
X-Google-Smtp-Source: APXvYqx0l+a349GQgq+IAiXGZ+Krr/yIAtOSyNnK8/aUwwJNQbHY+gS+hxHAcDTaCO8Gr0nX8fFX/Q==
X-Received: by 2002:adf:f4c9:: with SMTP id h9mr3138693wrp.354.1572555979337;
        Thu, 31 Oct 2019 14:06:19 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f17:6e00:fca0:78ee:80d0:6a3d? (p200300EA8F176E00FCA078EE80D06A3D.dip0.t-ipconnect.de. [2003:ea:8f17:6e00:fca0:78ee:80d0:6a3d])
        by smtp.googlemail.com with ESMTPSA id b3sm4674944wma.13.2019.10.31.14.06.17
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 31 Oct 2019 14:06:18 -0700 (PDT)
Subject: Re: Fwd: Bad permanent address 00:10:00:80:00:10 using r8168 module
 on some cards
To:     Luc Novales <luc.novales@enac.fr>, netdev@vger.kernel.org
References: <8e3ad60e-227a-a941-74b4-d4d19c2aa7a5@enac.fr>
 <3f9dad41-818e-4637-ab59-87f69b5c9212@enac.fr>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <220be845-230b-8c49-c748-e507eb4c36f5@gmail.com>
Date:   Thu, 31 Oct 2019 22:06:11 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <3f9dad41-818e-4637-ab59-87f69b5c9212@enac.fr>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 31.10.2019 14:04, Luc Novales wrote:
> Hi,
> 
> I have no answer from realtek, could you help me for debugging and determine if problem is hardware or software and howto solve it ?
> 
> In complement, howto get more information about module parameters ?
> 
> Best regards
> 
> Luc Novales.
> 
> 
> -------- Message transféré --------
> Sujet :     Bad permanent address 00:10:00:80:00:10 using r8168 module on some cards
> Date :     Tue, 29 Oct 2019 11:28:09 +0100
> De :     Luc Novales <luc.novales@enac.fr>
> Pour :     nicfae@realtek.com
> 
> 
> 
> Hi,
> 
> I am Luc Novales from ENAC in France.
> 
> We have some problems using tp-link PCI express network adapter (model : TG-3468(UN) ver:3.0, P/N:0152502214) under Debian Linux.
> 
> We uses this adapters on about 50 training computers.
> 
> Using r8168 compiled kernel driver, randomly and for unknown reasons bad address 00:10:00:80:00:10 is chosen at boot on some cards, causing some hardware address conflict on the network.
> 
[...]
Regarding the vendor driver r8168: You have the source code. That's all support you can get.

> 
> 
> For information, we can't use stock kernel driver r8169 because card fails in a state which it doesn't auto-negotiate and doesn't establish any link with the switch (standby power must be remove to unlock the adapter).
> 
A full dmesg output would be helpful, and please try also with a recent kernel.
The described failure refers to the cards with the MAC address issue, or to all cards?

> Best regards
> 
> Luc Novales.
> 
> 
Heiner
