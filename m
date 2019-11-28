Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D61F410C2CC
	for <lists+netdev@lfdr.de>; Thu, 28 Nov 2019 04:24:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727212AbfK1DYO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Nov 2019 22:24:14 -0500
Received: from f0-dek.dektech.com.au ([210.10.221.142]:32823 "EHLO
        mail.dektech.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727150AbfK1DYO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Nov 2019 22:24:14 -0500
Received: from localhost (localhost [127.0.0.1])
        by mail.dektech.com.au (Postfix) with ESMTP id 0B1014B9CC;
        Thu, 28 Nov 2019 14:10:11 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=dektech.com.au;
         h=x-mailer:message-id:date:date:subject:subject:from:from
        :received:received:received; s=mail_dkim; t=1574910610; bh=ILROK
        FXzc2kko4qLFI5h2rhv0uCmpypo++wMgubVIVg=; b=YIadP5j9eHDLjPqtBzXG4
        pc9D02ddpLb4pN88kFJ8e4pkLZbh0J/2YLYpdfdyXXm+h+E2M5G86mY7q6FSHvoR
        +6IjzlQ7QMM49HpEwD8n5ogVJ5RqL9tIE4pizTl9R9BNhNgWACs+i30JuXhQgddc
        c04Q/bRYm6FYg2DWD1DRHM=
X-Virus-Scanned: amavisd-new at dektech.com.au
Received: from mail.dektech.com.au ([127.0.0.1])
        by localhost (mail2.dektech.com.au [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id vIJf6DnFcIQf; Thu, 28 Nov 2019 14:10:10 +1100 (AEDT)
Received: from mail.dektech.com.au (localhost [127.0.0.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.dektech.com.au (Postfix) with ESMTPS id D93AE4B9CE;
        Thu, 28 Nov 2019 14:10:10 +1100 (AEDT)
Received: from ubuntu.dek-tpc.internal (unknown [14.161.14.188])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.dektech.com.au (Postfix) with ESMTPSA id 0B3B74B9CC;
        Thu, 28 Nov 2019 14:10:09 +1100 (AEDT)
From:   Tung Nguyen <tung.q.nguyen@dektech.com.au>
To:     davem@davemloft.net, netdev@vger.kernel.org,
        tipc-discussion@lists.sourceforge.net
Subject: [tipc-discussion] [net v1 0/4] Fix some bugs at socket layer
Date:   Thu, 28 Nov 2019 10:10:04 +0700
Message-Id: <20191128031008.2045-1-tung.q.nguyen@dektech.com.au>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series fixes some bugs at socket layer.

Tung Nguyen (4):
  tipc: fix potential memory leak in __tipc_sendmsg()
  tipc: fix wrong socket reference counter after tipc_sk_timeout()
    returns
  tipc: fix wrong timeout input for tipc_wait_for_cond()
  tipc: fix duplicate SYN messages under link congestion

 net/tipc/socket.c | 24 +++++++++++++++---------
 1 file changed, 15 insertions(+), 9 deletions(-)

-- 
2.17.1

