Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 084B76369C
	for <lists+netdev@lfdr.de>; Tue,  9 Jul 2019 15:16:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726930AbfGINQJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Jul 2019 09:16:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:50680 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726820AbfGINQJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 9 Jul 2019 09:16:09 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 12C768553A;
        Tue,  9 Jul 2019 13:16:04 +0000 (UTC)
Received: from renaissance-vector.mxp.redhat.com (unknown [10.32.181.34])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3628B86E17;
        Tue,  9 Jul 2019 13:16:02 +0000 (UTC)
From:   Andrea Claudi <aclaudi@redhat.com>
To:     netdev@vger.kernel.org
Cc:     stephen@networkplumber.org, dsahern@kernel.org
Subject: [PATCH iproute2 0/2] Fix IPv6 tunnel add when dev param is used
Date:   Tue,  9 Jul 2019 15:16:49 +0200
Message-Id: <cover.1562667648.git.aclaudi@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.28]); Tue, 09 Jul 2019 13:16:09 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit ba126dcad20e6 ("ip6tunnel: fix 'ip -6 {show|change} dev
<name>' cmds") breaks IPv6 tunnel creation when dev parameter
is used.

This series revert the original commit, which mistakenly use
dev for tunnel name, while addressing a issue on tunnel change
when no interface name is specified.

Andrea Claudi (2):
  Revert "ip6tunnel: fix 'ip -6 {show|change} dev <name>' cmds"
  ip tunnel: warn when changing IPv6 tunnel without tunnel name

 ip/ip6tunnel.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

-- 
2.20.1

