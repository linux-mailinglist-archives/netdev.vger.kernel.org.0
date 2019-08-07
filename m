Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D31368460D
	for <lists+netdev@lfdr.de>; Wed,  7 Aug 2019 09:34:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387435AbfHGHef (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Aug 2019 03:34:35 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:55821 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387402AbfHGHee (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Aug 2019 03:34:34 -0400
Received: by mail-wm1-f67.google.com with SMTP id f72so441852wmf.5
        for <netdev@vger.kernel.org>; Wed, 07 Aug 2019 00:34:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from:cc;
        bh=FZrUQH33y44Ytw4iJLLaq3ZcMTl1mI3uSlJR/j+IYIA=;
        b=sm33IYA6YCZXfStWQ2VxSkjKlqC6Pc49HxVe5SFTOVZhHqE4v/mQWVzH8A8t9QXGf1
         MZio94ryosMuUEyzoLF9A/9ZbHvZMRkXvwuoMEhDSTLqABdT45gyFfcm+vi/XY0NWzfX
         THUmMpBdZkqb55o9sEHSpbShnr+XMEUziry7S1aUi3q4APB+e2DcQ7A37XAaHeqpFkmP
         WDt9acG91X+y2w2BX9IhvXr1WtCR5ZYdoHgCDfYP3h1Tr5urOXUUtTzJiTdsEh4jFL1K
         zwxf1jq0f7jJhGDCZvh8f4M9acWpPg6VvRMAhd2q6wUsl+JwQufNZP47i9mjvwB/P5Fz
         tbZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from:cc;
        bh=FZrUQH33y44Ytw4iJLLaq3ZcMTl1mI3uSlJR/j+IYIA=;
        b=SslMqIH+Fb91N9Y1D8nbuqM5VBS67GkuFWFia5PP5ifqx2RLAvfROPiKZknvPfhOz1
         MkNm42fFW786CWDul2GMdR7w1wulhTJgH7nwJNo5iW4rM0SUVISmrUAb5h2DuCVdJT/z
         VJDKytf1B4Re7b4+td+H4PSzuhpAFLmg+gYUTyiTi1f+tASsx/baXaSL+mPsSky1vgnu
         vvBadYtOyYOouU3V8mrIi5zZ0ndaQa2pj3CTJLgZXHifaf/vq2FSvP7qYUimPNQ38na5
         ahe5gqIJ/95Ty7FXFOKdB20jfKbURYrDx12cykb+t49Q94klnSEjO01jw6cYQyYfw8Ba
         D63g==
X-Gm-Message-State: APjAAAW04rAYD6ttX4qNgcPzwJLZxCtR+Uc++lzBVkhJ5bRycx5bbaaJ
        qBQ4RFi+GKWHtOIKVyQNyPhVOQ==
X-Google-Smtp-Source: APXvYqzDJy8goZnkK981FtKvLP4ltt5j12SyCQo15xhOCqUOj4ur0/SSjmlX9lG53vtJrI5qznaTjA==
X-Received: by 2002:a05:600c:114f:: with SMTP id z15mr8983631wmz.131.1565163272906;
        Wed, 07 Aug 2019 00:34:32 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id y2sm79688035wrl.4.2019.08.07.00.34.31
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 07 Aug 2019 00:34:32 -0700 (PDT)
Message-ID: <5d4a7f08.1c69fb81.5cc82.1018@mx.google.com>
Date:   Wed, 07 Aug 2019 00:34:32 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: net-next
X-Kernelci-Kernel: v5.3-rc1-460-g05bb520376af
X-Kernelci-Lab-Name: lab-baylibre
X-Kernelci-Branch: master
X-Kernelci-Report-Type: bisect
Subject: net-next/master boot bisection: v5.3-rc1-460-g05bb520376af on
 meson-gxm-khadas-vim2
To:     Andrew Bowers <andrewx.bowers@intel.com>,
        tomeu.vizoso@collabora.com, guillaume.tucker@collabora.com,
        mgalka@collabora.com, Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        broonie@kernel.org, matthew.hart@linaro.org, khilman@baylibre.com,
        enric.balletbo@collabora.com,
        Jacob Keller <jacob.e.keller@intel.com>
From:   "kernelci.org bot" <bot@kernelci.org>
Cc:     netdev@vger.kernel.org, intel-wired-lan@lists.osuosl.org,
        linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
* This automated bisection report was sent to you on the basis  *
* that you may be involved with the breaking commit it has      *
* found.  No manual investigation has been done to verify it,   *
* and the root cause of the problem may be somewhere else.      *
*                                                               *
* If you do send a fix, please include this trailer:            *
*   Reported-by: "kernelci.org bot" <bot@kernelci.org>          *
*                                                               *
* Hope this helps!                                              *
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

net-next/master boot bisection: v5.3-rc1-460-g05bb520376af on meson-gxm-kha=
das-vim2

Summary:
  Start:      05bb520376af Merge branch '40GbE' of git://git.kernel.org/pub=
/scm/linux/kernel/git/jkirsher/next-queue
  Details:    https://kernelci.org/boot/id/5d4a3a6759b51422d431b28d
  Plain log:  https://storage.kernelci.org//net-next/master/v5.3-rc1-460-g0=
5bb520376af/arm64/defconfig/gcc-8/lab-baylibre/boot-meson-gxm-khadas-vim2.t=
xt
  HTML log:   https://storage.kernelci.org//net-next/master/v5.3-rc1-460-g0=
5bb520376af/arm64/defconfig/gcc-8/lab-baylibre/boot-meson-gxm-khadas-vim2.h=
tml
  Result:     b27223591606 i40e: verify string count matches even on early =
return

Checks:
  revert:     PASS
  verify:     PASS

Parameters:
  Tree:       net-next
  URL:        git://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.=
git
  Branch:     master
  Target:     meson-gxm-khadas-vim2
  CPU arch:   arm64
  Lab:        lab-baylibre
  Compiler:   gcc-8
  Config:     defconfig
  Test suite: boot

Breaking commit found:

---------------------------------------------------------------------------=
----
commit b27223591606f59c1f7c042b8e3dc74affadf492
Author: Jacob Keller <jacob.e.keller@intel.com>
Date:   Tue Jul 2 08:22:58 2019 -0400

    i40e: verify string count matches even on early return
    =

    Similar to i40e_get_ethtool_stats, add a goto to verify that the data
    pointer for the strings lines up with the expected stats count. This
    helps ensure that bugs are not introduced when adding stats.
    =

    Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
    Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
    Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>

diff --git a/drivers/net/ethernet/intel/i40e/i40e_ethtool.c b/drivers/net/e=
thernet/intel/i40e/i40e_ethtool.c
index ceca57a261dc..01e4615b1b4b 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_ethtool.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_ethtool.c
@@ -2342,7 +2342,7 @@ static void i40e_get_stat_strings(struct net_device *=
netdev, u8 *data)
 	}
 =

 	if (vsi !=3D pf->vsi[pf->lan_vsi] || pf->hw.partition_id !=3D 1)
-		return;
+		goto check_data_pointer;
 =

 	i40e_add_stat_strings(&data, i40e_gstrings_veb_stats);
 =

@@ -2354,6 +2354,7 @@ static void i40e_get_stat_strings(struct net_device *=
netdev, u8 *data)
 	for (i =3D 0; i < I40E_MAX_USER_PRIORITY; i++)
 		i40e_add_stat_strings(&data, i40e_gstrings_pfc_stats, i);
 =

+check_data_pointer:
 	WARN_ONCE(data - p !=3D i40e_get_stats_count(netdev) * ETH_GSTRING_LEN,
 		  "stat strings count mismatch!");
 }
