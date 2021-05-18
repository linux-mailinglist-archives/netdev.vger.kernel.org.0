Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB48A387DDA
	for <lists+netdev@lfdr.de>; Tue, 18 May 2021 18:43:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350866AbhERQpM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 May 2021 12:45:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346670AbhERQpK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 May 2021 12:45:10 -0400
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64D0FC061573;
        Tue, 18 May 2021 09:43:51 -0700 (PDT)
Received: by mail-ej1-x636.google.com with SMTP id l1so15607791ejb.6;
        Tue, 18 May 2021 09:43:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=qWBGH+31X26yOkng3p7bz4HR+xMDjcB7PfqrZjkZnA0=;
        b=T1YERtdqp4Ye+XTK51ACR7Q9kzTO8PoofA84l/tdEvNlitKVWNAg4kN35QYTxO2JEB
         tZm8o8t52BJKJxKhp1+zbg6lbiOzeCAfXZeO25nnGlIZBs70VVJMj6HLqtVT+bV1p73n
         s90pQnW4ghIVAsfGLoO/HwR31KdhNCkwvCLWMEPzqJWnmIYtmEV4kF1yh2X3OI91dALB
         x22Ug5JbZAqveAGjn1+9hEKlBL3p8hXb92AfHt4q+hsEs7SAcoX6dmNTPAgOO4GLeCjX
         tgioG/S8Bb6kmdE+1HZx2QE/sbMn98wonKOuuEKMfG608MLSWrU43MD8HcsZQBpJENP2
         Atkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=qWBGH+31X26yOkng3p7bz4HR+xMDjcB7PfqrZjkZnA0=;
        b=V2ik6Njq8sm7dsQwBkuCsQBy9PZYV+Olr31jXW+B2du3IcSOroooVYmKbkdfT1VoK6
         enU+ImHZqiKLd9Nin3Bys6jkYcwNJk/IYMU+TK+uqtEj2v0KNqsztt1mYfhnllwDQkDe
         1xXLnwuyCZeiViEzsrM1OE+SVl1TgroenNlGd5x7TfNjQL/woQ5OWnxx1QijQuoQdVzY
         po74OJ9up994A8fHJCutv44VEPHoTqUzL5MYcgKuKkrRXl/qIqzx9qsKgWcnbeGysFv1
         cSOd/jKZ03hZVBIyRb++RBaWhTTApwv7e1W0CPbx0B5nCpbv9yJ/AFNLVXpBLlmJGpgh
         z1pQ==
X-Gm-Message-State: AOAM532suvOt6mkA2ALf0f6/msCRL6Ue/RxJfQkiREp7yboVte8FHEs3
        INE+fOhoqXCSI5CykaIHR4E=
X-Google-Smtp-Source: ABdhPJydpnHDJ8oT2s80l6Hg0EPCWj+a0ZmcWve880eNG1uVwU+ckDGD8d2kFyHAV3EN7tSXXXDLgg==
X-Received: by 2002:a17:906:c0c3:: with SMTP id bn3mr6979565ejb.498.1621356230011;
        Tue, 18 May 2021 09:43:50 -0700 (PDT)
Received: from skbuf ([188.26.52.84])
        by smtp.gmail.com with ESMTPSA id t9sm13757408edf.70.2021.05.18.09.43.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 May 2021 09:43:49 -0700 (PDT)
Date:   Tue, 18 May 2021 19:43:48 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Randy Dunlap <rdunlap@infradead.org>
Cc:     Stephen Rothwell <sfr@canb.auug.org.au>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        John Crispin <john@phrozen.org>,
        Ansuel Smith <ansuelsmth@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: linux-next: Tree for May 18 (drivers/net/dsa/qca8k.c)
Message-ID: <20210518164348.vbuxaqg4s3mwzp4e@skbuf>
References: <20210518192729.3131eab0@canb.auug.org.au>
 <785e9083-174e-5287-8ad0-1b5b842e2282@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <785e9083-174e-5287-8ad0-1b5b842e2282@infradead.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Randy,

On Tue, May 18, 2021 at 09:32:49AM -0700, Randy Dunlap wrote:
> On 5/18/21 2:27 AM, Stephen Rothwell wrote:
> > Hi all,
> > 
> > Changes since 20210514:
> > 
> 
> on x86_64:
> # CONFIG_OF is not set
> 
> ../drivers/net/dsa/qca8k.c: In function ‘qca8k_mdio_register’:
> ../drivers/net/dsa/qca8k.c:797:9: error: implicit declaration of function ‘devm_of_mdiobus_register’; did you mean ‘devm_mdiobus_register’? [-Werror=implicit-function-declaration]
>   return devm_of_mdiobus_register(priv->dev, bus, mdio);
> 
> 
> Should there be a stub for this function in <linux/of_mdio.h>?
> or the driver could add a dependency on OF_MDIO.
> 
> Full randconfig file is attached.
> 
> -- 
> ~Randy
> Reported-by: Randy Dunlap <rdunlap@infradead.org>
> 

Would something like this work?

-----------------------------[ cut here ]-----------------------------
From 36c0b3f04ebfa51e52bd1bc2dc447d12d1c6e119 Mon Sep 17 00:00:00 2001
From: Vladimir Oltean <olteanv@gmail.com>
Date: Tue, 18 May 2021 19:39:18 +0300
Subject: [PATCH] net: mdio: provide shim implementation of
 devm_of_mdiobus_register

Similar to the way in which of_mdiobus_register() has a fallback to the
non-DT based mdiobus_register() when CONFIG_OF is not set, we can create
a shim for the device-managed devm_of_mdiobus_register() which calls
devm_mdiobus_register() and discards the struct device_node *.

In particular, this solves a build issue with the qca8k DSA driver which
uses devm_of_mdiobus_register and can be compiled without CONFIG_OF.

Reported-by: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
---
 include/linux/of_mdio.h | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/include/linux/of_mdio.h b/include/linux/of_mdio.h
index 2b05e7f7c238..da633d34ab86 100644
--- a/include/linux/of_mdio.h
+++ b/include/linux/of_mdio.h
@@ -72,6 +72,13 @@ static inline int of_mdiobus_register(struct mii_bus *mdio, struct device_node *
 	return mdiobus_register(mdio);
 }
 
+static inline int devm_of_mdiobus_register(struct device *dev,
+					   struct mii_bus *mdio,
+					   struct device_node *np)
+{
+	return devm_mdiobus_register(dev, mdio);
+}
+
 static inline struct mdio_device *of_mdio_find_device(struct device_node *np)
 {
 	return NULL;
-----------------------------[ cut here ]-----------------------------
