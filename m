Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B644868FCC6
	for <lists+netdev@lfdr.de>; Thu,  9 Feb 2023 03:02:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230455AbjBICCf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Feb 2023 21:02:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230394AbjBICCc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Feb 2023 21:02:32 -0500
Received: from gandalf.ozlabs.org (gandalf.ozlabs.org [150.107.74.76])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61E4525B90;
        Wed,  8 Feb 2023 18:02:29 -0800 (PST)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4PC0Vp5BLXz4xyF;
        Thu,  9 Feb 2023 13:02:26 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canb.auug.org.au;
        s=201702; t=1675908147;
        bh=IupGQDHLKSrO1KKSm66jjIg4WXdN8sGhbBsD1Hr6PO8=;
        h=Date:From:To:Cc:Subject:From;
        b=VfSwM5mGqsXqknqX9jqoplkn2BY4a0OG7QwvulhoVdRznkTcksh43Hs/DxgNymZql
         U36gVE3n1vKo1dXb6Hbuj3ywBuabFurhV+KnnV6dOufkVCiuY71+Aeb9rBDr/ohrLM
         oZZASdT56tX5SDiMsOMFlRp38Iy4XzjxUslyfNIDHQkYy88lGZ8uP3TpLyxJJn6I6C
         +Ycro1cotClvXnN9kEdpX3AoixRo6hoL95rfzMjTT06JSuLFYpHlrvFj4fh/EevUB9
         mWsCD4KVUq4tu7B5/8kRkfmK8oWUP235XDogsCuukzU+0OaH5I5Er/wXoiSzqJ6HWt
         O8s1SWF8oZSeA==
Date:   Thu, 9 Feb 2023 13:02:24 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Yury Norov <yury.norov@gmail.com>,
        David Miller <davem@davemloft.net>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Subject: linux-next: duplicate patches in the bitmap tree
Message-ID: <20230209130224.76c7f357@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/quWrNBKlEK6VYwMEZT.yHON";
 protocol="application/pgp-signature"; micalg=pgp-sha256
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/quWrNBKlEK6VYwMEZT.yHON
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

The following commits are also in the net-next tree as different commits
(but the same patches):

  2386459394d2 ("lib/cpumask: update comment for cpumask_local_spread()")
  a99b18849bc8 ("net/mlx5e: Improve remote NUMA preferences used for the IR=
Q affinity hints")
  af547a927f9f ("sched/topology: Introduce for_each_numa_hop_mask()")
  439829e1bfba ("sched/topology: Introduce sched_numa_hop_mask()")
  c0d13fba970d ("lib/cpumask: reorganize cpumask_local_spread() logic")
  8ec0ffa233ab ("cpumask: improve on cpumask_local_spread() locality")
  6139966175ca ("sched: add sched_numa_find_nth_cpu()")
  ded3cee7db80 ("cpumask: introduce cpumask_nth_and_andnot")

These are commits

  2ac4980c57f5 ("lib/cpumask: update comment for cpumask_local_spread()")
  2acda57736de ("net/mlx5e: Improve remote NUMA preferences used for the IR=
Q affinity hints")
  06ac01721f7d ("sched/topology: Introduce for_each_numa_hop_mask()")
  9feae65845f7 ("sched/topology: Introduce sched_numa_hop_mask()")
  b1beed72b8b7 ("lib/cpumask: reorganize cpumask_local_spread() logic")
  406d394abfcd ("cpumask: improve on cpumask_local_spread() locality")
  cd7f55359c90 ("sched: add sched_numa_find_nth_cpu()")
  62f4386e564d ("cpumask: introduce cpumask_nth_and_andnot")

in the net-next tree.

There are some slight differences (I got a conflict merging the bitmap
tree today), but the net-next series is newer than the bitmap tree one ...

--=20
Cheers,
Stephen Rothwell

--Sig_/quWrNBKlEK6VYwMEZT.yHON
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmPkVDEACgkQAVBC80lX
0Gy0Fgf/cBI2iSbRqrAkZ0sZM40/1c1FJkZFT2hmnSA92PqgcSTOjJfnHugObp3u
HEYKFZg1VNeg7pLtb58X1SSE41ejRAnhyEhUnsb70UH72KXL4OaLY0Y1A5Nc3NjB
xh+FhGOEWiv2/aHERC7o5YliTe8QDASAoybYmETcCJUC9Xb79hkJrRnkAU6PUSRa
BcoxdAR5Jpz+9BaFXdk291Ec2ohFMdczLDLt/qAcU0WxL/uvEsR9IEaLmwvr7CvN
COLljoue+XM+VETlIR79k3UE7IMN2IwsJvlqr/yiCTKbG31idCjux9seGB8yR86W
/0Lfz8FcJdCFlQcp0NXU3f/66oEsQw==
=V8iY
-----END PGP SIGNATURE-----

--Sig_/quWrNBKlEK6VYwMEZT.yHON--
