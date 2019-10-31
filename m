Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 383BFEAB3A
	for <lists+netdev@lfdr.de>; Thu, 31 Oct 2019 09:00:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726963AbfJaIA2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Oct 2019 04:00:28 -0400
Received: from dvalin.narfation.org ([213.160.73.56]:53626 "EHLO
        dvalin.narfation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726698AbfJaIA1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 31 Oct 2019 04:00:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=narfation.org;
        s=20121; t=1572508825;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Ia3172o3/jD2ekntHB/GkBV4C7wIggs5s/Ni/QTMMRI=;
        b=IRBmdR7dNASrVBhBhvK6MA6irw6Nb6bC//pd3DoPAsobpxxI2+oWjxkqoytud7ilnB3P5m
        r7HjTJ367tS1+ezqogDhtfm7ecD5rHhbpqpvmrTxHCS/CCb2Vvs2DzwKmneMZNeEm9S0/7
        x4VDfO47VaWNDVgW1zcJWeB82zRhyi8=
From:   Sven Eckelmann <sven@narfation.org>
To:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc:     davem@davemloft.net, mareklindner@neomailbox.ch,
        sw@simonwunderlich.de, a@unstable.cc,
        b.a.t.m.a.n@lists.open-mesh.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] batman-adv: Simplify 'batadv_v_ogm_aggr_list_free()'
Date:   Thu, 31 Oct 2019 09:00:21 +0100
Message-ID: <3535726.AjB5hMM71F@sven-edge>
In-Reply-To: <20191031074255.3234-1-christophe.jaillet@wanadoo.fr>
References: <20191031074255.3234-1-christophe.jaillet@wanadoo.fr>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart6722122.X2YU2N7q37"; micalg="pgp-sha512"; protocol="application/pgp-signature"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--nextPart6722122.X2YU2N7q37
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"

On Thursday, 31 October 2019 08:42:55 CET Christophe JAILLET wrote:
> Use 'skb_queue_purge()' instead of re-implementing it.
> 
> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

Consider this patch applied. I just have to leave now and thus I will only 
apply after my return.

> ---
> BTW, I don't really see the need of 'aggr_list_lock'. I think that the code
> could be refactored to drop 'aggr_list_lock' and use the already existing
> 'aggr_list.lock'.
> This would require to use the lock-free __skb_... variants when working on
> 'aggr_list'.
>
> As far as I understand, the use of 'aggr_list' and 'aggr_list_lock' is
> limited to bat_v_ogm.c'. So the impact would be limited.
> This would avoid a useless locking that never fails, so the performance
> gain should be really limited.
> 
> So, I'm not sure this would be more readable and/or future proof, so
> I just note it here to open the discussion.
> 
> If interested, I have a (compiled tested only) patch that implements this
> change.

Yes, please send it over.

Kind regards,
	Sven

--nextPart6722122.X2YU2N7q37
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEF10rh2Elc9zjMuACXYcKB8Eme0YFAl26lJUACgkQXYcKB8Em
e0YLkg//SFeu7zgzY5RZPY5HcftrEK1rjC2M7A8sCfKGM1M8vzzTA3tloEHUCNxD
EbJLxaVmG24RWkBL6vthM2PT1lvjHRFUphtpYa5z1uyXJFEoO2YRp8hDgIOw+/+1
OckzUOWC0Lq5OokHISYtWp673ZBLSNmshZY5eAZLec7p42UE3xnrWr7OOTGs6yTQ
nwb734FvWvmi44PUs5DGPaW7gpUYXFY9EWyAbpJD7uuifshVIaY7ql5LAfF2VL71
6hJ4rYPGtFN6wxMuh8QehYwiWG+Ze95uYl4oS05YdhsXGNuhFjN5Q2iOU4R4WBFD
g+ztkU7BitUMoaZz3ICi1T31QFUFzy5OPmUo97bX7BId9aTtVMwPvW06aJU/dBZc
pXI9vps1QPoGfTzNn+N12S5GB8ZFYJ+3ycaQjqb69uE3c8EsHVa42qoSiieaqsln
TiYMCK67jcB+cOYR/zbsw6YRr+ZTWxPJMN9ZVEFxswbHl1H677oTBpuC0eyTil/L
qscb04MIE0r11DJA1S4oWnidM+9zn7bGG7tVzMNsKCgvUaXkTWewahJR0ynTI/6j
XfbztcvAlMswIcb6Mk4f5LtARZ+l3BlXll/+WMzxLSZwwWU7yAwp0QxQJwXyKafV
PEps/jYve9O423rfIIwanNJIWi2Ab1sprc5Ka/iSmciz6hswmNk=
=3utl
-----END PGP SIGNATURE-----

--nextPart6722122.X2YU2N7q37--



