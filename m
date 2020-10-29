Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7212129E2AC
	for <lists+netdev@lfdr.de>; Thu, 29 Oct 2020 03:32:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726876AbgJ2Ca2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Oct 2020 22:30:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725616AbgJ2C3T (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Oct 2020 22:29:19 -0400
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 792ACC0613D1;
        Wed, 28 Oct 2020 19:29:19 -0700 (PDT)
Received: by mail-pg1-x541.google.com with SMTP id 15so1092043pgd.12;
        Wed, 28 Oct 2020 19:29:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=RrAp4VTh9NmjJ/ywAzq/mhhtbjAu3UObB6qru5j8vgI=;
        b=Rxv/LPy08KfsOMqOuw9geQ+ZRNZxXRMCKoMZMAFehvMrcNJm/+hNWw3m6l97QbQiAQ
         1Ga6N7Pre5jBbEeL+3LJZmXujE2URQ/5Zg7Btg4m9LnnKUQXoXiEkdAtKsqGwbTjRDRk
         409bPKWcNbWpSruJThk+tV0cM692bacqUvxhLnISgYt7Rz/EUM0J0hOukVsi3ehp/nwl
         hkoZ7MXQSaNP5YUIz0blrxEW36jtxWNNzsqHXflbmkezbE6mkoqF+pmeEvijhyEvTp55
         3fPk11d+Xg9jWDo/xABaPEnvo8gNYjT3j51iKH/dl9Tt6C/fh3xSkGEWFMOUo+r1FUwE
         vpmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=RrAp4VTh9NmjJ/ywAzq/mhhtbjAu3UObB6qru5j8vgI=;
        b=FDZ09/9trZNMrvFTaVWMcj+YZk8gEYquriZuC0tmf9GFds6/lhVUEi915Uf1beq5OR
         laVKiPD4OABjtV1UyiYYyifwPZtUO+LTn1QUhsKYPRWIXPXlXKhFQZKZmvmcpCxNkxvw
         E3fsG73C1XjFggUBMYQsBSVNbV9riCcWYqjgYKtGRDoutpg8XPoaFVtcU+9VVQ9FIhIe
         phMaXnH+rdvaltoehf7Nefo2ZKRHGHSl1II2wp9P2DK3uSnAhY2AQYGGnNdzVsJwgLoB
         IE8WexLyWp1oQl/Qm9RmAwYUjsbBoDW5e+HW6YclT1DfE1EXjYG6a3ePnNSLJjTDdhL2
         mHUA==
X-Gm-Message-State: AOAM533RL/2JwWS0bLT7TnqYYPfLL0Iory+wxoG7lVr4V1QDiRkN6zWL
        fEJ0Z/7PqeiAW2guEH8ghK65yrtPg60=
X-Google-Smtp-Source: ABdhPJwa+JPj038l1++SqOBBPJXgY9Z8emT2WOtYo7zPUi9qmElCCqrRfyCt/4wp4gZ+I5shpAOlPQ==
X-Received: by 2002:a63:1e02:: with SMTP id e2mr2030242pge.74.1603938558842;
        Wed, 28 Oct 2020 19:29:18 -0700 (PDT)
Received: from [10.230.28.251] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id f4sm715637pjs.8.2020.10.28.19.29.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 28 Oct 2020 19:29:18 -0700 (PDT)
Subject: Re: [PATCH net-next v7 3/8] net: dsa: Add DSA driver for Hirschmann
 Hellcreek switches
To:     Kurt Kanzenbach <kurt@linutronix.de>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Richard Cochran <richardcochran@gmail.com>,
        Kamil Alkhouri <kamil.alkhouri@hs-offenburg.de>,
        ilias.apalodimas@linaro.org
References: <20201028074221.29326-1-kurt@linutronix.de>
 <20201028074221.29326-4-kurt@linutronix.de>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <5a996a4c-e0bc-5862-49d8-fa5ee0d9800a@gmail.com>
Date:   Wed, 28 Oct 2020 19:29:16 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <20201028074221.29326-4-kurt@linutronix.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 10/28/2020 12:42 AM, Kurt Kanzenbach wrote:
> Add a basic DSA driver for Hirschmann Hellcreek switches. Those switches are
> implementing features needed for Time Sensitive Networking (TSN) such as support
> for the Time Precision Protocol and various shapers like the Time Aware Shaper.
> 
> This driver includes basic support for networking:
> 
>  * VLAN handling
>  * FDB handling
>  * Port statistics
>  * STP
>  * Phylink
> 
> Signed-off-by: Kurt Kanzenbach <kurt@linutronix.de>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
