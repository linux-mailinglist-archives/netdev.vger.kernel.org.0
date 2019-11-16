Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 092A8FECD6
	for <lists+netdev@lfdr.de>; Sat, 16 Nov 2019 16:14:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727787AbfKPPNw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 Nov 2019 10:13:52 -0500
Received: from smtp.uniroma2.it ([160.80.6.23]:54160 "EHLO smtp.uniroma2.it"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727123AbfKPPNw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 16 Nov 2019 10:13:52 -0500
Received: from localhost.localdomain ([160.80.103.126])
        by smtp-2015.uniroma2.it (8.14.4/8.14.4/Debian-8) with ESMTP id xAGF6Rd9011419
        (version=TLSv1/SSLv3 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Sat, 16 Nov 2019 16:06:27 +0100
From:   Andrea Mayer <andrea.mayer@uniroma2.it>
To:     "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Lebrun <dav.lebrun@gmail.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Andrea Mayer <andrea.mayer@uniroma2.it>
Subject: [net, 0/2] seg6: fixes to Segment Routing in IPv6
Date:   Sat, 16 Nov 2019 16:05:51 +0100
Message-Id: <20191116150553.17497-1-andrea.mayer@uniroma2.it>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: clamav-milter 0.100.0 at smtp-2015
X-Virus-Status: Clean
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patchset is divided in 2 patches and it introduces some fixes
to Segment Routing in IPv6, which are:

- in function get_srh() fix the srh pointer after calling
  pskb_may_pull();

- fix the skb->transport_header after calling decap_and_validate()
  function;

Any comments on the patchset are welcome.

Thanks.

Andrea Mayer (2):
  seg6: fix srh pointer in get_srh()
  seg6: fix skb transport_header after decap_and_validate()

 net/ipv6/seg6_local.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

-- 
2.20.1

