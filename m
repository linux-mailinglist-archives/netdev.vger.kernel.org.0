Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 769A7682907
	for <lists+netdev@lfdr.de>; Tue, 31 Jan 2023 10:38:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232146AbjAaJiJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Jan 2023 04:38:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232285AbjAaJiF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Jan 2023 04:38:05 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55B4530295
        for <netdev@vger.kernel.org>; Tue, 31 Jan 2023 01:37:49 -0800 (PST)
From:   Kurt Kanzenbach <kurt@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1675157868;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=EwDXBXvIvoOpnFE454wZfE0KFiUKOmlnhz7Vth7SKEI=;
        b=hJ3lm9miexH4GgFuLVEoWC6ZOn/NcVA8KZNhcJv2ceuPX6MyyG/HUe5J0Az4xxP7g/q7cB
        975R7L7jxaB8We86mhNI5wqjj6VnYGlCo57h6+9Xkr0esSlB9tRq461SDdcsCxY3s1gcv5
        Qu+dfRCFxrO7wS9hHvEAawyvKzCOVbntY6MMm9fy2F2UitTrWWHEwGXa9JkFb/oNO/ML8t
        5cuOuVnjVvEWZLrT2792EFQ0IBWhkAdy8njNOSzeZEy812YLhnOwgwvNyqSzmSQC+y8WoG
        Ym7xafECByY9zk5GjsQVMHmtkN63M5xSxAju+4pKz7GPWwfPCNmwHXZ0sOKDXw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1675157868;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=EwDXBXvIvoOpnFE454wZfE0KFiUKOmlnhz7Vth7SKEI=;
        b=o3QpYAEzLUBrKdeImo9Ip4QtOXqH98b3qFiVXzmFU+G1VoLgIqT24s+VQSgot0pLvlpikB
        Cb4ou/ytIgWMK3CA==
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>
Subject: Re: [RFC PATCH net-next 05/15] net/sched: taprio: give higher
 priority to higher TCs in software dequeue mode
In-Reply-To: <20230129131755.6uyekemd65243vg2@skbuf>
References: <20230128010719.2182346-1-vladimir.oltean@nxp.com>
 <20230128010719.2182346-6-vladimir.oltean@nxp.com> <87k016vp9m.fsf@kurt>
 <20230129131755.6uyekemd65243vg2@skbuf>
Date:   Tue, 31 Jan 2023 10:37:47 +0100
Message-ID: <875ycndoyc.fsf@kurt>
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

On Sun Jan 29 2023, Vladimir Oltean wrote:
> Anyway, I also need to be very realistic about what's possible for me to
> change and how far I'm willing to go, and Vinicius made it pretty clear
> that the existing taprio/mqprio configurations should be kept "working"
> (given an arbitrary definition of "working"). So things like adding UAPI
> for TXQ feature detection, such that an automated way of constructing
> the mqprio queue configuration, would be interesting but practically
> useless, since existing setups don't use that.
>
> He proposed to cut our losses and use the capability structure to
> conditionally keep that code in place. The resulting taprio code would
> be pretty horrible, but it might be doable.
>
> Here is a completely untested patch below, which is intended to replace
> this one. Feedback for the approach appreciated.

Yeah, I think Vinicius has to ack or nack this.

Thanks,
Kurt

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQJHBAEBCgAxFiEEvLm/ssjDfdPf21mSwZPR8qpGc4IFAmPY4WsTHGt1cnRAbGlu
dXRyb25peC5kZQAKCRDBk9HyqkZzgobxEACyexu9bYLz6wtqjcF2NlgMRcZA0C/E
W0bxrBYUmA0/pMGiSv/+nBnWgN6YB9nnOK2CZrIZiU5e5HtCtX3L/kmB8YG01CWY
WOMY8YEHB2sfMcKz1f4Atx9Upa3LuwCK9Tkn01UgymXkVv66FEWW1If060+OY2Ly
O5uzZFlpuZk9i+KzE00WXhTyv8dh36UAnrhLJuKSar6nhoyVUcPKQEOfsBnCogj4
b6ErUob+OZTKZ0T08+X/1j79KpNMahR+Jx/VNTRQsPLhVbD0vzESoUDPc6LlWYEv
h2KqQqQUNtem1D61hVwxx5ym3gIIp/xuSdZkifVOZTRBMktjuKlK/pdl1VJTFYcR
AGMNlWrXAS/gEJPlhrQWb44O/YyDU2ptSR68ZLaTio3ZnfyGv+ToZiGmc29OCgBY
ujv13TQ0dNr0t9Q+tEwpNMj5BIxqtoKBcVKmQDhDKn7N85r6LHXtjAVdTblFlob6
g8yzzb3v4CWTmAXYgokpahwIFMfKvgM7S53ApkdixZN/EP/IqK0RFq+B2C7yKvJ/
rDfwknBuYJFr0shjaDU/glYT3sjQCD++NZzOm+dDHuusVT2JdWa9o0eiWm5GgeoA
Y9ZLjPT7XdMqF1zDGFIlCyW6WlvdnxswLoNIFBh1B5SAs6KamlxVYV4t2+RF8Vrl
OcMw/btpmhrSzg==
=cUCM
-----END PGP SIGNATURE-----
--=-=-=--
