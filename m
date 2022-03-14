Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 654854D8C65
	for <lists+netdev@lfdr.de>; Mon, 14 Mar 2022 20:28:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237896AbiCNT3O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Mar 2022 15:29:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237872AbiCNT3L (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Mar 2022 15:29:11 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18667DFD1
        for <netdev@vger.kernel.org>; Mon, 14 Mar 2022 12:27:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3BFCD6113C
        for <netdev@vger.kernel.org>; Mon, 14 Mar 2022 19:27:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68EC1C340E9;
        Mon, 14 Mar 2022 19:27:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647286078;
        bh=SXQc2oU/JdA1bqUo1b3Lf7lDSsII0SAwVrS6tQ52qkY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=gDRvY/o7yaXLdxhVI2XUUy4/MIoVJAdURAzkQquyreRMqEJhVXs7hmU6HwDQ/fDNp
         g8aQH70V7eKbgYtuJL+57EHk1VMBHxB+ozuxscbLkZRjA6Auq/zKpvmOkD3ymtSct1
         fSA5DyQDXYjxJyOEmxblmydJAVpm2w9wryCQ1fgxz57OpexbpHIkUmDXDiqYMFNsku
         PZ7MOMnI1S232g789IhClzH8S951Sai13lJ6dKzUG4ivFoWSNHSNsYhVa03yR+W876
         z20WBc5uWSl8I51RGQZGImGrLjcGjNagBuga2GEXp20jZN5UMs8FYbnEX+WM3Zjj/M
         hnFfdm4FAk3Cw==
Date:   Mon, 14 Mar 2022 20:27:53 +0100
From:   Marek =?UTF-8?B?QmVow7pu?= <kabel@kernel.org>
To:     Tobias Waldekranz <tobias@waldekranz.com>
Cc:     Vladimir Oltean <vladimir.oltean@nxp.com>, netdev@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Jan =?UTF-8?B?QsSbdMOtaw==?= <hagrid@svine.us>
Subject: Re: [PATCH net] net: dsa: fix panic when port leaves a bridge
Message-ID: <20220314202753.13033f28@thinkpad>
In-Reply-To: <87r174l7lj.fsf@waldekranz.com>
References: <20220314153410.31744-1-kabel@kernel.org>
        <87tuc0lelc.fsf@waldekranz.com>
        <20220314174700.56feb3da@dellmb>
        <20220314190926.687ac099@dellmb>
        <87r174l7lj.fsf@waldekranz.com>
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 14 Mar 2022 19:19:52 +0100
Tobias Waldekranz <tobias@waldekranz.com> wrote:

> On Mon, Mar 14, 2022 at 19:09, Marek Beh=C3=BAn <kabel@kernel.org> wrote:
> > On Mon, 14 Mar 2022 17:47:00 +0100
> > Marek Beh=C3=BAn <kabel@kernel.org> wrote:
> > =20
> >> Tobias, I can backport these patches to 5.4+ stable. Or have you
> >> already prepared backports? =20
> >
> > OK the patches are prepared here
> >
> > https://secure.nic.cz/files/mbehun/dsa-fix-queue/ =20
>=20
> Great, thank you!
>=20
> Not sure what the procedure is here, any action required on my part?

Not particularly. I can just send it to stable once Linus merges it.

Pity we need to wait till it gets to Linus.

Marek
