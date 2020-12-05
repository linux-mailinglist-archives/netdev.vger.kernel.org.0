Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF0C02CFA33
	for <lists+netdev@lfdr.de>; Sat,  5 Dec 2020 08:12:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728634AbgLEHH3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Dec 2020 02:07:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726031AbgLEHH2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 5 Dec 2020 02:07:28 -0500
Received: from dvalin.narfation.org (dvalin.narfation.org [IPv6:2a00:17d8:100::8b1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C5AFC0613D1;
        Fri,  4 Dec 2020 23:06:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=narfation.org;
        s=20121; t=1607152004;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=1+DE9Hr4PZDJaNqKitRhvlhDRRDrwrId/lwHL2xJ1ck=;
        b=2e/jy53aNkFklxaB5Mx+OOqbO3eq8kTw4WtEQ6F95CF1n2CtgE1chEd3rBofTxLY8z6n2z
        HZAUwzp8qpTUV+QCxvWSYK4Sg/s/WSh+sXHyVSKk9fyfOw7Td8FSY2WkzihRaDc+oEqREi
        4kBMCn5kRvnYaDBRXOIBhO12BJApyFQ=
From:   Sven Eckelmann <sven@narfation.org>
To:     linux-kernel@vger.kernel.org,
        "Enrico Weigelt, metux IT consult" <info@metux.net>
Cc:     davem@davemloft.net, kuba@kernel.org, mareklindner@neomailbox.ch,
        sw@simonwunderlich.de, a@unstable.cc, marcel@holtmann.org,
        johan.hedberg@gmail.com, roopa@nvidia.com, nikolay@nvidia.com,
        edumazet@google.com, kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org,
        jmaloy@redhat.com, ying.xue@windriver.com, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, john.fastabend@gmail.com,
        kpsingh@chromium.org, netdev@vger.kernel.org,
        linux-bluetooth@vger.kernel.org,
        tipc-discussion@lists.sourceforge.net,
        linux-hyperv@vger.kernel.org, bpf@vger.kernel.org,
        Matthias Schiffer <mschiffer@universe-factory.net>
Subject: Re: [PATCH 2/7] net: batman-adv: remove unneeded MODULE_VERSION() usage
Date:   Sat, 05 Dec 2020 08:06:40 +0100
Message-ID: <4581108.GXAFRqVoOG@sven-edge>
In-Reply-To: <20201202124959.29209-2-info@metux.net>
References: <20201202124959.29209-1-info@metux.net> <20201202124959.29209-2-info@metux.net>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart1766490.tdWV9SEqCh"; micalg="pgp-sha512"; protocol="application/pgp-signature"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--nextPart1766490.tdWV9SEqCh
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"; protected-headers="v1"
From: Sven Eckelmann <sven@narfation.org>
To: linux-kernel@vger.kernel.org, "Enrico Weigelt, metux IT consult" <info@metux.net>
Cc: davem@davemloft.net, kuba@kernel.org, mareklindner@neomailbox.ch, sw@simonwunderlich.de, a@unstable.cc, marcel@holtmann.org, johan.hedberg@gmail.com, roopa@nvidia.com, nikolay@nvidia.com, edumazet@google.com, kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org, jmaloy@redhat.com, ying.xue@windriver.com, kafai@fb.com, songliubraving@fb.com, yhs@fb.com, john.fastabend@gmail.com, kpsingh@chromium.org, netdev@vger.kernel.org, linux-bluetooth@vger.kernel.org, tipc-discussion@lists.sourceforge.net, linux-hyperv@vger.kernel.org, bpf@vger.kernel.org, Matthias Schiffer <mschiffer@universe-factory.net>
Subject: Re: [PATCH 2/7] net: batman-adv: remove unneeded MODULE_VERSION() usage
Date: Sat, 05 Dec 2020 08:06:40 +0100
Message-ID: <4581108.GXAFRqVoOG@sven-edge>
In-Reply-To: <20201202124959.29209-2-info@metux.net>
References: <20201202124959.29209-1-info@metux.net> <20201202124959.29209-2-info@metux.net>

On Wednesday, 2 December 2020 13:49:54 CET Enrico Weigelt, metux IT consult wrote:
> Remove MODULE_VERSION(), as it isn't needed at all: the only version
> making sense is the kernel version.

Is there some explanation besides an opinion? Some kind goal which you want to 
achieve with it maybe?

At least for us it was an easy way to query the release cycle information via 
batctl. Which made it easier for us to roughly figure out what an reporter/
inquirer was using - independent of whether he is using the in-kernel version 
or a backported version.

Loosing this source of information and breaking parts of batctl and other 
tools (respondd, ...) is not the end of the world. But I would at least know 
why this is now necessary.

Kind regards,
	Sven
--nextPart1766490.tdWV9SEqCh
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEF10rh2Elc9zjMuACXYcKB8Eme0YFAl/LMYAACgkQXYcKB8Em
e0bcIg/+Pc8t5DCC6EDef3uUWb0WaC/JHR6FD9ueabx2XmSpMR9EueQrVuea8ufv
QAVsaCvfZQydsJStJ2I2+K73NZmLE/VdPXs4j1f0aBSQbeN34JmFesjne449g8OB
kzRn6zd4elPV8cbMQMaVvZJg+GNtBbiYfgxnErxp+213TSHAqYQ7VBdtbxEO6qH0
z7VsFrKzlyrLg+NmAZk9iswa5Pm/SI/vuW3pmZ4uHbKKrzLLdROyJDZNN7dXTC9K
n/feL9bOuv+fQjwggDzS1Q/Ttiz73VTfCHwkWaIB/caBpiW730zKiC183EI1y5mt
tLpyrSICHebE1VGIGXORUR7n7/1ceBUmJhu8kOM07XZw9HMRsBAMHrPIdx2hSL5/
OHthiJLlycxVN7W8zfRU25vxlmlDYuXctMKItiqIgtAxq7G01Fgvh91RrCWCha3N
pm4BN9r0D5byF/w38rLmBqEhZyi6Lzi0/H49JHwbEYSKKv+s3GK3LIik4aLPzTf8
/FFYSN6EoCPzHw77vBpZMhP0bMCW+g7MWLW9cqbVGqQBdYuxn5DTzBx5K/BJxw6s
AG8az/+K8Si/atL2IRDQZKqwnx4vHZxJtpd6JFUwG+38SczswlGzg5j1jjbYSiEi
/x3y9QqKd1PfkS+JJ9I9wc+T1m+MTHbYfZ3E0tU9CR/vWGnf5os=
=0NwX
-----END PGP SIGNATURE-----

--nextPart1766490.tdWV9SEqCh--



