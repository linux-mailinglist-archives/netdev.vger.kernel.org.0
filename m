Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8F81978A17
	for <lists+netdev@lfdr.de>; Mon, 29 Jul 2019 13:04:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387502AbfG2LEL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jul 2019 07:04:11 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:53248 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387424AbfG2LEL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Jul 2019 07:04:11 -0400
Received: from [5.158.153.52] (helo=linutronix.de)
        by Galois.linutronix.de with esmtpsa (TLS1.2:RSA_AES_256_CBC_SHA1:256)
        (Exim 4.80)
        (envelope-from <kurt.kanzenbach@linutronix.de>)
        id 1hs3Rp-00088m-Fl; Mon, 29 Jul 2019 13:04:09 +0200
Date:   Mon, 29 Jul 2019 13:04:09 +0200
From:   Kurt Kanzenbach <kurt.kanzenbach@linutronix.de>
To:     Stephen Hemminger <stephen@networkplumber.org>
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH iproute2 0/1] Fix s64 argument parsing
Message-ID: <20190729110408.fi6xfhc2msg5elih@linutronix.de>
References: <20190704122427.22256-1-kurt@linutronix.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="dbhz3svisq6x4eo7"
Content-Disposition: inline
In-Reply-To: <20190704122427.22256-1-kurt@linutronix.de>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--dbhz3svisq6x4eo7
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jul 04, 2019 at 02:24:26PM +0200, Kurt Kanzenbach wrote:
> Hi,
>
> while using the TAPRIO Qdisc on ARM32 I've noticed that the base_time parameter is
> incorrectly configured. The problem is the utility function get_s64() used by
> TAPRIO doesn't parse the value correctly.

polite ping.

>
> Thanks,
> Kurt
>
> Kurt Kanzenbach (1):
>   utils: Fix get_s64() function
>
>  lib/utils.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> --
> 2.11.0
>

--dbhz3svisq6x4eo7
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEooWgvezyxHPhdEojeSpbgcuY8KYFAl0+0qgACgkQeSpbgcuY
8Kb0oBAAg+8juvWpmLvBMGpU54lpBpbbyR6WhDm4JR3eajY4TsS2gbMNtolFWWOA
x4FKlNipVPwqF8DsBhn+7QCiE8DQNH9aNR865hCK0ltkFMC8lJYW+UyRv8hpSF3F
PBwQTh792LpUecJONx7EsVMB5bnMTiQrmTo2fjm8Hw5P90A7Wba/Cf2DbCkydnw5
svATDktr0dC2zMqf5nWRegFBrx9GJVSHx7xgbL9aUx4NLlcKewmYHVXhm2kt9M9a
EBuAsK9DgaKRlC7OQrhSVv8P1z1F7LHH4tY6D8mr07z2ZXwi/Dt9Z7n8fOchnsGD
B6PBvKfgqAOZiJJ5bTPrwG/j/p/J6mYTtPcJhRZHXeaW85Fu/hXlBmRjhcGHGMC/
VhbWrYF+h8aWDZ/DXf65VAmHn9Tgqb2ugGKSKkdAFcXXWY9wHs7XTS1SWSdCqaW9
Jr0nPMtgWUf3eOga7G8jylvgChKEMLxn7SuyU70wimsdp/iN2+Wfw5lUp+aMaqIt
ZimiDYVYe4H95LlvV2sXJQ9l/gr4llJEdgS84G/Pnj9Tp1MQP5IoDatW/84K5/c4
4oE6fxOpsmnbRzaKJ+ZU1vp86egtZBKxEhPB/gEFlDShDBV1q/AdUI6laGNFik7j
h8j5JbEztRmedjqx+N6lCLiDEOIIUvY7gw1bTr5dQNRmHA34xzc=
=0IYk
-----END PGP SIGNATURE-----

--dbhz3svisq6x4eo7--
