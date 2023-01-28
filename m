Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E2E4567F7BB
	for <lists+netdev@lfdr.de>; Sat, 28 Jan 2023 13:05:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234050AbjA1MFe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 28 Jan 2023 07:05:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232477AbjA1MFc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 28 Jan 2023 07:05:32 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3455A79099
        for <netdev@vger.kernel.org>; Sat, 28 Jan 2023 04:05:32 -0800 (PST)
From:   Kurt Kanzenbach <kurt@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1674907530;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Ygm3Nxkk5pa+SLI1ONz6czhMycSkh9RzC+1YpRQd/7A=;
        b=Qn7lIRMU/byGZbGBfmFyvCglFad/Dt5IUCkogPVgB6MFmnoLu/yt7mPLnsXXw+nmJ0UA/+
        WGAv+jLhFCmONw2j6cvNDOyK9A3Aw+UxBl/5wPLSio8v/KmRxR5cofypvqLxVdo3AP5cIr
        XaSUWvD49uRkUkOyj84Lx5gR/wt/QvdXkjCXzJ486YftQ0kT+EvqalqfYWjdoHs1mvYFX0
        aIb4CInex/taewD6iWiiYL0mRUtcpCbIDhItcd/LWUEP4mWfqgfBaYOnS5wD413V8W8jq0
        NsLo+Sz8mULwdB25Xa7Rho/EybU0MmaCTN3e3TfeIPI81oOWxl8RCNCJzjcSzw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1674907530;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Ygm3Nxkk5pa+SLI1ONz6czhMycSkh9RzC+1YpRQd/7A=;
        b=GWoc8S/gEFzoSeQ3X/s9v5ABbak8ee42DHUJV09b0/QxGLCNksskfJaKuks6w75cPn8Xlg
        ZYM7hspO9jouZqDg==
To:     Vladimir Oltean <vladimir.oltean@nxp.com>, netdev@vger.kernel.org
Cc:     Vinicius Costa Gomes <vinicius.gomes@intel.com>
Subject: Re: [RFC PATCH net-next 07/15] net/sched: taprio: rename close_time
 to end_time
In-Reply-To: <20230128010719.2182346-8-vladimir.oltean@nxp.com>
References: <20230128010719.2182346-1-vladimir.oltean@nxp.com>
 <20230128010719.2182346-8-vladimir.oltean@nxp.com>
Date:   Sat, 28 Jan 2023 13:05:29 +0100
Message-ID: <87edrevp86.fsf@kurt>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha512; protocol="application/pgp-signature"
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--=-=-=
Content-Type: text/plain

On Sat Jan 28 2023, Vladimir Oltean wrote:
> There is a confusion in terms in taprio which makes what is called
> "close_time" to be actually used for 2 things:
>
> 1. determining when an entry "closes" such that transmitted skbs are
>    never allowed to overrun that time (?!)
> 2. an aid for determining when to advance and/or restart the schedule
>    using the hrtimer
>
> It makes more sense to call this so-called "close_time" "end_time",
> because it's not clear at all to me what "closes". Future patches will
> hopefully make better use of the term "to close".
>
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Kurt Kanzenbach <kurt@linutronix.de>

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQJHBAEBCgAxFiEEvLm/ssjDfdPf21mSwZPR8qpGc4IFAmPVD4kTHGt1cnRAbGlu
dXRyb25peC5kZQAKCRDBk9HyqkZzgrsLD/9xcZXfYKg1q1KdnQt1GZhkjmeFRbnW
jsvrvRwY8gn0NByN1di1v+dBweMjn29eHc7yJfwotQ/qpYDfvcAztM8X1c6qP+OK
iTKl9BlATfBDC/RNEChf4Zn9LldviAPHas4ECg5TuClOoXGqJ8b3EG8nL5Mxp0yt
zezRkz8zLToBmPbkG5ErKqjquHTdNoZ9QmBabLMBrdxYI+BRZcY5eHXgkYjSBh6D
BA/IlymKh3RKj6H6749PGa+7BSfQ6IxdA/y4gCP/yMbFdUux6okQGcgk4LUhoB7v
/3fOW4w5l+uPe9aydNKEPFSPXY6k/7bh9mVKWD0+akl34Mm4xyQwYFAO7/m/5kN9
kE7wgW+wnQWowxE323pDiuQbTVBUPcu5Gp53yIrm3sVDprR3PvWzLSRMCidBfxTp
1ogLfTinyCK6wtMdtUOSq1a4YtQBrv2a9ev6JR3jueDZOIcrw1DWdH69tS25A8a7
3RRfSRXTWvzIUN9AwKeRDM0atgQBpzXpcAvhj+Q3yeBxb7saXHTZKrkErNBJfl+S
N0/90Sr9NnDObiIe/BBT+PAyCkd9HZRghmiaeppFurSqCggZMJOi2R0zbHOL88YL
xT1b+Bc/Blh6yF3F5B+9SBYMUez4W5r/M/ksRJsW5PVFJNsTExlxFqSKUWdQxh6O
BB14JAOVEEGpCQ==
=oehW
-----END PGP SIGNATURE-----
--=-=-=--
