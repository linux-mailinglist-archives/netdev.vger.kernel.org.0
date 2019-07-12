Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A5F6266608
	for <lists+netdev@lfdr.de>; Fri, 12 Jul 2019 07:15:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725941AbfGLFPy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Jul 2019 01:15:54 -0400
Received: from f0-dek.dektech.com.au ([210.10.221.142]:37454 "EHLO
        mail.dektech.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725899AbfGLFPx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Jul 2019 01:15:53 -0400
Received: from localhost (localhost [127.0.0.1])
        by mail.dektech.com.au (Postfix) with ESMTP id 354F645FEC;
        Fri, 12 Jul 2019 15:15:50 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=dektech.com.au;
         h=x-mailer:message-id:date:date:subject:subject:from:from
        :received:received:received; s=mail_dkim; t=1562908550; bh=X/NiD
        9F4ca5btl8KKqmDa7eqU6izIOjkoSf62MF/nDc=; b=KlCklqw/6rQxRvAUSVXfX
        crjHa/GKb/koZ0wBY58+ZrOT4zEFBfts9qVli+vOze5p1+uz4lawIYEe+xhNuIb+
        pLYTx1fI5enByqKPHGssEDwfV7cLFJtlHe9EYkM162uV+yQru2vFLRpF11msrF02
        7OuSliSC/PuO9ICQEPpt4A=
X-Virus-Scanned: amavisd-new at dektech.com.au
Received: from mail.dektech.com.au ([127.0.0.1])
        by localhost (mail2.dektech.com.au [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id fZKVA7TvcXMs; Fri, 12 Jul 2019 15:15:50 +1000 (AEST)
Received: from mail.dektech.com.au (localhost [127.0.0.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.dektech.com.au (Postfix) with ESMTPS id 7B96946093;
        Fri, 12 Jul 2019 15:15:49 +1000 (AEST)
Received: from localhost.localdomain (unknown [14.161.14.188])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.dektech.com.au (Postfix) with ESMTPSA id 58D8E45FEC;
        Fri, 12 Jul 2019 15:15:47 +1000 (AEST)
From:   Tuong Lien <tuong.t.lien@dektech.com.au>
To:     davem@davemloft.net, jon.maloy@ericsson.com, maloy@donjonn.com,
        ying.xue@windriver.com, netdev@vger.kernel.org
Cc:     tipc-discussion@lists.sourceforge.net
Subject: [net-next 0/2] tipc: link changeover issues
Date:   Fri, 12 Jul 2019 12:15:35 +0700
Message-Id: <20190712051537.10826-1-tuong.t.lien@dektech.com.au>
X-Mailer: git-send-email 2.13.7
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch series is to resolve some issues found with the current link
changeover mechanism, it also includes an optimization for the link
synching.

Tuong Lien (2):
  tipc: optimize link synching mechanism
  tipc: fix changeover issues due to large packet

 net/tipc/link.c | 119 +++++++++++++++++++++++++++++++++++++++++++++++++-------
 net/tipc/msg.c  |  59 ++++++++++++++++++++++++++++
 net/tipc/msg.h  |  28 ++++++++++++-
 net/tipc/node.c |   6 ++-
 net/tipc/node.h |   6 ++-
 5 files changed, 199 insertions(+), 19 deletions(-)

-- 
2.13.7

