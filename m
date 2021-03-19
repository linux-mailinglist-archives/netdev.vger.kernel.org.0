Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 897163417A7
	for <lists+netdev@lfdr.de>; Fri, 19 Mar 2021 09:41:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234412AbhCSIkk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Mar 2021 04:40:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234462AbhCSIkQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Mar 2021 04:40:16 -0400
Received: from mail-lf1-x12c.google.com (mail-lf1-x12c.google.com [IPv6:2a00:1450:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FC9DC06174A;
        Fri, 19 Mar 2021 01:40:15 -0700 (PDT)
Received: by mail-lf1-x12c.google.com with SMTP id w37so8756050lfu.13;
        Fri, 19 Mar 2021 01:40:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:organization:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Xqvabz6cLoghFbRuwuIjapRhuEI02T8/6UJvViDDDg4=;
        b=dH7skqon7lZvrh2iPIF3FFUqR6In9xtSazt8oCeUUsCMtMRh2QN1+YmuUXP+P/F9gp
         rW0h3Koj3rtuCNwfz9HyJCpyAcRmW4SBr06Ql0ckpFZ93IvGFTYvvyT0/0CcW0V28/iU
         sv2C42ZxhsnD4WoiDL88Vhxu1fUwqCcVh6Ho/4fXuTmp7lrS+9TuisqTmZWQox80hS2h
         +N09kvgCcCuZhppMprHpXvd3pE9MhObd8r621DyBeZVL3hpzGa38/oXKBAvxScCOMK1S
         uDSrz1UK7P5dVs6gJ8wWDB022wTNwsrGFvs625l2bgt2hNLJaJ8DBRcGR2eBhvCekSyF
         D8dg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:organization
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=Xqvabz6cLoghFbRuwuIjapRhuEI02T8/6UJvViDDDg4=;
        b=XfasbMLrNh3N+lFPmu1EbyEX7cqIWU7mfw/s9DysSZW8OHVR+0xR00UP5ll4kepoGt
         quxcI3ekpZrQyUipycgZNv90q8dPXFDrOsaK2Gqp6cNVINLwGFWFdy4jjnqU1I6Pz/4W
         zmAXX4ZlB7HIi76pZ+dHeOh0wmdF74644Eu43F9G1Upr949peIow8G0wQ15/LtrUSJuO
         KWUGe3EX/9HooRwyKD2ClD8v7wSc+2e0PCLdFbpKSV+ZNth4m/NOCXSsbkr9bn2KCnRX
         5uOf/8bU3nXKoct0ysVcZmcpNXxBs2pH6A+WY5jIxG3aXyGHtsTLLJq2DPl5TFgg/WIb
         IEaQ==
X-Gm-Message-State: AOAM531MPbdha2wFRGugT8K7Vfc7OoqN+0EGHE6FWmOTGSkRjXGVq+pk
        n4bhqBfd4+UIRwE7Tjdq/3PeJZUBSristQ==
X-Google-Smtp-Source: ABdhPJzaEiTpP8fxRkGHbXTOslYlQloPXXz4F15mGUCXwMfTKndZzrbEpaeHYcMkKaOWeuUXIqcuRQ==
X-Received: by 2002:a19:501b:: with SMTP id e27mr190844lfb.584.1616143213944;
        Fri, 19 Mar 2021 01:40:13 -0700 (PDT)
Received: from [192.168.1.100] ([178.176.79.146])
        by smtp.gmail.com with ESMTPSA id d8sm535926lfg.96.2021.03.19.01.40.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 19 Mar 2021 01:40:13 -0700 (PDT)
Subject: Re: [PATCH V3 5/5] arm64: dts: renesas: beacon kits: Setup AVB refclk
To:     Adam Ford <aford173@gmail.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Adam Ford-BE <aford@beaconembedded.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Magnus Damm <magnus.damm@gmail.com>,
        Linux-Renesas <linux-renesas-soc@vger.kernel.org>,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" 
        <devicetree@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <20210224115146.9131-1-aford173@gmail.com>
 <20210224115146.9131-5-aford173@gmail.com>
 <CAMuHMdW3SO7LemssHrGKkV0TUVNuT4oq1EfmJ-Js79=QBvNhqQ@mail.gmail.com>
 <CAHCN7xLtDyfB5h5rWTLpiUgWY==2KmxYCOQkVSeU8DV8KB-NKg@mail.gmail.com>
From:   Sergei Shtylyov <sergei.shtylyov@gmail.com>
Organization: Brain-dead Software
Message-ID: <2c9b5bb0-7229-43b4-adc6-dce8f96eac90@gmail.com>
Date:   Fri, 19 Mar 2021 11:40:02 +0300
User-Agent: Mozilla/5.0 (Windows NT 6.3; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <CAHCN7xLtDyfB5h5rWTLpiUgWY==2KmxYCOQkVSeU8DV8KB-NKg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 18.03.2021 15:44, Adam Ford wrote:

>>> The AVB refererence clock assumes an external clock that runs
>>
>> reference
>>
>>> automatically.  Because the Versaclock is wired to provide the
>>> AVB refclock, the device tree needs to reference it in order for the
>>> driver to start the clock.
>>>
>>> Signed-off-by: Adam Ford <aford173@gmail.com>
>>
>> Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
>> i.e. will queue in renesas-devel (with the typo fixed) once the DT
>> bindings have been accepted.
>>
> 
> Who do I need to ping to get the DT bindings accepted?  They have an
> acked-by from Rob.

    Normally, the bindings get picked up by a subsystem maintainer... or Rob :-)

[...]

MBR, Sergei
