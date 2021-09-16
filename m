Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2197C40D6DA
	for <lists+netdev@lfdr.de>; Thu, 16 Sep 2021 11:56:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237369AbhIPJ5l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Sep 2021 05:57:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:58044 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236073AbhIPJ4s (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Sep 2021 05:56:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2D6596120F;
        Thu, 16 Sep 2021 09:55:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631786126;
        bh=75WrKbSFBKg3yzGt07IbXwPNTFQ0wIIFH/Or+OVz1tk=;
        h=From:To:Cc:Subject:Date:From;
        b=uF5yJPv/qiKbXXEFvin6OmfsjMRrph3HNOgVM4VP8l98VyCCn6ZiDH4Vz9ThIa3nO
         /R3BLqZrexnLqAhaLqqje35cJvGT4N3rzjw+tJcda+Ho3iJSy3WwY5wVLASpoPMaG0
         BdVfOxuhSoKonDNgYiYNAV5b+jhnTDG3G0iRsZjuDNsSqouJPu1+uSll78aJKox5Ns
         KwHB376rUBOCM9pslwyGU8l8WVSDWBaAmSdRQHZs7Vn9W0IUzd/0QWauFDPCMtQEHo
         PeyD1wssHY2MBiz2gKKjgNgw/LEq0+KlatdR8BlJsvdBjXO7hPlAu8a1uYbkmb9sPv
         1LdRPeVp9uZAg==
Received: by mail.kernel.org with local (Exim 4.94.2)
        (envelope-from <mchehab@kernel.org>)
        id 1mQo72-001vTH-32; Thu, 16 Sep 2021 11:55:24 +0200
From:   Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
To:     Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Jonathan Corbet <corbet@lwn.net>
Cc:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        linux-kernel@vger.kernel.org, Daniel Vetter <daniel@ffwll.ch>,
        David Airlie <airlied@linux.ie>,
        Evgeniy Polyakov <zbr@ioremap.net>,
        Jakub Kicinski <kuba@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, Martin KaFai Lau <kafai@fb.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Rob Herring <robh+dt@kernel.org>,
        Shuah Khan <shuah@kernel.org>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        bpf@vger.kernel.org, devicetree@vger.kernel.org,
        dri-devel@lists.freedesktop.org,
        linux-arm-kernel@lists.infradead.org,
        linux-kselftest@vger.kernel.org,
        linux-mediatek@lists.infradead.org, linux-mmc@vger.kernel.org,
        linux-omap@vger.kernel.org, netdev@vger.kernel.org,
        sparmaintainer@unisys.com
Subject: [PATCH v2 00/23] Fix some issues at documentation
Date:   Thu, 16 Sep 2021 11:54:59 +0200
Message-Id: <cover.1631785820.git.mchehab+huawei@kernel.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: Mauro Carvalho Chehab <mchehab@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi John,

Please ignore the previous series I sent today [1].  I forgot that I had
already submitted a first version of this series.

[1]  https://lore.kernel.org/all/cover.1631783482.git.mchehab+huawei@kernel.org/


The first patch in this series fix a bad character used instead of
a "(c)" UTF-8 symbol.

The remaining ones fix several broken references to files
under Documentation/, several due to DT schema conversions
from .txt to .yaml.

---

v2:
   - Added a couple of extra fixes;
   - merged two patches touching mtd-physmap.yaml;
   - added missing tags (acked-by/reviewed-by) received after v1.
v1: https://lore.kernel.org/all/cover.1626947923.git.mchehab+huawei@kernel.org/



Mauro Carvalho Chehab (23):
  visorbus: fix a copyright symbol that was bad encoded
  dt-bindings: net: dsa: sja1105: update nxp,sja1105.yaml reference
  dt-bindings: arm: mediatek: mmsys: update mediatek,mmsys.yaml
    reference
  dt-bindings: w1: update w1-gpio.yaml reference
  dt-bindings: mmc: update mmc-card.yaml reference
  libbpf: update index.rst reference
  docs: accounting: update delay-accounting.rst reference
  tools: bpftool: update bpftool-prog.rst reference
  tools: bpftool: update bpftool-map.rst reference
  bpftool: update bpftool-cgroup.rst reference
  MAINTAINERS: update arm,vic.yaml reference
  MAINTAINERS: update aspeed,i2c.yaml reference
  MAINTAINERS: update faraday,ftrtc010.yaml reference
  MAINTAINERS: update fsl,fec.yaml reference
  MAINTAINERS: update ti,sci.yaml reference
  MAINTAINERS: update intel,ixp46x-rng.yaml reference
  MAINTAINERS: update nxp,imx8-jpeg.yaml reference
  MAINTAINERS: update gemini.yaml reference
  MAINTAINERS: update brcm,unimac-mdio.yaml reference
  MAINTAINERS: update chipone,icn8318.yaml reference
  MAINTAINERS: update silergy,sy8106a.yaml reference
  MAINTAINERS: update mtd-physmap.yaml reference
  MAINTAINERS: update ti,am654-hbmc.yaml reference

 Documentation/admin-guide/sysctl/kernel.rst   |  2 +-
 Documentation/bpf/index.rst                   |  2 +-
 .../display/mediatek/mediatek,disp.txt        |  2 +-
 Documentation/networking/dsa/sja1105.rst      |  2 +-
 Documentation/w1/masters/w1-gpio.rst          |  2 +-
 MAINTAINERS                                   | 28 +++++++++----------
 drivers/mmc/host/omap_hsmmc.c                 |  2 +-
 drivers/visorbus/visorbus_main.c              |  2 +-
 .../selftests/bpf/test_bpftool_synctypes.py   |  6 ++--
 9 files changed, 24 insertions(+), 24 deletions(-)

-- 
2.31.1


