Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 043DE67F60D
	for <lists+netdev@lfdr.de>; Sat, 28 Jan 2023 09:18:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233817AbjA1ISz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 28 Jan 2023 03:18:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233773AbjA1ISv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 28 Jan 2023 03:18:51 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6559811E90
        for <netdev@vger.kernel.org>; Sat, 28 Jan 2023 00:18:48 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1EC12B80DFA
        for <netdev@vger.kernel.org>; Sat, 28 Jan 2023 08:18:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 370F9C433D2;
        Sat, 28 Jan 2023 08:18:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674893925;
        bh=w5LHC/FgEAYGF57Dj4LpE9XcVUjd1fOGbS6jKhkvbRY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=u/Pklvz0pa59V63aBzd1RNm6dnpTNhadClsh88jkbbEh1LGa9fi7EOiFFdD/UP571
         +tP1oxt3H7+6OqJOrc2Z3U22tuQKkl+OJqzK8BdgYbERSmd/Au8IOE/efaGK4STeVI
         +aTqidcXnEGcW+juzBTVOEg2biQR4pGVXki2TEr33kHUHXpwVPL1SqM+nX/etNyoD7
         cJfUz5dNuE4RPoO3jRZfCnYI7OksRpgoJa87S1x92+43SCKSB1xgotYCzB8Zaj4u4I
         sRgVx5nXHqbJdhFd3VSJWN9kMlfoenewquv1xOruWZwBXZqpzTyO2HteewJhu4XL+S
         XA8i7olJpC+vw==
Date:   Sat, 28 Jan 2023 00:18:44 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Paul Blakey <paulb@nvidia.com>
Cc:     <netdev@vger.kernel.org>, Saeed Mahameed <saeedm@nvidia.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Oz Shlomo <ozsh@nvidia.com>, Jiri Pirko <jiri@nvidia.com>,
        Roi Dayan <roid@nvidia.com>, Vlad Buslov <vladbu@nvidia.com>
Subject: Re: [PATCH net-next v5 0/6] net/sched: cls_api: Support hardware
 miss to tc action
Message-ID: <20230128001810.08f02b0a@kicinski-fedora-PC1C0HJN>
In-Reply-To: <20230128001640.7d7ad66c@kernel.org>
References: <20230125153218.7230-1-paulb@nvidia.com>
        <20230128001640.7d7ad66c@kernel.org>
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

On Sat, 28 Jan 2023 00:16:40 -0800 Jakub Kicinski wrote:
> On Wed, 25 Jan 2023 17:32:12 +0200 Paul Blakey wrote:
> > This series adds support for hardware miss to instruct tc to continue e=
xecution
> > in a specific tc action instance on a filter's action list. The mlx5 dr=
iver patch
> > (besides the refactors) shows its usage instead of using just chain res=
tore.
> >=20
> > Currently a filter's action list must be executed all together or
> > not at all as driver are only able to tell tc to continue executing fro=
m a
> > specific tc chain, and not a specific filter/action.
> >=20
> > This is troublesome with regards to action CT, where new connections sh=
ould
> > be sent to software (via tc chain restore), and established connections=
 can
> > be handled in hardware. =20
>=20
> I'll mark this as Deferred - would be great if Red Hat OvS offload
> folks and/or another vendor and/or Jamal gave their acks.

Ignore that, it's already Changes Requested.. =F0=9F=A4=B7=EF=B8=8F
