Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E34754D47A
	for <lists+netdev@lfdr.de>; Thu, 16 Jun 2022 00:21:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244326AbiFOWVd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jun 2022 18:21:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236639AbiFOWVc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jun 2022 18:21:32 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D556135A9E;
        Wed, 15 Jun 2022 15:21:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 93BD4B81FDF;
        Wed, 15 Jun 2022 22:21:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB06BC3411A;
        Wed, 15 Jun 2022 22:21:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1655331689;
        bh=dSBxEPHdydbm3klkTdOm2Kku+8ae7xVTYQBfLHYT6zk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ilU4X/TD3iebLOoK2d5lo0Qd748vuLrQCldTYXN8mUfCTp7MxjSC3zkdHcbjOBuq6
         eMFrhHuD4VmNcspLoXPg18rQRpRCkXe2m03WL8/kpFT7+spTB8b/muhV6dzVr+qgaK
         xrOdEjF4aSfyFyoaKhN6Zh4OLQPECLk3sSdVu0+tcAhYyFc3UhTeAhw07OvNr4Tdke
         dl3Gm1FDPLfDi3bJMrjpcaKs0g5DME362VtGMU3nfs5SlGprLfnWul/yQIYgFsgN9D
         pNQU8+S67OYDka11EE6DgAwaHNbwnCZb83mfGs3m6uZPNFos+t/fv6UbZlDMy4iKKJ
         1xki5aDwRbVzw==
Date:   Wed, 15 Jun 2022 15:21:27 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Alvin =?UTF-8?B?xaBpcHJhZ2E=?= <ALSI@bang-olufsen.dk>
Cc:     Alvin =?UTF-8?B?xaBpcHJhZ2E=?= <alvin@pqrs.dk>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "hauke@hauke-m.de" <hauke@hauke-m.de>,
        Linus Walleij <linus.walleij@linaro.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Russell King <linux@armlinux.org.uk>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next v2 0/5] net: dsa: realtek: rtl8365mb: improve
 handling of PHY modes
Message-ID: <20220615152127.0d530fe4@kernel.org>
In-Reply-To: <20220615165529.3g6aqwdpwxqhs6nj@bang-olufsen.dk>
References: <20220610153829.446516-1-alvin@pqrs.dk>
        <20220615165529.3g6aqwdpwxqhs6nj@bang-olufsen.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 15 Jun 2022 16:55:29 +0000 Alvin =C5=A0ipraga wrote:
> David, Jakub, this series is marked Changes Requested on patchwork, but I=
 have
> addressed all the comments. Do you want me to resend?

Oh, that was me. I was hoping you'd respin to at least clarify=20
the commit message on patch 5, based on Russell's questions.
Perhaps that's not as important these days given we add Links
to the original discussion but should be useful to person reading=20
just the git history. Sorry for not making that clear, folks sending
comments and still acking the patch in general gives me low signal.
