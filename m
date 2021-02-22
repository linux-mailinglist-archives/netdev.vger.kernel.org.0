Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 396C1321037
	for <lists+netdev@lfdr.de>; Mon, 22 Feb 2021 06:20:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229748AbhBVFUd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Feb 2021 00:20:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229780AbhBVFUb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Feb 2021 00:20:31 -0500
Received: from mail-ot1-x335.google.com (mail-ot1-x335.google.com [IPv6:2607:f8b0:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5AAAFC061786
        for <netdev@vger.kernel.org>; Sun, 21 Feb 2021 21:19:51 -0800 (PST)
Received: by mail-ot1-x335.google.com with SMTP id g6so6758443otk.11
        for <netdev@vger.kernel.org>; Sun, 21 Feb 2021 21:19:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Dopg7DLXZ0kUYSF4Ot8Jn+o2u0dSUaIr2HpSFZiZqy8=;
        b=K/XlPz55kxK7IPCrHdPGvsk+XAIK7RGbQCNHY75XNQgs8P8Y1yWaaP4Cs0wHeHA8zF
         G0SQmu0MP48Rp7lJ7sM8QCBRT6U4F43Dl0y6mY+6BYmYFO08gRNZhJmpd2eD7/tB7SHv
         uPONmxX+td7D8U66VtUp3HkzLMdH3AxnJohvAui+uw0VHGaY8EK4pH/kAdmS4FkbMXYW
         7Z11DWYwK6aq6IheM6gXZ9g4Xc6ju/vwK+S/T4HQMFsIG8X3lt59eldQGrxtVOGZFXD5
         N/flwcWYnn7JJHWbuHc56kKkyI4aHVMp7K9yQDKyOncifXHjUForFKy0YIB7e+1HDNyJ
         iKEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Dopg7DLXZ0kUYSF4Ot8Jn+o2u0dSUaIr2HpSFZiZqy8=;
        b=SsrdtKIAtdeVc5o9kAXyMrRNrmIkZMnwt5ZPFXsxCztNnRU4I3yZZE4r/dCG91X2Mt
         Biuj1etnvq16oPy/9g8FJu53IvMwhc/y41pFRv74/acJLzebTCJuT7HRj3UO+ltR5cRZ
         iXoqlg0HZfpjgClv9nRxfNIydNq7CQTG+PR8oJiEYlwBWlYHNn9PgTDEQPttrud9n2pN
         I6R/cXXtSh4W0+CVHzvONKI2pEU2NX3W+JzurYUoh3vQpzV5gT3cOG/27kjeIwmR1AL1
         /mZ3FrGxTNUYvaXhALbcdaDXZwfEhPo00fVFHU+fT7ypyJkrMzEkiMIrI8xlqpAPVwkR
         /MMA==
X-Gm-Message-State: AOAM532Wt54Ik83MuXWxtdBzNOVav5C21ZcqwIhjCNGmXmBXZeNnYDQM
        mek8ZTw/nQ80QhuNeWmDX6k=
X-Google-Smtp-Source: ABdhPJzdai6QsRhPEyCa4b4omwg8DOxl53E6jyNMGjSD00FIB0J6rnE1BNuJ+mE+7+CHMeRXggtLsw==
X-Received: by 2002:a9d:75cb:: with SMTP id c11mr4259120otl.300.1613971190777;
        Sun, 21 Feb 2021 21:19:50 -0800 (PST)
Received: from ?IPv6:2600:1700:dfe0:49f0:f028:e4b6:7941:9a45? ([2600:1700:dfe0:49f0:f028:e4b6:7941:9a45])
        by smtp.gmail.com with ESMTPSA id b17sm3278780ook.21.2021.02.21.21.19.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 21 Feb 2021 21:19:50 -0800 (PST)
Subject: Re: [RFC PATCH net-next 09/12] Documentation: networking: dsa: add
 paragraph for the MRP offload
To:     Vladimir Oltean <olteanv@gmail.com>, netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ido Schimmel <idosch@idosch.org>,
        DENG Qingfang <dqfext@gmail.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        George McCollister <george.mccollister@gmail.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        Kurt Kanzenbach <kurt@linutronix.de>
References: <20210221213355.1241450-1-olteanv@gmail.com>
 <20210221213355.1241450-10-olteanv@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <4c8f2b6e-2e32-c4dc-0c18-27e34de26028@gmail.com>
Date:   Sun, 21 Feb 2021 21:19:44 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210221213355.1241450-10-olteanv@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2/21/2021 13:33, Vladimir Oltean wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> Add a short summary of the methods that a driver writer must implement
> for getting an MRP instance to work on top of a DSA switch.
> 
> Cc: Horatiu Vultur <horatiu.vultur@microchip.com>
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
