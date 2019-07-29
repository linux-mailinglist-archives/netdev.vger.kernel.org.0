Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BBEA178B91
	for <lists+netdev@lfdr.de>; Mon, 29 Jul 2019 14:16:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727644AbfG2MQp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jul 2019 08:16:45 -0400
Received: from mx1.redhat.com ([209.132.183.28]:62911 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726818AbfG2MQo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 29 Jul 2019 08:16:44 -0400
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id A4796C049E12;
        Mon, 29 Jul 2019 12:16:44 +0000 (UTC)
Received: from [192.168.42.247] (ovpn-200-29.brq.redhat.com [10.40.200.29])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5FE266012A;
        Mon, 29 Jul 2019 12:16:39 +0000 (UTC)
Subject: [PATCH net-next] MAINTAINERS: Remove mailing-list entry for XDP
 (eXpress Data Path)
From:   Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     Jesper Dangaard Brouer <brouer@redhat.com>,
        xdp-newbies@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        davem@davemloft.net, jakub.kicinski@netronome.com,
        john.fastabend@gmail.com
Date:   Mon, 29 Jul 2019 14:16:37 +0200
Message-ID: <156440259790.6123.1563221733550893420.stgit@carbon>
User-Agent: StGit/unknown-version
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.31]); Mon, 29 Jul 2019 12:16:44 +0000 (UTC)
To:     unlisted-recipients:; (no To-header on input)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This removes the mailing list xdp-newbies@vger.kernel.org from the XDP
kernel maintainers entry.

Being in the kernel MAINTAINERS file successfully caused the list to
receive kbuild bot warnings, syzbot reports and sometimes developer
patches. The level of details in these messages, doesn't match the
target audience of the XDP-newbies list. This is based on a survey on
the mailing list, where 73% voted for removal from MAINTAINERS file.

Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
---
 MAINTAINERS |    1 -
 1 file changed, 1 deletion(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 9cc156c58f0c..45cb4237eddc 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -17560,7 +17560,6 @@ M:	Jakub Kicinski <jakub.kicinski@netronome.com>
 M:	Jesper Dangaard Brouer <hawk@kernel.org>
 M:	John Fastabend <john.fastabend@gmail.com>
 L:	netdev@vger.kernel.org
-L:	xdp-newbies@vger.kernel.org
 L:	bpf@vger.kernel.org
 S:	Supported
 F:	net/core/xdp.c

