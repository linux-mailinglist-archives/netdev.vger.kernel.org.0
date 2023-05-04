Return-Path: <netdev+bounces-248-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AA0466F65CB
	for <lists+netdev@lfdr.de>; Thu,  4 May 2023 09:34:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E2D271C20F65
	for <lists+netdev@lfdr.de>; Thu,  4 May 2023 07:34:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4461A186A;
	Thu,  4 May 2023 07:34:07 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A1EAEA6
	for <netdev@vger.kernel.org>; Thu,  4 May 2023 07:34:07 +0000 (UTC)
X-Greylist: delayed 361 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 04 May 2023 00:34:06 PDT
Received: from mint-fitpc2.localdomain (unknown [81.168.73.77])
	by lindbergh.monkeyblade.net (Postfix) with ESMTP id 3D4C52116
	for <netdev@vger.kernel.org>; Thu,  4 May 2023 00:34:05 -0700 (PDT)
Received: from palantir17.mph.net (palantir17 [192.168.0.4])
	by mint-fitpc2.localdomain (Postfix) with ESMTP id 127C132234C;
	Thu,  4 May 2023 08:28:02 +0100 (BST)
Received: from localhost ([::1] helo=palantir17.mph.net)
	by palantir17.mph.net with esmtp (Exim 4.95)
	(envelope-from <habetsm.xilinx@gmail.com>)
	id 1puTNh-00086Z-Ep;
	Thu, 04 May 2023 08:28:01 +0100
Subject: [PATCH net] sfc: Add back mailing list
From: Martin Habets <habetsm.xilinx@gmail.com>
To: davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
 edumazet@google.com
Cc: netdev@vger.kernel.org, ecree.xilinx@gmail.com, linux-net-drivers@amd.com
Date: Thu, 04 May 2023 08:28:01 +0100
Message-ID: <168318528134.31137.11625787711228662726.stgit@palantir17.mph.net>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=0.7 required=5.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	FORGED_GMAIL_RCVD,FREEMAIL_FROM,KHOP_HELO_FCRDNS,NML_ADSP_CUSTOM_MED,
	SPF_HELO_NONE,SPF_SOFTFAIL,SPOOFED_FREEMAIL,SPOOF_GMAIL_MID,
	T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

We used to have a mailing list in the MAINTAINERS file, but removed this
when we became part of Xilinx as it stopped working.
Now inside AMD we have the list again. Add it back so patches will be seen
by all sfc developers.

Signed-off-by: Martin Habets <habetsm.xilinx@gmail.com>
---
 MAINTAINERS |    1 +
 1 file changed, 1 insertion(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index ebd26b3ca90e..dcab6b41ad8d 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -18987,6 +18987,7 @@ SFC NETWORK DRIVER
 M:	Edward Cree <ecree.xilinx@gmail.com>
 M:	Martin Habets <habetsm.xilinx@gmail.com>
 L:	netdev@vger.kernel.org
+L:	linux-net-drivers@amd.com
 S:	Supported
 F:	Documentation/networking/devlink/sfc.rst
 F:	drivers/net/ethernet/sfc/



