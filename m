Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B97B63F3921
	for <lists+netdev@lfdr.de>; Sat, 21 Aug 2021 08:43:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232231AbhHUGoO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 21 Aug 2021 02:44:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232143AbhHUGoM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 21 Aug 2021 02:44:12 -0400
X-Greylist: delayed 356 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Fri, 20 Aug 2021 23:43:33 PDT
Received: from dvalin.narfation.org (dvalin.narfation.org [IPv6:2a00:17d8:100::8b1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A036CC061575;
        Fri, 20 Aug 2021 23:43:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=narfation.org;
        s=20121; t=1629527850;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=rrWiyvtJw8z+AfOLY8yVae6muI5PLy9dSHdSOzPLmZQ=;
        b=YcOge26ZtWX/9V7VLFOKZHa4MEAdqNhKEyXQnct/zoThJ27KRUJXaJZ0Mxh3r0sVKKJ6dt
        WUUzR+vvm6+k2r9rKX9ZA3MoBL9X8Q67++Ka95uJtmpn6BooQTA78CQsXR+6YO97fvn1Ie
        OhuSbMQZRzphvxmTCl+mJciaAgk6PGg=
From:   Sven Eckelmann <sven@narfation.org>
To:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>
Cc:     Saeed Mahameed <saeedm@nvidia.com>,
        Vlad Buslov <vladbu@nvidia.com>,
        Dmytro Linkin <dlinkin@nvidia.com>,
        Simon Wunderlich <sw@simonwunderlich.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Subject: Re: linux-next: Signed-off-by missing for commits in the net-next tree
Date:   Sat, 21 Aug 2021 08:37:27 +0200
Message-ID: <5095251.gXbVoBLRLe@sven-l14>
In-Reply-To: <20210821130815.22b5cfc3@canb.auug.org.au>
References: <20210821130815.22b5cfc3@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart1805552.DliSOAIF8d"; micalg="pgp-sha512"; protocol="application/pgp-signature"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--nextPart1805552.DliSOAIF8d
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"; protected-headers="v1"
From: Sven Eckelmann <sven@narfation.org>
To: David Miller <davem@davemloft.net>, Networking <netdev@vger.kernel.org>, Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Saeed Mahameed <saeedm@nvidia.com>, Vlad Buslov <vladbu@nvidia.com>, Dmytro Linkin <dlinkin@nvidia.com>, Simon Wunderlich <sw@simonwunderlich.de>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Linux Next Mailing List <linux-next@vger.kernel.org>
Subject: Re: linux-next: Signed-off-by missing for commits in the net-next tree
Date: Sat, 21 Aug 2021 08:37:27 +0200
Message-ID: <5095251.gXbVoBLRLe@sven-l14>
In-Reply-To: <20210821130815.22b5cfc3@canb.auug.org.au>
References: <20210821130815.22b5cfc3@canb.auug.org.au>

On Saturday, 21 August 2021 05:08:15 CEST Stephen Rothwell wrote:
[...]
>   71d41c09f1fa ("batman-adv: Move IRC channel to hackint.org")

Something went wrong here. The tag
https://git.open-mesh.org/linux-merge.git/tag/refs/tags/batadv-next-pullrequest-20210820 [1]
has this version of the patch:
https://git.open-mesh.org/linux-merge.git/commit/3baa9f522a0cad3cd8a45f4a5b85c3694cece672. 
And it seems like it has the correct Signed-off-by: and the patchwork-bot 
informed us that it was merged [2]

But it seems like 815cc21d8d2e47c2d00caf3cd4cddcf0b5b07292 merged [3] 
refs/tags/batadv-next-pullrequest-20210819 - an older version where we 
forgot this Signed-off-by (and Jakub informed us about it [4]).

Kind regards,
	Sven

[1] https://patchwork.kernel.org/project/netdevbpf/patch/20210820083300.32289-1-sw@simonwunderlich.de/
[2] https://lore.kernel.org/netdev/162946395159.27725.6381822484284696109.git-patchwork-notify@kernel.org/
[3] https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git/commit/?id=815cc21d8d2e47c2d00caf3cd4cddcf0b5b07292
[4] https://lore.kernel.org/netdev/20210819135238.354db062@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com/
--nextPart1805552.DliSOAIF8d
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEF10rh2Elc9zjMuACXYcKB8Eme0YFAmEgnycACgkQXYcKB8Em
e0Z0/BAAi+Jg6MrtVgzZVEo+/SVttw71oyyuIfBmAdM+rgCGjccvl9J6VnxbnXcM
RMCDrsyHGrYazFP6R12kKqFFwbfycrn8KdMJM06D3LC0NKOFVc25ezxYJkGpL8DL
JTpTX9fGLdYEZPqgENd3q/6fiySKrYG7LeC83loT0uPnzK4oPmpJYzvEhF3KXwqf
aA8QtC8g9J1cPIzM1DBX710E/qElnc3gh6E095lVb+vOXzsVQaFShQM1OVE7v5qM
HhlitW0e7AEcXvVJHjrYw8FPXr+jDsY2qpX9+raF1UG9jBRFQz6a0okX3VZH2Bp5
fwJMATVX4TEiWJB4bJZ3jimzuaLRN7nNeS8ZVc75H+CcOa6+q74iMGV3VA/iXpc7
cV/kN6aVI6gzD6iGun6xMOesG8BC9IbCfUaXxBQJgr+Vcz5Yo/YORIHi6j3knbmT
eM0KNrcKbIAzXRxxuutDLx1uDOubsajgLzPeMWouI4SA80i/UkCE+RSCrtr/ueRq
KIKVy/H7i0iwMSY4NS95M3j5Io3ynskFbQq93/3hhq+18Kpyqr9F6IplaVLqCQfa
1eRfUHoTBDAmW0M1oG5+MehLIgAcsVdibMaEM/ldEDWDpXB75A/MBJmKsCaIKyue
l1/RHeuKQg9Daxe+fiwgxbLPxsRRIJPk2AtMEomXYW6suDyGofM=
=QDjm
-----END PGP SIGNATURE-----

--nextPart1805552.DliSOAIF8d--



