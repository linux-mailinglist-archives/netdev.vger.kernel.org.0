Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC78333D97F
	for <lists+netdev@lfdr.de>; Tue, 16 Mar 2021 17:34:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237795AbhCPQd2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Mar 2021 12:33:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238712AbhCPQcv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Mar 2021 12:32:51 -0400
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 091CAC06174A;
        Tue, 16 Mar 2021 09:32:45 -0700 (PDT)
Received: by mail-ed1-x532.google.com with SMTP id b16so9536839eds.7;
        Tue, 16 Mar 2021 09:32:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=DjTxZT8AqroYP99shdWO695KE0Qo/izOf7I5S4PGebY=;
        b=eMHU0ZgB9iZLTIKhDQsi86LqQoF4n2XUMbJKievcKjSFjzL5haEqigr0DZHElui9cB
         5JaBQP2aW1BvQL6g0yEV7mrfwR+Vp7rFSaGia5lBvayHQr7Zs3azVbbMhDEzUH9imeVI
         svVLaHn8Rho/uRN/hE3RUXfJKLnCIDpcM+RsWJ7Mcb1rnoSmXDRESN1Qx93D2vyFFN98
         iHw+/g5pMjm8PHSC6Yri7oG4q+Mg/SJLFWe5P+V8PFAAh1JUIgr2I3WMw8tmS/N1sdLK
         aihwSsUuCs33DfjsEd7yyGVm7LLVF8qXDDHxs97MiAU/mGbzk/qVvtFmiKbO+XXmUXzX
         7X0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=DjTxZT8AqroYP99shdWO695KE0Qo/izOf7I5S4PGebY=;
        b=XTfHH0V0X2l3+hRw/aPwe5eZKhrd2+TkX4fihr17YFb2y9vIYC0COTwpkKJquu4PRt
         3/pxDgi9yFeXTQe1Qd7xxNNr1RKPnpK5xz4vKRREGvBy4PDW9xx/KnSjcW2IRzEtHbSe
         ARxlKC0Rv6ClHg2CIXZjLGTgiLq3bgc7helCrlz1fNfbPez3vWI34kD9BFtobt1B2tih
         z2SiCpv5hE0SUa/P/bGH4GFFc9aZ0CemLfjEuPoe6+mt2cJw1fCrGw9c6o9mreJmJefY
         h768C0pwc1NZntZjQqqpcyGS1y8v7LgmQYRLlqE23AG6+fwbb4jaPtljm2YtIHZqs8Q3
         qPZQ==
X-Gm-Message-State: AOAM533ru0LdnTUdciog/bam1B8HdHGTBE6F/cXU6qYSoQF8Et//bTWD
        vS1M/4E6XaFpXt1pvNjia8Y=
X-Google-Smtp-Source: ABdhPJxtZ4WnHx3NTNAcSmsmTV5p7JCQe4MelLjCfJBcuTeGIGE21s7wKJhvqqqetIqjzZvaCHLdvQ==
X-Received: by 2002:a05:6402:4309:: with SMTP id m9mr38266598edc.25.1615912363716;
        Tue, 16 Mar 2021 09:32:43 -0700 (PDT)
Received: from BV030612LT ([188.24.140.160])
        by smtp.gmail.com with ESMTPSA id d15sm10818511edx.62.2021.03.16.09.32.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Mar 2021 09:32:43 -0700 (PDT)
Date:   Tue, 16 Mar 2021 18:32:40 +0200
From:   Cristian Ciocaltea <cristian.ciocaltea@gmail.com>
To:     David Miller <davem@redhat.com>
Cc:     andrew@lunn.ch, kuba@kernel.org, robh+dt@kernel.org,
        afaerber@suse.de, mani@kernel.org, p.zabel@pengutronix.de,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-actions@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/3] net: ethernet: actions: Add Actions Semi Owl
 Ethernet MAC driver
Message-ID: <20210316163240.GA1111731@BV030612LT>
References: <cover.1615807292.git.cristian.ciocaltea@gmail.com>
 <a93430bc30d7e733184a2fa3ab5c66180a76d379.1615807292.git.cristian.ciocaltea@gmail.com>
 <20210315.143933.939938434416308507.davem@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210315.143933.939938434416308507.davem@redhat.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 15, 2021 at 02:39:33PM -0700, David Miller wrote:
> From: Cristian Ciocaltea <cristian.ciocaltea@gmail.com>
> Date: Mon, 15 Mar 2021 13:29:17 +0200
> 
> > +
> > +#define DEFAULT_MSG_ENABLE (NETIF_MSG_DRV | NETIF_MSG_PROBE | NETIF_MSG_LINK)
> > +static int debug = -1;
> > +module_param(debug, int, 0);
> > +MODULE_PARM_DESC(debug, "Debug level (0=none,...,16=all)");
> 
> Module parameters are strongly discouraged in networking drivers, pplease delete this
> ad just pass the default to netif_mdg_init(), thanks!

Ups, I was not aware of this since I've seen it in quite a lot of drivers.

Thanks for pointing this out, I will take care of it in the next
revision.

Kind regards,
Cristi
