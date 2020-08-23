Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 64B4324EF38
	for <lists+netdev@lfdr.de>; Sun, 23 Aug 2020 20:18:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726751AbgHWSSb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Aug 2020 14:18:31 -0400
Received: from mailrelay102.isp.belgacom.be ([195.238.20.129]:53622 "EHLO
        mailrelay102.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725867AbgHWSS1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 Aug 2020 14:18:27 -0400
IronPort-SDR: wRdfGMtH/v7YGUeUfpzneb66FO/dbgm58H+vuqXISzfKbqtgU4XYbYgH29VJXJmXK+svY/3V7t
 3nwsVB26GfbDOdIQPd2zhNOZAmYKO5hmoTaz0g4ldiO+2BMU+fONQtQWFYwJnc8IIZREz2k68C
 w+0r9vZ1seUpH7uPu/7kXKwkw0nSfeBm4rwHp4+gLWIMSlq2mk+ADwNIgehtjE4aaslhjU2NWw
 n+tLzdJ7J7vupbgx3Ee9aMY+wT8Fkw+EuujsY/dfZ+wDhrehwOxBiz6aMRxb346UxMNEdJtN2v
 eg4=
X-Belgacom-Dynamic: yes
IronPort-PHdr: =?us-ascii?q?9a23=3Abyg8XRCLthwAGw0knWmvUyQJP3N1i/DPJgcQr6?=
 =?us-ascii?q?AfoPdwSP35pMSwAkXT6L1XgUPTWs2DsrQY0rSQ6vm+EjVaut6oizMrSNR0TR?=
 =?us-ascii?q?gLiMEbzUQLIfWuLgnFFsPsdDEwB89YVVVorDmROElRH9viNRWJ+iXhpTEdFQ?=
 =?us-ascii?q?/iOgVrO+/7BpDdj9it1+C15pbffxhEiCCybL9vLRi6txjdutQXjIdtN6o91B?=
 =?us-ascii?q?XEqWZUdupLwm9lOUidlAvm6Meq+55j/SVQu/Y/+MNFTK73Yac2Q6FGATo/K2?=
 =?us-ascii?q?w669HluhfFTQuU+3sTSX4WnQZSAwjE9x71QJH8uTbnu+Vn2SmaOcr2Ta0oWT?=
 =?us-ascii?q?mn8qxmRgPkhDsBOjUk9mzcl85+g79BoB+5pxJx3ZPabo+WOvR5cazTcsgXSX?=
 =?us-ascii?q?ZCU8tLSyBMGJ+wY5cJAuEcPehYtY79p14WoBW+HwajH+LvxSVOhnTr3aM6yf?=
 =?us-ascii?q?ouHhzY0ww6HtIBrHfUp8jyOaccS++616fIwC7Yb/NV2Tb97pbHcgw7rf6XQ7?=
 =?us-ascii?q?19aMzcwlQgGA3ZlFufs5DlPy+L2eQXtWiW9+RuWOGrhmAnqgx8oiajy8kshI?=
 =?us-ascii?q?TUmo4Z10zI+CR2zog6ONC1RlB2bMOkHZZSqSyUOJd6TM0tTWxsuCg0yqMKtJ?=
 =?us-ascii?q?q9cSMXy5on3wbSZviaf4SS/x7uV/idLS1liH9keL+znQu+/Emmx+bhTMe7yk?=
 =?us-ascii?q?xKoTBAktTUs3AN0AHc5dafR/tm+0ehxS6P1wfO6uFYOUw0lbTUK5omwrMokp?=
 =?us-ascii?q?oTtljMETXymEX2i6+WbVkk9vKs6+TgfrrpvJucOJJzigH7KKsum8q/Dfw5Mg?=
 =?us-ascii?q?gIQWeb5fyx2bn+8UHjXblHjeM6nrPEvJ3bJckXvLO1Dg5N3oYm8Rm/DjOm0N?=
 =?us-ascii?q?oCnXkAKVJIYByHgJLyNFHAO/34FvS/glSqkDh12/DKJKbuDYvVInjZjLjhZa?=
 =?us-ascii?q?p961JbyAcr1dBQ/YlbCrUGIP/oXE/+qsDYDhE4Mwyw3+boFs992pkZWWKVDa?=
 =?us-ascii?q?+TKLnSvkOQ5uIzP+mMY5cYuDXnJPc44/7hk2M2lEQbfaa3wZsXZnG4HvB6I0?=
 =?us-ascii?q?qHe3rgmNABEX0FvgAmVuzllEWCUSJPZ3a1R6886D86BZm9DYffXICthKKO3C?=
 =?us-ascii?q?GhEpJLeG9MEkqMHmvwd4WYR/cMbzqfItR6nTweVLihVY4h1Ra1uQ/g1bVoM+?=
 =?us-ascii?q?rU9TcEtZ75yNd14OjTnwko9TNoF8Sdz32NT2Zsk2MOWTA2wK5/oU15ylefz6?=
 =?us-ascii?q?d4meVUGsFN6PNXTAg6MYXRz/J1C9/sQALNZNSJR0i8QtWgHz4xSsg9w9gUY0?=
 =?us-ascii?q?ZyA9+ilAzM3zK2A78JkLyGHIA78qXG33fvO8Zy1WzJ1Kw6glkgXMRPKWOmhq?=
 =?us-ascii?q?979wjPGYHJiV+Vl6GwdaQTxCTN7nuMzXKSvEFEVw59SaPFUm4DZkTLs9v5+F?=
 =?us-ascii?q?jPT6GhCbs5KAtN082CJbVQat3vk1pGQO3vONPEY2K+g22wHwqHxquQbIr2fG?=
 =?us-ascii?q?UQxCvdB1IfnAAd5nuGLgs+Byeno23AEDxiD0ngbF2/udV5/WuyREsz5weHc0?=
 =?us-ascii?q?Ng06a44FgSn/PYA/Aa0rYJsw8npil6HVKh0siQDMCP40JvY41Hfck57VEB2W?=
 =?us-ascii?q?+d/xd3JJ2+LqdKnFMScw1r+Ujp0kZZEIJFxOYjpnIjykJcM6+U3UlAfDDQiZ?=
 =?us-ascii?q?75MLP/MWrj+h2zLaTbjAKNmO2K87sCvaxr427ouxukQxIv?=
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: =?us-ascii?q?A2BfCQB9skJf/xCltltfHgEBCxIMR4F?=
 =?us-ascii?q?FgxhUX404kkqSAgsBAQEBAQEBAQEnDQECBAEBhEyCRyU4EwIDAQEBAwIFAQE?=
 =?us-ascii?q?GAQEBAQEBBQQBhg9FQxYBgV0ig1IBIyOBPxKDJgGCVymyT4QQhGeBQIE4AYg?=
 =?us-ascii?q?jhRmBQT+EX4QfhhUEj0ameYJtgwyEWn6RMQ8hoDKSQ6FagXpNIBiDJAlHGQ2?=
 =?us-ascii?q?caEIwNwIGCgEBAwlXAT0BjAWEHwEB?=
X-IPAS-Result: =?us-ascii?q?A2BfCQB9skJf/xCltltfHgEBCxIMR4FFgxhUX404kkqSA?=
 =?us-ascii?q?gsBAQEBAQEBAQEnDQECBAEBhEyCRyU4EwIDAQEBAwIFAQEGAQEBAQEBBQQBh?=
 =?us-ascii?q?g9FQxYBgV0ig1IBIyOBPxKDJgGCVymyT4QQhGeBQIE4AYgjhRmBQT+EX4Qfh?=
 =?us-ascii?q?hUEj0ameYJtgwyEWn6RMQ8hoDKSQ6FagXpNIBiDJAlHGQ2caEIwNwIGCgEBA?=
 =?us-ascii?q?wlXAT0BjAWEHwEB?=
Received: from 16.165-182-91.adsl-dyn.isp.belgacom.be (HELO localhost.localdomain) ([91.182.165.16])
  by relay.skynet.be with ESMTP; 23 Aug 2020 20:18:25 +0200
From:   Fabian Frederick <fabf@skynet.be>
To:     pablo@netfilter.org, kadlec@netfilter.org, fw@strlen.de,
        sbrivio@redhat.com
Cc:     netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, Fabian Frederick <fabf@skynet.be>
Subject: [PATCH V2 5/5 nf] selftests: netfilter: add command usage
Date:   Sun, 23 Aug 2020 20:18:06 +0200
Message-Id: <20200823181806.13463-1-fabf@skynet.be>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Avoid bad command arguments.
Based on tools/power/cpupower/bench/cpufreq-bench_plot.sh

Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
V2: new patch

 tools/testing/selftests/netfilter/nft_flowtable.sh | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/tools/testing/selftests/netfilter/nft_flowtable.sh b/tools/testing/selftests/netfilter/nft_flowtable.sh
index 44a8798262369..431296c0f91cf 100755
--- a/tools/testing/selftests/netfilter/nft_flowtable.sh
+++ b/tools/testing/selftests/netfilter/nft_flowtable.sh
@@ -86,12 +86,23 @@ omtu=9000
 lmtu=1500
 rmtu=2000
 
+usage(){
+	echo "nft_flowtable.sh [OPTIONS]"
+	echo
+	echo "MTU options"
+	echo "   -o originator"
+	echo "   -l link"
+	echo "   -r responder"
+	exit 1
+}
+
 while getopts "o:l:r:" o
 do
 	case $o in
 		o) omtu=$OPTARG;;
 		l) lmtu=$OPTARG;;
 		r) rmtu=$OPTARG;;
+		*) usage;;
 	esac
 done
 
-- 
2.27.0

