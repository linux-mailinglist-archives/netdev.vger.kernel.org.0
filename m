Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 47ADA28253E
	for <lists+netdev@lfdr.de>; Sat,  3 Oct 2020 17:56:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725809AbgJCP4e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 3 Oct 2020 11:56:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725788AbgJCP4e (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 3 Oct 2020 11:56:34 -0400
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3802EC0613D0
        for <netdev@vger.kernel.org>; Sat,  3 Oct 2020 08:56:34 -0700 (PDT)
Received: by mail-pj1-x1041.google.com with SMTP id p21so2985600pju.0
        for <netdev@vger.kernel.org>; Sat, 03 Oct 2020 08:56:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=VMKEB/jU0kRa2w6Ec/LA3ih71dBuxaWaNkrhEqUNwDc=;
        b=o6cAbxcx93lBOu6R4xH5RAJYP8ey3pu/UwwJe681PGC9IVsRmcBb4Gb1+A2Xf/77we
         2jvU0vPpj+1cIdpqmpUba3SnDkTosHXrv95R6uXGJyF/dcUPN8ArGRSh7ZRnhnedlnXp
         kZS9a4bR97E2B1o3WikflHSXnTcnSbLwe+oxqTaDeTUfW3eC2TO7mvHWjoov2j1N4+cm
         kkaHarypLhu5YpgQvRPAYo8VUNPkuBQqZGiru3KrLkD/DBtCXYZNckGgQcGETwb1LPGS
         K+kJF7KxRP6kwxBGHPfpEsHKkdyuB9eL82swLV/W95sxyS/ImkLArVpiYoGVGEk6VT/b
         X3ZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=VMKEB/jU0kRa2w6Ec/LA3ih71dBuxaWaNkrhEqUNwDc=;
        b=A6Poapa3FQ1UucXQ1eF47qoGxSpR1tlmncFvXwxnhGQJ6S480o0JJc9FGy4CF03D+h
         MeNV7/ca5lJ2mSVzQdED5q4bJz6BcxjqZSwSQekHxz8HNDhMnUr+wBV11MbxUbiZMMFv
         gfcCvl65Fy+OPYFDSuB0H4e1RwvBpV2A8nXIN+6BFiWNz7Hm3oExmrzrZYxIZLeTZL3V
         g6RhsMmHqVI/5Iyr9RBSKtFOREDgJLhJUUGQrawCcC9Sshb3YFTJ23wP9/dasl9YA6g5
         hOdehzFjmw+RXTE+/BSEwhjjT8SFkHOo40VamBQEV0oK1INwxMaNenpUMkZy3kAETRz3
         IWig==
X-Gm-Message-State: AOAM531z5iOHzOx7AR6Ah05PtiOdpttIAFRtopl11rIg5x10gC7cSuCt
        KgycbFTkT588wU7ohGhG5fV3xHKGSJEmUA==
X-Google-Smtp-Source: ABdhPJwk6u0isADYnSulk3wVyPqzIPeJSFQNHs2iMOa4Kmj7H7gWxHHkf835G8icx0blY+1lzoIaVg==
X-Received: by 2002:a17:90a:aa90:: with SMTP id l16mr8026607pjq.0.1601740593369;
        Sat, 03 Oct 2020 08:56:33 -0700 (PDT)
Received: from [192.168.1.3] (ip68-111-84-250.oc.oc.cox.net. [68.111.84.250])
        by smtp.gmail.com with ESMTPSA id bj2sm5081542pjb.20.2020.10.03.08.56.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 03 Oct 2020 08:56:32 -0700 (PDT)
Subject: Re: [PATCH net-next 2/2] dt-bindings: net: dsa: b53: Fix full duplex
 in example
To:     Kurt Kanzenbach <kurt@linutronix.de>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>, netdev@vger.kernel.org
References: <20201003093051.7242-1-kurt@linutronix.de>
 <20201003093051.7242-2-kurt@linutronix.de>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <e62b8072-ab7a-ce6d-1ac1-7fcb1b28081d@gmail.com>
Date:   Sat, 3 Oct 2020 08:56:32 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.3.1
MIME-Version: 1.0
In-Reply-To: <20201003093051.7242-2-kurt@linutronix.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 10/3/2020 2:30 AM, Kurt Kanzenbach wrote:
> There is no such property as duplex-full. It's called full-duplex. Leading to
> reduced speed when using the example as base for a real device tree.

Doh, thanks for correcting this. Would you want to make this a YAML 
binding at some point? I can take care of it if you do not have time to 
do it.

> 
> Signed-off-by: Kurt Kanzenbach <kurt@linutronix.de>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
