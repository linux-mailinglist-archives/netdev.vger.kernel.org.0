Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2B4065523C3
	for <lists+netdev@lfdr.de>; Mon, 20 Jun 2022 20:20:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245274AbiFTSUL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jun 2022 14:20:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244784AbiFTSUK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jun 2022 14:20:10 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12B5D1D0EC;
        Mon, 20 Jun 2022 11:20:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9C9EA615A0;
        Mon, 20 Jun 2022 18:20:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 680DFC3411B;
        Mon, 20 Jun 2022 18:20:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1655749207;
        bh=x+MSuR8qiYAoAuTw0a3wDkLNwPe4DgSH2PEwnYzOPFw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=rX1SzwCoa1vEVgBjzIbtYKbbVHCUtteCvFrM4r0Tzmvofc1lQqZn3vLkdSDmWfb+r
         YufwgFVeXCw9/XPGyJuA9xlTpig4X6Hq/JF5c2hexgOqzlY4OMASE7kPHyoV7CcvX1
         RTv/XlRpulRtoW9JSBqDgACkHFrxOqXS+cEoRfD8JDWXG7igJFHoLbT5o8/jI2L+aQ
         pVvfxy3NOT4ncv0SLqlNBa0C4GQfvCmC4pBXu2ivdIiFarUeHWzEvJNJ6QsRwSMmIM
         Nz2Ov5hJXIEv0L2U8CkzNuCC0KqRWSi7+al7C/2gq4QpUQUSxvVcCGg3JFSty1nGLz
         IarKYVYr1W0dQ==
Date:   Mon, 20 Jun 2022 11:20:06 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     jdmason@kudzu.us
Cc:     patchwork-bot+netdevbpf@kernel.org,
        Wentao_Liang <Wentao_Liang_g@163.com>, davem@davemloft.net,
        edumazet@google.com, pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drivers/net/ethernet/neterion/vxge: Fix a
 use-after-free bug in vxge-main.c
Message-ID: <20220620112006.48c09ef6@kernel.org>
In-Reply-To: <20220620085649.79989775@kernel.org>
References: <20220619141454.3881-1-Wentao_Liang_g@163.com>
        <165563641313.16837.10425130041626423819.git-patchwork-notify@kernel.org>
        <20220620085649.79989775@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 20 Jun 2022 08:56:49 -0700 Jakub Kicinski wrote:
> > Here is the summary with links:
> >   - drivers/net/ethernet/neterion/vxge: Fix a use-after-free bug in vxg=
e-main.c
> >     https://git.kernel.org/netdev/net/c/8fc74d18639a
> >=20
> > You are awesome, thank you! =20
>=20
> =F0=9F=98=AD=F0=9F=98=AD=F0=9F=98=AD
>=20
> Jon, if you care about this driver staying upstream please send=20
> a correct fix (on top of this change since it's already merged).

Actually, let me just send a revert, so I don't have to remember=20
to get this fixed before Thursday's PR to Linus.
