Return-Path: <netdev+bounces-5698-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 0C0147127BC
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 15:45:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 749DB1C21037
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 13:45:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CDD7E1DDCC;
	Fri, 26 May 2023 13:45:34 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D71818B1C
	for <netdev@vger.kernel.org>; Fri, 26 May 2023 13:45:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0EFCC433EF;
	Fri, 26 May 2023 13:45:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1685108733;
	bh=b79EPlDpBE6N14DOiOUfMACk/WSW3bWcDE9wud5hejE=;
	h=From:Date:Subject:To:Cc:From;
	b=vEdFbzt0A0UwgzAXBuPdaryCNaNCXxjbTLJ+zrl5afehQC1+s6VQT6VNFGUbIqs2z
	 ZA8pWDclCoKZEZUfm+HOT+1eBudS+c5IUv4llAnhOW4lhtd1Bc9RsGOArEca4zBj0h
	 8HCjPeeNJ4chgQgklD1On8BRq5pwygLLfKkpht4pgU+AtKJTW9PMfcA8QSmUU+BB+z
	 psALx9pf6FZ8BSWxa9vDNssL4tCXf1TDUY5DFqiCeS9E1GhuxS3+Xs/QkUOV7MJvhx
	 kqRYSjPjYPQa8YkZISEJ7MmMfqnc5ZkuY0jP3j+W1oISAMx0rHdaMexn3NW0X8i6XE
	 /RV10ksN/4rlg==
From: Simon Horman <horms@kernel.org>
Date: Fri, 26 May 2023 15:45:13 +0200
Subject: [PATCH net-next] devlink: Spelling corrections
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230526-devlink-spelling-v1-1-9a3e36cdebc8@kernel.org>
X-B4-Tracking: v=1; b=H4sIAOi3cGQC/x2N0QqDMBAEf0XuuQdpqqX2V4oPiW71aLhKYkUQ/
 92jbzsLw+xUkAWFntVOGasU+arB9VJRPwUdwTIYk3f+5hp/5wFrEv1wmZFsjOxjfDi0TVv7SKb
 FUMAxB+0nE/WXkp1zxlu2f+dFioUV20LdcZyq5UAZgQAAAA==
To: Jakub Kicinski <kuba@kernel.org>, 
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
 Paolo Abeni <pabeni@redhat.com>
Cc: Jiri Pirko <jiri@resnulli.us>, netdev@vger.kernel.org
X-Mailer: b4 0.12.2

Make some minor spelling corrections in comments.

Found by inspection.

Signed-off-by: Simon Horman <horms@kernel.org>
---
 include/net/devlink.h  | 2 +-
 net/devlink/leftover.c | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/include/net/devlink.h b/include/net/devlink.h
index 1bd56c8d6f3c..ec109b39c3ea 100644
--- a/include/net/devlink.h
+++ b/include/net/devlink.h
@@ -1261,7 +1261,7 @@ struct devlink_ops {
 	/**
 	 * @supported_flash_update_params:
 	 * mask of parameters supported by the driver's .flash_update
-	 * implemementation.
+	 * implementation.
 	 */
 	u32 supported_flash_update_params;
 	unsigned long reload_actions;
diff --git a/net/devlink/leftover.c b/net/devlink/leftover.c
index 0410137a4a31..9e801b749194 100644
--- a/net/devlink/leftover.c
+++ b/net/devlink/leftover.c
@@ -6761,7 +6761,7 @@ static void devlink_port_type_warn_cancel(struct devlink_port *devlink_port)
  * @devlink: devlink
  * @devlink_port: devlink port
  *
- * Initialize essencial stuff that is needed for functions
+ * Initialize essential stuff that is needed for functions
  * that may be called before devlink port registration.
  * Call to this function is optional and not needed
  * in case the driver does not use such functions.
@@ -6782,7 +6782,7 @@ EXPORT_SYMBOL_GPL(devlink_port_init);
  *
  * @devlink_port: devlink port
  *
- * Deinitialize essencial stuff that is in use for functions
+ * Deinitialize essential stuff that is in use for functions
  * that may be called after devlink port unregistration.
  * Call to this function is optional and not needed
  * in case the driver does not use such functions.


