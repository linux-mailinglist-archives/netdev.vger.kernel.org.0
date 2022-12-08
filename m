Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C7407646CAE
	for <lists+netdev@lfdr.de>; Thu,  8 Dec 2022 11:25:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229517AbiLHKZY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Dec 2022 05:25:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229437AbiLHKZX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Dec 2022 05:25:23 -0500
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3AE448401
        for <netdev@vger.kernel.org>; Thu,  8 Dec 2022 02:25:22 -0800 (PST)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id A6B9C33779;
        Thu,  8 Dec 2022 10:25:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1670495121; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=oKpUG++kxKtkhIdGGK7yZrbSjfROIG6FTWOMiZL1Vsk=;
        b=EctgejjYvR7thPcVTNiPHhZj6rlZFOT599V0GG+nzVcZ8kWmZrTNULHjmcKsLzrFjEIIGw
        O4vWp62TlroimXVGObK1n2ujqDk9UvV9ACRJsElSiQR/YvN//xueKuiNtkxN+y56FoV1er
        iH/XJKrqOH37iJ5gYgZMyn3jo78Fe8k=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1670495121;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=oKpUG++kxKtkhIdGGK7yZrbSjfROIG6FTWOMiZL1Vsk=;
        b=4+hggiVulPV6Ydjucl547u4Y2+uuajNVLaaEhjfvouLog/txX+SXqFgBFNNCu+mO5ovD2K
        mSMxbM/Ub4fYoaBg==
Received: from lion.mk-sys.cz (unknown [10.100.200.14])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id 645D62C142;
        Thu,  8 Dec 2022 10:25:19 +0000 (UTC)
Received: by lion.mk-sys.cz (Postfix, from userid 1000)
        id 5C9456045E; Thu,  8 Dec 2022 11:25:21 +0100 (CET)
Date:   Thu, 8 Dec 2022 11:25:21 +0100
From:   Michal Kubecek <mkubecek@suse.cz>
To:     Jesse Brandeburg <jesse.brandeburg@intel.com>
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH ethtool v2 04/13] ethtool: commonize power related strings
Message-ID: <20221208102521.rqbw6d4wqipal5qy@lion.mk-sys.cz>
References: <20221208011122.2343363-1-jesse.brandeburg@intel.com>
 <20221208011122.2343363-5-jesse.brandeburg@intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="w7e4ykjeoqavm2kb"
Content-Disposition: inline
In-Reply-To: <20221208011122.2343363-5-jesse.brandeburg@intel.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--w7e4ykjeoqavm2kb
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Dec 07, 2022 at 05:11:13PM -0800, Jesse Brandeburg wrote:
> When looking into the implementation of the qsfp.h file, I found three
> pieces of code all doing the same thing and using similar, but bespoke
> strings.
>=20
> Just make one set of strings for all three places to use. I made an
> effort to see if there was any size change due to making this change but
> I see no difference.
>=20
> Signed-off-by: Jesse Brandeburg <jesse.brandeburg@intel.com>

Acked-by: Michal Kubecek <mkubecek@suse.cz>

Perhaps you might go one step further and replace the whole repeating

  sd->rx_power_type ? rx_power_average : rx_power_oma

pattern with an inline helper.

Michal

--w7e4ykjeoqavm2kb
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCAAdFiEEWN3j3bieVmp26mKO538sG/LRdpUFAmORu40ACgkQ538sG/LR
dpUaHwgAx9/3BJCbq4fQILgDKd5r0FmWFI++Lph7EwEYpfaSBoiRPcDlwbIbXFH1
HOMzpLxyU9L+MG+MtrQWIO379o+zKNyfITDHcNHBsLJyduz5nAMwaJjWjVkL4W1B
mb9P3Xt2qIPRFStFM54bnmzh6WxIXoDpQsg8NTLcbrAY3sqhqS3ZxGdLK/x3ipQi
/mikRIZruKAyFCTDDqaCqOmiHV3wHyfDgXPsrBDVXLk6YzX31Kc+0wm3NI6gOFB5
kuLR7lf42JXKzT6rpILDaqbWcpNn7vIYGKvmCGgy7YRj/QLSmqt/BIlq0yLjpRoy
MmzluGg+B/cJNo3hMBU4Tw3vbscsAA==
=vAnk
-----END PGP SIGNATURE-----

--w7e4ykjeoqavm2kb--
