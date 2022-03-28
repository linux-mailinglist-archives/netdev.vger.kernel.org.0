Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 889C04EA389
	for <lists+netdev@lfdr.de>; Tue, 29 Mar 2022 01:13:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230283AbiC1XK6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Mar 2022 19:10:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230389AbiC1XK4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Mar 2022 19:10:56 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 047561BE8B
        for <netdev@vger.kernel.org>; Mon, 28 Mar 2022 16:09:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A46E5B81168
        for <netdev@vger.kernel.org>; Mon, 28 Mar 2022 23:09:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 326F9C340ED;
        Mon, 28 Mar 2022 23:09:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648508951;
        bh=dOxZZzewi+vuAFMRxsLSWbMrW/i33LCrweLLhobXukU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=s3np0eCJb0wveTvU+wSSX60hRGkxCecCxPbY5yWyJP/GFWK+Jc12N2Ti66Q6AuZzr
         DecfET9gkDQDa9uj1qUEHfHq8htilJvj7oB5X6nmfPYs2NFY7gSe/+vqFpKv/OtX6c
         xm5rPbdAMtajvBxN8ORhP3fK4SzzEmNqpyQNGNOvfrm+lSVM/btPHaONfhAX7sOdgW
         4387o1B8J4kLCqOOYuHaLcgdfwge81jc2/ZcC7d2XSiMdHE+k/RijiXIEDjeasPSuS
         jLfxQwNtTcimY0e7MN/0DO0y26KpgvCxOdrWLK6xUPn/M3/CUokh//WsqKGl6JADcp
         R8T3LyFb2CDCA==
Date:   Mon, 28 Mar 2022 16:09:10 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Uwe =?UTF-8?B?S2xlaW5lLUvDtm5pZw==?= 
        <u.kleine-koenig@pengutronix.de>
Cc:     Joakim Zhang <qiangqing.zhang@nxp.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        kernel@pengutronix.de, NXP Linux Team <linux-imx@nxp.com>
Subject: Re: [PATCH net-next] net: fec: Do proper error checking for
 enet_out clk
Message-ID: <20220328160910.3eb8fb87@kernel.org>
In-Reply-To: <20220325165543.33963-1-u.kleine-koenig@pengutronix.de>
References: <20220325165543.33963-1-u.kleine-koenig@pengutronix.de>
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

On Fri, 25 Mar 2022 17:55:43 +0100 Uwe Kleine-K=C3=B6nig wrote:
> An error code returned by devm_clk_get() might have other meanings than
> "This clock doesn't exist". So use devm_clk_get_optional() and handle
> all remaining errors as fatal.
>=20
> Signed-off-by: Uwe Kleine-K=C3=B6nig <u.kleine-koenig@pengutronix.de>
> ---
> Hello,
>=20
> this isn't urgent and doesn't fix a problem I encountered, just noticed
> this patch opportunity while looking up something different in the
> driver.

Would you mind reposting after the merge window?=20
We keep net-next closed until -rc1 is cut.
