Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BD3CF11FBE9
	for <lists+netdev@lfdr.de>; Mon, 16 Dec 2019 00:43:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726470AbfLOXn1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 15 Dec 2019 18:43:27 -0500
Received: from gloria.sntech.de ([185.11.138.130]:50438 "EHLO gloria.sntech.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726260AbfLOXn1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 15 Dec 2019 18:43:27 -0500
Received: from ip5f5a5f74.dynamic.kabel-deutschland.de ([95.90.95.116] helo=diego.localnet)
        by gloria.sntech.de with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <heiko@sntech.de>)
        id 1igdXn-0004g5-FK; Mon, 16 Dec 2019 00:43:23 +0100
From:   Heiko =?ISO-8859-1?Q?St=FCbner?= <heiko@sntech.de>
To:     Soeren Moch <smoch@web.de>
Cc:     Kalle Valo <kvalo@codeaurora.org>,
        brcm80211-dev-list.pdl@broadcom.com, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-rockchip@lists.infradead.org, brcm80211-dev-list@cypress.com,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2 0/9] brcmfmac: add support for BCM4359 SDIO chipset
Date:   Mon, 16 Dec 2019 00:43:22 +0100
Message-ID: <2685733.IzV8dBlDb2@diego>
In-Reply-To: <22526722-1ae8-a018-0e24-81d7ad7512dd@web.de>
References: <20191211235253.2539-1-smoch@web.de> <1daadfe0-5964-db9b-818c-6e4c75ac6a69@web.de> <22526722-1ae8-a018-0e24-81d7ad7512dd@web.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Soeren,

Am Sonntag, 15. Dezember 2019, 22:24:10 CET schrieb Soeren Moch:
> On 12.12.19 11:59, Soeren Moch wrote:
> > On 12.12.19 10:42, Kalle Valo wrote:
> >> Soeren Moch <smoch@web.de> writes:
> >>
> >>> Add support for the BCM4359 chipset with SDIO interface and RSDB support
> >>> to the brcmfmac wireless network driver in patches 1-7.
> >>>
> >>> Enhance devicetree of the RockPro64 arm64/rockchip board to use an
> >>> AP6359SA based wifi/bt combo module with this chipset in patches 8-9.
> >>>
> >>>
> >>> Chung-Hsien Hsu (1):
> >>>   brcmfmac: set F2 blocksize and watermark for 4359
> >>>
> >>> Soeren Moch (5):
> >>>   brcmfmac: fix rambase for 4359/9
> >>>   brcmfmac: make errors when setting roaming parameters non-fatal
> >>>   brcmfmac: add support for BCM4359 SDIO chipset
> >>>   arm64: dts: rockchip: RockPro64: enable wifi module at sdio0
> >>>   arm64: dts: rockchip: RockPro64: hook up bluetooth at uart0
> >>>
> >>> Wright Feng (3):
> >>>   brcmfmac: reset two D11 cores if chip has two D11 cores
> >>>   brcmfmac: add RSDB condition when setting interface combinations
> >>>   brcmfmac: not set mbss in vif if firmware does not support MBSS
> >>>
> >>>  .../boot/dts/rockchip/rk3399-rockpro64.dts    | 50 +++++++++++---
> >>>  .../broadcom/brcm80211/brcmfmac/bcmsdh.c      |  8 ++-
> >>>  .../broadcom/brcm80211/brcmfmac/cfg80211.c    | 68 +++++++++++++++----
> >>>  .../broadcom/brcm80211/brcmfmac/chip.c        | 54 ++++++++++++++-
> >>>  .../broadcom/brcm80211/brcmfmac/chip.h        |  1 +
> >>>  .../broadcom/brcm80211/brcmfmac/pcie.c        |  2 +-
> >>>  .../broadcom/brcm80211/brcmfmac/sdio.c        | 17 +++++
> >>>  include/linux/mmc/sdio_ids.h                  |  2 +
> >>>  8 files changed, 176 insertions(+), 26 deletions(-)
> >> Just to make sure we are on the same page, I will apply patches 1-7 to
> >> wireless-drivers-next and patches 8-9 go to some other tree? And there
> >> are no dependencies between the brcmfmac patches and dts patches?
> >>
> > Yes, this also is my understanding. I'm glad if you are fine with
> > patches 1-7.
> > Heiko will pick up patches 8-9 later for linux-rockchip independently.
> > And if we need another round of review for patches 8-9, I think we don't
> > need to bother linux-wireless with this.
> 
> Heiko,
> 
> is this OK for you when patches 1-7 are merged now in wireless-drivers,
> and then I send a v3 for patches 8-9 only for you to merge in
> linux-rockchip later? Or do you prefer a full v3 for the whole series
> with only this pending clock name update in patch 9?

Nope, merging 1-7 from this v2 and then getting a v3 with only the dts
stuff is perfectly fine :-)

Heiko


