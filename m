Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A57F28710E
	for <lists+netdev@lfdr.de>; Thu,  8 Oct 2020 10:57:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729038AbgJHI5v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Oct 2020 04:57:51 -0400
Received: from ns.lineo.co.jp ([203.141.200.203]:38818 "EHLO mail.lineo.co.jp"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726304AbgJHI5e (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 8 Oct 2020 04:57:34 -0400
Received: from [172.31.78.0] (unknown [203.141.200.204])
        by mail.lineo.co.jp (Postfix) with ESMTPSA id 9872580214FF9;
        Thu,  8 Oct 2020 17:47:21 +0900 (JST)
From:   Naoki Hayama <naoki.hayama@lineo.co.jp>
Subject: [PATCH 0/6] spelling: Fix typo related to "arbitrary"
To:     linux-kernel@vger.kernel.org
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Colin Ian King <colin.king@canonical.com>,
        Andy Whitcroft <apw@canonical.com>,
        Joe Perches <joe@perches.com>,
        Samuel Chessman <chessman@tux.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Andy Gross <agross@kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.com>,
        Lucas Stach <l.stach@pengutronix.de>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>, netdev@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-gpio@vger.kernel.org,
        devicetree@vger.kernel.org, alsa-devel@alsa-project.org,
        etnaviv@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        Naoki Hayama <naoki.hayama@lineo.co.jp>
Message-ID: <4dea2b7e-31b9-a231-7fa2-9ee7ffd37686@lineo.co.jp>
Date:   Thu, 8 Oct 2020 17:47:21 +0900
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I found some typos related to "arbitrary".

s/abitrary/arbitrary/
s/arbitary/arbitrary/

This series fixes them.

These typos have been reported in the past in other codes, but
correction 'abitrary||arbitrary' wasn't added to scripts/spelling.txt.
Therefore, PATCH #6 adds it to spelling.txt.


Naoki Hayama (6):
  net: tlan: Fix typo abitrary
  dt-bindings: pinctrl: qcom: Fix typo abitrary
  dt-bindings: pinctrl: sirf: Fix typo abitrary
  ALSA: hdspm: Fix typo arbitary
  drm/etnaviv: Fix typo arbitary
  scripts/spelling.txt: Add arbitrary correction

 Documentation/devicetree/bindings/pinctrl/pinctrl-atlas7.txt    | 2 +-
 .../devicetree/bindings/pinctrl/qcom,ipq4019-pinctrl.txt        | 2 +-
 drivers/gpu/drm/etnaviv/etnaviv_gpu.c                           | 2 +-
 drivers/net/ethernet/ti/tlan.c                                  | 2 +-
 scripts/spelling.txt                                            | 1 +
 sound/pci/rme9652/hdspm.c                                       | 2 +-
 6 files changed, 6 insertions(+), 5 deletions(-)

-- 
2.17.1
