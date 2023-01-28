Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E5AD467F7BD
	for <lists+netdev@lfdr.de>; Sat, 28 Jan 2023 13:06:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232477AbjA1MF7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 28 Jan 2023 07:05:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234052AbjA1MF6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 28 Jan 2023 07:05:58 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDF62790A1
        for <netdev@vger.kernel.org>; Sat, 28 Jan 2023 04:05:57 -0800 (PST)
From:   Kurt Kanzenbach <kurt@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1674907556;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=4OFjzZukP2Uq8MHHu8p0E+XfE1WWveheAs0H2mGRx1c=;
        b=ZL1ZcGbeh9ossVYep9d7VfQ45L32qPtpPmaVs/pipq0pzSjhJwU9MXBuxGa5EjUzggfHhE
        p3V1MyCt2OubmFjXaHX+6xsaSwHTPSV+K0l+0cfQ74phImZAeBxM2yCmwiu61ElN4hpHGi
        XKrTKxyBgn9M8ID4CDE3qxBmG8G24LQhGgD2PzYNniRkMbSyv+uOXv2igyJtX7P/NFKTu7
        ylVQv3BB4OeOoDeNmvg2cjT7xII4MplSHl1w7r+tjZVtvrwDvuHw0qBgL1hQOKSkH8CxHL
        b+BqNoDRXf3MNnuJUKAZU8mniTFB0+sBngebX/bd9V9ViOyThtufPnfl1mnYhg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1674907556;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=4OFjzZukP2Uq8MHHu8p0E+XfE1WWveheAs0H2mGRx1c=;
        b=tBRG4xqXh6BiJQMch7clv3QPUrECG9pixQ17DCffJQdDMLWpmMvs3eYMw2mibWjwYLx2dP
        cW/wZpi5+tFf7YCw==
To:     Vladimir Oltean <vladimir.oltean@nxp.com>, netdev@vger.kernel.org
Cc:     Vinicius Costa Gomes <vinicius.gomes@intel.com>
Subject: Re: [RFC PATCH net-next 09/15] net/sched: taprio: calculate guard
 band against actual TC gate close time
In-Reply-To: <20230128010719.2182346-10-vladimir.oltean@nxp.com>
References: <20230128010719.2182346-1-vladimir.oltean@nxp.com>
 <20230128010719.2182346-10-vladimir.oltean@nxp.com>
Date:   Sat, 28 Jan 2023 13:05:55 +0100
Message-ID: <878rhmvp7g.fsf@kurt>
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
> taprio_dequeue_from_txq() looks at the entry->end_time to determine
> whether the skb will overrun its traffic class gate, as if at the end of
> the schedule entry there surely is a "gate close" event for it. Hint:
> maybe there isn't.
>
> For each schedule entry, introduce an array of kernel times which
> actually tracks when in the future will there be an *actual* gate close
> event for that traffic class, and use that in the guard band overrun
> calculation.
>
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Kurt Kanzenbach <kurt@linutronix.de>

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQJHBAEBCgAxFiEEvLm/ssjDfdPf21mSwZPR8qpGc4IFAmPVD6MTHGt1cnRAbGlu
dXRyb25peC5kZQAKCRDBk9HyqkZzgqUVEACPamzwBeGzEHB64c0wydo0foDJevwM
VKOHR3a6FAVNdHCVSj8uEoaNszvtOU2BHty4TMbJdld5pCGoBuh/OiuBH659l6Lq
Tv6iJ0ldauPoDDuTldsd5e1ohZoVDI3HWw5S4bMq6sYcuVgqitzlUu0jtnWbnoak
bc2cYAcXQr0ow30jDu52FQXA4bJAJ8b9r8poX+o3iq3NZNu5kKH1dU21XuzUJToD
dh/zUj7DSZBXKi+UKMUhZy9+M2eFpehqHG7k7DTloOApg6OPBfzFKsn7DZa9lisN
Mwma4cFdaTjRdv+X1ZCz1YdHUgBE1pogFMRnmJFTuHVM0qY7HB/MYSaeXJ4WNwdb
I5OGDmqQBHBs4xw5k6Vl9hn8CvymJDuNT6pX3wM1feNaTK0RxdJEF/fO8DdY5ejW
lAFdHrQvoB8li9hZ8mJ/UBnw5K32Nw32u9QkkOM+p4WwL5cU8Ou852PNnn4LiTaN
C4JL7acRk1zvxWUMH/k8p1bup7i3eqr1GZEL7JSoU4gqHdsPaL2vgGfjBfIFeZMA
hy6gMykIFleun6owNUca8SAplMA44x/0D4fDCl1idgb+xF615cvpS1xwQZW7b+kB
mhFT6DK5VEALXXN1nRNTcczi0LavUdWJv+3ZBdXol+Z4W7VtV/p4jashE15DlKGg
5SVV4Vlu3ciufA==
=Zgw2
-----END PGP SIGNATURE-----
--=-=-=--
