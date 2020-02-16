Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C498E1604C0
	for <lists+netdev@lfdr.de>; Sun, 16 Feb 2020 17:17:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728456AbgBPQRp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 16 Feb 2020 11:17:45 -0500
Received: from dvalin.narfation.org ([213.160.73.56]:59426 "EHLO
        dvalin.narfation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728239AbgBPQRp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 16 Feb 2020 11:17:45 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=narfation.org;
        s=20121; t=1581869862;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ycDGsIuRvIAvHC8M9jSWoOHJ+C/adZPAoQJAg4MOHh0=;
        b=zMk1rHpHJsElWdVbsSg4ZDZMx5E98D/6dpZl5fZ7/wTxbWc59OHrFcAPUL4dFRogbZ6BVR
        a2bf3WJenvnoXSI5J9ZK/6Ud5A8BUs7+CfYLzru/8x4teDCFj3+iU4/214121/5rIFYCMC
        8hsv797rAa9Y+pWYK8gV6jiuYAOJuZ8=
From:   Sven Eckelmann <sven@narfation.org>
To:     Madhuparna Bhowmik <madhuparnabhowmik10@gmail.com>
Cc:     mareklindner@neomailbox.ch, sw@simonwunderlich.de, a@unstable.cc,
        davem@davemloft.net, b.a.t.m.a.n@lists.open-mesh.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        joel@joelfernandes.org, frextrite@gmail.com,
        linux-kernel-mentees@lists.linuxfoundation.org
Subject: Re: [PATCH] net: batman-adv: Use built-in RCU list checking
Date:   Sun, 16 Feb 2020 17:17:36 +0100
Message-ID: <14125758.fD4hS3u3Vl@sven-edge>
In-Reply-To: <20200216155243.GB4542@madhuparna-HP-Notebook>
References: <20200216144718.2841-1-madhuparnabhowmik10@gmail.com> <1634394.jP7ydfi60B@sven-edge> <20200216155243.GB4542@madhuparna-HP-Notebook>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart2027361.KDeqtIc2Nz"; micalg="pgp-sha512"; protocol="application/pgp-signature"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--nextPart2027361.KDeqtIc2Nz
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"

On Sunday, 16 February 2020 16:52:44 CET Madhuparna Bhowmik wrote:
[...]
> > I understand this part. I was asking how you've identified them. Did you use 
> > any tool for that? coccinelle, sparse, ...
> 
> Not really, I did it manually by inspecting each occurence.

In that case, I don't understand why you didn't convert the occurrences from 
hlist_for_each_entry_rcu to hlist_for_each_entry [1]. Because a manual
inspection should have noticed that there will always be the lock around
these ones.

KInd regards,
	Sven

[1] https://www.kernel.org/doc/html/v5.6-rc1/RCU/whatisRCU.html#analogy-with-reader-writer-locking
--nextPart2027361.KDeqtIc2Nz
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEF10rh2Elc9zjMuACXYcKB8Eme0YFAl5JayAACgkQXYcKB8Em
e0arqxAAs2BMDdBX1BL6F26UneTAZ8w5R8MOruf6/NJycj1OzwF9X96BeX0cyj4q
Gnryzgqb3/LXfZPWhF2HSLjuPeVjgiJOoF5S+3n9R00k0Oitqo53gFHirNzLqFYu
bJThufWSFbq3agNcYgrjYe15pyOe46r9Vt/aGyjVsvX+f8J/7PRFCTkznhluzo9C
tmLWbM4tbVJu8JDUD3PY/vR9SxPShYqDOlFz45bqmzHb7Dcr2fLYZC/jlbzd5af+
xTNCsjsk2U9pwR+te1MaIqJ6BDrIljis4HXLCdAMuL5ny1QKrNL1Hj/iS9ycxCnh
1lUNi0HGdRtGcpXbRBIiLkykMJMiIZoep+PkP5CND2WELURBBRVrys8xvwDD3mxJ
xdvhXKAkMv2qaJpbGIQWEf/p+UDbXQXr9Xa1UeUOOHjpC8eNm1FYtKKzTL0W74lE
9KSt086kB2Y9pUMAGQWoIDyb1QKTxQV+jzx9YJEL2AzGO0NEwd+d0UJrxXX+qNbF
BKd+EqdAIR/PfAp2pA4PIxAvieu9Z3jCnXkEURkhS19Rgu1G/0iBq6p8abj+CW8a
7OBNe+13SISLc0rMoX/nbH/Pwxq9MlqRJifFr05S77mKEvdNS8tz0KwN/ZVMSfA+
2dDdXfKzPo3BGnfSOtj7G1wgUMBWOFXVLnFytQEyYXMdlWC47Ks=
=70Ud
-----END PGP SIGNATURE-----

--nextPart2027361.KDeqtIc2Nz--



