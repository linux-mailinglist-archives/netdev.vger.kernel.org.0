Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 09041271AA8
	for <lists+netdev@lfdr.de>; Mon, 21 Sep 2020 08:04:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726452AbgIUGEl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Sep 2020 02:04:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726149AbgIUGEi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Sep 2020 02:04:38 -0400
Received: from dvalin.narfation.org (dvalin.narfation.org [IPv6:2a00:17d8:100::8b1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 336C9C061755
        for <netdev@vger.kernel.org>; Sun, 20 Sep 2020 23:04:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=narfation.org;
        s=20121; t=1600668272;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=b8fQsCvgcnqMQgvxHhj7epbLkU3gFqxiKxz9y0e4wlc=;
        b=JqaTnaVcg3c5vaxTp9fuoGBCO5CZ3YvkbUnhCKsqdmqoAu8hts5PmKq21SLHsWD478HmGW
        DWszYPZ1cgDyeHsqU2mX1ytgZZe64b4Fp3QRIP7dHzbfXOqQF+5py186tjK+ZLRun1XLv0
        Jz+gXgQp8EljnWB7GlAZsLAjWtLkQ5I=
From:   Sven Eckelmann <sven@narfation.org>
To:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>
Cc:     Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linus =?ISO-8859-1?Q?L=FCssing?= <linus.luessing@c0d3.blue>,
        Simon Wunderlich <sw@simonwunderlich.de>
Subject: Re: linux-next: Fixes tag needs some work in the net tree
Date:   Mon, 21 Sep 2020 08:04:30 +0200
Message-ID: <1845864.bm72gKIjWm@ripper>
In-Reply-To: <20200921055919.5bf70643@canb.auug.org.au>
References: <20200921055919.5bf70643@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart5321733.tfhsDO9XnZ"; micalg="pgp-sha512"; protocol="application/pgp-signature"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--nextPart5321733.tfhsDO9XnZ
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"

On Sunday, 20 September 2020 21:59:19 CEST Stephen Rothwell wrote:
> Hi all,

Yes, I've accidentally swapped the IDs while adding them to the various patches.

The correct ones should have been:

* 097930e85f90 ("batman-adv: bla: fix type misuse for backbone_gw hash indexing")

  Fixes: 07568d0369f9 ("batman-adv: don't rely on positions in struct for hashing")
  (seems to be correct)

* 7dda5b338412 ("batman-adv: mcast/TT: fix wrongly dropped or rerouted packets")

  Fixes: 279e89b2281a ("batman-adv: bla: use netif_rx_ni when not in interrupt context")
  (seems to be correct)

* 4bba9dab86b6 ("batman-adv: Add missing include for in_interrupt()")

  Fixes: 279e89b2281a ("batman-adv: bla: use netif_rx_ni when not in interrupt context")
  (seems to be correct)

* 3236d215ad38 ("batman-adv: mcast: fix duplicate mcast packets in BLA backbone from LAN")

  Fixes: a44ebeff6bbd ("batman-adv: Fix multicast TT issues with bogus ROAM flags")
  (this was wrong)

* 74c09b727512 ("batman-adv: mcast: fix duplicate mcast packets in BLA backbone from mesh")

  Fixes: 2d3f6ccc4ea5 ("batman-adv: check incoming packet type for bla")
  (this was wrong)

* 2369e8270469 ("batman-adv: mcast: fix duplicate mcast packets from BLA backbone to mesh")

  Fixes: fe2da6ff27c7 ("batman-adv: add broadcast duplicate check")
  (this was wrong)

Kind regards,
	Sven
--nextPart5321733.tfhsDO9XnZ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEF10rh2Elc9zjMuACXYcKB8Eme0YFAl9oQm4ACgkQXYcKB8Em
e0ZYdQ//evajP1e6HFFq7NS/9XZOCyoIOsAvo+FBGaA9uImaBPJY7ekJBdkzpr9y
i2Hrx4I08Z0a65Ph5VLHWLNao12Gw0XnVKHLWyPf+6vMqjiqRyi6qaddYR78T2P1
wRNXm72bCG+ZQGpTM7DPmU8BYaANatM56CPI90p6549BW4ts3XTYXrhDp+AuITKp
SP47rG3j5gx+kK484CQ5URpNzfNxUn2gn9otPVoSsRmcod4X9IzmLiEF8xA0RhO+
vKkRCBSuC4M2gwltKPLXNzuGbEip7dOP9Re8Z/uOgPp/f5fzC/2lGvUxB0Zt+yR+
iELJkdulA9wOu59rCFJHrVHi+5CzAPDrqfQS+ZQO2OLDOcY2Ljv3Mk9srmwMdaUg
7KFo6opjGV9aCYgVSC3s25hhmGjgTgCGhsA45xWeMLIrfLttLYREgAnj9NnStyHN
KXc1pYb5ZkC5B8eIS2kkrHdns/2Xc3ZWBmY4fEvmHnvCPMaslQPCZf2BJ4JPJ6ko
FRsQC9F8qmWZuDC96dazWTYseq0+EkW9NBym3QSuxoAifJcD3EPcO7CBI8Y14k7p
mfnqhOZSufYlJSJYGuuPUusbGnnz6mFSDjBt3u1qg4dK48S3vEKZl933/7xotbmi
dtBz2c+bjgHRNfzUEyzs9U1nmifWgSn9HsQ/pPbZfBEzABcnD8Q=
=GCWG
-----END PGP SIGNATURE-----

--nextPart5321733.tfhsDO9XnZ--



