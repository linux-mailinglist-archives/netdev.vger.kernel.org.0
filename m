Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 77B7167F7C2
	for <lists+netdev@lfdr.de>; Sat, 28 Jan 2023 13:07:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234119AbjA1MHP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 28 Jan 2023 07:07:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234103AbjA1MHN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 28 Jan 2023 07:07:13 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CD4779F0D
        for <netdev@vger.kernel.org>; Sat, 28 Jan 2023 04:07:13 -0800 (PST)
From:   Kurt Kanzenbach <kurt@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1674907631;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=oWIU1w13hxP+SFKG39bH3M39/k7wv6132qsMHZLl2Qo=;
        b=mlzn+/dT6IFRodksumsVy9WAsFBI7b2e6NCWuIXetD3G/LXs1c4Luwn7pQJuZFFhoPXOEY
        XFfDvk8WQh6gPQNHnl4xuv+AserDCOnUD4AKzoXgFxph7kQWev0Tq8oW2nUsZ8/7GKy2mr
        0Xoc6gQ/UKDBo7NoNcN3+dGdoztEilr1phGTdck3maiCAPXDn6s1XVrS/I4NDprGrCS0SM
        sX5WQlA0tos3vAMLZiTlIO6/ZlkVZK2rtyt6eBAJCGI5nNwrCp0V+YC9CsNOQ1ZF7z3Njt
        sgW0yHcUVjVT3wTW2hfYlIPKcpB3T+OsIajcf4XNYCSZYbdXJWNHh6cZrzHyCA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1674907631;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=oWIU1w13hxP+SFKG39bH3M39/k7wv6132qsMHZLl2Qo=;
        b=TXRScpD3b2u8wVA/fFJPwyNR707DaZPSCha8Le/jO99IvLX4xXePPzlvMz0T3iwqmbJxwC
        ediIYb55uk9PgxCA==
To:     Vladimir Oltean <vladimir.oltean@nxp.com>, netdev@vger.kernel.org
Cc:     Vinicius Costa Gomes <vinicius.gomes@intel.com>
Subject: Re: [RFC PATCH net-next 14/15] net/sched: taprio: split
 segmentation logic from qdisc_enqueue()
In-Reply-To: <20230128010719.2182346-15-vladimir.oltean@nxp.com>
References: <20230128010719.2182346-1-vladimir.oltean@nxp.com>
 <20230128010719.2182346-15-vladimir.oltean@nxp.com>
Date:   Sat, 28 Jan 2023 13:07:10 +0100
Message-ID: <87tu0auakx.fsf@kurt>
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
> The majority of the taprio_enqueue()'s function is spent doing TCP
> segmentation, which doesn't look right to me. Compilers shouldn't have a
> problem in inlining code no matter how we write it, so move the
> segmentation logic to a separate function.
>
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Kurt Kanzenbach <kurt@linutronix.de>

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQJHBAEBCgAxFiEEvLm/ssjDfdPf21mSwZPR8qpGc4IFAmPVD+4THGt1cnRAbGlu
dXRyb25peC5kZQAKCRDBk9HyqkZzgltaEACryaYaHdcmXD76JIG3mg34keGa/8AE
pYpkNcOPryD3+oJwTxqN4jwAjm79ZFaLH5vWkhX/vMHhYje4Fsxw2wM8BBIJh+jI
S3GqB3SQVw4N9nVCpV7vbze6g3vLU+9+i/Q/YeNsSzgJ5aYbRx2lgJvIbpC92elw
8o36hehUwWcoflzhFjMJxfLOz1Q9B31FU+AjFTcQqT9J4dayKhYI9lQVZQI1Lr5F
f3IuV57LsJrOKQUIcs6XLJWoU9R7GXk2gkrkiNcqmx9mrR6nvbqemLpYp+agf5SG
dBTw0FTaLD8+KraWCNgmRdNGubDoPwedG0eXk7aq0rStTySJbnp8nW0yniuCbDUf
K+6/cSutMb3CPKG53LNCp6lqO+jrj6E89c3rez0bf68lCAiesTV07I1YHg1SN+AM
BLhOCJYRzDLpD0w2cbOYwBKtX4twN0AtZBgqM6vWkptitg0lLMdA0GdzXiAEzzw+
aCQoyVmOtVqFnEmLLAg+43P3xtrkn44k5ONo0gNNdWLRHt8qE+qGkOu1i7r4tlYQ
dhR/dL8Z+bq6Mg0/jmpeoNmzf2jhY4Ni5+sXMea708rlmeZmpSnXtJhj2bJ55wkg
8TFmnEJtn1VoWQxjPjOOys2RrS1irmHMGZoNhINSQdf6bMNnsZ9falACqzfvxWQg
fT120IyszKCYOg==
=pk2k
-----END PGP SIGNATURE-----
--=-=-=--
