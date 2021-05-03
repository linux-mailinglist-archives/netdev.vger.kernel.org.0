Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B703371203
	for <lists+netdev@lfdr.de>; Mon,  3 May 2021 09:31:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230137AbhECHcH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 May 2021 03:32:07 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:45538 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231605AbhECHcF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 May 2021 03:32:05 -0400
From:   Kurt Kanzenbach <kurt@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1620027071;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ZLl/dfE5xGtjKVTqlZm9ProhV0dqNjr3HBIdv3mpY+E=;
        b=QGo0GBcVd0Y+oycY/Z6pdt7/a5a6DD402Z6Jc+q5cTYOz3lheOh8ce8VAOmo/i1OIJbt6o
        L9xjArLVZSC3rJBBg3sKGGJHfViKqYUiJ4H7XsQp6oIbYJQLhWDooKE2U7KWE4KSC42eeE
        itYF2QDZ6OEX/ApSRfs4OMATOQI1XgNnKMaSEx6bU9LTb+pzkXc9rNdIbuLQXVc4Vwstjq
        gcgXAtsWpUTknQ7LKvhCiYPvm/gSMQX4kPUv8pwAz+GZZS8N4bZYO28f5nyyGW/i8yuLRl
        RMxuyvuI3yiLoHVLaBtcZti28mYZFtmwk+Q6qFanU6TsbSklN1VyVh4AseAA+w==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1620027071;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ZLl/dfE5xGtjKVTqlZm9ProhV0dqNjr3HBIdv3mpY+E=;
        b=4CARGnMWYGR+PeCtsOsjrCI3vwN8VEk1LVoI2yWsHE7RvRKDOVE1k0vsNXWfpOC9/LRc1W
        g0uhd2f7t73KGEAA==
To:     Tyler S <tylerjstachecki@gmail.com>
Cc:     alexander.duyck@gmail.com, anthony.l.nguyen@intel.com,
        ast@kernel.org, bigeasy@linutronix.de, bpf@vger.kernel.org,
        daniel@iogearbox.net, davem@davemloft.net, hawk@kernel.org,
        ilias.apalodimas@linaro.org, intel-wired-lan@lists.osuosl.org,
        jesse.brandeburg@intel.com, john.fastabend@gmail.com,
        kuba@kernel.org, lorenzo@kernel.org, netdev@vger.kernel.org,
        richardcochran@gmail.com, sven.auhagen@voleatech.de,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Subject: Re: [PATCH net v2] igb: Fix XDP with PTP enabled
In-Reply-To: <CAMfj=-ZzOLog6NQvgpThSOy_5od_dY4KHd0uojxRxaWQA9kKJg@mail.gmail.com>
References: <CAMfj=-YEh1ZnLB8zye7i-5Y2S015n0qat+FQ6JW7bFKwBUHBPg@mail.gmail.com>
 <871rax9loz.fsf@kurt>
 <CAMfj=-ZzOLog6NQvgpThSOy_5od_dY4KHd0uojxRxaWQA9kKJg@mail.gmail.com>
Date:   Mon, 03 May 2021 09:31:10 +0200
Message-ID: <87sg34clz5.fsf@kurt>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha512; protocol="application/pgp-signature"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--=-=-=
Content-Type: text/plain

On Tue Apr 27 2021, Tyler S wrote:
> Sorry, I didn't see v3.  I can confirm that v3 fixes the issue I was
> seeing with jumbo frames.

Great :). I just sent v4 and added you to Cc.

Thanks,
Kurt

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQJHBAEBCgAxFiEEooWgvezyxHPhdEojeSpbgcuY8KYFAmCPpr4THGt1cnRAbGlu
dXRyb25peC5kZQAKCRB5KluBy5jwpr8WEACLqLQ0XIqiUfor1L1SPbilVfAKGf1m
QFbdFXnpozIxX0Jmg4ywOwRJYNfGZDBGy6hE9O1Huu+CS//PQiVh7hmemhIF/JjB
pUsURIwly5FbYi1LEVS9poAxlo1mseMoSvWS/sEzoYcVHj2cKSOel4/B+4LAZTot
rOEs/qLxIuUoA36DGZMZQbCp8StmuR2fYb+P2qOwapqMdzcpQ4I8eXnLK6FLofLg
Gcm4c+vCbKzGWQld89+w0u9VTS5GAGRO517ATqGitNMtv4JujzNLnB5NpmVK6OFN
J2IyO3MElTya22VLfdqEpj9Lu4uRtSQ3JN0WNXYj9znyVsQaIdbST7yvRmX5mNP5
XGCQrIQ6nR57G8YLZzAYGDb1mbgLL2agKaXJ9ag1svkJXlUW6r+lGC4ImToKh16w
t+bnyqVa1O0AGs/jGdHUj2sT0dIiRWxb2BUnpaFu76CdwE0WWP5oSHc9DKIqFVrq
k8iknnNgq5/ft2mMYJyMp2FWOoqZca/Vkgr1vllOwoYEpx9EgtwH4mNYhMRQA+Ct
UFbVuTOtSqGrE8vvJbm95y7iLzmRiOqVAtHZd5A37K4SWKrm1OVXWC52w7TCT4tH
OiaY607cqn3QD4Orb2hyJlALRmuUMtojhn/vELb46W6jcSsZq2WdlYV/fot7Tj3j
3TeIoZsTjn9egg==
=11Dq
-----END PGP SIGNATURE-----
--=-=-=--
