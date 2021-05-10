Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 96A8F378247
	for <lists+netdev@lfdr.de>; Mon, 10 May 2021 12:32:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231697AbhEJKdo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 May 2021 06:33:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:40400 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231364AbhEJKbk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 10 May 2021 06:31:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EB4A161601;
        Mon, 10 May 2021 10:27:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620642444;
        bh=jioxfYQEAZJHM7vUpkbi4bioydkL+hH7U0N0/80717Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QGxfv/dzUFDNIhEgvRwGe+4xhXIgzAhDXite3H3ABCjNV5YmUzEPbL2jpPWhcQVZp
         7JJXhGxerlhHo+IKC9tXpUm1QXFRiSVATJQcmgf+tXkF4ow7MENHh7KIiTlSiOZy0F
         7O30u1MBLDKNT0bAjucVe80toRflL50xNyMU+Kq4nMjkS+OXcf+ghxD/SzM8WLjdTx
         h0NGUYXmAzN1L7Me/rcwzu0yzqB/6pvnu5YsYPcLfSXrDq60T/4cJUshKKNWsuoulH
         rgUdSunGMQ0znLFtNz6WF5TKcjT5G76BvfMQGntU2bpmQE8iJltrNZxRWYVnqU+KiT
         aTtizOWPvw7gg==
Received: by mail.kernel.org with local (Exim 4.94.2)
        (envelope-from <mchehab@kernel.org>)
        id 1lg38E-000UQa-1q; Mon, 10 May 2021 12:27:22 +0200
From:   Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
To:     Linux Doc Mailing List <linux-doc@vger.kernel.org>
Cc:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        "Jonathan Corbet" <corbet@lwn.net>,
        Jakub Kicinski <kuba@kernel.org>, Jiri Pirko <jiri@nvidia.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH 35/53] docs: networking: devlink: devlink-dpipe.rst: avoid using UTF-8 chars
Date:   Mon, 10 May 2021 12:26:47 +0200
Message-Id: <ef67533dd90ecdeb6cd8aa3e1697c11187d62d8e.1620641727.git.mchehab+huawei@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <cover.1620641727.git.mchehab+huawei@kernel.org>
References: <cover.1620641727.git.mchehab+huawei@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: Mauro Carvalho Chehab <mchehab@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

While UTF-8 characters can be used at the Linux documentation,
the best is to use them only when ASCII doesn't offer a good replacement.
So, replace the occurences of the following UTF-8 characters:

	- U+2019 ('’'): RIGHT SINGLE QUOTATION MARK

Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
---
 Documentation/networking/devlink/devlink-dpipe.rst | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/networking/devlink/devlink-dpipe.rst b/Documentation/networking/devlink/devlink-dpipe.rst
index af37f250df43..2df7cbf1ba70 100644
--- a/Documentation/networking/devlink/devlink-dpipe.rst
+++ b/Documentation/networking/devlink/devlink-dpipe.rst
@@ -52,7 +52,7 @@ purposes as a standard complementary tool. The system's view from
 ``devlink-dpipe`` should change according to the changes done by the
 standard configuration tools.
 
-For example, it’s quite common to  implement Access Control Lists (ACL)
+For example, it's quite common to  implement Access Control Lists (ACL)
 using Ternary Content Addressable Memory (TCAM). The TCAM memory can be
 divided into TCAM regions. Complex TC filters can have multiple rules with
 different priorities and different lookup keys. On the other hand hardware
-- 
2.30.2

