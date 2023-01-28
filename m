Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B502467F7B0
	for <lists+netdev@lfdr.de>; Sat, 28 Jan 2023 12:59:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232098AbjA1L7Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 28 Jan 2023 06:59:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230452AbjA1L7X (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 28 Jan 2023 06:59:23 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B2FF2364E
        for <netdev@vger.kernel.org>; Sat, 28 Jan 2023 03:59:22 -0800 (PST)
From:   Kurt Kanzenbach <kurt@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1674907159;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Y/EXalUBgz5MBQw9Q+QmO8KOk48+pm9Vf9NP98XAngE=;
        b=hkdoG3kMXLuHXJBv+1NtZ/6UrSos+s3AUJZ7rQSnWaxE+xozTiWRNh0F8Ipr55FsGqM95W
        oZRqTJHPGFOMwA0FkrgMwtTaEzOAgjaABriQ/jlUM0o8fvtO/Td+9eHGpSOZCkSSGsfUwe
        lHEdUEW4LfAdTPBMNBa6C7dEOu9SgVGQnREKEMdn74m5juDrTmJaCwAxiMN8atNE0pWTyf
        zrQRAfNUfMtYuxLgIdsjCq036Hg4cy/hLq2gVG6E4gyHrnGpOIjPhYQsLmQLHZEWbPamlQ
        eC139OYLyif+ix6xISept07x/e+GPMtkQTrb6OJjV4QblGcMKOPAxfiAIR0xxA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1674907159;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Y/EXalUBgz5MBQw9Q+QmO8KOk48+pm9Vf9NP98XAngE=;
        b=4n4EdiB60q9SrqYFVwXc50jZn1V8t0R0vq4WZYMhqX5A0Fh2a9zTW9PcMZRhkvDCRUSC6O
        eoGvjtXRH3PPF7Aw==
To:     Vladimir Oltean <vladimir.oltean@nxp.com>, netdev@vger.kernel.org
Cc:     Vinicius Costa Gomes <vinicius.gomes@intel.com>
Subject: Re: [RFC PATCH net-next 01/15] net/sched: taprio: delete peek()
 implementation
In-Reply-To: <20230128010719.2182346-2-vladimir.oltean@nxp.com>
References: <20230128010719.2182346-1-vladimir.oltean@nxp.com>
 <20230128010719.2182346-2-vladimir.oltean@nxp.com>
Date:   Sat, 28 Jan 2023 12:59:18 +0100
Message-ID: <87v8kqvpih.fsf@kurt>
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
> There isn't any code in the network stack which calls taprio_peek().
> We only see qdisc->ops->peek() being called on child qdiscs of other
> classful qdiscs, never from the generic qdisc code. Whereas taprio is
> never a child qdisc, it is always root.
>
> This snippet of a comment from qdisc_peek_dequeued() seems to confirm:
>
> 	/* we can reuse ->gso_skb because peek isn't called for root qdiscs */
>
> Since I've been known to be wrong many times though, I'm not completely
> removing it, but leaving a stub function in place which emits a warning.
>
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Kurt Kanzenbach <kurt@linutronix.de>

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQJHBAEBCgAxFiEEvLm/ssjDfdPf21mSwZPR8qpGc4IFAmPVDhYTHGt1cnRAbGlu
dXRyb25peC5kZQAKCRDBk9HyqkZzghmzD/9hdERtSNmkuIM0ZBqE/cvRnrOMApxh
C0L3HhCfkFpETjuekcFswB927tuIdZ6TouvL/3CXYIbB1DIF20PjB4y0KFS7inOQ
dmok/kvwpvHH9m3FYFwafKEem0JWDG5cwQjA7HwEyMBiZKmSj+gRtZ2N0sMrFYAN
Xh1oDEgm+rVh3n0HoMOFtTk5vrhnuWcpDJXsA2n6vXoI69penOpKV/ErFkzFjXvj
hPZRpmrCNfVzPU4dS0bpcf6apgPyQanuKM1tYMJKX3X9HMLV86cj6/sFxooHzBkS
LdxM1EyW8auVUObi7zadD9FAjuYLIZhYokO9QmGaMSEB9rckuyb7QqR2XZAeVzcr
kzRTpkNEzGtojtxIGacpT9hS6JapYBniwJWxdC1/kL/wvm+6r+BiqINJDm5uW292
TCilfLxX3oDw9hKeNIeB/ltbkAVQJtlTB/BGS02KBgz9ObYHVaPuDiGr8omN5y9D
Km+WeKNImswpAuVticVlhoj2Yrsq6HKRSVRNI+LjaBA+Or7mxEcIzddWabrQ1BHv
bmA6TGUix73pc6+dh7mdSqRXk6URkD2dTgCN/CIKko0Lv7LpRvVdO3/VMJZvuJoA
WdFnUFu4ACC2xtOAZpvXTEUcV7iVeU8q4AyPyQXsBFl7ojj2UBEMbU8EIrN9IQFd
Pb5R7UIUrLXeCg==
=/kWS
-----END PGP SIGNATURE-----
--=-=-=--
