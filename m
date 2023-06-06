Return-Path: <netdev+bounces-8613-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2364E724D49
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 21:43:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D2ADA281036
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 19:43:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EACDA23D54;
	Tue,  6 Jun 2023 19:43:19 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8DE3125CC
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 19:43:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DC9DC433D2;
	Tue,  6 Jun 2023 19:43:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686080598;
	bh=7nssHBTiaHiID03l2qOsLU00r53VPAbRHgBMeqAilgs=;
	h=From:To:Cc:Subject:Date:From;
	b=cXt273y5NKh7QGOobF6Dt6RdUA4fHrZEAv1x29c2hFQGOvkSy5N1tv7tB2MXK2g2u
	 2xPuCrH/sg/QgtADWy87TU7oBpp3jPhGYFQwg/b3S2XMudDB8odM7Zr9/wzZ6fV5MI
	 Z3WpS+PQIlV2zAJ8XbwEAincq8N4TjvL95ylZLZ+afp+0F4Z69H7zEbzEycXyqYh9d
	 eYzebE9K5+j3UoYi/sn7mSr/bPnxMoSnUWRTxhtw9jdwG0/I0e9PmD/pdI2JYjUbBW
	 bdbIMCdUVxiW2mEJnuftXlx/hnjVEbk6VHCQyYW+QJgz7pgO3dqKlSxG8C9ycxVf2D
	 rji+AIhsz1AMw==
From: Jakub Kicinski <kuba@kernel.org>
To: davem@davemloft.net
Cc: netdev@vger.kernel.org,
	edumazet@google.com,
	pabeni@redhat.com,
	sdf@google.com,
	willemdebruijn.kernel@gmail.com,
	chuck.lever@oracle.com,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 0/3] tools: ynl: generate code for the handshake family
Date: Tue,  6 Jun 2023 12:42:59 -0700
Message-Id: <20230606194302.919343-1-kuba@kernel.org>
X-Mailer: git-send-email 2.40.1
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add necessary features and generate user space C code for serializing
/ deserializing messages of the handshake family.

In addition to basics already present in netdev and fou, handshake
has nested attrs and multi-attr u32.

Jakub Kicinski (3):
  tools: ynl-gen: fill in support for MultiAttr scalars
  tools: ynl-gen: improve unwind on parsing errors
  tools: ynl: generate code for the handshake family

 tools/net/ynl/generated/Makefile         |   2 +-
 tools/net/ynl/generated/handshake-user.c | 385 +++++++++++++++++++++++
 tools/net/ynl/generated/handshake-user.h | 148 +++++++++
 tools/net/ynl/ynl-gen-c.py               |  69 +++-
 4 files changed, 593 insertions(+), 11 deletions(-)
 create mode 100644 tools/net/ynl/generated/handshake-user.c
 create mode 100644 tools/net/ynl/generated/handshake-user.h

-- 
2.40.1


