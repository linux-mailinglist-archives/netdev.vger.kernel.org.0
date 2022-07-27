Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8BCE958323C
	for <lists+netdev@lfdr.de>; Wed, 27 Jul 2022 20:43:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239763AbiG0SnV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jul 2022 14:43:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234213AbiG0Smx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jul 2022 14:42:53 -0400
Received: from mail-oi1-x22e.google.com (mail-oi1-x22e.google.com [IPv6:2607:f8b0:4864:20::22e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F35B13F71
        for <netdev@vger.kernel.org>; Wed, 27 Jul 2022 10:40:14 -0700 (PDT)
Received: by mail-oi1-x22e.google.com with SMTP id j70so21633765oih.10
        for <netdev@vger.kernel.org>; Wed, 27 Jul 2022 10:40:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=semihalf.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=auHRXEOVurCyZQ+OD7PQkEunz1CClGN/q8cW3ry8A/g=;
        b=akCwbqOsMLF9KceYPsH4teUTmTLQJm9UmCBAtjLicHsInsBvGqYezvSQ7Vq/DLgJMh
         JaMrPsWCtssM6IJjbvwzpQGnOvwF10M7JqDIOvJLH/ZEBkayv0rbTQ5U9Q0fzE0qMaQa
         ujphGuNbPVj/jV8bmrH0778cavVEpkTM1FgZZZrUIoCZGLfBp/lp6x38VkwFC4q4MZzn
         hpetGpid8YOeWrW6XhpilDqQjtWyv+SBQeor7hjSo40dju6z9S6yJCy5WM7BD/IJZOVQ
         qWLBVAzv5fEclDkjni97HZAexI7xc00wO+kFrsW+ieELPQc7D13hfaFph9u7k40FGJ0S
         fpow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=auHRXEOVurCyZQ+OD7PQkEunz1CClGN/q8cW3ry8A/g=;
        b=0hfOIoApYIq0tcPQLKI4vvsG6FV5X+Of1U8P6g2frkOMAPPcXpyQbQeIqoQ9BhlCGK
         weWOfbHh8nz3CfOfhS04YuFRav/QnoBJWQcdWkYBnW7mMG1afTTgX8W5rKux9UHrP6yF
         /rxpcdhDQ3OVmkSV9Gsv7hDD9sF0dWNBHS3NNcrlsO99LfIH7Kgq5n3a5iQ6lE7m6f2X
         Cl0B0tf3r5h6eCYvBKP0+QPf5C/WN4piPjekaQKZREzdH5LdQq4uWyOi7GjN4nTzNB+K
         s0IdiEancsyXr3fiYF+EeC1UFXPjYJlcOGrKKX1Iw8tOu5KOlCNSeCv+/tsLcEx49AY8
         Lp1A==
X-Gm-Message-State: AJIora/PuSNHy0pNk4ZQRJtGDRlkcAGB8ZMAxsYnkPDHPnb3EEYQC2PV
        LXxKup9ixjiLbnBM+kWU/oI8NW/AsYFVggdPmjozAw==
X-Google-Smtp-Source: AGRyM1tmJ3CJLPbWQymZfXyGJNkgqaJhPLCByqEuYO5lRFaghvav9GCSr0ZX0nazp2AbJYqjEUkrSLAJV1vzXBhmZRw=
X-Received: by 2002:aca:ba86:0:b0:33a:c6f7:3001 with SMTP id
 k128-20020acaba86000000b0033ac6f73001mr2382818oif.5.1658943612325; Wed, 27
 Jul 2022 10:40:12 -0700 (PDT)
MIME-Version: 1.0
References: <20220727064321.2953971-1-mw@semihalf.com> <20220727064321.2953971-7-mw@semihalf.com>
 <20220727143147.u6yd6wqslilspyhw@skbuf> <CAPv3WKc88KQN=athEqBg=Z5Bd1SC3QSOPZpDH7dfuYGHhR+oVg@mail.gmail.com>
 <20220727163848.f4e2b263zz3vl2hc@skbuf>
In-Reply-To: <20220727163848.f4e2b263zz3vl2hc@skbuf>
From:   Marcin Wojtas <mw@semihalf.com>
Date:   Wed, 27 Jul 2022 19:40:00 +0200
Message-ID: <CAPv3WKe+e6sFd6+7eoZbA2iRTPhBorD+mk6W+kJr-f9P8SFh+w@mail.gmail.com>
Subject: Re: [net-next: PATCH v3 6/8] net: core: switch to fwnode_find_net_device_by_node()
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
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
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

=C5=9Br., 27 lip 2022 o 18:38 Vladimir Oltean <olteanv@gmail.com> napisa=C5=
=82(a):
>
> On Wed, Jul 27, 2022 at 05:18:16PM +0200, Marcin Wojtas wrote:
> > Do you mean a situation analogous to what I addressed in:
> > [net-next: PATCH v3 4/8] net: mvpp2: initialize port fwnode pointer
> > ?
>
> Not sure if "analogous" is the right word. My estimation is that the
> overwhelmingly vast majority of DSA masters can be found by DSA simply
> due to the SET_NETDEV_DEV() call that the Ethernet drivers need to make
> anyway.  I see that mvpp2 also needed commit c4053ef32208 ("net: mvpp2:
> initialize port of_node pointer"), but that isn't needed in general, and
> I can't tell you exactly why it is needed there, I don't know enough
> about the mvpp2 driver.

SET_NETDEV_DEV() fills net_device->dev.parent with &pdev->dev
and in most cases it is sufficient apparently it is sufficient for
fwnode_find_parent_dev_match (at least tests with mvneta case proves
it's fine).

We have some corner cases though:
* mvpp2 -> single controller can handle up to 3 net_devices and
therefore we need device_set_node() to make this work. I think dpaa2
is a similar case
* PCIE drivers with extra DT description (I think that's the case of enetc)=
.

>
> > I found indeed a couple of drivers that may require a similar change
> > (e.g. dpaa2).
>
> There I can tell you why the dpaa2-mac code mangles with net_dev->dev.of_=
node,
> but I'd rather not go into an explanation that essentially doesn't matter=
.
> The point is that you'd be mistaken to think that only the drivers which
> touch the net device's ->dev->of_node are the ones that need updating
> for your series to not cause regressions.

As above - SET_NETDEV_DEV() should be fine in most cases, but we can
never be 100% sure untils it's verified.

>
> > IMO we have 2 options:
> > - update these drivers
> > - add some kind of fallback? If yes, I am wondering about an elegant
> > solution - maybe add an extra check inside
> > fwnode_find_parent_dev_match?
> >
> > What would you suggest?
>
> Fixing fwnode_find_parent_dev_match(), of course. This change broke DSA
> on my LS1028A system (master in drivers/net/ethernet/freescale/enetc/)
> and LS1021A (master in drivers/net/ethernet/freescale/gianfar.c).

Can you please check applying following diff:

--- a/drivers/base/property.c
+++ b/drivers/base/property.c
@@ -695,20 +695,22 @@ EXPORT_SYMBOL_GPL(fwnode_get_nth_parent);
  * The routine can be used e.g. as a callback for class_find_device().
  *
  * Returns: %1 - match is found
  *          %0 - match not found
  */
 int fwnode_find_parent_dev_match(struct device *dev, const void *data)
 {
        for (; dev; dev =3D dev->parent) {
                if (device_match_fwnode(dev, data))
                        return 1;
+               else if (device_match_of_node(dev, to_of_node(data))
+                       return 1;
        }

        return 0;
 }
 EXPORT_SYMBOL_GPL(fwnode_find_parent_dev_match);

Thanks for the review and test.
Marcin
