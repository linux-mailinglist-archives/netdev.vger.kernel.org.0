Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8C07E149559
	for <lists+netdev@lfdr.de>; Sat, 25 Jan 2020 12:49:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726565AbgAYLtA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Jan 2020 06:49:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:58986 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725767AbgAYLs7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 25 Jan 2020 06:48:59 -0500
Received: from p977.fit.wifi.vutbr.cz (unknown [147.229.117.36])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3B81020704;
        Sat, 25 Jan 2020 11:48:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579952939;
        bh=QsfMFepH1m+XlwBoXv654v8+jT1qGKdvJVCuBd4sg54=;
        h=From:To:Cc:Subject:Date:From;
        b=H50XH7NChNzrNP+Eyfz+shBKCCjZX1JMWEPdYlKnacY98TuO4HDANnGJA/3wcNrPj
         kf3dDHnx4ZoTJCvUou51NNAxf8R5zUFF1fc4GI+x7NvtE6W7vE9K2TyOHuVBGQ/hoV
         LMNCAg7aBrYb6YyeOtOXGwTov8K9bwXa+kHivFUQ=
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     netdev@vger.kernel.org
Cc:     ilias.apalodimas@linaro.org, davem@davemloft.net,
        lorenzo.bianconi@redhat.com, brouer@redhat.com
Subject: [PATCH net 0/2] XDP fixes for socionext driver
Date:   Sat, 25 Jan 2020 12:48:49 +0100
Message-Id: <cover.1579952387.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.21.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix possible user-after-in XDP rx path
Fix rx statistics accounting if no bpf program is attached

Lorenzo Bianconi (2):
  net: socionext: fix possible user-after-free in netsec_process_rx
  net: socionext: fix xdp_result initialization in netsec_process_rx

 drivers/net/ethernet/socionext/netsec.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

-- 
2.21.1

