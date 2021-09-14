Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E892340B820
	for <lists+netdev@lfdr.de>; Tue, 14 Sep 2021 21:34:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233028AbhINTez (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Sep 2021 15:34:55 -0400
Received: from mail.aperture-lab.de ([116.203.183.178]:44928 "EHLO
        mail.aperture-lab.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230390AbhINTey (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Sep 2021 15:34:54 -0400
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id D7D2E3EA6B;
        Tue, 14 Sep 2021 21:25:25 +0200 (CEST)
From:   =?UTF-8?q?Linus=20L=C3=BCssing?= <linus.luessing@c0d3.blue>
To:     Kalle Valo <kvalo@codeaurora.org>, Felix Fietkau <nbd@nbd.name>,
        Sujith Manoharan <c_manoha@qca.qualcomm.com>,
        ath9k-devel@qca.qualcomm.com
Cc:     linux-wireless@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "John W . Linville" <linville@tuxdriver.com>,
        Felix Fietkau <nbd@openwrt.org>,
        Simon Wunderlich <sw@simonwunderlich.de>,
        Sven Eckelmann <sven@narfation.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 0/3] ath9k: interrupt fixes on queue reset
Date:   Tue, 14 Sep 2021 21:25:12 +0200
Message-Id: <20210914192515.9273-1-linus.luessing@c0d3.blue>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Last-TLS-Session-Version: TLSv1.3
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

The following are two patches for ath9k to fix a potential interrupt
storm (PATCH 2/3) and to fix potentially resetting the wifi chip while
its interrupts were accidentally reenabled (PATCH 3/3).

PATCH 1/3 adds the possibility to trigger the ath9k queue reset through
the ath9k reset file in debugfs. Which was helpful to reproduce and debug
this issue and might help for future debugging.

PATCH 2/3 and PATCH 3/3 should be applicable for stable.

Regards, Linus

