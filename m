Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EAB6517BC7D
	for <lists+netdev@lfdr.de>; Fri,  6 Mar 2020 13:15:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726382AbgCFMPT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Mar 2020 07:15:19 -0500
Received: from simonwunderlich.de ([79.140.42.25]:44544 "EHLO
        simonwunderlich.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726190AbgCFMPS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Mar 2020 07:15:18 -0500
Received: from kero.packetmixer.de (p200300C597077300B0A48B46F0435C76.dip0.t-ipconnect.de [IPv6:2003:c5:9707:7300:b0a4:8b46:f043:5c76])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by simonwunderlich.de (Postfix) with ESMTPSA id DEDC762058;
        Fri,  6 Mar 2020 13:06:19 +0100 (CET)
From:   Simon Wunderlich <sw@simonwunderlich.de>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, b.a.t.m.a.n@lists.open-mesh.org,
        Simon Wunderlich <sw@simonwunderlich.de>
Subject: [PATCH 0/1] pull request for net: batman-adv 2020-03-06
Date:   Fri,  6 Mar 2020 13:06:17 +0100
Message-Id: <20200306120618.25714-1-sw@simonwunderlich.de>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi David,

here is a bugfix which we would like to have integrated into net.

Please pull or let me know of any problem!

Thank you,
      Simon

The following changes since commit bb6d3fb354c5ee8d6bde2d576eb7220ea09862b9:

  Linux 5.6-rc1 (2020-02-09 16:08:48 -0800)

are available in the Git repository at:

  git://git.open-mesh.org/linux-merge.git tags/batadv-net-for-davem-20200306

for you to fetch changes up to 8e8ce08198de193e3d21d42e96945216e3d9ac7f:

  batman-adv: Don't schedule OGM for disabled interface (2020-02-18 09:07:55 +0100)

----------------------------------------------------------------
Here is a batman-adv bugfix:

 - Don't schedule OGM for disabled interface, by Sven Eckelmann

----------------------------------------------------------------
Sven Eckelmann (1):
      batman-adv: Don't schedule OGM for disabled interface

 net/batman-adv/bat_iv_ogm.c | 4 ++++
 1 file changed, 4 insertions(+)
