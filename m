Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 035FE3066FC
	for <lists+netdev@lfdr.de>; Wed, 27 Jan 2021 23:05:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235723AbhA0WEr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jan 2021 17:04:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236585AbhA0WDu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jan 2021 17:03:50 -0500
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C851C061573;
        Wed, 27 Jan 2021 14:02:48 -0800 (PST)
Received: by mail-ed1-x534.google.com with SMTP id g1so4323629edu.4;
        Wed, 27 Jan 2021 14:02:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=idtjhYoE5wXkN+IDNxcvxujnOhFSiptRGKFL5jD/Gtk=;
        b=MG7F5b5YyMngK8hKuMhC0ejRw4o2BfEWsGcdYoNZ/sKZ9bfSYaLS1IuY4ubPvfoZNq
         GEDglY3CVMWtdkC/OqZUA9Ai9u6ftYhqy4Yalr402cTfALBiC8Wah1keefVBZReIBf4L
         ij+ek558k4mJM3BVLxzI9VsIz92KAEUoZNyEtymnQzUbzxY1cb6bWQgt6k96UeHeybPo
         dcSKfBVCt9Eaz1ngEMfuCPCIXeYOuESfXne6nsMaPV0Wu20vVxysx2jxv6+P/DIVijrJ
         bWwM4blo1PrZW6//sV+cKmrnnieIKoY6NYvC9klrcIXohAYftNfVR2C5dXIiywc7JyNe
         tLsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=idtjhYoE5wXkN+IDNxcvxujnOhFSiptRGKFL5jD/Gtk=;
        b=nmgN9eMJ8c4D64kCDEXvHmT/trsLhlZAETYf08GxqP8gDBVu6UQ7LCUmyruNATVs1E
         /MxXJ9WsvywYtbZB2xue7B2kshgHl4pTKUZmFwCyo63MrGM3Notsyzn+nHmCntmeTYaB
         au6d7/K3BvQDFwBCsbNG3LaxsqygnMdLvi8e1yF5T59qpWrHTxAH0Ss8lUt1WAVocTd3
         /1Kp6Fkl1obAKdSBNXNEDOlDmqywTqZoPWEUbmCBvMkH2nWhxGr1r5TexsUtflpKshT8
         dOVWectlgx33u9KGQaOsdkqUyfAdfzxzhhxPf6IMnrFCYqI2ABkrG3Tj0xS8Nat6GGf7
         uymw==
X-Gm-Message-State: AOAM530X9n/f3SzLU/s+5sZI3o0I5zZMkmilrs2R2iCKAovR0vZAXktW
        Vs8PFVbNtZk9VirZe4nmA+0=
X-Google-Smtp-Source: ABdhPJxzIocTMZOy+9kF63lWBmSCy5wsG9xx4YD6iavchBy/Ei1LslVXL4ZN+gyf/c0kTtshr3sgWQ==
X-Received: by 2002:aa7:c0cd:: with SMTP id j13mr10727303edp.217.1611784967509;
        Wed, 27 Jan 2021 14:02:47 -0800 (PST)
Received: from lorenzo-HP-650-Notebook-PC ([95.236.1.158])
        by smtp.gmail.com with ESMTPSA id v25sm1431998ejw.21.2021.01.27.14.02.46
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 27 Jan 2021 14:02:46 -0800 (PST)
Date:   Wed, 27 Jan 2021 23:02:44 +0100
From:   Lorenzo Carletti <lorenzo.carletti98@gmail.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Vladimir Oltean <olteanv@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>, andrew@lunn.ch,
        vivien.didelot@gmail.com, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH V2 1/1] net: dsa: rtl8366rb: standardize init jam tables
Message-ID: <20210127215753.GA4935@lorenzo-HP-650-Notebook-PC>
References: <20210127010632.23790-1-lorenzo.carletti98@gmail.com>
 <20210127010632.23790-2-lorenzo.carletti98@gmail.com>
 <20210127190159.s6irvdej3fs4cdai@skbuf>
 <CABRCJOQDLrms1B4TsQonDEUAyXDV22-ufq4eGYZ8wq9KgHVKkA@mail.gmail.com>
 <21a30b7b-56ba-29e1-de0e-4d3969360a54@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <21a30b7b-56ba-29e1-de0e-4d3969360a54@gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 27, 2021 at 12:17:37PM -0800, Florian Fainelli wrote:
> One of those guidelines is no top-posting and make sure you use a
> plaintext format for your emails otherwise the mailing-lists may be
> dropping your response (we may still get those responses because we are
> copied).

My bad. I was using a client and only when the second message I sent was
rejected as well, did I understand what was happening.
I switched to mutt. Many thanks for your patience!
