Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1E9F915478C
	for <lists+netdev@lfdr.de>; Thu,  6 Feb 2020 16:18:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727790AbgBFPSY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Feb 2020 10:18:24 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:38224 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727641AbgBFPSB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Feb 2020 10:18:01 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Sender:Content-Transfer-Encoding:
        MIME-Version:Message-Id:Date:Subject:Cc:To:From:Reply-To:Content-Type:
        Content-ID:Content-Description:In-Reply-To:References;
        bh=eNDq33QOomCijKEVn1Z9oPH66Mc+mguHW+VeL5pLAhc=; b=So8I9geR14GrGuO9lA9c6sXiEo
        7Ws15T/LX0KmsnmzEPlAAEj23x41YzqKtxcygM1Xqa3cte8wLkTcHLT/w0P+Mx8wvk79NQg2iSCJ6
        fctuWwiTO348VpvHZBgzU9iqP9XQIh1Ohc78Tr+kj7Mm0cbBOWXGEsDO6B0PgI+o+1yyscaCOyL/A
        8AD1Iv7rkKa0ycgY8nsAEugIElBxYwhWE91OCEI+owntY79wPXGI++GaM9OCtOmkpd9Nn8rpu7QfJ
        72YqQZf8OZZXxyX88DBgxCoA76E6oyjzgcVYxeEFOzHXAyBfkpM9+mA0BT54q/c9g0dxFRCiSzrqF
        UHHHAhNA==;
Received: from [179.95.15.160] (helo=bombadil.infradead.org)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iziul-0005jA-Al; Thu, 06 Feb 2020 15:17:59 +0000
Received: from mchehab by bombadil.infradead.org with local (Exim 4.92.3)
        (envelope-from <mchehab@bombadil.infradead.org>)
        id 1iziuc-002oUk-B9; Thu, 06 Feb 2020 16:17:50 +0100
From:   Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
To:     Linux Media Mailing List <linux-media@vger.kernel.org>
Cc:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Alexander Aring <alex.aring@gmail.com>,
        linux-doc@vger.kernel.org, Yonghong Song <yhs@fb.com>,
        Jukka Rissanen <jukka.rissanen@linux.intel.com>,
        netdev@vger.kernel.org, Martin KaFai Lau <kafai@fb.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        linux-wpan@vger.kernel.org, Song Liu <songliubraving@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jonathan Corbet <corbet@lwn.net>, bpf@vger.kernel.org,
        linux-decnet-user@lists.sourceforge.net,
        Daniel Borkmann <daniel@iogearbox.net>,
        linux-bluetooth@vger.kernel.org
Subject: [PATCH 00/28] Manually convert network text files to ReST (part 1)
Date:   Thu,  6 Feb 2020 16:17:20 +0100
Message-Id: <cover.1581002062.git.mchehab+huawei@kernel.org>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Manually convert Documentation/networking text files to ReST.

As there are lots of unconverted files there, I have ~120 patches.
So, I'll split the conversion into 4 parts. This is the first patch.

Mauro Carvalho Chehab (28):
  docs: networking: caif: convert to ReST
  docs: networking: convert 6lowpan.txt to ReST
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

 .../networking/{6lowpan.txt => 6lowpan.rst}   |   29 +-
 .../networking/{6pack.txt => 6pack.rst}       |   46 +-
 .../{altera_tse.txt => altera_tse.rst}        |   87 +-
 ...rcnet-hardware.txt => arcnet-hardware.rst} | 2169 +++++++++--------
 .../networking/{arcnet.txt => arcnet.rst}     |  348 +--
 Documentation/networking/{atm.txt => atm.rst} |    6 +
 .../networking/{ax25.txt => ax25.rst}         |    6 +
 .../networking/{baycom.txt => baycom.rst}     |  110 +-
 .../networking/{bonding.txt => bonding.rst}   | 1273 +++++-----
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
 Documentation/networking/index.rst            |   28 +
 34 files changed, 3610 insertions(+), 3140 deletions(-)
 rename Documentation/networking/{6lowpan.txt => 6lowpan.rst} (64%)
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

-- 
2.24.1


