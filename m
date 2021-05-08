Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 03D513771CA
	for <lists+netdev@lfdr.de>; Sat,  8 May 2021 14:37:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231167AbhEHMih (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 8 May 2021 08:38:37 -0400
Received: from mout.kundenserver.de ([217.72.192.73]:45113 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230447AbhEHMi2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 8 May 2021 08:38:28 -0400
Received: from localhost.localdomain ([37.4.249.151]) by
 mrelayeu.kundenserver.de (mreue107 [212.227.15.183]) with ESMTPSA (Nemesis)
 id 1MyKYE-1lKPVD33am-00yhqi; Sat, 08 May 2021 14:37:19 +0200
From:   Stefan Wahren <stefan.wahren@i2se.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Stefan Wahren <stefan.wahren@i2se.com>
Subject: [PATCH 0/3 net-next] net: qca_spi: Improve sync handling
Date:   Sat,  8 May 2021 14:36:32 +0200
Message-Id: <1620477395-12740-1-git-send-email-stefan.wahren@i2se.com>
X-Mailer: git-send-email 2.7.4
X-Provags-ID: V03:K1:Z/triiid6itqm+P3mty7nxGXzaV/djZGACUlcQbIGHtdFyysGmU
 eKaOUBC47iFB1DNvpQU3DiTK9/jA78hgvJC2jDaNVt+NDwEJuLHpFa8gkyGcrGGldMAET5g
 FikCvVwrU3bjg6hvpwRQd1G/DlOmwYx4Mdxg5pfb4UkjYIx7Vd06zec5bPl2Yo78de4au2+
 ykUrMZDUbgy2meTnX9i+Q==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:1VrgSrbWnpc=:pRqvJVhga/UjTuNaPM6GVi
 wkIIoYdNcu0C4rUiU8J2UuUreAs6oEbdipa9foOvoFlJIFXBmhJLG771BkqtECfVn/K+OgGvs
 5ZQellguTTm9+MJMTNYCX7nOW8owr2gHaMpDVf1xp59xi6EkMoInIUhGy0MMVxy0pxelPfC+R
 MBpBKsQOuBZMgd1LIv45t3D2lDbvUcp31XKIxNr4216VTvORWDkJOPAVmEg55n5rR2vcAW/3T
 FLrEyAqdOBL5oSgvw3H8CUE3kFCgz2S0JmwtPEhSwAY3vk38yCMknny0tsyGPIyMITUKOFNFW
 YPH+aj6Ftd5wrKJSbPxr49goJEAZUWPFNuy+Or37cSNsB6IIRLumZ/uf56L5++VImeptV8HmZ
 ZOlHtuWnO2V5yP8mVvibmvMf2m0GunvNB+jvwT2f79GJH/d+aKQHoQLsDfFkqe5daq2ZlDEd/
 9hccTIYU2xBrE8CfrSHpNYOHF6qgREiI5hzP57xEV8SaJ4RUfw4ABgEYpu4SWEWXh6fijq2E1
 gL84G3uTDvIGOY0TtUlzTI=
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This small patch series contains some improvements of the sync
handling. This was discovered while the QCA7000 was doing SLAC
(Signal Level Attenuation Characterization).

Stefan Wahren (3):
  net: qca_spi: Avoid reading signature three times in a row
  net: qca_spi: Avoid re-sync for single signature error
  net: qca_spi: Introduce stat about bad signature

 drivers/net/ethernet/qualcomm/qca_debug.c |  1 +
 drivers/net/ethernet/qualcomm/qca_spi.c   | 10 +++++++++-
 drivers/net/ethernet/qualcomm/qca_spi.h   |  1 +
 3 files changed, 11 insertions(+), 1 deletion(-)

-- 
2.7.4

