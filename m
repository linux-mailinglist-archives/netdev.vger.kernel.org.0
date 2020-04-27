Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 11F0C1BB142
	for <lists+netdev@lfdr.de>; Tue, 28 Apr 2020 00:05:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726991AbgD0WFU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Apr 2020 18:05:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:47572 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726204AbgD0WB6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 27 Apr 2020 18:01:58 -0400
Received: from mail.kernel.org (ip5f5ad5c5.dynamic.kabel-deutschland.de [95.90.213.197])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 49E132082E;
        Mon, 27 Apr 2020 22:01:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588024916;
        bh=6hICUJOm73tC7mybOqnlsNRDxZD2tv+mEL2WRMC0A40=;
        h=From:To:Cc:Subject:Date:From;
        b=WYg28824GL3DwqDlANPhGsSSLnLCt+nOUarYdI+8iK8EnAlq74+LHuJNW6rd/NOH5
         oTUvcy5e4wOKxSC4GuXp+IABhcvwc1W2XSXkjunBIJ9G3botBuK/jslIHLS2Uid7wJ
         H5Wm1uLFOHUzoyYKgayq/3HfAxgkHCPKSiRuDjIs=
Received: from mchehab by mail.kernel.org with local (Exim 4.92.3)
        (envelope-from <mchehab@kernel.org>)
        id 1jTBp4-000Inf-FO; Tue, 28 Apr 2020 00:01:54 +0200
From:   Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
To:     Linux Doc Mailing List <linux-doc@vger.kernel.org>
Cc:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        netdev@vger.kernel.org, linux-hams@vger.kernel.org,
        intel-wired-lan@lists.osuosl.org,
        linux-decnet-user@lists.sourceforge.net,
        ceph-devel@vger.kernel.org, bpf@vger.kernel.org,
        linux-atm-general@lists.sourceforge.net, lvs-devel@vger.kernel.org
Subject: [PATCH 00/38] net: manually convert files to ReST format - part 1
Date:   Tue, 28 Apr 2020 00:01:15 +0200
Message-Id: <cover.1588024424.git.mchehab+huawei@kernel.org>
X-Mailer: git-send-email 2.25.4
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There are very few documents upstream that aren't converted upstream.

This series convert part of the networking text files into ReST.
It is part of a bigger set of patches, which were split on parts,
in order to make reviewing task easier.

The full series (including those ones) are at:

	https://git.linuxtv.org/mchehab/experimental.git/log/?h=net-docs

And the documents, converted to HTML via the building system
are at:

	https://www.infradead.org/~mchehab/kernel_docs/networking/


