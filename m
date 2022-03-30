Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D1384EB7F3
	for <lists+netdev@lfdr.de>; Wed, 30 Mar 2022 03:48:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232827AbiC3BuM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Mar 2022 21:50:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230273AbiC3BuL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Mar 2022 21:50:11 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B65121030;
        Tue, 29 Mar 2022 18:48:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CBF99B81AB1;
        Wed, 30 Mar 2022 01:48:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5974C340ED;
        Wed, 30 Mar 2022 01:48:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648604901;
        bh=SKgN/RLXn28ODm+lNlegsLp9OY5R/R282Wv06WIAmGo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=p1GqbdOn6QwfEATtTDLM3vt3GAGITHq7R23FhSCv/CcM5zgDoPzlbDcep979jQWpv
         IX2k+SGaGUqzQmYyye7X9Tp5kCqmgaKIeAJMCEpZlhKjoC1nwbQbptMg8jPVe7VpXc
         XZH3U5dxZ2+3gp5ES8DmdQSihotS3TMxFuhQqtQoqhanAaRLjPtT0tkjw3Hp6RcHCZ
         LFUrMXLP+nJE4oWZQzM5trMJ6Z8k8P+mhu30Y3WtzBeQTMBPWMp4thngJC1k8Sw8Kw
         USSAawfNqGOocsioequhArj2ZXwgakO/n0PTaTc7kOSpv3x7iYVNY3Gt5UreRWIfy3
         2/ZB6/RHZ6tPQ==
Date:   Tue, 29 Mar 2022 18:48:19 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Andrew Lunn <andrew@lunn.ch>, Andy Chiu <andy.chiu@sifive.com>
Cc:     radhey.shyam.pandey@xilinx.com, robert.hancock@calian.com,
        michal.simek@xilinx.com, davem@davemloft.net, pabeni@redhat.com,
        robh+dt@kernel.org, linux@armlinux.org.uk, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, robh@kernel.org,
        Greentime Hu <greentime.hu@sifive.com>
Subject: Re: [PATCH v7 net 4/4] net: axiemac: use a phandle to reference
 pcs_phy
Message-ID: <20220329184819.6d4354b6@kernel.org>
In-Reply-To: <YkOxexKUQqmFVe9l@lunn.ch>
References: <20220329024921.2739338-1-andy.chiu@sifive.com>
        <20220329024921.2739338-5-andy.chiu@sifive.com>
        <20220329155609.674caa9c@kernel.org>
        <YkOxexKUQqmFVe9l@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 30 Mar 2022 03:25:15 +0200 Andrew Lunn wrote:
> > I'm not sure if this is a fix or adding support for a new configuration.
> > Andrew, WDYT? =20
>=20
> I guess it fails this stable rule:
>=20
> It must fix a problem that causes a build error (but not for things
> marked CONFIG_BROKEN), an oops, a hang, data corruption, a real
> security issue, or some =E2=80=9Coh, that=E2=80=99s not good=E2=80=9D iss=
ue. In short,
> something critical.
>=20
> So this probably should be for net-next.

Okay, thanks! Just to spell it out this means you'll need to hold off
with reposting, Andy, until net-next re-opens (which means until
5.18-rc1 kernel version is tagged by Linus, see the netdev-FAQ).

You should also drop the Fixes tag from patch 4. The change will make
it to Linux 5.19 and won't be backported to stable.
