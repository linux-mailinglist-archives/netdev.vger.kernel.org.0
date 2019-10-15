Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D75F0D718C
	for <lists+netdev@lfdr.de>; Tue, 15 Oct 2019 10:49:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727561AbfJOItx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Oct 2019 04:49:53 -0400
Received: from mga03.intel.com ([134.134.136.65]:54161 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726775AbfJOItx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 15 Oct 2019 04:49:53 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga103.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 15 Oct 2019 01:49:52 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.67,298,1566889200"; 
   d="scan'208";a="396741080"
Received: from lkp-server01.sh.intel.com (HELO lkp-server01) ([10.239.97.150])
  by fmsmga006.fm.intel.com with ESMTP; 15 Oct 2019 01:49:50 -0700
Received: from kbuild by lkp-server01 with local (Exim 4.89)
        (envelope-from <lkp@intel.com>)
        id 1iKIWb-000E3c-MT; Tue, 15 Oct 2019 16:49:49 +0800
Date:   Tue, 15 Oct 2019 16:48:48 +0800
From:   kbuild test robot <lkp@intel.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     kbuild-all@lists.01.org, netfilter-devel@vger.kernel.org,
        davem@davemloft.net, netdev@vger.kernel.org,
        jakub.kicinski@netronome.com, jiri@resnulli.us,
        saeedm@mellanox.com, vishal@chelsio.com, vladbu@mellanox.com,
        ecree@solarflare.com
Subject: [RFC PATCH] net: flow_offload: tc_proto_udp_hdr[] can be static
Message-ID: <20191015084848.iqcyexo5ub3l27ce@332d0cec05f4>
References: <20191014221051.8084-4-pablo@netfilter.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191014221051.8084-4-pablo@netfilter.org>
X-Patchwork-Hint: ignore
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Fixes: 0f2458c9ef75 ("net: flow_offload: mangle action at byte level")
Signed-off-by: kbuild test robot <lkp@intel.com>
---
 cls_api.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/sched/cls_api.c b/net/sched/cls_api.c
index 1898ce3ce5ecc..a58934997632c 100644
--- a/net/sched/cls_api.c
+++ b/net/sched/cls_api.c
@@ -3393,7 +3393,7 @@ static struct tc_proto_hdr_field tc_proto_tcp_hdr[] = {
 	TC_PROTO_HDR_FIELD_END
 };
 
-struct tc_proto_hdr_field tc_proto_udp_hdr[] = {
+static struct tc_proto_hdr_field tc_proto_udp_hdr[] = {
 	{ .offset = offsetof(struct udphdr, source),    .len = 2, },
 	{ .offset = offsetof(struct udphdr, dest),      .len = 2, },
 	{ .offset = offsetof(struct udphdr, len),       .len = 2, },
