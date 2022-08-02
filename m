Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6378B587783
	for <lists+netdev@lfdr.de>; Tue,  2 Aug 2022 09:07:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235648AbiHBHHR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Aug 2022 03:07:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235738AbiHBHGu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Aug 2022 03:06:50 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06744491F3;
        Tue,  2 Aug 2022 00:06:48 -0700 (PDT)
From:   Kurt Kanzenbach <kurt@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1659424006;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=tAdw5PAie7dR2rW+68+HHxt7ehKp+AayklL8k0nymhM=;
        b=QXwOSd8d5AHmPeyPL9f/yDH28NMjHF80aZwbr+TMSiGR9kzsFRlqwXUV6TOrtUrg5YIuHM
        RuV0qtyNz02QMrzDTTLPzSW9dCUx/J7XTMo1r7sQJaa2MpupTpY/Y5Cl0md1dN7365uMjz
        f6KHchHr5IILDoTyVSiobqiUQ5BAlwXyNT4uQ1zgY/mR3MOUZMoZ3yefeAqnzO1pMeDHeh
        ukhfd1w3GYpKlSpx4Wk0MH3GYBBTFnE08FB40Af7fQZlwf7wH4DeVA6DSCO9cXuybY8DFQ
        mR4bIvZjTH4xQsbWCm6DjESbOGeD5+btKZz4PTgkI3dGmVvXsCMdT2BZbLNfIg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1659424006;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=tAdw5PAie7dR2rW+68+HHxt7ehKp+AayklL8k0nymhM=;
        b=eu9kQ392QLiVoA1eEm0Lb59RVAT3nn2RMJY3mEbxlnxo7jDmV5ZrEQCvFJkyzuxVTwQUAT
        rYNxUPmT1PetgVDQ==
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Jesper Dangaard Brouer <jbrouer@redhat.com>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Joanne Koong <joannelkoong@gmail.com>,
        Jiri Olsa <jolsa@kernel.org>,
        Dave Marchevsky <davemarchevsky@fb.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Geliang Tang <geliang.tang@suse.com>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>
Subject: Re: [PATCH bpf-next] bpf: Add BPF-helper for accessing CLOCK_TAI
In-Reply-To: <CAADnVQKqo1XfrPO8OYA1VpArKHZotuDjGNtxM0AftUj_R+vU7g@mail.gmail.com>
References: <20220606103734.92423-1-kurt@linutronix.de>
 <CAADnVQJ--oj+iZYXOwB1Rs9Qiy6Ph9HNha9pJyumVom0tiOFgg@mail.gmail.com>
 <875ylc6djv.ffs@tglx> <c166aa47-e404-e6ee-0ec5-0ead1923f412@redhat.com>
 <CAADnVQKqo1XfrPO8OYA1VpArKHZotuDjGNtxM0AftUj_R+vU7g@mail.gmail.com>
Date:   Tue, 02 Aug 2022 09:06:44 +0200
Message-ID: <87pmhj15vf.fsf@kurt>
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

Hi Alexei,

On Tue Jun 07 2022, Alexei Starovoitov wrote:
> Anyway I guess new helper bpf_ktime_get_tai_ns() is ok, since
> it's so trivial, but selftest is necessary.

So, I did write a selftest [1] for testing bpf_ktime_get_tai_ns() and
verifying that the access to the clock works. It uses AF_XDP sockets and
timestamps the incoming packets. The timestamps are then validated in
user space.

Since AF_XDP related code is migrating from libbpf to libxdp, I'm
wondering if that sample fits into the kernel's selftests or not. What
kind of selftest are you looking for?

Thanks,
Kurt

[1] - https://github.com/shifty91/xdp-timestamping/tree/master/src

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQJHBAEBCgAxFiEEvLm/ssjDfdPf21mSwZPR8qpGc4IFAmLozQQTHGt1cnRAbGlu
dXRyb25peC5kZQAKCRDBk9HyqkZzgt3bD/0cPNL9DF0UocuUq/aYcJwAr132MSSt
GPbregF7Q7HtI41B0nbqfj3Zz3zYB4GYcMzen8ApbpTKIcnrxTQ2lRbyMoElfe3e
9KKCVh6ALl8RzzHiCPfvFqwJClfdWZhyLr5IZ98K2cxIRPp/HdrPEBpK2LxcBXPu
5Pi585ymkWZM/0dk6/NvmvDWPgMhPTbtwdQUGl85/q++2zUFGPNc6Sd7DO7f1bm9
7mVZTZAp/OKj1W0Ul5/o+AA+7zIVbFnd7+s9Ezg908QqlW45Civy9dZpVCtsNvmX
oa6jjipmU8tAUxRM8S8zuoR74o4TLthRNi481jKROGN6PHQpIQOGBlj9Mw1INnM7
DjA//xYFYcjpPoG2ozvICZeWUNcqEIyuc+Ka5RlcGCpYw5WNHq+2XZLR6K6QhQ4k
eZjCZK7jPLbM7zvm+M7pCMqGzG+nuddW2OcS+N2g4LgkKlK2xQ9Acp1KMyScXkaP
RXEzPZkr9HcEVqd5KlzyFiqM4OFHOmQvZ4eyKxaNjAZwA9wwrVqiWI8xnp+PlpNF
Gg2MVYYITQ4YWkepK3XieusPhINJARSNgBFRyRIG++2nm+1UDJ7RE6gI5vyLfpl0
NwtwXBUMEM4JNog+7j/YHeF76pwHs9wCecplm2CdISZ+2RbWORS+Ox1i5/WnU9Mt
MANw9OXx70nesA==
=NcTj
-----END PGP SIGNATURE-----
--=-=-=--
