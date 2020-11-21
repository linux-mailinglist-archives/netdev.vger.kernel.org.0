Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1244C2BBC6C
	for <lists+netdev@lfdr.de>; Sat, 21 Nov 2020 03:57:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727165AbgKUC42 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Nov 2020 21:56:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726674AbgKUC42 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Nov 2020 21:56:28 -0500
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F090BC0613CF;
        Fri, 20 Nov 2020 18:56:26 -0800 (PST)
Received: by mail-pg1-x544.google.com with SMTP id q28so8984957pgk.1;
        Fri, 20 Nov 2020 18:56:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=tiGQF91pXwToLfH95MJb6mPTaXdEHuIF5O/rnoQkwDw=;
        b=Yd048lgz57LpXmk8mOVmu2bn3uPCQYJRVc2mmSNevdSufij/uNxyGO2xekJ3wO6YvD
         wHYQz8Jn5xvbycbKNlcEOAgpHZ3VHNd3XBU/Ot99O9Vu4ub5SglLBJzw5wER3qSsSE1G
         DjsdO6e3o3RTh3b/wfXcnJIY09qkTUu2BVtmSwmxv8bQ4suRczLbd4IRkqEJNJ11TKjZ
         QLMltieZ5LDGoomrYppgjRagnyKdFEjKpaSqW0mHmtcF/l29XQo/rm2u07aQtWFACav7
         40266/4vbxXpagHE58H6TQce0RLaLH8brVocVxqpTf0tMX2/sGfzuPkCFmjQxiyyYaqE
         63Tw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=tiGQF91pXwToLfH95MJb6mPTaXdEHuIF5O/rnoQkwDw=;
        b=S+63hNwbNkqepqblz2Ae85NUyw3mLLSKBWfMERZ0693S875deCPyR5krD3RW0k4MCJ
         DbGh8QeEwIfzWspg8XZZSRW4Zc9mYcJsO8q9r9tllmU+VnklH6pIP3gi5r0HQdY1aYSw
         Vjf+aj7jAwgj9N/JWZ8HfS2jAKqxejUWs+FZPLCQNdsU2Apo4iePWdO5SjQ2OOqIXiTc
         HtuL7ydllLn54s3qyd2AnpouVzL0kqvoiQSUIf8Ks6r3zRUPUFfH1o+swch4lHc0yxko
         4Yz+PwhN1hY5eqgE6/Ced7diEV997Co+G7H9EsJf0WPDp5FndDjv8TTxxhG+kU60daE0
         dquQ==
X-Gm-Message-State: AOAM530+3IjRhXDoDfF0XQNW4lK1ag4jqIUgQ/sT0aRLKxAbHYk4k32w
        3/z8pBQF9em7f1IUmvbhdmU=
X-Google-Smtp-Source: ABdhPJxRBiAsdinQTFYzDXsd3gaxa2k/NQWiH23GSU8wTnebHNk2eY7h86si2MwU6iI9pQMZ8Qz7og==
X-Received: by 2002:a62:fc8c:0:b029:197:d6e4:2961 with SMTP id e134-20020a62fc8c0000b0290197d6e42961mr6314460pfh.20.1605927386415;
        Fri, 20 Nov 2020 18:56:26 -0800 (PST)
Received: from [10.230.28.242] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id o62sm5744189pjo.7.2020.11.20.18.56.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 20 Nov 2020 18:56:25 -0800 (PST)
Subject: Re: [PATCH v2 00/10] Broadcom b53 YAML bindings
To:     Florian Fainelli <f.fainelli@gmail.com>,
        linux-arm-kernel@lists.infradead.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>, Ray Jui <rjui@broadcom.com>,
        Scott Branden <sbranden@broadcom.com>,
        "maintainer:BROADCOM IPROC ARM ARCHITECTURE" 
        <bcm-kernel-feedback-list@broadcom.com>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
        "open list:NETWORKING DRIVERS" <netdev@vger.kernel.org>,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" 
        <devicetree@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        Kurt Kanzenbach <kurt@kmk-computers.de>
References: <20201112045020.9766-1-f.fainelli@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <fb26d286-d0df-db00-53d3-1a0a185109c5@gmail.com>
Date:   Fri, 20 Nov 2020 18:56:22 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <20201112045020.9766-1-f.fainelli@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 11/11/2020 8:50 PM, Florian Fainelli wrote:
> Hi,
> 
> This patch series fixes the various Broadcom SoCs DTS files and the
> existing YAML binding for missing properties before adding a proper b53
> switch YAML binding from Kurt.
> 
> If this all looks good, given that there are quite a few changes to the
> DTS files, it might be best if I take them through the upcoming Broadcom
> ARM SoC pull requests. Let me know if you would like those patches to be
> applied differently.
> 
> Thanks!

Series applied to devicetree/next, thanks everyone.
-- 
Florian
