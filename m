Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 74CB62C4CA3
	for <lists+netdev@lfdr.de>; Thu, 26 Nov 2020 02:32:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732029AbgKZBa5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Nov 2020 20:30:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730646AbgKZBa5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Nov 2020 20:30:57 -0500
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBDD1C0613D4;
        Wed, 25 Nov 2020 17:30:56 -0800 (PST)
Received: by mail-pl1-x641.google.com with SMTP id bj5so326592plb.4;
        Wed, 25 Nov 2020 17:30:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=dqn3xYEOmqiWFbZO0kfu1ACxuY/6aBHVumYvBc1mBoA=;
        b=ZejAxetQjuL9b5BFzW3CaRb2QH5gOBMLcv042ZzrSUfH0WtWteGbmpx8AVsVRB/RcV
         iBE7H4UZ6iOBt5CoXPyPhuSiS8zkc5psHWLxbK0H6XC4AMz7K4/RfTiuZsxs+p/XY+BU
         CD3lNlIts1y56klABDxQ0NgBW5BKH9gKEbTdoy14QHm2N7sovMckEMxb8oF2Gerlt5wN
         C7ar8NMiOwvR0s76kd9XoHH+NSMFT/cRzWZ8Amh/7JfeZgDlfQ28L0ID7kfIDF1rp6HQ
         0JUlA0qt8/vGEZG/5jAupDqdt9wtYsuJNOwXCon1KjBBDnmuHTvpw6F9dCji11Yci458
         pkOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=dqn3xYEOmqiWFbZO0kfu1ACxuY/6aBHVumYvBc1mBoA=;
        b=ECaTwvMoMW0rgH1cGmjWNyGkEGVmAtxJo5ElXxS58OduoHwfQre6be2XtO/76LQdtW
         fY/Cum5aveXcz8fBwCJam56iha3xvlh3ct1bEVu8PQywyaWgbRJVA0wKTjjeqnYORWfr
         vpek37AlUAf8iHzgKficishUIBAkWX14SNUXieGB5WDsv36eh8EF4hO3XrEOnTTc9Eno
         gCFxt0gCbJX5EkBps9m/DCEJUVnjnNqjH9zv2S0Is9Nv6vnief7lvjMtAK/jM+1Expse
         do9Ja99E7Efz2LUCi5SLOlHL5+O93Z2zrb9vC4/hp7IsJgU1+RySqclzB55UGv6y4tK8
         TDdQ==
X-Gm-Message-State: AOAM530zfvnKg/YSU4STvL58m83sQM57HXCSQY3gbM/ChZRpNF8ilTT3
        tWooWafkUaSvUo7j9EatYcEAaGjnKFQ=
X-Google-Smtp-Source: ABdhPJyPcJW4M0rh5XdDUvhDvoNNBZz9m21WAqCZ1saP4Nn/BaGHcuAITWLYDny2HKRrK2k3r0yR7w==
X-Received: by 2002:a17:902:778f:b029:da:2f5:ed6e with SMTP id o15-20020a170902778fb02900da02f5ed6emr691901pll.52.1606354255734;
        Wed, 25 Nov 2020 17:30:55 -0800 (PST)
Received: from [10.230.28.242] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id l76sm3124831pfd.82.2020.11.25.17.30.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 25 Nov 2020 17:30:55 -0800 (PST)
Subject: Re: [PATCH net-next v2 3/3] dt-bindings: net: dsa: add bindings for
 xrs700x switches
To:     George McCollister <george.mccollister@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org
References: <20201125193740.36825-1-george.mccollister@gmail.com>
 <20201125193740.36825-4-george.mccollister@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <778f8c76-c844-4b87-5119-588b29e616f5@gmail.com>
Date:   Wed, 25 Nov 2020 17:30:53 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <20201125193740.36825-4-george.mccollister@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 11/25/2020 11:37 AM, George McCollister wrote:
> Add documentation and an example for Arrow SpeedChips XRS7000 Series
> single chip Ethernet switches.
> 
> Signed-off-by: George McCollister <george.mccollister@gmail.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
