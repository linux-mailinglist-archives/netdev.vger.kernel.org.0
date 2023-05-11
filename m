Return-Path: <netdev+bounces-1636-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 656526FE98A
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 03:43:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C2052280E4E
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 01:43:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BB4BB1F175;
	Thu, 11 May 2023 01:43:42 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AC29645
	for <netdev@vger.kernel.org>; Thu, 11 May 2023 01:43:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6823C433D2;
	Thu, 11 May 2023 01:43:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1683769421;
	bh=WgiagVILFlJr+BssirgOWdx4EX6xaOlwOwJSQdWpN6M=;
	h=From:To:Cc:Subject:Date:From;
	b=ByRJMek1Bn5TXGuVVZO1SyoLXds2iMI5zSyd7EQfLgL1hQWlWUlVoXPaz3Id/G1lK
	 r32ICq2Mr+hXG0qjY0HpHmf3wLwmRZzV49qXY7y58VTMjvW1gIfjXH8jKa7EkVL5Nh
	 M2XN4T6JGGIyBKJ3BWrTmdPwXCJKqE+KRkFUxMjr4AnSheyZIJEYSoCBu2oV/UYA2b
	 5aNUmrxyjrGr7cLM2yC3idtBISan6Zj3N8SYmHsXCFkXcHVNRx5cjyg+Sv6neEs2E4
	 O2ye0MrmZNlAP98AYSWcish3ckD8ZVU5AFeB1PK+EP5eFtXr826rQ5/wT1/A7gUDv2
	 bXBqDGUD6r0Kg==
From: Jakub Kicinski <kuba@kernel.org>
To: davem@davemloft.net
Cc: netdev@vger.kernel.org,
	edumazet@google.com,
	pabeni@redhat.com,
	linux-doc@vger.kernel.org,
	corbet@lwn.net,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net] MAINTAINERS: don't CC docs@ for netlink spec changes
Date: Wed, 10 May 2023 18:43:39 -0700
Message-Id: <20230511014339.906663-1-kuba@kernel.org>
X-Mailer: git-send-email 2.40.1
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Documentation/netlink/ contains machine-readable protocol
specs in YAML. Those are much like device tree bindings,
no point CCing docs@ for the changes.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 MAINTAINERS | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 7e0b87d5aa2e..1c78e61a3387 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -6218,6 +6218,7 @@ X:	Documentation/devicetree/
 X:	Documentation/driver-api/media/
 X:	Documentation/firmware-guide/acpi/
 X:	Documentation/i2c/
+X:	Documentation/netlink/
 X:	Documentation/power/
 X:	Documentation/spi/
 X:	Documentation/userspace-api/media/
@@ -14607,6 +14608,7 @@ B:	mailto:netdev@vger.kernel.org
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git
 F:	Documentation/core-api/netlink.rst
+F:	Documentation/netlink/
 F:	Documentation/networking/
 F:	Documentation/process/maintainer-netdev.rst
 F:	Documentation/userspace-api/netlink/
-- 
2.40.1


