Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C51FC6343BC
	for <lists+netdev@lfdr.de>; Tue, 22 Nov 2022 19:40:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234016AbiKVSkS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Nov 2022 13:40:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233081AbiKVSkO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Nov 2022 13:40:14 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19C737FF01
        for <netdev@vger.kernel.org>; Tue, 22 Nov 2022 10:40:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A6C086182F
        for <netdev@vger.kernel.org>; Tue, 22 Nov 2022 18:40:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0308C433D7;
        Tue, 22 Nov 2022 18:40:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669142413;
        bh=Okg7sTJ3HQqgRqkB/KVgBNeC0O9D+9OAcIegz3edsmw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=OvH8/Up1HlsAQJM3o8LUKbgsO6mW7yLHCVHKURRkCd4T0agcx9OhiTp1N/BEh1nWg
         hn7YXBMwdU2eldsGYfYOr853vkVSmRub/BZuJDKKlYCENXmqy2PpSpujAV+Z5nLrac
         rfZAoVsgkwVCYMCjBOXIC9e0VD7SF+oxAwRPNKEIqD4xKN4f4CIwW33Yh0fgzBgl51
         PlUc42TSXqLia4dd52pHxmm0/yTtOf5QKS34JdsPj1QBLviEHDEuamcGJW1V/fPTY4
         RCUWHirLsMbC2ZkyKOmKir16wkAANRUqUusiTFIN6SJ4OYLq37VZJwDwUX/PA7MZDG
         AFeDQNetD7GiQ==
Date:   Tue, 22 Nov 2022 10:40:11 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Uwe =?UTF-8?B?S2xlaW5lLUvDtm5pZw==?= 
        <u.kleine-koenig@pengutronix.de>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
        pabeni@redhat.com, uwe@kleine-koenig.org
Subject: Re: [PATCH net-next 00/12] net: Complete conversion to
 i2c_probe_new
Message-ID: <20221122104011.20792b02@kernel.org>
In-Reply-To: <20221122093843.ph5prj7thbxds5n7@pengutronix.de>
References: <20221121191546.1853970-1-kuba@kernel.org>
        <20221122093843.ph5prj7thbxds5n7@pengutronix.de>
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

On Tue, 22 Nov 2022 10:38:43 +0100 Uwe Kleine-K=C3=B6nig wrote:
> On Mon, Nov 21, 2022 at 11:15:34AM -0800, Jakub Kicinski wrote:
> > Reposting for Uwe the networking slice of his mega-series:
> > https://lore.kernel.org/all/20221118224540.619276-1-uwe@kleine-koenig.o=
rg/
> > so that our build bot can confirm the obvious.
> >=20
> > fix mlx5 -> mlxsw while at it. =20
>=20
> What is the relevant difference that made the build bot consider your
> resent but not my series? Is it "net-next" in the Subject?

Not all patches hit the netdev ML so the bot considered the series
incomplete, at least on our end. I'm guessing the general Intel bot
can reconstruct a partial series based on LKML.
