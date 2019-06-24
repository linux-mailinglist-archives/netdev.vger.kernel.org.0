Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EF19351941
	for <lists+netdev@lfdr.de>; Mon, 24 Jun 2019 19:05:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731249AbfFXRFa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jun 2019 13:05:30 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36576 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726920AbfFXRFa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 24 Jun 2019 13:05:30 -0400
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 5D7653007149;
        Mon, 24 Jun 2019 17:05:30 +0000 (UTC)
Received: from renaissance-vector.mxp.redhat.com (unknown [10.32.181.34])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8E7B1600C0;
        Mon, 24 Jun 2019 17:05:29 +0000 (UTC)
From:   Andrea Claudi <aclaudi@redhat.com>
To:     netdev@vger.kernel.org
Cc:     stephen@networkplumber.org, dsahern@kernel.org
Subject: [PATCH iproute2 0/3] do not set IPv6-only options on IPv4 addresses
Date:   Mon, 24 Jun 2019 19:05:52 +0200
Message-Id: <cover.1561394228.git.aclaudi@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.41]); Mon, 24 Jun 2019 17:05:30 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

'home', 'nodad' and 'mngtmpaddr' options are IPv6-only, but
it is possible to set them on IPv4 addresses, too. This should
not be possible.

Fix this adding a check on the protocol family before setting
the flags, and exiting with invarg() on error.

Andrea Claudi (3):
  ip address: do not set nodad option for IPv4 addresses
  ip address: do not set home option for IPv4 addresses
  ip address: do not set mngtmpaddr option for IPv4 addresses

 ip/ipaddress.c | 15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

-- 
2.20.1

