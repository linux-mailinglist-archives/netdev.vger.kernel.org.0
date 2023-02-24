Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 922E26A1BF6
	for <lists+netdev@lfdr.de>; Fri, 24 Feb 2023 13:11:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229758AbjBXML3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Feb 2023 07:11:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229838AbjBXML2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Feb 2023 07:11:28 -0500
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B73515D469
        for <netdev@vger.kernel.org>; Fri, 24 Feb 2023 04:11:07 -0800 (PST)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id 2825A38C22;
        Fri, 24 Feb 2023 12:10:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1677240652; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=hqDliG01w5FWWjrW1HlTSGgLUD8gyej3e3gtyjKg+Ig=;
        b=zG806qYyEE0wywcnZ4iQuGFuL17FqPFUAe0lnmQaNGitY4JnSUAWN/9lRc3n2e6wV9IFAT
        307I4GnHkLuoy9uHQpOOmZ+NROKUkhMCSvOMlHuOuy5TdYE24GWzU8ikWAhNWPYiN7BPDc
        kptPUurTRatelUqkcPgrT00fWBdiLx4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1677240652;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=hqDliG01w5FWWjrW1HlTSGgLUD8gyej3e3gtyjKg+Ig=;
        b=Bn6XNVopyIGSkcPm3H/cxZCnSrCNn+ee4pN9Og2AM6lRppWI7b2hrxSGhCShKSeGzyN7WO
        dRP9n/RtE3yILoAA==
Received: from unicorn.suse.cz (unicorn.suse.cz [10.100.12.242])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id 1700C2C141;
        Fri, 24 Feb 2023 12:10:52 +0000 (UTC)
Received: by unicorn.suse.cz (Postfix, from userid 1000)
        id E1F2FE03CF; Fri, 24 Feb 2023 13:10:51 +0100 (CET)
Date:   Fri, 24 Feb 2023 13:10:51 +0100
From:   Michal Kubecek <mkubecek@suse.cz>
To:     Thomas Devoogdt <thomas@devoogdt.com>
Cc:     netdev@vger.kernel.org, Thomas Devoogdt <thomas.devoogdt@barco.com>
Subject: Re: [PATCH ethtool] uapi: if.h: fix linux/libc-compat.h include on
 Linux < 3.12
Message-ID: <20230224121051.GA7007@unicorn.suse.cz>
References: <CACXRmJiuDeBW4in51_TUG5guLHLc7HZqfCTxCwMr6y_xGdUR5g@mail.gmail.com>
 <20230223211735.v62yutmzmwx3awb2@lion.mk-sys.cz>
 <CACXRmJj8hkni1NdKHvutCQw3An-uwu0MJkHFDS14d+OiwzDHZA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="yrj/dFKFPuw6o+aM"
Content-Disposition: inline
In-Reply-To: <CACXRmJj8hkni1NdKHvutCQw3An-uwu0MJkHFDS14d+OiwzDHZA@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--yrj/dFKFPuw6o+aM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Feb 24, 2023 at 11:05:43AM +0100, Thomas Devoogdt wrote:
>=20
> I now remember (while looking at the other patches I had to add) that
> I'm also missing __kernel_sa_family_t from /uapi/linux/socket.h (for
> Linux < 3.7). So it's indeed not just libc-compat.h which is causing
> problems. So perhaps take that one along while at it.

At the moment, the full set to add would be

    linux/const.h
    linux/if_addr.h
    linux/if_ether.h
    linux/libc-compat.h
    linux/neighbour.h
    linux/posix_types.h
    linux/socket.h
    linux/stddef.h
    linux/types.h

It looks like a lot but maintaining the whole uapi subdirectory can be
fully scripted. Then I realized that there can be more than just linux/*
and updated the script to pull in everything found in exported kernel
headers. That added few more files:

    asm-generic/bitsperlong.h
    asm-generic/int-ll64.h
    asm-generic/types.h
    asm/bitsperlong.h
    asm/posix_types.h
    asm/types.h

This is a bit more tricky as asm/* are architecture dependent. I suppose
just taking x86_64 versions everywhere would be a bad idea for headers
defining types. So I guess we may either omit asm/ or both asm-generic/
and asm/. Neither is perfect and I'm not completely sure which option is
safer.

Michal

--yrj/dFKFPuw6o+aM
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEWN3j3bieVmp26mKO538sG/LRdpUFAmP4qUEACgkQ538sG/LR
dpUd9Af/bXYmPSCiiWqhknjqVvbl3271MD84mgRLlsd7g+ZxIYDRHnnlNRhz3anF
jp+qA/eyiex51rwue/c2Uou2BwI4RZKCtRWyZaQDI9u16uQLQ461D4Nmg5bGu+bl
mmX6ZdazbsJQFIb8GVA9JJPdpBh+TOVOAZ0a5vPzaDNT/nYu9LBkCHrvyPnyZxTi
iciYo5DfCKpk41dRbZggusJMlhMrk94GYZddZ7vSqNMtv+yX3mu0jNyQ8rAbR6+u
lC9z7IjxSwok4Vh9p0Rx1E6qNXrxbXC3MGt2rwOQRVFkkgyETatnvx6jv1YruQ4b
hOb5A/ylflFULdXlT7Gxj+AZPUXh6w==
=rKYa
-----END PGP SIGNATURE-----

--yrj/dFKFPuw6o+aM--
