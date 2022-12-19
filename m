Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F033C650ED3
	for <lists+netdev@lfdr.de>; Mon, 19 Dec 2022 16:42:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232336AbiLSPm1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Dec 2022 10:42:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232283AbiLSPmZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Dec 2022 10:42:25 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E58C712083;
        Mon, 19 Dec 2022 07:42:24 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 822D661019;
        Mon, 19 Dec 2022 15:42:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B584C433D2;
        Mon, 19 Dec 2022 15:42:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671464544;
        bh=Mko/GoxpYbPQ1yT5G9uVYi0KpQ+vihSNa+XLZtA91z0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DWak3xIi05AKzNtr1WWLLzc+peZ8xZpm6TTgUPSynIjojSoqR750nA616UErlxrMB
         29TTfEliPDLOb7UCT3DByW05KD308TRJKkoEPjTDIn5ZQFVYBNO7H/ldmle9XprNN9
         YXNt6Qg4iIfJYRUTNdMEug0O29qAdHhhWjOs/c8sWrw/3uSyWcpvrWI17b8RW7BGP7
         +nKefQxLm27DzZ+6CP6oV37Oim4bgzJYXAmDSHisW9EyKbhDkgqF7SYlMnKJGyWmd7
         x0kmPXr6uNH1swEFCcqK0Ghvw+EojYHQcDJPu/sCuLGetZ+Mrv9hbGByNzFVHFMgNP
         sEZ+khaXZzPaQ==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, davem@davemloft.net, kuba@kernel.org,
        hawk@kernel.org, pabeni@redhat.com, edumazet@google.com,
        toke@redhat.com, memxor@gmail.com, alardam@gmail.com,
        saeedm@nvidia.com, anthony.l.nguyen@intel.com, gospo@broadcom.com,
        vladimir.oltean@nxp.com, nbd@nbd.name, john@phrozen.org,
        leon@kernel.org, simon.horman@corigine.com, aelior@marvell.com,
        christophe.jaillet@wanadoo.fr, ecree.xilinx@gmail.com,
        grygorii.strashko@ti.com, mst@redhat.com, bjorn@kernel.org,
        magnus.karlsson@intel.com, maciej.fijalkowski@intel.com,
        intel-wired-lan@lists.osuosl.org, lorenzo.bianconi@redhat.com
Subject: [RFC bpf-next 1/8] tools: uapi: align if_link.h
Date:   Mon, 19 Dec 2022 16:41:30 +0100
Message-Id: <ad8a0debd10ef5a2edcbfc202ae439af4cb1b718.1671462950.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <cover.1671462950.git.lorenzo@kernel.org>
References: <cover.1671462950.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Align IFLA enum definitions in tools/include/uapi/linux/if_link.h to
include/uapi/linux/if_link.h after the following commits:
- '7e6e1b57162e ("rtnetlink: advertise allmulti counter")'
- 'dca56c3038c3 ("net: expose devlink port over rtnetlink")'

Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 tools/include/uapi/linux/if_link.h | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/tools/include/uapi/linux/if_link.h b/tools/include/uapi/linux/if_link.h
index 901d98b865a1..82fe18f26db5 100644
--- a/tools/include/uapi/linux/if_link.h
+++ b/tools/include/uapi/linux/if_link.h
@@ -350,6 +350,9 @@ enum {
 	IFLA_GRO_MAX_SIZE,
 	IFLA_TSO_MAX_SIZE,
 	IFLA_TSO_MAX_SEGS,
+	IFLA_ALLMULTI,		/* Allmulti count: > 0 means acts ALLMULTI */
+
+	IFLA_DEVLINK_PORT,
 
 	__IFLA_MAX
 };
-- 
2.38.1

