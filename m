Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A6ACA60ED82
	for <lists+netdev@lfdr.de>; Thu, 27 Oct 2022 03:37:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233884AbiJ0Bh0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Oct 2022 21:37:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233891AbiJ0BhX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Oct 2022 21:37:23 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32121F63E3;
        Wed, 26 Oct 2022 18:37:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E344BB82407;
        Thu, 27 Oct 2022 01:37:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9A45C433D6;
        Thu, 27 Oct 2022 01:37:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666834640;
        bh=mpyS3sJDkaKSZRmNmNC0CyMizCFv/rGTfRjX8WnfQf8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=HqOxSyTdcT/THuqY0cp8/PKehIK6rzefcwGbU6xB74T5j8T8y3Wih007+6IqFy46n
         QgtGuUaRqlafesSHnYTZZJ/YuaFMUkdFmDESIGDdOkOED13Wl5YFF08S0/DfnZBPRv
         qBerz/s8779GniQNxCcla212w6e08zi9GM8vFIR1i4ZPGkBusTY6/Esab77UmiZV92
         90LcMP2w4sFXs4RW4ykdqObPrEvCd38YwHeCDkmEYEOMuJiKEi/45cWVRWGaTdULto
         Qgswc4vR0m8MWa+Hj3/TchTzXQqTZH7qkL97PkatGQ81NF5sx4iuQzjQ2BfWv6tAYr
         o9UO7jZAUEA5A==
Date:   Wed, 26 Oct 2022 18:37:18 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     =?UTF-8?B?0L3QsNCx?= <nabijaczleweli@nabijaczleweli.xyz>
Cc:     Jonathan Corbet <corbet@lwn.net>,
        Federico Vaga <federico.vaga@vaga.pv.it>,
        Alex Shi <alexs@kernel.org>,
        Yanteng Si <siyanteng@loongson.cn>,
        Hu Haowen <src.res@email.cn>,
        Thomas Sailer <t.sailer@alumni.ethz.ch>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jirislaby@kernel.org>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        linux-doc-tw-discuss@lists.sourceforge.net,
        linux-hams@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH 01/15] hamradio: baycom: remove BAYCOM_MAGIC
Message-ID: <20221026183711.342ae914@kernel.org>
In-Reply-To: <9a453437b5c3b4b1887c1bd84455b0cc3d1c40b2.1666822928.git.nabijaczleweli@nabijaczleweli.xyz>
References: <9a453437b5c3b4b1887c1bd84455b0cc3d1c40b2.1666822928.git.nabijaczleweli@nabijaczleweli.xyz>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 27 Oct 2022 00:42:37 +0200 =D0=BD=D0=B0=D0=B1 wrote:
> Since defanging in v2.6.12-rc1 it's set exactly once per port on probe
> and checked exactly once per port on unload: it's useless. Kill it.
>=20
> Notably, magic-number.rst has never had the right value for it with the
> new-in-2.1.105 network-based driver
>=20
> Signed-off-by: Ahelenia Ziemia=C5=84ska <nabijaczleweli@nabijaczleweli.xy=
z>

Interesting name :S Just to be clear full legal names are required.
Not saying that's not your name, just saying I haven't heard it before.

Plus the From line must be the same, legal name.

> Ref: https://lore.kernel.org/linux-doc/YyMlovoskUcHLEb7@kroah.com/

Link: is the tag we use.

Otherwise looks fine.
