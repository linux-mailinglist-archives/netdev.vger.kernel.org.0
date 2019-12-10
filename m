Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 33AA0118218
	for <lists+netdev@lfdr.de>; Tue, 10 Dec 2019 09:21:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726932AbfLJIVR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Dec 2019 03:21:17 -0500
Received: from f0-dek.dektech.com.au ([210.10.221.142]:32991 "EHLO
        mail.dektech.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726801AbfLJIVR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Dec 2019 03:21:17 -0500
Received: from localhost (localhost [127.0.0.1])
        by mail.dektech.com.au (Postfix) with ESMTP id F021A4BCC3;
        Tue, 10 Dec 2019 19:21:13 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=dektech.com.au;
         h=x-mailer:message-id:date:date:subject:subject:from:from
        :received:received:received; s=mail_dkim; t=1575966073; bh=1vuNe
        rE+k9EukVY3g6hOMdTK4G8oAOgyiE9jpskmwvA=; b=Hb23cPrnsDkAQ7kkKotVa
        S+UDiWAq5CQsPM+hhgYw/lvb6lGHbalXGdCPd/Hhylc3HF/9MnfwRVaqyxrP/VOo
        pXvDrGyTdWsEC01cYSfgc1uxCvHF0rTzaAOZ7HWL0hN7cyxayqjrqL4x2YRajOSj
        yyeu0Vr9SGsn3gDtJT4WzE=
X-Virus-Scanned: amavisd-new at dektech.com.au
Received: from mail.dektech.com.au ([127.0.0.1])
        by localhost (mail2.dektech.com.au [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id ZIH2K8AhdaPV; Tue, 10 Dec 2019 19:21:13 +1100 (AEDT)
Received: from mail.dektech.com.au (localhost [127.0.0.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.dektech.com.au (Postfix) with ESMTPS id 5D7914BD36;
        Tue, 10 Dec 2019 19:21:13 +1100 (AEDT)
Received: from localhost.localdomain (unknown [14.161.14.188])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.dektech.com.au (Postfix) with ESMTPSA id 037ED4BCC3;
        Tue, 10 Dec 2019 19:21:11 +1100 (AEDT)
From:   Tuong Lien <tuong.t.lien@dektech.com.au>
To:     davem@davemloft.net, jon.maloy@ericsson.com, maloy@donjonn.com,
        ying.xue@windriver.com, netdev@vger.kernel.org
Cc:     tipc-discussion@lists.sourceforge.net
Subject: [net 0/4] tipc: fix some issues
Date:   Tue, 10 Dec 2019 15:21:01 +0700
Message-Id: <20191210082105.23905-1-tuong.t.lien@dektech.com.au>
X-Mailer: git-send-email 2.13.7
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series consists of some bug-fixes for TIPC.

Tuong Lien (4):
  tipc: fix name table rbtree issues
  tipc: fix potential hanging after b/rcast changing
  tipc: fix retrans failure due to wrong destination
  tipc: fix use-after-free in tipc_disc_rcv()

 net/tipc/bcast.c      |  24 +++--
 net/tipc/discover.c   |   6 +-
 net/tipc/name_table.c | 279 ++++++++++++++++++++++++++++++++------------------
 net/tipc/socket.c     |  32 +++---
 4 files changed, 215 insertions(+), 126 deletions(-)

-- 
2.13.7

