Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 78FB468A7BA
	for <lists+netdev@lfdr.de>; Sat,  4 Feb 2023 02:57:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233208AbjBDB5n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Feb 2023 20:57:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232463AbjBDB5n (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Feb 2023 20:57:43 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0202B36458;
        Fri,  3 Feb 2023 17:57:41 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 902B462053;
        Sat,  4 Feb 2023 01:57:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7088C433D2;
        Sat,  4 Feb 2023 01:57:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675475860;
        bh=bVorAYvZofJTR0LZ3KP1S/JX6BONaZ+DPRW7cXlor7g=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=KffP9T0LN7C2vDD8ETlwHzmzh3iikRWqvPg4m46AtmCp0qqrt1/h5mM1COvlgkJRM
         S2C0XT/ztoadCr07dDnVL9P1PMPzyta96tOwYhHU6u9hR45gpSieo+QcVErinyFWKA
         GIueO0nNeQjGczdBfzbYJH55WNm6o6nHX+EEkdWFt565K2VKhiOLbwlXj5RlnlrtL5
         cE1kwitt3o/aLEU4eH2pNMaUipw2e6eZ/wNcD/GD8368bFkH4Odf9TIOSn/9saoXpM
         c4LcfnPwcWmbFsG04hQpOJ1k9TkkxLUg6NoPAB0HP1SmyV6FSHh1fdEGQqZ2AvuHRf
         Lg0CzgMsJ3MsA==
Date:   Fri, 3 Feb 2023 17:57:39 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Saeed Mahameed <saeed@kernel.org>
Cc:     Leon Romanovsky <leon@kernel.org>,
        Jason Gunthorpe <jgg@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Saeed Mahameed <saeedm@nvidia.com>, linux-rdma@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: pull-request: mlx5-next 2023-01-24 V2
Message-ID: <20230203175739.1fef3a24@kernel.org>
In-Reply-To: <Y92rHsui8dmZclca@x130>
References: <20230202091312.578aeb03@kernel.org>
        <Y9vvcSHlR5PW7j6D@nvidia.com>
        <20230202092507.57698495@kernel.org>
        <Y9v2ZW3mahPBXbvg@nvidia.com>
        <20230202095453.68f850bc@kernel.org>
        <Y9v61gb3ADT9rsLn@unreal>
        <Y9v93cy0s9HULnWq@x130>
        <20230202103004.26ab6ae9@kernel.org>
        <Y91pJHDYRXIb3rXe@x130>
        <20230203131456.42c14edc@kernel.org>
        <Y92rHsui8dmZclca@x130>
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

On Fri, 3 Feb 2023 16:47:26 -0800 Saeed Mahameed wrote:
> On 03 Feb 13:14, Jakub Kicinski wrote:
> >I believe Paolo is planning to look next week. No idea why the patch
> >got marked as Accepted =F0=9F=A4=B7=EF=B8=8F
> >
> >On Fri, 3 Feb 2023 12:05:56 -0800 Saeed Mahameed wrote: =20
> >> I don't agree, RDMA isn't proprietary, and I wish not to go into this
> >> political discussion, as this series isn't the right place for that. =
=20
> >
> >I don't think it's a political discussion. Or at least not in the sense
> >of hidden agendas because our agendas aren't hidden. I'm a maintainer
> >of an open source networking stack, you're working for a vendor who
> >wants to sell their own networking stack.
>=20
> we don't own any networking stack.. yes we do work on multiple opesource
> fronts and projects, but how is that related to this patchset ?=20
> For the sake of this patchset, this purely mlx5 device management, and
> yes for RoCE traffic, RoCE is RDMA spec and standard and an open source
> mainstream kernel stack.

My memory is that Leon proposed IPsec offload, I said "you're doing
this for RDMA", he said "no we will also need this for TC redirect",
I said "if you implement TC redirect that's a legit use of netdev APIs".

And now RDMA integration is coming, and no TC in sight.

I think it's reasonable for me to feel mislead.

> >I don't think we can expect Linus to take a hard stand on this, but
> >do not expect us to lend you our APIs and help you sell your product.
> >
> >Saying that RDMA/RoCE is not proprietary because there is a "standard"
> >is like saying that Windows is an open source operating system because
> >it supports POSIX.
>=20
> Apples and oranges, really :) ..=20
>=20
> Sorry but I have to disagree, the difference here is that the spec
> is open and the stack is in the mainstream linux, and there are at least
> 10 active vendors currently contributing to rdma with open source driver
> and open source user space, and there is pure software RoCE
> implementation for the paranoid who don't trust hw vendors, oh and it uses
> netdev APIs, should that be also forbidden ??

I don't want to be having theoretical discussions.
In theory there could exist a fully open RoCE implementation which
inter-operates with all other implementations perfectly. Agreed.

> What you're really saying here is that no vendor is allowed to do any
> offload or acceleration ..

IDK where you got that form, and it's obviously counter factual.
If I was nacking all offloads, I've have nacked the "full" IPsec
offload and we wouldn't be having this conversation at all.
