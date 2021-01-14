Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C91622F58FE
	for <lists+netdev@lfdr.de>; Thu, 14 Jan 2021 04:32:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727744AbhANDLX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jan 2021 22:11:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:53094 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727716AbhANDLW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 13 Jan 2021 22:11:22 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 28F2923877;
        Thu, 14 Jan 2021 03:10:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610593805;
        bh=ANpyG7RkBNC6assg33y5Mp0O9hHtuDSw4gsID3Dvo3o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TCnxXD72z0/CphRucflZ1DrtPIvMtKSSWt/TgD8FBRDL+JES6LKlA4dcyw0Vkj3e8
         0Y1b/IRglE3MSSk9XiqMXm/ySJe2OEN8Sr3QMgKPLPz352xbninve/S9kxP8TO0RyC
         Ng0wwwGfrO0sRqG6s2/rZxkyKj7ce9nNCZ6hsOnUX8CCij37QsFYXvvqc07w4nAQd2
         N+QWfIDLFY3mawPtTuPFziyH51Pjs02P5SUzMkIppTW+ghmdISyGyLWxgNLekp1AHn
         +jIOMrIYrLnrfVlL8h1PZtcxlMPm4XFQRNTz8kW4PX3ZUPX8PughpUFLKYwXIjfkag
         FZyi7I7ZCd8DQ==
From:   David Ahern <dsahern@kernel.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, schoen@loyalty.org,
        David Ahern <dsahern@kernel.org>
Subject: [PATCH net-next v4 12/13] selftests: Remove exraneous newline in nettest
Date:   Wed, 13 Jan 2021 20:09:48 -0700
Message-Id: <20210114030949.54425-13-dsahern@kernel.org>
X-Mailer: git-send-email 2.24.3 (Apple Git-128)
In-Reply-To: <20210114030949.54425-1-dsahern@kernel.org>
References: <20210114030949.54425-1-dsahern@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Signed-off-by: David Ahern <dsahern@kernel.org>
---
 tools/testing/selftests/net/nettest.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/tools/testing/selftests/net/nettest.c b/tools/testing/selftests/net/nettest.c
index 1707af21eb15..55c586eb2393 100644
--- a/tools/testing/selftests/net/nettest.c
+++ b/tools/testing/selftests/net/nettest.c
@@ -1462,7 +1462,6 @@ static int do_server(struct sock_args *args, int ipc_fd)
 
 	ipc_write(ipc_fd, 1);
 	while (1) {
-		log_msg("\n");
 		log_msg("waiting for client connection.\n");
 		FD_ZERO(&rfds);
 		FD_SET(lsd, &rfds);
-- 
2.24.3 (Apple Git-128)