---------------------------------------------------------------------------=
----


Git bisection log:

---------------------------------------------------------------------------=
----
git bisect start
# good: [9e8fb25254f76cb483303d8e9a97ed80a65418fe] Merge branch 'net-l3-l4-=
functional-tests'
git bisect good 9e8fb25254f76cb483303d8e9a97ed80a65418fe
# bad: [05bb520376af2c5146d3c44832c22ec3bb54d778] Merge branch '40GbE' of g=
it://git.kernel.org/pub/scm/linux/kernel/git/jkirsher/next-queue
git bisect bad 05bb520376af2c5146d3c44832c22ec3bb54d778
# good: [c4ed52538cd012bd9dfe97beda6802454d367e70] Merge branch 'drop_monit=
or-Various-improvements-and-cleanups'
git bisect good c4ed52538cd012bd9dfe97beda6802454d367e70
# good: [fb1b775a247ee8d846152841f780eba6cb71bcfc] net: sched: add skbedit =
of ptype action to hardware IR
git bisect good fb1b775a247ee8d846152841f780eba6cb71bcfc
# good: [ef68de56c7ad6f708bee8db5e08b83013083e757] Merge branch 'Support-tu=
nnels-over-VLAN-in-NFP'
git bisect good ef68de56c7ad6f708bee8db5e08b83013083e757
# good: [0969402fd5dd57268bb7547d7e5ece8fcd81157d] i40e: Update visual effe=
ct for advertised FEC mode.
git bisect good 0969402fd5dd57268bb7547d7e5ece8fcd81157d
# bad: [b27223591606f59c1f7c042b8e3dc74affadf492] i40e: verify string count=
 matches even on early return
git bisect bad b27223591606f59c1f7c042b8e3dc74affadf492
# good: [b603f9dc20afed5e4666642c8713cafb94a23058] i40e: Log info when PF i=
s entering and leaving Allmulti mode.
git bisect good b603f9dc20afed5e4666642c8713cafb94a23058
# first bad commit: [b27223591606f59c1f7c042b8e3dc74affadf492] i40e: verify=
 string count matches even on early return
---------------------------------------------------------------------------=
----
