Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B716F6955FE
	for <lists+netdev@lfdr.de>; Tue, 14 Feb 2023 02:36:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229863AbjBNBgT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Feb 2023 20:36:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229570AbjBNBgS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Feb 2023 20:36:18 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96F024238
        for <netdev@vger.kernel.org>; Mon, 13 Feb 2023 17:36:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B591B61370
        for <netdev@vger.kernel.org>; Tue, 14 Feb 2023 01:36:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4A20C433D2;
        Tue, 14 Feb 2023 01:36:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676338575;
        bh=FFy3lBM5uwSNctUSfNnw4D9KRyYy9ynrHfsioBN+Vbg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=t+rzlY+kCjtd4mn1aybZotX4qyDWKo653us8eXPu5k3nlUVZlesuC8t294fxkZLdG
         zODm2RgQ4om91rrYXRRrqQombri4duB3UzPwFUIvV6F0M/4qJxDD9AZr1PzJSdfJr3
         Cj+P3AjKP/24HkhRz1ZxBrXYYILQa//7P+1gkDpr4iRIASDAsgDI2YDfi6GT6PPHI1
         kQ2HA2dVUAHc2DPDUe4xhIEfF5OgHf8ohlnwX+sKjGGz4ngFvvgE9UajAmPl2Z5ppo
         3zWkyBDogBzTrB4JtV3dNBI1DUelhs0cunGwrAjGyBwxoNkcuc1ChSieCKxfO1Rx23
         pYlUDzYmg5yAQ==
Date:   Mon, 13 Feb 2023 17:36:13 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Uwe =?UTF-8?B?S2xlaW5lLUvDtm5pZw==?= 
        <u.kleine-koenig@pengutronix.de>
Cc:     Larysa Zaremba <larysa.zaremba@intel.com>, netdev@vger.kernel.org,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>, kernel@pengutronix.de,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 1/2] net: stmmac: Make stmmac_dvr_remove() return void
Message-ID: <20230213173613.67512a1e@kernel.org>
In-Reply-To: <20230213162333.iqjlwa2ladkxfooy@pengutronix.de>
References: <20230211112431.214252-1-u.kleine-koenig@pengutronix.de>
        <Y+pHZ75Ynp5xkgQy@lincoln>
        <20230213162333.iqjlwa2ladkxfooy@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 13 Feb 2023 17:23:33 +0100 Uwe Kleine-K=C3=B6nig wrote:
> > Code in both patches looks OK. =20
>=20
> Is this an Ack?

FWIW we encourage folks on netdev who reviewed a patch to speak up,
even if they don't feel confident enough to send a persistent tag.

> > Also, multiple patches usually require a cover letter. The code changes=
 are=20
> > trivial, so maybe the best solution would be to just to squash those pa=
tches=20
> > together. =20
>=20
> My conclusion was a bit different: The code changes are trivial, so they
> don't require a cover letter :-)
>=20
> I don't care much about squashing the two patches together. I slightly
> prefer to keep the changes as two changes as the changes are orthogonal
> and one patch per thing is the usual action.

Fair enough, 2 patches are fine w/o a cover letter.
