Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 825EB46AA92
	for <lists+netdev@lfdr.de>; Mon,  6 Dec 2021 22:39:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352153AbhLFVnN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Dec 2021 16:43:13 -0500
Received: from novek.ru ([213.148.174.62]:39358 "EHLO novek.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1352145AbhLFVnJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 6 Dec 2021 16:43:09 -0500
Received: from nat1.ooonet.ru (gw.zelenaya.net [91.207.137.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by novek.ru (Postfix) with ESMTPSA id 036925009F6;
        Tue,  7 Dec 2021 00:34:54 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 novek.ru 036925009F6
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=novek.ru; s=mail;
        t=1638826495; bh=/dWHgFxqbnhsChkgD1Lr+aJNb2hG2phTG+uMTwe1Xr4=;
        h=From:To:Cc:Subject:Date:From;
        b=TuEP7dA3tm7y6rvskjucTvbMIIS6OUV8fUkbI0toQFhN8UwNahfNEO9SLVfWiFPEc
         GdRi1va5n4d6UXK1p9XXoWqC9HwFx3kbnvnciHLCFcQtzHM2WVMO0GTRJ+R3aaR6SG
         GAuwfsgZnuVWWF95AKWsMsJi5JcUF3ar0oM/uCpc=
From:   Vadim Fedorenko <vfedorenko@novek.ru>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Vadim Fedorenko <vfedorenko@novek.ru>, netdev@vger.kernel.org
Subject: [PATCH net 0/2] net: tls: cover all ciphers with tests 
Date:   Tue,  7 Dec 2021 00:39:30 +0300
Message-Id: <20211206213932.7508-1-vfedorenko@novek.ru>
X-Mailer: git-send-email 2.18.4
X-Spam-Status: No, score=0.0 required=5.0 tests=UNPARSEABLE_RELAY
        autolearn=ham autolearn_force=no version=3.4.1
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on gate.novek.ru
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Recent patches to Kernel TLS showed that some ciphers are not covered
with tests. Let's cover missed.

Vadim Fedorenko (2):
  selftests: tls: add missing AES-CCM cipher tests
  selftests: tls: add missing AES256-GCM cipher

 tools/testing/selftests/net/tls.c | 36 +++++++++++++++++++++++++++++++
 1 file changed, 36 insertions(+)

-- 
2.18.4

