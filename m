Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C899D50DBCF
	for <lists+netdev@lfdr.de>; Mon, 25 Apr 2022 10:57:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240179AbiDYJAX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Apr 2022 05:00:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240068AbiDYJAW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Apr 2022 05:00:22 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2B6B13DD6
        for <netdev@vger.kernel.org>; Mon, 25 Apr 2022 01:57:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8F074614EE
        for <netdev@vger.kernel.org>; Mon, 25 Apr 2022 08:57:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFE44C385A7;
        Mon, 25 Apr 2022 08:57:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650877037;
        bh=vMdH0udi4LYgeruqX/zLF+e57iQvSCVnWceNR9oAmaA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=o9VxN8krN+ARe0B76dEEI1i7cp/bd9xGoO9QMQ8ynA45Q4NEvPKq6Bv2c/kzQV2hh
         6SREgWwIH5qiFf+Lhjusi5PypFm58o1OsdJau++RTxBMBVtOZDTBDXkC4ms/qshopm
         wPg3c2/yl5bC0uDLFwNJQUeIOTKPIb+fBm7MFUg8zO6DN0gJgJql9HDBTp1zkmIaVC
         rqg4BiZYsuoFcW0oizhzNS254p6dMFO9y0gGOPrt1IJJ1VpaPkMrg3LsXbUjWwkDFR
         AN82SINkgICq8T5OpiAvHgx3DgjeWzEcsUoI1yRjkXLiggfqYXjxSWRr00UzqJ/yvh
         Ec+kZ532/5Epw==
Date:   Mon, 25 Apr 2022 10:57:12 +0200
From:   Marek =?UTF-8?B?QmVow7pu?= <kabel@kernel.org>
To:     Baruch Siach <baruch@tkos.co.il>
Cc:     Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        Baruch Siach <baruch.siach@siklu.com>
Subject: Re: [PATCH] net: phy: marvell10g: fix return value on error
Message-ID: <20220425105712.6891182d@thinkpad>
In-Reply-To: <f47cb031aeae873bb008ba35001607304a171a20.1650868058.git.baruch@tkos.co.il>
References: <f47cb031aeae873bb008ba35001607304a171a20.1650868058.git.baruch@tkos.co.il>
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
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

On Mon, 25 Apr 2022 09:27:38 +0300
Baruch Siach <baruch@tkos.co.il> wrote:

> From: Baruch Siach <baruch.siach@siklu.com>
>=20
> Return back the error value that we get from phy_read_mmd().
>=20
> Fixes: c84786fa8f91 ("net: phy: marvell10g: read copper results from CSSR=
1")
> Signed-off-by: Baruch Siach <baruch.siach@siklu.com>

Reviewed-by: Marek Beh=C3=BAn <kabel@kernel.org>
