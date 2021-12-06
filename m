Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5DA2A46AA6C
	for <lists+netdev@lfdr.de>; Mon,  6 Dec 2021 22:27:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352678AbhLFVaj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Dec 2021 16:30:39 -0500
Received: from serv108.segi.ulg.ac.be ([139.165.32.111]:52562 "EHLO
        serv108.segi.ulg.ac.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351997AbhLFVag (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Dec 2021 16:30:36 -0500
Received: from localhost.localdomain (148.24-240-81.adsl-dyn.isp.belgacom.be [81.240.24.148])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by serv108.segi.ulg.ac.be (Postfix) with ESMTPSA id 06663200CD04;
        Mon,  6 Dec 2021 22:18:15 +0100 (CET)
DKIM-Filter: OpenDKIM Filter v2.11.0 serv108.segi.ulg.ac.be 06663200CD04
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uliege.be;
        s=ulg20190529; t=1638825495;
        bh=KXvPk7LxCtUj/vU1Z2WRiCkySD2XF57wWZknRzxB4rM=;
        h=From:To:Cc:Subject:Date:From;
        b=mEKoh9Dn0/t5vR9tQWMSJ/KWO5OBrTCN6UxMw0DZUDEoi0BHaCIzJMqKgL7i9rjjO
         Cjko/u3DkHIFOqiSb7SWqxmSNrnSizCpu2ErD5+73HKzVE9Kod1eXpPK3/QTHAvUeL
         AlKJSJoWbvQiQWRuW86DHPqYNJFANkC0fS3VDPsVrPV6H7dHEeKnw7EIF48tco1pW7
         hXzydEx5wf4dqzZltRpXeaJJPVF1DLPVDF8wZZmT9HvDWTGg3rPoQgFvMlKTpvPqgP
         QSAUPbUkFA/igAsZsBzF+1J4Rvy07RB9up3AcYNvcwOIpnG9JYZ1j/dTcUGx+YaKt1
         47yMxocSjOdRA==
From:   Justin Iurman <justin.iurman@uliege.be>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, dsahern@kernel.org,
        yoshfuji@linux-ipv6.org, linux-mm@kvack.org, cl@linux.com,
        penberg@kernel.org, rientjes@google.com, iamjoonsoo.kim@lge.com,
        akpm@linux-foundation.org, vbabka@suse.cz, justin.iurman@uliege.be
Subject: [RFC net-next 0/2] IOAM queue depth and buffer occupancy
Date:   Mon,  6 Dec 2021 22:17:56 +0100
Message-Id: <20211206211758.19057-1-justin.iurman@uliege.be>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Request for comments on this solution to add support for two IOAM trace
data fields, i.e., queue depth and buffer occupancy. CC'ing mm people
for patch #2. See commit messages for more details.

Justin Iurman (2):
  ipv6: ioam: Support for Queue depth data field
  ipv6: ioam: Support for Buffer occupancy data field

 include/linux/slab.h | 15 +++++++++++++++
 mm/slab.h            | 14 --------------
 net/ipv6/ioam6.c     | 27 +++++++++++++++++++++++++--
 3 files changed, 40 insertions(+), 16 deletions(-)

-- 
2.25.1

