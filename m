Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C70967B2FA
	for <lists+netdev@lfdr.de>; Wed, 25 Jan 2023 14:09:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234529AbjAYNJd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Jan 2023 08:09:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229571AbjAYNJc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Jan 2023 08:09:32 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D553D4617E
        for <netdev@vger.kernel.org>; Wed, 25 Jan 2023 05:09:31 -0800 (PST)
From:   Kurt Kanzenbach <kurt@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1674652169;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=QwDV/29udP1hyz25Yq9mcpQieAxTOux2pQbbUmv5FLI=;
        b=vVAcq7gifMdt0rfal4N+AcRFD1kViQXdCWEar+tbV5+hT/vlui7yfkwAU6q0jxqQjxFg6B
        x1X/0LqWNS4gKq/P8JJSUn2tc4xwCkFBVo3JnsUny+Q8vBJhoa0139/RyRgrEDUxI9eKzL
        3fD1AcSsADqb6IsSa98JOP+YpscL10zaXMOYt+lza4mjQt8yLDwtr+tlCSKieXAI+GDBUA
        dzqmt6QWXPrXe7BZHTdD+KSgDQTU90pmyIjj06kF2dWVQdelEnY0+6fDxqiE0M+u6fixSz
        QUAjPG9O462oHZqGnDaSU7lrPPBwlMHshchdHAcqi5EeMv4Bd5SZroewcoR1Kg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1674652169;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=QwDV/29udP1hyz25Yq9mcpQieAxTOux2pQbbUmv5FLI=;
        b=Tg6i5EHDSShHqCY4B6LpLuwJmNkkt/0owTMOS0KJTCyve3ytWDiQoASYJI7AxT044VlnyJ
        1KEQufLDSk8NfuDQ==
To:     Vladimir Oltean <vladimir.oltean@nxp.com>, netdev@vger.kernel.org,
        John Fastabend <john.fastabend@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Camelia Groza <camelia.groza@nxp.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Gerhard Engleder <gerhard@engleder-embedded.com>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        Ferenc Fejes <ferenc.fejes@ericsson.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Jacob Keller <jacob.e.keller@intel.com>
Subject: Re: [RFC PATCH net-next 03/11] net/sched: move struct
 tc_mqprio_qopt_offload from pkt_cls.h to pkt_sched.h
In-Reply-To: <20230120141537.1350744-4-vladimir.oltean@nxp.com>
References: <20230120141537.1350744-1-vladimir.oltean@nxp.com>
 <20230120141537.1350744-4-vladimir.oltean@nxp.com>
Date:   Wed, 25 Jan 2023 14:09:27 +0100
Message-ID: <87cz72ahh4.fsf@kurt>
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

On Fri Jan 20 2023, Vladimir Oltean wrote:
> Since taprio is a scheduler and not a classifier, move its offload

s/taprio/mqprio/

Since mqprio is a .... ?

> structure to pkt_sched.h, where struct tc_taprio_qopt_offload also lies.
>
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQJHBAEBCgAxFiEEvLm/ssjDfdPf21mSwZPR8qpGc4IFAmPRKgcTHGt1cnRAbGlu
dXRyb25peC5kZQAKCRDBk9HyqkZzgjjwD/9RAe8dBrk9La9ddHitFnGt/MPJxtco
89sHeZqpCSy/PMRblGR/cupypJz8vvFxG9FeYM3Uj0JVzncO3IqX1Nie8mdxsP6B
kQ38CRMbTw0JOCKauOitcJ3RJ7e8I2tSIqCEpG5EYRFcQnJiM3qa6c1u0TPf4C+x
tNLTlohG2WR/z27Ne7d7GJXxofr1E62Jgii+LbmDZsWp1U9g3urs8xkPD9+bp0XJ
YLCR4YH+PmZ95Zyg+zno36Sag+urziVqasARwbDgYzO7Z9zOFJpS9wD5Ko1OIUpR
R202XHv6o1BnjYreKH/CXyXFLtGmbc9AY9bcviVgkxQ94Tz6z08Gp2ur8bGsevi6
fP7qwkAUuLp1DKpX9lozv7vaFsv/5uih50QNs5xzU+UUX0bpkN+oyS13oAZf+a3f
PDlDjMQhRaxV1bQ0Xs4+Urty11QJTZosIEmwncLvP5SFyitEtjosYR8XoakruLoy
o44Yi/8FhLl1KjnxY5pormPJkKUszQWwYSagvjiLa4siCHMH/wc5ntr0azWUjXeX
b8LU4R/+hUngSy1bKW1XK1El90Ow9Y/iz3Rmq7zMgeqxkQuxaf/oA7jDGicskUqk
uAaP5NIyOpapALOrLoKYEx3JcTAKZRSiVfelAFjHzXO9I8o8ldsvsS332LFW1nz/
OnZHg/QMKr+/Nw==
=jHLX
-----END PGP SIGNATURE-----
--=-=-=--
