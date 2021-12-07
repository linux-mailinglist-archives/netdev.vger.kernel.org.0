Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A274D46BE56
	for <lists+netdev@lfdr.de>; Tue,  7 Dec 2021 15:57:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238312AbhLGPBD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Dec 2021 10:01:03 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:52722 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232266AbhLGPBC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Dec 2021 10:01:02 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 2BB20CE1AB3
        for <netdev@vger.kernel.org>; Tue,  7 Dec 2021 14:57:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AEF2AC341C3;
        Tue,  7 Dec 2021 14:57:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638889049;
        bh=XVfC6Mt/zr0VxOP5Qbta9UfypMNhMs2P/p4kDxCEEPc=;
        h=From:To:Cc:Subject:Date:From;
        b=D9zYfIRuEudRxcl9MlEKPB2p1W8TC8zLKFdWbr1Tf/lNX5b0fNnichW+hl/lOoANJ
         o1fx4mfiWDAYWZ0ZyGryVPGHUCJs4Hea7RmvhGaP6khuDKEE9ry0yW3BvDGh1qFsz6
         Zxk4LQQaHkOIjfN1W1n9ENLmfVGYl9v/Mws0UgzbMHN0fEjzLfRxhjz7WzoVokWhSQ
         SSXX/mq0KsLQb1TXGoRqTIhLN3pBCEK91DcsWLQpbSedLMLPvhDu7dBXtrVBdjSef0
         swDS7oQXV0x2R7wN/xdgT5xBe22ZwQhkUGzGDK9mvOSJBB2nFfxH9rVbHlHQDksk8v
         l4tOeJeaOfASw==
From:   Antoine Tenart <atenart@kernel.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Antoine Tenart <atenart@kernel.org>, alexander.duyck@gmail.com,
        netdev@vger.kernel.org
Subject: [PATCH net-next 0/2] net: track the queue count at unregistration
Date:   Tue,  7 Dec 2021 15:57:23 +0100
Message-Id: <20211207145725.352657-1-atenart@kernel.org>
X-Mailer: git-send-email 2.33.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

Those two patches allow to track the Rx and Tx queue count at
unregistration and help in detecting illegal addition of Tx queues after
unregister (a warning is added).

This follows discussions on the following thread,
https://lore.kernel.org/all/20211122162007.303623-1-atenart@kernel.org/T/

A patch fixing one issue linked to this was merged ealier,
https://lore.kernel.org/all/20211203101318.435618-1-atenart@kernel.org/T/

Thanks,
Antoine

Antoine Tenart (2):
  net-sysfs: update the queue counts in the unregistration path
  net-sysfs: warn if new queue objects are being created during device
    unregistration

 net/core/net-sysfs.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

-- 
2.33.1

