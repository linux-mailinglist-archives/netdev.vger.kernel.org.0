Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E53605BF175
	for <lists+netdev@lfdr.de>; Wed, 21 Sep 2022 01:44:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231240AbiITXot (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Sep 2022 19:44:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230235AbiITXos (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Sep 2022 19:44:48 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1098311827
        for <netdev@vger.kernel.org>; Tue, 20 Sep 2022 16:44:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 93864B82DA2
        for <netdev@vger.kernel.org>; Tue, 20 Sep 2022 23:44:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E70B7C433D7;
        Tue, 20 Sep 2022 23:44:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663717476;
        bh=AV7za8TpXjMgf6rejG4N+Zc63R8iC6vGVEWoz59uRMk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Og7chGQpJjNv2WZqHUOwlXaOxSVBx8IB5hzSSEANDVZiMZC3MoaOJaHCvQlCyYT2i
         dHXik4dUoKPncxi6Arl75hkMM+Ckxi5zEGiszmtCfGud0d9HtJKwpwxrCurF3cWL9F
         GodZzfaiIxS9T0pZQzt8hjvZi8kNjmeyFpljz8qpSoBx6ImKgaC4C954T5eRMQEbRM
         VUr9jovSbucvMYncYquToHL/ME7JzEZjhaRwXE9tLP/cNqZiIMs1qYEKUzxh02aUNh
         lObM47gctkpg3Gp4TZsP1akbzOzEk7q5nNIs8N6fHL57lPEYCh1COyLPICIMwGRMHM
         TVHiN3YGUt2vA==
Date:   Tue, 20 Sep 2022 16:44:35 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Uwe =?UTF-8?B?S2xlaW5lLUvDtm5pZw==?= 
        <u.kleine-koenig@pengutronix.de>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        kernel@pengutronix.de, Yasuaki Ishimatsu <yasu.isimatu@gmail.com>
Subject: Re: [PATCH] net: fjes: Reorder symbols to get rid of a few forward
 declarations
Message-ID: <20220920164435.55c026d3@kernel.org>
In-Reply-To: <20220917225142.473770-1-u.kleine-koenig@pengutronix.de>
References: <20220917225142.473770-1-u.kleine-koenig@pengutronix.de>
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

On Sun, 18 Sep 2022 00:51:42 +0200 Uwe Kleine-K=C3=B6nig wrote:
> Quite a few of the functions and other symbols defined in this driver had
> forward declarations. They can all be dropped after reordering them.
>=20
> This saves a few lines of code and reduces code duplication.
>=20
> Signed-off-by: Uwe Kleine-K=C3=B6nig <u.kleine-koenig@pengutronix.de>

Any reason why do this? There's a ton of cobwebbed code with pointless
forward declarations. Do you have the HW and plan to work on the driver?
