Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 622CA67F7B3
	for <lists+netdev@lfdr.de>; Sat, 28 Jan 2023 13:00:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233931AbjA1MAJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 28 Jan 2023 07:00:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233971AbjA1MAH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 28 Jan 2023 07:00:07 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23EF0728D0
        for <netdev@vger.kernel.org>; Sat, 28 Jan 2023 04:00:06 -0800 (PST)
From:   Kurt Kanzenbach <kurt@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1674907204;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=XVe1uNwoM/19UfWJElUZa2hhQ4Q0hhXmDM2Bi1pl7LA=;
        b=wkQL3g6p3VXF3AOHgE+g/8qttmYxluz6kBYjiXnebpt9890x0a6ZtY6LArD8+jl2a7Aw3L
        xnjNI74OFPVLIDAoVX0Z3DP38rfvxCGnc4Gs/IMIcHhHQamg40qXY/cFCkVYRxQp1VTzAn
        T+uFvZBUk0mKkChEvXnowo/bIvO9512Wqcre/aJBfPaYvyHbnr7CbWuMYAPi6SW9r+lRbT
        IlcLzFmy7eIMMZOAiGceQh44LzfoBZcke017SgjZXPpgLLsmObI9HMtSqSawt+w7dY/PuR
        +rIaknhpBO4yFVfbzPiQN7PPnDJEgs8D8Smuk6PJnpq0D36Yp04HSs/VrEFRhw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1674907204;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=XVe1uNwoM/19UfWJElUZa2hhQ4Q0hhXmDM2Bi1pl7LA=;
        b=YccETaYB8S53jn/IRrzCGC4PYDvgQWmU8QSi7n3FLo9nhY/KHq1kyFTYigTWo698pBA37h
        RZ+EKw09NDSuLICQ==
To:     Vladimir Oltean <vladimir.oltean@nxp.com>, netdev@vger.kernel.org
Cc:     Vinicius Costa Gomes <vinicius.gomes@intel.com>
Subject: Re: [RFC PATCH net-next 04/15] net/sched: taprio: avoid calling
 child->ops->dequeue(child) twice
In-Reply-To: <20230128010719.2182346-5-vladimir.oltean@nxp.com>
References: <20230128010719.2182346-1-vladimir.oltean@nxp.com>
 <20230128010719.2182346-5-vladimir.oltean@nxp.com>
Date:   Sat, 28 Jan 2023 13:00:03 +0100
Message-ID: <87mt62vph8.fsf@kurt>
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
> Simplify taprio_dequeue_from_txq() by noticing that we can goto one call
> earlier than the previous skb_found label. This is possible because
> we've unified the treatment of the child->ops->dequeue(child) return
> call, we always try other TXQs now, instead of abandoning the root
> dequeue completely if we failed in the peek() case.
>
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Kurt Kanzenbach <kurt@linutronix.de>

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQJHBAEBCgAxFiEEvLm/ssjDfdPf21mSwZPR8qpGc4IFAmPVDkMTHGt1cnRAbGlu
dXRyb25peC5kZQAKCRDBk9HyqkZzgvuhEACARXWev0rtYPZgkwVgoJjZxQTZMlml
pZl/XFMLBGrkHRKrxgLxH+s8w/dMNHHBCYWb1/hwnPz3+BeUVf2//Mwy+Chi0xMV
ERthcMez5Fay403vfTFG71AkVOrzYQIyEkAHK+n5z4qMayWVS/6ClGuaPmVUTAoR
Cy0k9d8oxz7qUnSxI6YmdFQmCOqCSRK1/0w9uCD+aWVbi1eb8SPtjDOoHR/hOqRb
wRIg2RWXBf8GFaom/9vu9A7q1YRstswmKa0CnzopPSIYyRab0FBDqK7ZD2yRxwZV
TGHDyKA7ZKD5P6wVNvVxh6wDsKV+wPIS1OxUJl8fUgaTYNNKTLCE8oJ8ABmj8f0f
BfT25/2CApjmtigKxWPZqR2+QveS5VSVEG810w92PfUtWttEsFZwEtSrhtp01gWu
223v+1zKF/cYUMjt46cGjzO+HyPEjlg9ZyoxPQU3cUMTs3VDBUzTrScr6phK2f7N
epGGUmd9ThCVv/H4BTDQw7KsmCbLZj7EdouVpfA88emY6Dj9nQVc7/vxo+oHBo+l
HOCrfp7YgCgLmxJmCQ1h6PlaALvh88krSEkgIbKR1DqhpOMP441pU7WslpLOQt/1
bwb8nWwKm9kr5z0C6wyYUpNRQIqjV72sfhQlP65KUaemZ+YBdWmYnrB71O/klCDq
vVGj54RweQsakg==
=Cmhp
-----END PGP SIGNATURE-----
--=-=-=--
