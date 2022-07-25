Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 15CE35803E2
	for <lists+netdev@lfdr.de>; Mon, 25 Jul 2022 20:18:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229942AbiGYSSd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Jul 2022 14:18:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235786AbiGYSSc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jul 2022 14:18:32 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C4EE1EEEC
        for <netdev@vger.kernel.org>; Mon, 25 Jul 2022 11:18:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 49A14B81025
        for <netdev@vger.kernel.org>; Mon, 25 Jul 2022 18:18:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9A09C341C8;
        Mon, 25 Jul 2022 18:18:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658773109;
        bh=goOzq3Z8iS5RBEqXhX6gucINTt84fjgDxtA8VxZ4fyc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=MpfLO/K2tkHQwclBS4vgZQZ1YWyaEYsWPTPus1Jn4kUXr7q7+LxLN/xkN0qsL4+no
         oaVMJJUToWMaVz0TdSNJJku1vNObP5v5vgwmq5ZEn9jT7Mqx7E2OJRiOYxl95sPTXI
         xNN/5wIAgemt87k9xt5g7MGjaCxa3jc8Se1kZSUQ2OsAQqC3NzawujhrbjI80ftktl
         39u+RD8gkCoRCtN3o6U3X0VfWFlXvx+kseqYfhDo/GCz53BBzX4IF+92Q244zXNsU8
         /+td7CCGhFhbC5hhX4nMY3//AjMhx6Qx/8IBRGIYvg8bd9A88ggKJT4b7GtiVJpCZF
         Xz8y9Gwgo5Ogg==
Date:   Mon, 25 Jul 2022 11:18:27 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Steffen Klassert <steffen.klassert@secunet.com>
Cc:     David Miller <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        <netdev@vger.kernel.org>
Subject: Re: [PATCH 0/5] pull request (net-next): ipsec-next 2022-07-20
Message-ID: <20220725111827.4aa36c4a@kernel.org>
In-Reply-To: <20220725122302.GI678471@gauss3.secunet.de>
References: <20220720081746.1187382-1-steffen.klassert@secunet.com>
        <20220725122302.GI678471@gauss3.secunet.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 25 Jul 2022 14:23:02 +0200 Steffen Klassert wrote:
> On Wed, Jul 20, 2022 at 10:17:41AM +0200, Steffen Klassert wrote:
> > 1) Don't set DST_NOPOLICY in IPv4, a recent patch made this
> >    superfluous. From Eyal Birger.
> >=20
> > 2) Convert alg_key to flexible array member to avoid an iproute2
> >    compile warning when built with gcc-12.
> >    From Stephen Hemminger.
> >=20
> > 3) xfrm_register_km and xfrm_unregister_km do always return 0
> >    so change the type to void. From Zhengchao Shao.
> >=20
> > 4) Fix spelling mistake in esp6.c
> >    From Zhang Jiaming.
> >=20
> > 5) Improve the wording of comment above XFRM_OFFLOAD flags.
> >    From Petr Van=C4=9Bk.
> >=20
> > Please pull or let me know if there are problems. =20
>=20
> Can anyone reconsider this pull request?
>=20
> It is marked as Accepted in patchwork, but seems not to be included
> in net-next.

FTR DaveM pulled it this morning (e222dc8d8408 ("Merge branch 'master'
of git://git.kernel.org/pub/scm/linux/kernel/git/klassert/ipsec-next"))
sorry for the wait!
