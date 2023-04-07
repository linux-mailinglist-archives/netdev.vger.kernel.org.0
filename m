Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B92D6DA716
	for <lists+netdev@lfdr.de>; Fri,  7 Apr 2023 03:48:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239429AbjDGBsE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Apr 2023 21:48:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239408AbjDGBsD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Apr 2023 21:48:03 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90B2F83F2
        for <netdev@vger.kernel.org>; Thu,  6 Apr 2023 18:47:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 13A6664987
        for <netdev@vger.kernel.org>; Fri,  7 Apr 2023 01:47:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE1AAC433D2;
        Fri,  7 Apr 2023 01:47:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680832078;
        bh=1s6gOd8huckDp8xTFT0CY1dHtmdBmaxA/1cwRmsCC1w=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=O7mb0qZoJbW/OILv0dKBSjxhqQdSjulwbUiK4NDU4B7BjfxoiDl9GkvEodabtHsF6
         bB0370HYEcFmqF6hnPpokg/kRtDg2rHyxIeQD6dZRCm+w2e55GuiHnZ07sQmBuiGIq
         lBQiMuQusxdTLJQwDhaCTm2X+85Tu51c2ET6or2ZKO+2JHoW5qd/gkUR9ayT60tVg/
         kQ6w4MaYhFv1rhoS5bEU1J7FundlSHbtP1xA8BOjhB7SNFSyLZzgKNZmUIICWjEJj6
         UNIwQt+Ld73zdZJatr7dV0V3J/D8MIB4QScdpaTWHTa5Kfn+KDT49IyRLPfIPmpSY4
         8k6wK26hBQoDg==
Date:   Thu, 6 Apr 2023 18:47:57 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     =?UTF-8?B?S8O2cnk=?= Maincent <kory.maincent@bootlin.com>
Cc:     netdev@vger.kernel.org, glipus@gmail.com,
        maxime.chevallier@bootlin.com, vladimir.oltean@nxp.com,
        vadim.fedorenko@linux.dev, richardcochran@gmail.com,
        gerhard@engleder-embedded.com, thomas.petazzoni@bootlin.com,
        krzysztof.kozlowski+dt@linaro.org, robh+dt@kernel.org,
        linux@armlinux.org.uk
Subject: Re: [PATCH net-next RFC v4 4/5] net: Let the active time stamping
 layer be selectable.
Message-ID: <20230406184757.7193ea23@kernel.org>
In-Reply-To: <20230406173308.401924-5-kory.maincent@bootlin.com>
References: <20230406173308.401924-1-kory.maincent@bootlin.com>
        <20230406173308.401924-5-kory.maincent@bootlin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu,  6 Apr 2023 19:33:07 +0200 K=C3=B6ry Maincent wrote:
> +/**
> + * A whitelist for PHYs selected as default timesetamping.
> + * Its use is to keep compatibility with old PTP API which is selecting
> + * these PHYs as default timestamping.
> + * The new API is selecting the MAC as default timestamping.
> + */
> +const char * const phy_timestamping_whitelist[] =3D {

whitelist -> allowlist or some such, inclusive naming
