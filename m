Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0AF75298A20
	for <lists+netdev@lfdr.de>; Mon, 26 Oct 2020 11:15:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1769245AbgJZKOj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Oct 2020 06:14:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:42510 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1768386AbgJZJrn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 26 Oct 2020 05:47:43 -0400
Received: from mail.kernel.org (ip5f5ad5a1.dynamic.kabel-deutschland.de [95.90.213.161])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EED8420704;
        Mon, 26 Oct 2020 09:47:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603705663;
        bh=cm0DgYGOWrzWhAQoSMBRcvt64IJtdw58FGbr6XTCKpw=;
        h=From:To:Cc:Subject:Date:From;
        b=eVW0Kh9mJcqAGqXz7Tc5qsUNbIaIgFX/WeC+zatS7ooQ/8UicBHJZrmUAlCfzOi8Z
         Z3G9pE4WncM6z5lBJRPa0MaxWCbcMvUk/odUc8x8beaV9WUD43rG5a1Gz65xeeQio6
         y/a4IWfbub0GY/Z9+LwShaWH6G7ez+RfSXK9oIXs=
Received: from mchehab by mail.kernel.org with local (Exim 4.94)
        (envelope-from <mchehab@kernel.org>)
        id 1kWz6J-0030sz-Ke; Mon, 26 Oct 2020 10:47:39 +0100
From:   Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
To:     Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Mark Brown <broonie@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        "David S. Miller" <davem@davemloft.net>,
        "J. Bruce Fields" <bfields@fieldses.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrew Lunn <andrew@lunn.ch>, Andrii Nakryiko <andriin@fb.com>,
        Anna Schumaker <anna.schumaker@netapp.com>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        Chuck Lever <chuck.lever@oracle.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Florian Westphal <fw@strlen.de>,
        Guillaume Nault <gnault@redhat.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jiri Pirko <jiri@mellanox.com>,
        Martin Varghese <martin.varghese@nokia.com>,
        Maxim Mikityanskiy <maximmi@mellanox.com>,
        Miaohe Lin <linmiaohe@huawei.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Pravin B Shelar <pshelar@ovn.org>,
        Russell King <linux@armlinux.org.uk>,
        Sabrina Dubroca <sd@queasysnail.net>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Taehee Yoo <ap420073@gmail.com>,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Willem de Bruijn <willemb@google.com>,
        Yadu Kishore <kyk.segfault@gmail.com>,
        linux-nfs@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH RESEND 0/3] Fix wrong identifiers on kernel-doc markups
Date:   Mon, 26 Oct 2020 10:47:35 +0100
Message-Id: <cover.1603705472.git.mchehab+huawei@kernel.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: Mauro Carvalho Chehab <mchehab@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Mark/Jakub,

As you requested, I'm resending the three -net patches
from the /56 patch series I sent last Friday:

	[PATCH v3 00/56] Fix several bad kernel-doc markups

They fix a few kernel-doc markups that are using different
identifiers than the function/struct that they are actually
documenting.

This should help checking them via CI automation.

Regards,
Mauro

Mauro Carvalho Chehab (3):
  net: phy: fix kernel-doc markups
  net: datagram: fix some kernel-doc markups
  net: core: fix some kernel-doc markups

 drivers/net/phy/mdio_bus.c   |  2 +-
 drivers/net/phy/phy-c45.c    |  2 +-
 drivers/net/phy/phy.c        |  2 +-
 drivers/net/phy/phy_device.c |  2 +-
 drivers/net/phy/phylink.c    |  2 +-
 include/linux/netdevice.h    | 11 +++++++++--
 net/core/datagram.c          |  2 +-
 net/core/dev.c               |  4 ++--
 net/core/skbuff.c            |  2 +-
 net/ethernet/eth.c           |  6 +++---
 net/sunrpc/rpc_pipe.c        |  3 ++-
 11 files changed, 23 insertions(+), 15 deletions(-)

-- 
2.26.2


