Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4EE671B1B5D
	for <lists+netdev@lfdr.de>; Tue, 21 Apr 2020 03:49:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726121AbgDUBtf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Apr 2020 21:49:35 -0400
Received: from mga17.intel.com ([192.55.52.151]:47086 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725958AbgDUBtf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 20 Apr 2020 21:49:35 -0400
IronPort-SDR: jJZQhULJuLs4j4p7bCtxMWZq+i+SirzLd2KF9ukWfQz1ycaLj160b7BRjwXzgLfm+pC0prIZaF
 Bk47kTaYw+qw==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Apr 2020 18:49:35 -0700
IronPort-SDR: /pClrDGIUSTi/yhcFYFOJDCKjqhPKe7c6oLLKJ32YTkTW09C3q40QWtqXfRJbzUShvBv3mlCjR
 mYMXeNRpcycA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,408,1580803200"; 
   d="scan'208";a="291449653"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.86])
  by orsmga008.jf.intel.com with ESMTP; 20 Apr 2020 18:49:34 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Jeff Kirsher <jeffrey.t.kirsher@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com
Subject: [net-next 0/4][pull request] 40GbE Intel Wired LAN Driver Updates 2020-04-20
Date:   Mon, 20 Apr 2020 18:49:28 -0700
Message-Id: <20200421014932.2743607-1-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.25.3
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This small series contains updates to i40e only.

Takashi Iwai, from SUSE, changes snprintf() to scnprintf() to avoid
potential buffer overflow.

Jesper Dangaard Brouer fixes code comments in the XDP code, which were a
cut and paste error.

Arkadiusz adds support for total port shutdown, which allows completely
shutdown the port on the link-down procedure by physically removing the
link from the port.

Todd adds a check to see if Max Frame Size (MFS) is set to an
unsupported value.

The following are changes since commit 82ebc889091a488b4dd95e682b3c3b889a50713c:
  qed: use true,false for bool variables
and are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/jkirsher/next-queue 40GbE

Arkadiusz Kubalewski (1):
  i40e: Add support for a new feature: Total Port Shutdown

Jesper Dangaard Brouer (1):
  i40e: trivial fixup of comments in i40e_xsk.c

Takashi Iwai (1):
  i40e: Use scnprintf() for avoiding potential buffer overflow

Todd Fujinaka (1):
  i40e: Add a check to see if MFS is set

 drivers/net/ethernet/intel/i40e/i40e.h        |   1 +
 .../net/ethernet/intel/i40e/i40e_ethtool.c    |   8 +
 drivers/net/ethernet/intel/i40e/i40e_main.c   | 158 ++++++++++++++----
 drivers/net/ethernet/intel/i40e/i40e_xsk.c    |   4 +-
 4 files changed, 135 insertions(+), 36 deletions(-)

-- 
2.25.3

