Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D600F222BBB
	for <lists+netdev@lfdr.de>; Thu, 16 Jul 2020 21:17:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729266AbgGPTRE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jul 2020 15:17:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728541AbgGPTRD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jul 2020 15:17:03 -0400
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4A4DC061755;
        Thu, 16 Jul 2020 12:17:03 -0700 (PDT)
Received: by mail-pl1-x643.google.com with SMTP id l6so4279807plt.7;
        Thu, 16 Jul 2020 12:17:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition
         :user-agent;
        bh=ctBf8/7XPdvbbAkJHl7up2LKX2yqPU2x4trxTx5gJxQ=;
        b=mkb+z21tnzXUUogTFHF8Q1qb56fwTZmcZUnsDM+2Bl88ZPTCYaX4A1LtSFhV0mInzV
         MmkU+tXreJo+pQCFKqIv9yfbKZmtP54qa9yKHCAG6y+fK/kme/KYpOvkEle+1C64AP5Q
         j7HlJ+jyN2bF5vTjNNd6rrFuFjfHlZpvgKXYOip9Xw82nX0vdltTzpiEamt2kWonnCCA
         x1Ka0lzXQNLmJnEgyXm9NEVXLNVNKhd3HAZ+9VK2RDJweEcQJUFVEsuY0Ae2AkpqYqFV
         X7/TuA2CCGe7yL2ydyitajzK+o/G3CIQvnM/43Y6oN2tWH6h9+D7a4xPwaknoqfAfFRe
         GLDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=ctBf8/7XPdvbbAkJHl7up2LKX2yqPU2x4trxTx5gJxQ=;
        b=MC4NrMl51ZZxniBD0Y8ebdWut4F87pfQYCqCOBdT846IrBCte05BxRUXtQ/IZokyj9
         Ocz0Wd+xOJufn28TUqZNHhVW4t20wKg68Ga67g5JV2RluIS5G7JGN0VVTaBXHSAdvy7f
         0CbsmNoQ7sm4XuVOc+RVeBu/7rEvsNpsTPsJvHcsOAdCAyCy9WedWMDnrR7g57YX+Whk
         N3S21mfiCnn0ulF8B0COIOnuW9RX+4HQRXRkYyTb++KKf3PK1ZniNcGrY/Ua4yOT3mHY
         KTaeLSCP8bb1v2Q/CRr/pxdw3cft/j/1GT4SFu+6PSgrabL7TMX1IzVmr6pVNuzcgVpy
         oOkQ==
X-Gm-Message-State: AOAM5331UGrXoFA0N66PIQjn+c2/ttP27ZL022ZR73KvNk4qT8fzR3qa
        ps0tojCzhUlH+kG5m0sx/fI=
X-Google-Smtp-Source: ABdhPJwSzTaQlCtxnOXDeWa3n+peKBrIVM9xhShLR8fMayDya6j6FbD33dwdlWUE+CtW9NUj15lS+g==
X-Received: by 2002:a17:902:d70f:: with SMTP id w15mr4792036ply.110.1594927023223;
        Thu, 16 Jul 2020 12:17:03 -0700 (PDT)
Received: from blackclown ([103.88.82.145])
        by smtp.gmail.com with ESMTPSA id q10sm6124187pfk.86.2020.07.16.12.17.00
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 16 Jul 2020 12:17:02 -0700 (PDT)
Date:   Fri, 17 Jul 2020 00:46:45 +0530
From:   Suraj Upadhyay <usuraj35@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     linux-decnet-user@lists.sourceforge.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] net: decnet: af_decnet: Simplify goto loop.
Message-ID: <20200716191645.GA4953@blackclown>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="IJpNTDwzlM2Ie8A6"
Content-Disposition: inline
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--IJpNTDwzlM2Ie8A6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Replace goto loop with while loop.

Signed-off-by: Suraj Upadhyay <usuraj35@gmail.com>
---
 net/decnet/af_decnet.c | 13 +++++--------
 1 file changed, 5 insertions(+), 8 deletions(-)

diff --git a/net/decnet/af_decnet.c b/net/decnet/af_decnet.c
index 0a46ea3bddd5..7d7ae2dd69b8 100644
--- a/net/decnet/af_decnet.c
+++ b/net/decnet/af_decnet.c
@@ -2134,14 +2134,11 @@ static struct sock *dn_socket_get_next(struct seq_f=
ile *seq,
 	struct dn_iter_state *state =3D seq->private;
=20
 	n =3D sk_next(n);
-try_again:
-	if (n)
-		goto out;
-	if (++state->bucket >=3D DN_SK_HASH_SIZE)
-		goto out;
-	n =3D sk_head(&dn_sk_hash[state->bucket]);
-	goto try_again;
-out:
+	while (!n) {
+		if (++state->bucket >=3D DN_SK_HASH_SIZE)
+			break;
+		n =3D sk_head(&dn_sk_hash[state->bucket]);
+	}
 	return n;
 }
=20
--=20
2.17.1


--IJpNTDwzlM2Ie8A6
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEE7AbCa0kOsMJ4cx0j+gRsbIfe744FAl8Qp5wACgkQ+gRsbIfe
74734BAAorwVxz+f8hyIOXsQT3a5bVBzZlIZLjZGqBMc2M45GtFrb2NQRPTmwr+s
f0I/PbgtXj5+tADrCSY7FD4AOkBk3qHgUfWze8dpM0/9EopSqOzNp6x88nO4LLqu
P8raX7c55wujcWqqDdwe/4Kk3Uhs3ZxobwPGwBivUEFCHFqXFyAFOxNdBqh5geXE
xlh0WTrnvbD8Pwt+D9aP02QjTIp/7n3hGsf4lznPsVt4u32hl51QrXdOp9AL25B4
1ligDFPjt+2VrnQrdJ/NZ2pORjF7pEYcG5kPMk3qPathqN9gz2sRrFg8IyOY9UvZ
6BeOd3h7HbhyHezaROSxIf8puIVNWybxqidy3aPk7yLIptDzTqk8/JhlD/Js7Fle
XBlMinF0M+I+YXIWMipVx2mvldqmnuwDhYvEMwQF3xhp4N2A7r8ruAdztQyAJR+k
k308k6hm/Op54yvksym93rv3VngYjFJ8MtUjHzuLhQ+jHs19dOpKHfI8gfMdqQsY
NIWcUKHYF3ZTcT2aRcdHdBdYIolOt45Qidap99nf47aUjHBTNavB8+6vxeA+hbV/
PzrSdZYO8r/my10iz3Ihgpm7R7iFTnChlWL70XGDOsURINn8jOKPTBBRm4xs38Eq
0UpzqU4ej+DZP5mz1yg3uxpwxTNceCeHIEY8PrVjytcNgEGuM/Y=
=TBRA
-----END PGP SIGNATURE-----

--IJpNTDwzlM2Ie8A6--
