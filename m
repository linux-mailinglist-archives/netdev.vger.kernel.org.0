Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 07BD54F68EA
	for <lists+netdev@lfdr.de>; Wed,  6 Apr 2022 20:19:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239845AbiDFSEZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Apr 2022 14:04:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239810AbiDFSEO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Apr 2022 14:04:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F00827139C;
        Wed,  6 Apr 2022 09:39:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 72A7261725;
        Wed,  6 Apr 2022 16:39:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A22EC385A1;
        Wed,  6 Apr 2022 16:39:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649263159;
        bh=OfUEq6J8iH0Ir0JNWmJZkAViT/357XnNBWg3nMYlceQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=InufhPzdnWEY2M74Pa+HR8qGNaZCtFgwVMs5cB4ussp45Zj1Fsi2Ag2zu7pX7kU3e
         htvQycQtUDRi0ozVIN/2MEOVA9WNuBzQrlZa+A3cucFn6nOKsnz6lqPRQYF6+gElRY
         ff6VIr+abgqRRQWd8H1egGrj4OYp+z388yRbfI0oEMZtVaM3yx32osS8VekSdw85un
         2GZ8sjCKMGZB6hh/ZnaGK54MNJBHQRBSQOrhZU5fp3JCTv8f7Si0vAXGJMihDyclix
         fEPfv8/LPfwVPWCCiLKQJlGLUbqnRHMBK7JAbfTPUlEW73F8SqZFQ0by3CcNkKd4yz
         EDdNWDpjnnCnQ==
Date:   Wed, 6 Apr 2022 09:39:18 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Christophe Leroy <christophe.leroy@csgroup.eu>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next] sungem: Prepare cleanup of powerpc's
 asm/prom.h
Message-ID: <20220406093918.35b97b2e@kernel.org>
In-Reply-To: <f43aa220-dcef-bc4b-ebb5-74268581e3e6@csgroup.eu>
References: <fa778bf9c0a23df8a9e6fe2e2b20d936bd0a89af.1648833433.git.christophe.leroy@csgroup.eu>
        <20220405132215.75f0d5ec@kernel.org>
        <f43aa220-dcef-bc4b-ebb5-74268581e3e6@csgroup.eu>
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

On Wed, 6 Apr 2022 05:53:46 +0000 Christophe Leroy wrote:
> Le 05/04/2022 =C3=A0 22:22, Jakub Kicinski a =C3=A9crit=C2=A0:
> > On Sat,  2 Apr 2022 12:17:13 +0200 Christophe Leroy wrote: =20
> >> powerpc's asm/prom.h brings some headers that it doesn't
> >> need itself.
> >>
> >> In order to clean it up, first add missing headers in
> >> users of asm/prom.h =20
> >=20
> > Could you resend the net-next patches you had? =20
>=20
> Sure I can but,
>=20
> >=20
> > They got dropped from patchwork due to net-next being closed during
> > the merge window. =20
>=20
> https://patchwork.kernel.org/project/netdevbpf/list/?series=3D&submitter=
=3D192363&state=3D*&q=3D&archive=3D&delegate=3D
>=20
> As far as I can see they are in patchwork and two of them have been=20
> accepted, and this one is tagged as 'deferred', so do I have to resend it=
 ?

Erm, perhaps a clerical error? I don't see them in the tree.
I'd resend both.