Mauro Carvalho Chehab (38):
  docs: networking: convert caif files to ReST
  docs: networking: convert 6pack.txt to ReST
  docs: networking: convert altera_tse.txt to ReST
  docs: networking: convert arcnet-hardware.txt to ReST
  docs: networking: convert arcnet.txt to ReST
  docs: networking: convert atm.txt to ReST
  docs: networking: convert ax25.txt to ReST
  docs: networking: convert baycom.txt to ReST
  docs: networking: convert bonding.txt to ReST
  docs: networking: convert cdc_mbim.txt to ReST
  docs: networking: convert cops.txt to ReST
  docs: networking: convert cxacru.txt to ReST
  docs: networking: convert dccp.txt to ReST
  docs: networking: convert dctcp.txt to ReST
  docs: networking: convert decnet.txt to ReST
  docs: networking: convert defza.txt to ReST
  docs: networking: convert dns_resolver.txt to ReST
  docs: networking: convert driver.txt to ReST
  docs: networking: convert eql.txt to ReST
  docs: networking: convert fib_trie.txt to ReST
  docs: networking: convert filter.txt to ReST
  docs: networking: convert fore200e.txt to ReST
  docs: networking: convert framerelay.txt to ReST
  docs: networking: convert generic-hdlc.txt to ReST
  docs: networking: convert generic_netlink.txt to ReST
  docs: networking: convert gen_stats.txt to ReST
  docs: networking: convert gtp.txt to ReST
  docs: networking: convert hinic.txt to ReST
  docs: networking: convert ila.txt to ReST
  docs: networking: convert ipddp.txt to ReST
  docs: networking: convert ip_dynaddr.txt to ReST
  docs: networking: convert iphase.txt to ReST
  docs: networking: convert ipsec.txt to ReST
  docs: networking: convert ip-sysctl.txt to ReST
  docs: networking: convert ipv6.txt to ReST
  docs: networking: convert ipvlan.txt to ReST
  docs: networking: convert ipvs-sysctl.txt to ReST
  docs: networking: convert kcm.txt to ReST

 .../admin-guide/kernel-parameters.txt         |   10 +-
 Documentation/admin-guide/sysctl/net.rst      |    4 +-
 Documentation/bpf/index.rst                   |    4 +-
 .../networking/{6pack.txt => 6pack.rst}       |   46 +-
 .../{altera_tse.txt => altera_tse.rst}        |   87 +-
 ...rcnet-hardware.txt => arcnet-hardware.rst} | 2169 +++++++++--------
 .../networking/{arcnet.txt => arcnet.rst}     |  348 +--
 Documentation/networking/{atm.txt => atm.rst} |    6 +
 .../networking/{ax25.txt => ax25.rst}         |    6 +
 .../networking/{baycom.txt => baycom.rst}     |  110 +-
 .../networking/{bonding.txt => bonding.rst}   | 1275 +++++-----
 Documentation/networking/caif/caif.rst        |    2 -
 Documentation/networking/caif/index.rst       |   13 +
 .../caif/{Linux-CAIF.txt => linux_caif.rst}   |   54 +-
 Documentation/networking/caif/spi_porting.rst |  229 ++
 Documentation/networking/caif/spi_porting.txt |  208 --
 .../networking/{cdc_mbim.txt => cdc_mbim.rst} |   76 +-
 Documentation/networking/cops.rst             |   80 +
 Documentation/networking/cops.txt             |   63 -
 .../networking/{cxacru.txt => cxacru.rst}     |   86 +-
 .../networking/{dccp.txt => dccp.rst}         |   39 +-
 .../networking/{dctcp.txt => dctcp.rst}       |   14 +-
 .../networking/{decnet.txt => decnet.rst}     |   77 +-
 .../networking/{defza.txt => defza.rst}       |    8 +-
 .../networking/device_drivers/intel/e100.rst  |    2 +-
 .../networking/device_drivers/intel/ixgb.rst  |    2 +-
 .../{dns_resolver.txt => dns_resolver.rst}    |   52 +-
 .../networking/{driver.txt => driver.rst}     |   22 +-
 Documentation/networking/{eql.txt => eql.rst} |  445 ++--
 .../networking/{fib_trie.txt => fib_trie.rst} |   16 +-
 .../networking/{filter.txt => filter.rst}     |  850 ++++---
 .../networking/{fore200e.txt => fore200e.rst} |    8 +-
 .../{framerelay.txt => framerelay.rst}        |   21 +-
 .../{gen_stats.txt => gen_stats.rst}          |   98 +-
 .../{generic-hdlc.txt => generic-hdlc.rst}    |   86 +-
 ...eneric_netlink.txt => generic_netlink.rst} |    6 +
 Documentation/networking/{gtp.txt => gtp.rst} |   95 +-
 .../networking/{hinic.txt => hinic.rst}       |    5 +-
 Documentation/networking/{ila.txt => ila.rst} |   81 +-
 Documentation/networking/index.rst            |   38 +
 .../{ip-sysctl.txt => ip-sysctl.rst}          |  829 ++++---
 .../{ip_dynaddr.txt => ip_dynaddr.rst}        |   29 +-
 .../networking/{ipddp.txt => ipddp.rst}       |   13 +-
 .../networking/{iphase.txt => iphase.rst}     |  185 +-
 .../networking/{ipsec.txt => ipsec.rst}       |   14 +-
 .../networking/{ipv6.txt => ipv6.rst}         |    8 +-
 .../networking/{ipvlan.txt => ipvlan.rst}     |  159 +-
 .../{ipvs-sysctl.txt => ipvs-sysctl.rst}      |  180 +-
 Documentation/networking/{kcm.txt => kcm.rst} |   83 +-
 Documentation/networking/ltpc.txt             |    2 +-
 Documentation/networking/packet_mmap.txt      |    2 +-
 Documentation/networking/snmp_counter.rst     |    2 +-
 MAINTAINERS                                   |    8 +-
 drivers/atm/Kconfig                           |    4 +-
 drivers/net/Kconfig                           |    4 +-
 drivers/net/appletalk/Kconfig                 |    6 +-
 drivers/net/arcnet/Kconfig                    |    6 +-
 drivers/net/caif/Kconfig                      |    2 +-
 drivers/net/hamradio/Kconfig                  |   10 +-
 drivers/net/wan/Kconfig                       |    4 +-
 net/Kconfig                                   |    2 +-
 net/atm/Kconfig                               |    2 +-
 net/ax25/Kconfig                              |    6 +-
 net/ceph/Kconfig                              |    2 +-
 net/core/gen_stats.c                          |    2 +-
 net/decnet/Kconfig                            |    4 +-
 net/dns_resolver/Kconfig                      |    2 +-
 net/dns_resolver/dns_key.c                    |    2 +-
 net/dns_resolver/dns_query.c                  |    2 +-
 net/ipv4/Kconfig                              |    2 +-
 net/ipv4/icmp.c                               |    2 +-
 net/ipv6/Kconfig                              |    2 +-
 tools/bpf/bpf_asm.c                           |    2 +-
 tools/bpf/bpf_dbg.c                           |    2 +-
 74 files changed, 4656 insertions(+), 3769 deletions(-)
 rename Documentation/networking/{6pack.txt => 6pack.rst} (90%)
 rename Documentation/networking/{altera_tse.txt => altera_tse.rst} (85%)
 rename Documentation/networking/{arcnet-hardware.txt => arcnet-hardware.rst} (66%)
 rename Documentation/networking/{arcnet.txt => arcnet.rst} (76%)
 rename Documentation/networking/{atm.txt => atm.rst} (89%)
 rename Documentation/networking/{ax25.txt => ax25.rst} (91%)
 rename Documentation/networking/{baycom.txt => baycom.rst} (58%)
 rename Documentation/networking/{bonding.txt => bonding.rst} (75%)
 create mode 100644 Documentation/networking/caif/index.rst
 rename Documentation/networking/caif/{Linux-CAIF.txt => linux_caif.rst} (90%)
 create mode 100644 Documentation/networking/caif/spi_porting.rst
 delete mode 100644 Documentation/networking/caif/spi_porting.txt
 rename Documentation/networking/{cdc_mbim.txt => cdc_mbim.rst} (88%)
 create mode 100644 Documentation/networking/cops.rst
 delete mode 100644 Documentation/networking/cops.txt
 rename Documentation/networking/{cxacru.txt => cxacru.rst} (66%)
 rename Documentation/networking/{dccp.txt => dccp.rst} (94%)
 rename Documentation/networking/{dctcp.txt => dctcp.rst} (89%)
 rename Documentation/networking/{decnet.txt => decnet.rst} (87%)
 rename Documentation/networking/{defza.txt => defza.rst} (91%)
 rename Documentation/networking/{dns_resolver.txt => dns_resolver.rst} (89%)
 rename Documentation/networking/{driver.txt => driver.rst} (85%)
 rename Documentation/networking/{eql.txt => eql.rst} (62%)
 rename Documentation/networking/{fib_trie.txt => fib_trie.rst} (96%)
 rename Documentation/networking/{filter.txt => filter.rst} (77%)
 rename Documentation/networking/{fore200e.txt => fore200e.rst} (94%)
 rename Documentation/networking/{framerelay.txt => framerelay.rst} (93%)
 rename Documentation/networking/{gen_stats.txt => gen_stats.rst} (60%)
 rename Documentation/networking/{generic-hdlc.txt => generic-hdlc.rst} (75%)
 rename Documentation/networking/{generic_netlink.txt => generic_netlink.rst} (64%)
 rename Documentation/networking/{gtp.txt => gtp.rst} (79%)
 rename Documentation/networking/{hinic.txt => hinic.rst} (97%)
 rename Documentation/networking/{ila.txt => ila.rst} (82%)
 rename Documentation/networking/{ip-sysctl.txt => ip-sysctl.rst} (83%)
 rename Documentation/networking/{ip_dynaddr.txt => ip_dynaddr.rst} (65%)
 rename Documentation/networking/{ipddp.txt => ipddp.rst} (89%)
 rename Documentation/networking/{iphase.txt => iphase.rst} (50%)
 rename Documentation/networking/{ipsec.txt => ipsec.rst} (90%)
 rename Documentation/networking/{ipv6.txt => ipv6.rst} (93%)
 rename Documentation/networking/{ipvlan.txt => ipvlan.rst} (54%)
 rename Documentation/networking/{ipvs-sysctl.txt => ipvs-sysctl.rst} (62%)
 rename Documentation/networking/{kcm.txt => kcm.rst} (84%)

-- 
2.25.4


