Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 846E8FB922
	for <lists+netdev@lfdr.de>; Wed, 13 Nov 2019 20:48:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726418AbfKMTsA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Nov 2019 14:48:00 -0500
Received: from smtp.uniroma2.it ([160.80.6.16]:57695 "EHLO smtp.uniroma2.it"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726105AbfKMTr7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 13 Nov 2019 14:47:59 -0500
X-Greylist: delayed 1019 seconds by postgrey-1.27 at vger.kernel.org; Wed, 13 Nov 2019 14:47:58 EST
Received: from localhost.localdomain ([160.80.103.126])
        by smtp-2015.uniroma2.it (8.14.4/8.14.4/Debian-8) with ESMTP id xADJTimk023525
        (version=TLSv1/SSLv3 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 13 Nov 2019 20:29:49 +0100
From:   Andrea Mayer <andrea.mayer@uniroma2.it>
To:     "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Lebrun <dav.lebrun@gmail.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Andrea Mayer <andrea.mayer@uniroma2.it>
Subject: [net-next, 0/3] seg6: improvements to Segment Routing in IPv6
Date:   Wed, 13 Nov 2019 20:29:09 +0100
Message-Id: <20191113192912.17546-1-andrea.mayer@uniroma2.it>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: clamav-milter 0.100.0 at smtp-2015
X-Virus-Status: Clean
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patchset is divided in 3 patches and it introduces some improvements
to Segment Routing in IPv6, which are:

- in function get_srh() verify the srh pointer after calling
  pskb_may_pull();

- set skb->transport_header properly after calling decap_and_validate()
  function;

- allow local packet processing for SRv6 End.DT6 behavior.

Any comments on the patchset are welcome.

Thanks.


Andrea Mayer (3):
  verify srh pointer in get_srh()
  set skb transport_header properly after decap_and_validate()
  allow local packet processing for SRv6 End.DT6 behavior

 net/ipv6/seg6_local.c | 34 +++++++++++++++++++++++++++++-----
 1 file changed, 29 insertions(+), 5 deletions(-)

-- 
2.20.1

