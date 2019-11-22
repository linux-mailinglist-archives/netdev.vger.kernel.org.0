Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BD0F41075B8
	for <lists+netdev@lfdr.de>; Fri, 22 Nov 2019 17:24:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727187AbfKVQXw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Nov 2019 11:23:52 -0500
Received: from smtp.uniroma2.it ([160.80.6.23]:32845 "EHLO smtp.uniroma2.it"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726046AbfKVQXw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 22 Nov 2019 11:23:52 -0500
Received: from localhost.localdomain ([160.80.103.126])
        by smtp-2015.uniroma2.it (8.14.4/8.14.4/Debian-8) with ESMTP id xAMGN8QG031618
        (version=TLSv1/SSLv3 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Fri, 22 Nov 2019 17:23:08 +0100
From:   Andrea Mayer <andrea.mayer@uniroma2.it>
To:     "David S. Miller" <davem@davemloft.net>,
        Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Lebrun <dav.lebrun@gmail.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Andrea Mayer <andrea.mayer@uniroma2.it>
Subject: [net-next, v3 0/1] seg6: allow local packet processing for SRv6 End.DT6 behavior
Date:   Fri, 22 Nov 2019 17:22:41 +0100
Message-Id: <20191122162242.2574-1-andrea.mayer@uniroma2.it>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: clamav-milter 0.100.0 at smtp-2015
X-Virus-Status: Clean
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

v2 changes:
 - change local_delivery type from int to bool in
   seg6_lookup_any_nexthop().

v3 changes:
 - remove inline keyword from seg6_lookup_nexthop().

Andrea Mayer (1):
  seg6: allow local packet processing for SRv6 End.DT6 behavior

 net/ipv6/seg6_local.c | 22 ++++++++++++++++++----
 1 file changed, 18 insertions(+), 4 deletions(-)

-- 
2.20.1

