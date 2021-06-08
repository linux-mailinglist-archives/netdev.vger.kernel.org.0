Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1717839F460
	for <lists+netdev@lfdr.de>; Tue,  8 Jun 2021 12:56:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231777AbhFHK5t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Jun 2021 06:57:49 -0400
Received: from smtp.uniroma2.it ([160.80.6.16]:48259 "EHLO smtp.uniroma2.it"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231608AbhFHK5s (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 8 Jun 2021 06:57:48 -0400
X-Greylist: delayed 873 seconds by postgrey-1.27 at vger.kernel.org; Tue, 08 Jun 2021 06:57:46 EDT
Received: from localhost.localdomain ([160.80.103.126])
        by smtp-2015.uniroma2.it (8.14.4/8.14.4/Debian-8) with ESMTP id 158Aelop017313
        (version=TLSv1/SSLv3 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 8 Jun 2021 12:40:47 +0200
From:   Andrea Mayer <andrea.mayer@uniroma2.it>
To:     "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Shuah Khan <shuah@kernel.org>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-kselftest@vger.kernel.org
Cc:     Stefano Salsano <stefano.salsano@uniroma2.it>,
        Paolo Lungaroni <paolo.lungaroni@uniroma2.it>,
        Ahmed Abdelsalam <ahabdels.dev@gmail.com>,
        Andrea Mayer <andrea.mayer@uniroma2.it>
Subject: [RFC net-next 0/2] seg6: add support for SRv6 End.DT46 Behavior
Date:   Tue,  8 Jun 2021 12:40:15 +0200
Message-Id: <20210608104017.21181-1-andrea.mayer@uniroma2.it>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: clamav-milter 0.100.0 at smtp-2015
X-Virus-Status: Clean
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SRv6 End.DT46 Behavior is defined in the IETF RFC 8986 [1] along with SRv6
End.DT4 and End.DT6 Behaviors.

The proposed End.DT46 implementation is meant to support the decapsulation
of both IPv4 and IPv6 traffic coming from a *single* SRv6 tunnel.
The SRv6 End.DT46 Behavior greatly simplifies the setup and operations of
SRv6 VPNs in the Linux kernel. 

 - patch 1/2 is the core patch that adds support for the SRv6 End.DT46
   Behavior;

 - patch 2/2 adds the selftest for SRv6 End.DT46 Behavior.


The patch introducing the new SRv6 End.DT46 Behavior in iproute2 will
follow shortly.

Comments, suggestions and improvements are very welcome as always!

Thanks,
Andrea

[1] https://www.rfc-editor.org/rfc/rfc8986.html#name-enddt46-decapsulation-and-s

Andrea Mayer (2):
  seg6: add support for SRv6 End.DT46 Behavior
  selftests: seg6: add selftest for SRv6 End.DT46 Behavior

 include/uapi/linux/seg6_local.h               |   2 +
 net/ipv6/seg6_local.c                         |  94 ++-
 .../selftests/net/srv6_end_dt46_l3vpn_test.sh | 573 ++++++++++++++++++
 3 files changed, 647 insertions(+), 22 deletions(-)
 create mode 100755 tools/testing/selftests/net/srv6_end_dt46_l3vpn_test.sh

-- 
2.20.1

