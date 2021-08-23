Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F24C3F486B
	for <lists+netdev@lfdr.de>; Mon, 23 Aug 2021 12:15:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236127AbhHWKQE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Aug 2021 06:16:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231539AbhHWKQD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Aug 2021 06:16:03 -0400
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8B05C061575;
        Mon, 23 Aug 2021 03:15:20 -0700 (PDT)
Received: by mail-wm1-x32b.google.com with SMTP id x2-20020a1c7c02000000b002e6f1f69a1eso13633238wmc.5;
        Mon, 23 Aug 2021 03:15:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=ZmR7Gv23NUaTJo4E+5MKNgsxk7YjPqzu97xkHjlGKW0=;
        b=LXOJ5U7KRt4dzxzT/5y/TCQH+XLpETilOlJ0KohlKDuKh633D/1EG1BSpPNrzDIAHX
         4XOYcTxVdmn5ZDVg3vje/fum8syjXoVsP97WlleZLRi9ZTTBVr9S0QLDV+/OV4Saq15n
         GRGyKxq7D4sC09mQpxUao40W/dGrAteZChQJr7IACyISj/hp6EdejZOXSbVbcV/oS6aw
         K0qr41g6qdzvpU6ji+drd1HofBCcA1T51ojCY/CQQRv96Fvb6JYtezCQxAoJzDkn6kDK
         fPiOCID7qzFSUHl+jBkqSlFGXv+JNfHE5DZuRqM/lOT0DltjZbZ+j5dW2GIsIrPbGeAs
         vRIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=ZmR7Gv23NUaTJo4E+5MKNgsxk7YjPqzu97xkHjlGKW0=;
        b=dFqErlMqXwzzSXbzmjFskORX2qHRrwx1C+OdvpaGB9e3T9sXBeM9/CNRhLukGRdAl/
         2uC1O86ICxzGCR08UFPChBd8sErHvqfkrvi7nNJlTl/N15uEUBpcNtk6M9CiJpaGhdlB
         6whdvQkPJ96M9m40Cyccb9Lprzox9P3a6jqdOGSnO/Xt5mGcZgVt96iusHM263eSL19D
         TdrKpuJP7UZkFLQFNMeVvuh4bkrqxRGOB6LMVDptk2JnK6vE3W4YxKfX8vXaEzA/R6Kx
         e5zautzKUTXuzGRxn+Bk8fOAYLHbbsU0VXHPjNx1ELKvilRnut4VhwMtM2+hW72pq1mx
         BzkA==
X-Gm-Message-State: AOAM533W9fic7AoEisCtmgUWIZ1LNIveHHlgXNpNcdLw+y+JNMNJdlJ0
        QWFHp7EM/79Dm5J85pgkqMs=
X-Google-Smtp-Source: ABdhPJyydLsTNgu4PmnxEa2xeXceH7vGga9mxFHC77YcbpVLHGewqchz+PTApBv3dFjv1p/VnPDWkw==
X-Received: by 2002:a7b:cd82:: with SMTP id y2mr15756541wmj.4.1629713719354;
        Mon, 23 Aug 2021 03:15:19 -0700 (PDT)
Received: from ?IPV6:2a01:cb05:8192:e700:d8d0:123c:2bc1:6888? (2a01cb058192e700d8d0123c2bc16888.ipv6.abo.wanadoo.fr. [2a01:cb05:8192:e700:d8d0:123c:2bc1:6888])
        by smtp.gmail.com with UTF8SMTPSA id w29sm14819905wra.88.2021.08.23.03.15.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 23 Aug 2021 03:15:19 -0700 (PDT)
Message-ID: <8b32c616-8c76-206f-30b2-6286104f9705@gmail.com>
Date:   Mon, 23 Aug 2021 12:15:18 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.0.2
Subject: Re: [RFC PATCH net-next 2/5] dt-bindings: net: dsa: realtek-smi:
 document new compatible rtl8365mb
Content-Language: en-US
To:     =?UTF-8?Q?Alvin_=c5=a0ipraga?= <alvin@pqrs.dk>,
        Linus Walleij <linus.walleij@linaro.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>
Cc:     mir@bang-olufsen.dk,
        =?UTF-8?Q?Alvin_=c5=a0ipraga?= <alsi@bang-olufsen.dk>,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20210822193145.1312668-1-alvin@pqrs.dk>
 <20210822193145.1312668-3-alvin@pqrs.dk>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20210822193145.1312668-3-alvin@pqrs.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 8/22/2021 9:31 PM, Alvin Šipraga wrote:
> From: Alvin Šipraga <alsi@bang-olufsen.dk>
> 
> rtl8365mb is a new realtek-smi subdriver for the RTL8365MB-VC 4+1 port
> 10/100/1000M Ethernet switch controller. Its compatible string is
> "realtek,rtl8365mb".
> 
> Signed-off-by: Alvin Šipraga <alsi@bang-olufsen.dk>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
