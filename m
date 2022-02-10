Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 032934B02EC
	for <lists+netdev@lfdr.de>; Thu, 10 Feb 2022 03:06:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230419AbiBJCFw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Feb 2022 21:05:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231549AbiBJCFR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Feb 2022 21:05:17 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2859525DFF;
        Wed,  9 Feb 2022 18:01:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B8A5A6117E;
        Thu, 10 Feb 2022 02:01:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0F4AC340EE;
        Thu, 10 Feb 2022 02:01:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644458475;
        bh=PesCenNYKGfDCkBOjJ0wktqSVSTcpyqB7n5XxF1F8UM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=bBDtMA/Qh9oWqXnKfiwjYZNtgHn5K/nKmE8jCG1RuWYwjnuTwVlBjej4PeI0oAx2R
         dCYd48MbFst/MmLWeakhz7T2u9C/bG8vCJTIKbYpSW5tqX01hWMR205ltt1WXoQ/KY
         oW844z83NR6b1GPZYgVwSATnkx06CC9iF36/Pe6FLhKHpHTztQzaLkYNrynhY2zjd+
         givbCY2HZuy5seOqjBQIUq8CfJD3x+1C11Hbbz+7kTKyemAapvTw8+iqEc7jU33cWP
         FNcsH9mO92Cl2Wx4gvCL7vo/2Ta1J0Qbwn8X4xbOid3k5sEA0sF600Ynoi4jwKd/HA
         IG32/G4I4g92Q==
Date:   Wed, 9 Feb 2022 18:01:13 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc:     patchwork-bot+netdevbpf@kernel.org, Qing Wang <wangqing@vivo.com>,
        dchickles@marvell.com, sburla@marvell.com, fmanlunas@marvell.com,
        davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: ethernet: cavium: use div64_u64() instead of
 do_div()
Message-ID: <20220209180113.3b3f0f5d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <056a7276-c6f0-cd7e-9e46-1d8507a0b6b1@wanadoo.fr>
References: <1644395960-4232-1-git-send-email-wangqing@vivo.com>
        <164441341163.22778.9220881439999777663.git-patchwork-notify@kernel.org>
        <056a7276-c6f0-cd7e-9e46-1d8507a0b6b1@wanadoo.fr>
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

On Wed, 9 Feb 2022 21:01:35 +0100 Christophe JAILLET wrote:
> Le 09/02/2022 =C3=A0 14:30, patchwork-bot+netdevbpf@kernel.org a =C3=A9cr=
it=C2=A0:
> > Here is the summary with links:
> >    - net: ethernet: cavium: use div64_u64() instead of do_div()
> >      https://git.kernel.org/netdev/net-next/c/038fcdaf0470
> >=20
> > You are awesome, thank you! =20
>=20
> Hi,
>=20
> I think that this patch should be reverted because do_div() and=20
> div64_u64() don't have the same calling convention.
>=20
> See [1]
>=20
> [1]:=20
> https://lore.kernel.org/linux-kernel/20211117112559.jix3hmx7uwqmuryg@peng=
utronix.de/

Would you mind sending a revert?
