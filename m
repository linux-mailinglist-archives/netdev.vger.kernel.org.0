Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E37DC68D4F2
	for <lists+netdev@lfdr.de>; Tue,  7 Feb 2023 11:58:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231792AbjBGK57 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Feb 2023 05:57:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231886AbjBGK5y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Feb 2023 05:57:54 -0500
Received: from dvalin.narfation.org (dvalin.narfation.org [213.160.73.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 731F52D149
        for <netdev@vger.kernel.org>; Tue,  7 Feb 2023 02:57:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=narfation.org;
        s=20121; t=1675767467;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=twwWEE4WjjCfg99cZRakSAtV07e2F6CYBPPCSXxSISM=;
        b=Bu1w6I/JBYcenWPVw/KaX7Eyd3Q1a6ptM29w8VCgG6DffX3yuS4W+wLfbF9olSgF1/HOaD
        KD1+bQIIxv5klElwyf1LR7SY9Ydiwd8PpIbJz3nt8huylL99SFiNnME2f4R+tTWxC+ZmV7
        F7MOL+4Uoj078gv2+OkzUdneHFuDb9w=
From:   Sven Eckelmann <sven@narfation.org>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     b.a.t.m.a.n@lists.open-mesh.org, Jiri Pirko <jiri@resnulli.us>,
        Linus =?ISO-8859-1?Q?L=FCssing?= <linus.luessing@c0d3.blue>,
        kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org
Subject: Re: [PATCH 1/5] batman-adv: Start new development cycle
Date:   Tue, 07 Feb 2023 11:57:41 +0100
Message-ID: <3940036.VdNmn5OnKV@ripper>
In-Reply-To: <Y+Iq8dv0QZGebBFU@unreal>
References: <20230127102133.700173-1-sw@simonwunderlich.de> <4503106.V25eIC5XRa@ripper>
 <Y+Iq8dv0QZGebBFU@unreal>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart3012276.PIDvDuAF1L";
 micalg="pgp-sha512"; protocol="application/pgp-signature"
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--nextPart3012276.PIDvDuAF1L
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"; protected-headers="v1"
From: Sven Eckelmann <sven@narfation.org>
To: Leon Romanovsky <leon@kernel.org>
Subject: Re: [PATCH 1/5] batman-adv: Start new development cycle
Date: Tue, 07 Feb 2023 11:57:41 +0100
Message-ID: <3940036.VdNmn5OnKV@ripper>
In-Reply-To: <Y+Iq8dv0QZGebBFU@unreal>
MIME-Version: 1.0

On Tuesday, 7 February 2023 11:41:53 CET Leon Romanovsky wrote:
> Once you stop to update version, you will push users to look on the real
> version (kernel) which really matters.

I would have understood if you say "let us use a magic value like 'in-tree' or 
'linux'" but setting it to an old (existing) version number - I don't want to 
live with the headaches it creates. Because this is what users often don't 
(want) to understand: if it looks like a valid version number, why isn't it 
the valid version number? So I have to do a lot of pushing - without any 
rewards because it is necessary to push every new "user".

Kind regards,
	Sven
--nextPart3012276.PIDvDuAF1L
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEF10rh2Elc9zjMuACXYcKB8Eme0YFAmPiLqUACgkQXYcKB8Em
e0YKwxAAwewFwrNpytsfpzAIxdnmF3AgpNErn1Sv+GI0o2V41uBL0dFYi1WJu0xo
xxAqYNTujRT/+c62Rh2M64ex4pWj8rdPSk4qzHW/QYc3oxUkywger8LV6An8T5eV
LOUanSE3Jho3N2sZSxWBDrsX4d7qsDGxEm7V7LI9JTZj/OOOQhKnP4YFG2EAdXKv
a5mKp+knqu5hxjvFQHSTKRKim0rzIgo0vnWl/S2MMn9jZrwJ7Or5XBiQsUev7iTC
aWe+xoRmQRFakOBv/iedMgs2CaIUqE8u89nPm+MtaiLsyTyNArfpPU7NSsXA8sf/
DP/JtxcCvV1KYEw3709iZs89bESjAqpjk8z7wRzbYpC7yjxDoNEHZTh9bF+WKDzp
IYjsJXZ5//BcpuDDtNqnWJ81WmOue9ey+Mo1KBtW2h+1Mx8A+7z1qt1vYAGYtxgn
rnPZfZ5peIfmvt+isJCU+1W5acewaLY3UaW6D9VX4MM+HUbvk4RClUx2lcfvGITp
XooEo1Z0YOMr6GcbtYdz2Ze0uFweTlY/5lfI/C9iYY3W5Cf1B4l1xI9CdM8j7cBB
GP/smY5uARwGbGhUpdhSF+ZylvEVJLDxUh0YVTHrYjpfYMZgKOyOa0AYxy4rU1hA
ZHr8TAhqQLN83Q7hXBjHsVKCJ30W9ggNUojlDHIkorqCzQVwJ2g=
=UFiJ
-----END PGP SIGNATURE-----

--nextPart3012276.PIDvDuAF1L--



