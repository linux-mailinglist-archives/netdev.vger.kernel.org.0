Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 25AC0131A0C
	for <lists+netdev@lfdr.de>; Mon,  6 Jan 2020 22:05:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727078AbgAFVFV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jan 2020 16:05:21 -0500
Received: from mail-pl1-f193.google.com ([209.85.214.193]:44247 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726906AbgAFVFU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Jan 2020 16:05:20 -0500
Received: by mail-pl1-f193.google.com with SMTP id az3so22280960plb.11
        for <netdev@vger.kernel.org>; Mon, 06 Jan 2020 13:05:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=EJqzgtafuLEMKWeDTRfLHopVpmSdKzKynlPe3lrgYJE=;
        b=dueQpANJxYdMud3SrfvsnFxFM4mUKkX+jCljHkiBa7CTKNfVmtZT8VOtnO9MzYl9K3
         KbjkWRKIbejuNWBchG2fjedxrDp/xtGTUgRb3JGfd7RIe19a35uhZ15oAN2sR6GV6rOI
         wZCUs/sLeIQdTSxGs0dLH3ZjIOYlCfc1FSZwq8UtIDUmyovCnAfofByad8yXWHRp3Thz
         HZFTf1ANiYdcboPF9fDdHJZfEit61rZv20zcggsRlv3Z7NFYVvNYMWeIFatyTESWPgvR
         X2YHDDV61jSvEm5TeOV7egsP/m3YJikB5GCXDnolbQRx7TMTQc9bHT36xbNwY4aMJxG2
         a10w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=EJqzgtafuLEMKWeDTRfLHopVpmSdKzKynlPe3lrgYJE=;
        b=guSg3qzw0dkKEbZ2AOv21xwgqgA+lxPaJcd21Zx8xVXAYe50tpdVHy95guaJ8vyRjJ
         ow9AxLnrvRA6dyi3YK3P55YoP+x0IBvs3T0nDtXzfB5O+ufT05bltdRPuRiqF8uLczHd
         9D376Z+icdEcWjkyaIPV4TEx06V+Gp8NbLRSSCaJGuwsB++6ry/nL53bXSU6HIEpOTpp
         ZS14Neez1msFSGGs3UUForWOcTUYxqUA0DCWyRfiQ08wZRYuaDklnicS64OA3DLNSwSB
         jA/UNqcKZGgqVgB5tnB8FAv1r8P2iRlx2dtKLh7k6CHsLIX2V7n+gz1CZVHGomWJKl5B
         5mtA==
X-Gm-Message-State: APjAAAV2PplvPGBm1c3SFyeMYovoz6iQjmj08Frf4+Dc6sqVh5Sb1ynI
        zlAD2ClB6kD9gx2BmS48h6BBjuWYN9A=
X-Google-Smtp-Source: APXvYqzPBV3GezyvCOmJPSNR6OgPGiiKlGIBMcJKJQL2HAC7eYFS9U1KiU7+lh5JSkUmv+i2/EpSlw==
X-Received: by 2002:a17:90b:3011:: with SMTP id hg17mr44717545pjb.90.1578344719342;
        Mon, 06 Jan 2020 13:05:19 -0800 (PST)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id p16sm63183003pfq.184.2020.01.06.13.05.18
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 06 Jan 2020 13:05:18 -0800 (PST)
From:   Shannon Nelson <snelson@pensando.io>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     Shannon Nelson <snelson@pensando.io>
Subject: [PATCH net-next 0/4] ionic: driver updates
Date:   Mon,  6 Jan 2020 13:05:08 -0800
Message-Id: <20200106210512.34244-1-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

These are a few little updates for the ionic network driver.

Shannon Nelson (4):
  ionic: drop use of subdevice tags
  ionic: fix for ppc msix layout
  ionic: add Rx dropped packet counter
  ionic: restrict received packets to mtu size

 drivers/net/ethernet/pensando/ionic/ionic.h   |  4 ----
 .../ethernet/pensando/ionic/ionic_bus_pci.c   |  3 +++
 .../net/ethernet/pensando/ionic/ionic_lif.h   |  1 +
 .../net/ethernet/pensando/ionic/ionic_stats.c |  1 +
 .../net/ethernet/pensando/ionic/ionic_txrx.c  | 23 +++++++++++++++----
 5 files changed, 23 insertions(+), 9 deletions(-)

-- 
2.17.1

