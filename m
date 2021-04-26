Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 557ED36B672
	for <lists+netdev@lfdr.de>; Mon, 26 Apr 2021 18:05:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234348AbhDZQFg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Apr 2021 12:05:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234198AbhDZQFf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Apr 2021 12:05:35 -0400
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E59F0C061574;
        Mon, 26 Apr 2021 09:04:53 -0700 (PDT)
Received: by mail-pf1-x432.google.com with SMTP id e15so2478366pfv.10;
        Mon, 26 Apr 2021 09:04:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=kkYraJwnloN5E+mP22oPH515xvEP/CtcwIjfN1GMSTI=;
        b=AZsIWnVgPQWJr8dUtS6g7rNhE9ykXSWt7u2xvRVVgHMO4x43wZ9JH18MEt3U+LfS4F
         YrPks18+BgAq+bCi8NY5WsKX7YKJLf1B6TOZgkQ8y0/g3nT6gs+5KkD5NivyXvleMZGD
         fxR33goSkfuSGy6gJoq+keZYkOJpAcN8Fk1PuLxeRczhaLJcxK2v2j6Zinuy/0lp/gHl
         raeLb0UhSZupfN2Tn3CwlF0nS0idcCShmhxWGV/wKJZkOwUHvkolSim48Z4FrYUZK9HM
         vXxnhoKa7Gz9gTFePK4EE6SO9Xzvvl1HAXN+UdkpWA2hkHIAdfHNhc0rWr+4geODfoOL
         H6uQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=kkYraJwnloN5E+mP22oPH515xvEP/CtcwIjfN1GMSTI=;
        b=pB4jMmGxBOoMa9BbRonpY7ps/Jo52NoXGmK2I+FoKcyjwbfNLLw3OXkSqeHqYCgC0d
         xvncMPR1e/GK74kKmMPHL3mpDLe/Kj+Xz+uEmF6IV2o+KSJ2Kxh4yWR2OwlEAU2YD58j
         VppbVJPZHxD2dN9KsNwq1CEbb9GhCHDI523DNNdq5aDNkPKJXjJVMTRtj3hi2cJE+o5Z
         cxDgFrit2KkW4N1SeGuBesX8agHjsnZeJHHcYUnyZ27/rY1XDpnJfYKmqmZj+eCDwEVF
         q9e00stJ0YQtC9MqGzs3IHC82K1DK9R1EW3jTzBJ7GdNFVL78B/spO0pyNv1JYWsSyeU
         RMiQ==
X-Gm-Message-State: AOAM5334k/zMjGkFqy25jtIHoBEChGB40WJiuLAI4lCJiFY1PzCYhAG4
        QTgj0l9NDDhHUYDfpZbtorEydOnmSUY=
X-Google-Smtp-Source: ABdhPJyS4OcVwmNQzxzB//76dVCBsULGTCSqezd5fDPXmAt1kGKqYLtjmTTOQZOupvHXKKX7XcSD7g==
X-Received: by 2002:a63:1b0a:: with SMTP id b10mr17612766pgb.68.1619453093083;
        Mon, 26 Apr 2021 09:04:53 -0700 (PDT)
Received: from [10.67.49.104] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id ml19sm255995pjb.2.2021.04.26.09.04.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 26 Apr 2021 09:04:52 -0700 (PDT)
Subject: Re: [PATCH v2 net-next 1/9] dt-bindings: net: dsa: dt bindings for
 microchip lan937x
To:     Prasanna Vengateshan <prasanna.vengateshan@microchip.com>,
        Rob Herring <robh@kernel.org>
Cc:     andrew@lunn.ch, netdev@vger.kernel.org, olteanv@gmail.com,
        UNGLinuxDriver@microchip.com, hkallweit1@gmail.com,
        linux@armlinux.org.uk, davem@davemloft.net, kuba@kernel.org,
        linux-kernel@vger.kernel.org, vivien.didelot@gmail.com,
        devicetree@vger.kernel.org
References: <20210422094257.1641396-1-prasanna.vengateshan@microchip.com>
 <20210422094257.1641396-2-prasanna.vengateshan@microchip.com>
 <20210422173844.GA3227277@robh.at.kernel.org>
 <2f1e011ba458d493f34ea38c9e7e9753226ccab2.camel@microchip.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <7b291e79-fd4b-13e8-797d-7f3dd04c8895@gmail.com>
Date:   Mon, 26 Apr 2021 09:04:49 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <2f1e011ba458d493f34ea38c9e7e9753226ccab2.camel@microchip.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/25/21 9:05 PM, Prasanna Vengateshan wrote:
>>> +          port@4 {
>>> +            reg = <4>;
>>> +            phy-mode = "rgmii";
>>> +            ethernet = <&ethernet>;
>>
>> You are missing 'ethernet' label.
> This is the cpu port and label is not used anywhere. i received this feedback in
> last patch version. 

Your example of a CPU port node is valid here, we need an 'ethernet'
phandle to know this is a CPU port, otherwise it is just a regular
user-facing port.
-- 
Florian
