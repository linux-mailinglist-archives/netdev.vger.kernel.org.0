Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB10B629CD5
	for <lists+netdev@lfdr.de>; Tue, 15 Nov 2022 16:00:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229545AbiKOPAz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Nov 2022 10:00:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230231AbiKOO6S (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Nov 2022 09:58:18 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D59C1705E
        for <netdev@vger.kernel.org>; Tue, 15 Nov 2022 06:58:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AC2B9617BA
        for <netdev@vger.kernel.org>; Tue, 15 Nov 2022 14:58:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 968C3C433C1;
        Tue, 15 Nov 2022 14:58:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668524297;
        bh=f7OxNG4juvSoJz1DOGpDrgOHGogaGImrzt4CmQx+/8k=;
        h=In-Reply-To:References:Subject:From:Cc:To:Date:From;
        b=X2Ei1MIRT/Zfj++sJaKsX7NiRliLk4K4scQ3/yd6G0yaOyv6BHVvHOnkaFx5M1lZ2
         rnoCFto2i6DvOCgFUKJW76k27I9LXs6ufXf5VOW1nucnpeq86Y666vM1aeZFs/rqaf
         e2zdnsxf/oc2eQ6X13ry3X/IB0RdKs75/VWR2Q0I5hBboxO24DUshNRgztR94aNJZp
         HSoIkTPFxj6I81vv3h1IH7W3DdBkl1j1SHK1uqNcYOYRRuenb5h2xRa6PKh/ZQWkhA
         ssmNfzR3rGngUKo8zPFShYrF6Fh34OdZ9q7/vXyjPEdPvjU2YKKhc+H9yvNpxYm7sD
         qmPqw/cXTMO9Q==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <9facd5682e29fa5e02062c8f665d9c2370a16fdb.camel@redhat.com>
References: <20221114092033.34405-1-atenart@kernel.org> <9facd5682e29fa5e02062c8f665d9c2370a16fdb.camel@redhat.com>
Subject: Re: [PATCH net-next] net: phy: mscc: macsec: do not copy encryption keys
From:   Antoine Tenart <atenart@kernel.org>
Cc:     sd@queasysnail.net, netdev@vger.kernel.org
To:     Paolo Abeni <pabeni@redhat.com>, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org
Date:   Tue, 15 Nov 2022 15:58:13 +0100
Message-ID: <166852429383.51101.3677122083527960854@kwain>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

Quoting Paolo Abeni (2022-11-15 15:38:06)
> On Mon, 2022-11-14 at 10:20 +0100, Antoine Tenart wrote:
> > Instead of calling memzero_explicit on the key when freeing a flow,
> > let's simply not copy the key in the first place as it's only used when
> > a new flow is set up.
> >=20
> > Signed-off-by: Antoine Tenart <atenart@kernel.org>
> > ---
> >=20
> > Following
> > https://lore.kernel.org/all/20221108153459.811293-1-atenart@kernel.org/=
T/
> > refactor the MSCC PHY driver not to make a copy the encryption keys.
>=20
> The patch LGTM, but would you mind including into the commit message a
> reference to the -net commit, so that the dependency is there to
> simplify eventual backports?

Sure, will do in a v2.

Thanks!
Antoine
