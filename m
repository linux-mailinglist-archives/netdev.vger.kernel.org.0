Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AFEBC552E48
	for <lists+netdev@lfdr.de>; Tue, 21 Jun 2022 11:29:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348751AbiFUJ2q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jun 2022 05:28:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348950AbiFUJ2Z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jun 2022 05:28:25 -0400
Received: from mail-lf1-x133.google.com (mail-lf1-x133.google.com [IPv6:2a00:1450:4864:20::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51B272B1
        for <netdev@vger.kernel.org>; Tue, 21 Jun 2022 02:28:21 -0700 (PDT)
Received: by mail-lf1-x133.google.com with SMTP id t24so9110906lfr.4
        for <netdev@vger.kernel.org>; Tue, 21 Jun 2022 02:28:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=semihalf.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=Va65CLlXT66lPiOAfwa9g+ASPcDM2MU+8pT24RRRO7k=;
        b=fu3PlG9cjiFDFScwOu8ddGWGy5g+HqrHZe10yxTdqH078iLyUE2HKHs8FuC59gH2So
         WY7XXtfa8HVwjJrAbMJiHsVO4ag6N85TnZqdR2nXa54ZOSeoi/oe7DGi3vRoK4mRkUrI
         XCWgoPJvlF10a8dqge8Nxc3I81fcwUwjCC05vPyqmKy0Q7umD3STPXA69BtRZTOrlaz5
         Phftvrz0yrSqsVEdNSl8UxNIptUQYyKKZbHGTNdDbX7MHSIf6b9IczF5CJemmhWsZFCC
         kttCGIp2asVqs3R6/hefDfA9BUWTDy6LeTczrj2VIE+m5EpdUiRuSWzB8zGODXyEYNhB
         Xk/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=Va65CLlXT66lPiOAfwa9g+ASPcDM2MU+8pT24RRRO7k=;
        b=ZLpVEe7IO4hnbK8duCiqf+wJufiHbCvXUEczNwtYhrY4UZifv2c08OowqJJvan2B/5
         rA1/+yJD3N10W1ATCOyarojR351dzucgst+C2gAr6lEylEP+srTIGtbcEilroAewQ076
         5ev630CV3x6ZDZHMRvGlgO2ivh+Gj1nHFu9Ypw47ywGxnAKCAAc3/KgSKkoVznIstvVp
         SRVhA760ml2xPdnVM8Y2yA2pSV0EQOA2M2cFsRUaM/NKgExe3GsBNs5nJRXX/8djOcmv
         MpK5Oj/jBT1jPowf07qz6J+sjRPUE7xvS82F+pL+UyaW+yYUcV9JPwcr7GOBymBX17NI
         o1zg==
X-Gm-Message-State: AJIora8sKyB1cIEzAyBK/o9YyGLOTNBCyIsh4O/CYLoVnt14ymydhM8F
        /EhbRMcNw0+5zRHMAoozTkE/bxXhi8esrzbgE1iV8w==
X-Google-Smtp-Source: AGRyM1tnr/7fffHg+1rH3vAPs7eTuYvzjKulUmJ/wgqA54vx/4+Zywf0KM0jO8ZNCCX++WmE4C8hdBJqBRCAAR4w1Yw=
X-Received: by 2002:a05:6512:118f:b0:47f:6a1a:20d4 with SMTP id
 g15-20020a056512118f00b0047f6a1a20d4mr7110048lfr.428.1655803699554; Tue, 21
 Jun 2022 02:28:19 -0700 (PDT)
MIME-Version: 1.0
References: <20220620150225.1307946-1-mw@semihalf.com> <20220620150225.1307946-5-mw@semihalf.com>
 <YrCxqDYg6OIdgmG1@smile.fi.intel.com> <YrCx5SkADWBzRokM@smile.fi.intel.com>
In-Reply-To: <YrCx5SkADWBzRokM@smile.fi.intel.com>
From:   Marcin Wojtas <mw@semihalf.com>
Date:   Tue, 21 Jun 2022 11:28:10 +0200
Message-ID: <CAPv3WKfVs9KVboCBgiwR_WA+aPD02Axwvb5uSgjKDsvxYepe7A@mail.gmail.com>
Subject: Re: [net-next: PATCH 04/12] net: mvpp2: initialize port fwnode pointer
To:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Len Brown <lenb@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        vivien.didelot@gmail.com, Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>, pabeni@redhat.com,
        Russell King - ARM Linux <linux@armlinux.org.uk>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Grzegorz Bernacki <gjb@semihalf.com>,
        Grzegorz Jaszczyk <jaz@semihalf.com>,
        Tomasz Nowicki <tn@semihalf.com>,
        Samer El-Haj-Mahmoud <Samer.El-Haj-Mahmoud@arm.com>,
        upstream@semihalf.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

pon., 20 cze 2022 o 19:44 Andy Shevchenko
<andriy.shevchenko@linux.intel.com> napisa=C5=82(a):
>
> On Mon, Jun 20, 2022 at 08:43:05PM +0300, Andy Shevchenko wrote:
> > On Mon, Jun 20, 2022 at 05:02:17PM +0200, Marcin Wojtas wrote:
> > > As a preparation to switch the DSA subsystem from using
> > > of_find_net_device_by_node() to its more generic fwnode_
> > > equivalent, the port's device structure should be updated
> > > with its fwnode pointer, similarly to of_node - see analogous
> > > commit c4053ef32208 ("net: mvpp2: initialize port of_node pointer").
> > >
> > > This patch is required to prevent a regression before updating
> > > the DSA API on boards that connect the mvpp2 port to switch,
> > > such as Clearfog GT-8K or CN913x CEx7 Evaluation Board.
> >
> > ...
> >
> > >     dev->dev.of_node =3D port_node;
> > > +   dev->dev.fwnode =3D port_fwnode;
> >
> > device_set_node() ?
>
> Ah, important remark to all device_set_node() comments. It assumes that y=
ou
> replace _both_ assignments with _single_ call.
>

OK, will do.

Thanks,
Marcin
