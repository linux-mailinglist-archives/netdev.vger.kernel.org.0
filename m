Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C3E7D34B019
	for <lists+netdev@lfdr.de>; Fri, 26 Mar 2021 21:23:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230150AbhCZUW2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Mar 2021 16:22:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:41202 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230127AbhCZUW2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 26 Mar 2021 16:22:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C5957619DC;
        Fri, 26 Mar 2021 20:22:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616790148;
        bh=aSyhC3Zoj+dB/OOEOB7l+v2Ru+O+DYlDTxDxX0rSRpk=;
        h=From:To:Cc:Subject:Date:From;
        b=vQhsaYOkAIqazyu8ItQiHlK12x9W+Vmk4oIoZYtN2PzDysxbkreJH7eELLT0pvkMK
         rhfCuu9rjipGA+IObQHwTIyzFoHAtPU/TEbYjvQ7QrA6shBVV2IZ4jgSdCKXbkoa+a
         UlTchAMIwXagd3WBHgWSZ4ge13EmJexJYGUMvxyA/oWkwk744TVMgCb4lJC6RG0aah
         AbpKHXDMjv6Tx5D6VTCvoWS0i9DkHrlO+ZSBIxscsL6Qf0PPra4gLJ4aKHOnWgefMw
         DtcCQIeEZCH9Mp+vU9/Uugk/y8wtfbc48S8WAJOMmCPpjAZpBlnV5byOVwed5cpXHx
         CHeuPi39BShMQ==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, mkubecek@suse.cz,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 0/3] ethtool: fec: ioctl kdoc touch ups
Date:   Fri, 26 Mar 2021 13:22:20 -0700
Message-Id: <20210326202223.302085-1-kuba@kernel.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

A few touch ups from v1 review.

Jakub Kicinski (3):
  ethtool: fec: add note about reuse of reserved
  ethtool: fec: fix FEC_NONE check
  ethtool: document the enum values not defines

 include/uapi/linux/ethtool.h | 24 ++++++++++++++----------
 net/ethtool/ioctl.c          |  2 +-
 2 files changed, 15 insertions(+), 11 deletions(-)

-- 
2.30.2

