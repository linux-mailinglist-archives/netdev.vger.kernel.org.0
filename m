Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BBA701C3B55
	for <lists+netdev@lfdr.de>; Mon,  4 May 2020 15:34:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728174AbgEDNeC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 May 2020 09:34:02 -0400
Received: from mga04.intel.com ([192.55.52.120]:32040 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726913AbgEDNeB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 4 May 2020 09:34:01 -0400
IronPort-SDR: 5LO5AD5mClU3VLrGDAL4n7WaApGF4J1IUSdeytyTDgCSPqJwRw8UVhqI/Y2QRWEzeYOr1wnJQz
 v1k2I/q38zog==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 May 2020 06:34:01 -0700
IronPort-SDR: /tNFyZ8Vk9C0xZVz509jhPEnYCo/eyqBvY2yyFC0zqWIRZ5SccwPlxmUjKeBne/n+ma8132MUQ
 B0wO7PHB1xLw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,352,1583222400"; 
   d="scan'208";a="406478254"
Received: from mkarlsso-mobl.ger.corp.intel.com (HELO localhost.localdomain) ([10.249.47.50])
  by orsmga004.jf.intel.com with ESMTP; 04 May 2020 06:33:59 -0700
From:   Magnus Karlsson <magnus.karlsson@intel.com>
To:     magnus.karlsson@intel.com, bjorn.topel@intel.com, ast@kernel.org,
        daniel@iogearbox.net, netdev@vger.kernel.org,
        jonathan.lemon@gmail.com
Subject: [PATCH bpf-next 0/2] xsk: improve code readability
Date:   Mon,  4 May 2020 15:33:50 +0200
Message-Id: <1588599232-24897-1-git-send-email-magnus.karlsson@intel.com>
X-Mailer: git-send-email 2.7.4
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This small series improves xsk code readibility by renaming two
variables in the first patch and removing one struct member that there
is no reason to keep around in the second patch. Basically small
things that were found in other series but not fixed there for one or
the other reason.

Thanks: Magnus

Magnus Karlsson (2):
  xsk: change two variable names for increased clarity
  xsk: remove unnecessary member in xdp_umem

 include/net/xdp_sock.h |  5 ++---
 net/xdp/xdp_umem.c     | 21 ++++++++++-----------
 net/xdp/xsk.c          |  8 ++++----
 net/xdp/xsk_queue.c    |  4 ++--
 net/xdp/xsk_queue.h    |  8 ++++----
 5 files changed, 22 insertions(+), 24 deletions(-)

--
2.7.4
