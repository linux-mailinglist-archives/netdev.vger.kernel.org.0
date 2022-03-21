Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9AE674E20AC
	for <lists+netdev@lfdr.de>; Mon, 21 Mar 2022 07:43:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344635AbiCUGop (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Mar 2022 02:44:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344625AbiCUGoi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Mar 2022 02:44:38 -0400
Received: from gandalf.ozlabs.org (mail.ozlabs.org [IPv6:2404:9400:2221:ea00::3])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3EAA13DE9;
        Sun, 20 Mar 2022 23:43:12 -0700 (PDT)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4KMQ6c2Vkpz4xRB;
        Mon, 21 Mar 2022 17:43:04 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canb.auug.org.au;
        s=201702; t=1647844987;
        bh=cz6ekqfIqPBFlhDzuYDWDUWzUPqnlYRI1w9LAehsuAE=;
        h=Date:From:To:Cc:Subject:From;
        b=mFOxCJvnp2pYkscfBSN2sxCg84CmEYDSoPeDggoxT7Pp4EfxB1xjWbosMpKjj+ASJ
         7/3rydam24YBQpv5U7Lv58GFYFxNYYp/349uv8WRU3f4Dg1B5PWV+nMNmIhn3fsJt2
         IyiSQWi5D0WFgTMONKAUIMSfn39RSqHOaLN0JNU+G5NlM1AW7zFHOTHEcZ6r/KI0Al
         9bTYGDHAIiZbH2iCzZC/5mrRRjet3PLUtU8vzIJOQqG0m5WGx+fe+HQpIzHAgjfAZ8
         5mTpUMLtHayPv1rqo5I1OmTJ9egP5hO+6aAbsKwLygHeOoCeYdQ9hu50L/R0Hby01b
         kn9EUMlqrXX0w==
Date:   Mon, 21 Mar 2022 17:43:01 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>
Cc:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Alex Gaynor <alex.gaynor@gmail.com>,
        Ayaan Zaidi <zaidi.ayaan@gmail.com>,
        Boris-Chengbiao Zhou <bobo1239@web.de>,
        Finn Behrens <me@kloenk.de>, Gary Guo <gary@garyguo.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Miguel Ojeda <ojeda@kernel.org>,
        Milan Landaverde <milan@mdaverde.com>,
        "Steven Rostedt (Google)" <rostedt@goodmis.org>,
        Sven Van Asbroeck <thesven73@gmail.com>,
        Wedson Almeida Filho <wedsonaf@google.com>
Subject: linux-next: manual merge of the rust tree with the bpf-next tree
Message-ID: <20220321174301.3a1b3943@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/=q_KJTYcwUDjXRGJHMvX+7q";
 protocol="application/pgp-signature"; micalg=pgp-sha256
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/=q_KJTYcwUDjXRGJHMvX+7q
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the rust tree got a conflict in:

  samples/Makefile

between commit:

  6ee64cc3020b ("fprobe: Add sample program for fprobe")

from the bpf-next tree and commit:

  44d687f85cc3 ("samples: add Rust examples")

from the rust tree.

I fixed it up (see below) and can carry the fix as necessary. This
is now fixed as far as linux-next is concerned, but any non trivial
conflicts should be mentioned to your upstream maintainer when your tree
is submitted for merging.  You may also want to consider cooperating
with the maintainer of the conflicting tree to minimise any particularly
complex conflicts.

--=20
Cheers,
Stephen Rothwell

diff --cc samples/Makefile
index 701e912ab5af,fc5e9760ea32..000000000000
--- a/samples/Makefile
+++ b/samples/Makefile
@@@ -34,4 -33,4 +34,5 @@@ subdir-$(CONFIG_SAMPLE_WATCHDOG)	+=3D wat
  subdir-$(CONFIG_SAMPLE_WATCH_QUEUE)	+=3D watch_queue
  obj-$(CONFIG_DEBUG_KMEMLEAK_TEST)	+=3D kmemleak/
  obj-$(CONFIG_SAMPLE_CORESIGHT_SYSCFG)	+=3D coresight/
 +obj-$(CONFIG_SAMPLE_FPROBE)		+=3D fprobe/
+ obj-$(CONFIG_SAMPLES_RUST)		+=3D rust/

--Sig_/=q_KJTYcwUDjXRGJHMvX+7q
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmI4HnUACgkQAVBC80lX
0Gx+TAf/ZUzpK+OgNBF8vnv5tJEOS9KA2q9qTLkp/oAxS+GoPBwlE29XtqcNsM3C
0jvHhQRHhQX2EHwYicsStxfoCy8DA5PL5ECmSCGv66Kc2Hen7hbkEr+MoS5ARaCQ
DLDz/mE31dw2MqGaGWPQXfmCJCd4V0dMRVqa4ZUs+J5YhUFC3SPH9lY6C179ET7G
LXWowatY5BhHPQ3fIO7jCrumVhYkSLd0BkejTwfDat61rUQCygICgfv8WJBLmiak
Wpwy13DKjEJlAHfsamtE8eKramai//72OrWbkBivU3wRZ49XsBayTSF7iS2kv+lD
taRDgLA3mI8EFJeOQO0oT+9vFxobNQ==
=7Vas
-----END PGP SIGNATURE-----

--Sig_/=q_KJTYcwUDjXRGJHMvX+7q--
