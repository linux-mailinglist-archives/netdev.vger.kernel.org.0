Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4DAC152984
	for <lists+netdev@lfdr.de>; Tue, 25 Jun 2019 12:30:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727040AbfFYKaE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jun 2019 06:30:04 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39916 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732007AbfFYK3u (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 25 Jun 2019 06:29:50 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id B4E0AC0586C1;
        Tue, 25 Jun 2019 10:29:50 +0000 (UTC)
Received: from renaissance-vector.mxp.redhat.com (unknown [10.32.181.34])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D36DE5C234;
        Tue, 25 Jun 2019 10:29:49 +0000 (UTC)
From:   Andrea Claudi <aclaudi@redhat.com>
To:     netdev@vger.kernel.org
Cc:     stephen@networkplumber.org, dsahern@kernel.org
Subject: [PATCH iproute2 v2 0/3] do not set IPv6-only options on IPv4 addresses
Date:   Tue, 25 Jun 2019 12:29:54 +0200
Message-Id: <cover.1561457597.git.aclaudi@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.31]); Tue, 25 Jun 2019 10:29:50 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

'home', 'nodad' and 'mngtmpaddr' options are IPv6-only, but
it is possible to set them on IPv4 addresses, too. This should
not be possible.

Fix this adding a check on the protocol family before setting
the flags, and print warning messages on error to not break
existing scripted setups.

Andrea Claudi (3):
  ip address: do not set nodad option for IPv4 addresses
  ip address: do not set home option for IPv4 addresses
  ip address: do not set mngtmpaddr option for IPv4 addresses

 ip/ipaddress.c | 15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

-- 
2.20.1

