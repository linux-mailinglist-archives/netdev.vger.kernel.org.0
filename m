Return-Path: <netdev+bounces-10179-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 4F78472CAD6
	for <lists+netdev@lfdr.de>; Mon, 12 Jun 2023 17:59:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3492E1C20B52
	for <lists+netdev@lfdr.de>; Mon, 12 Jun 2023 15:59:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1C2891EA7C;
	Mon, 12 Jun 2023 15:59:34 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C90AA1C75F
	for <netdev@vger.kernel.org>; Mon, 12 Jun 2023 15:59:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0D53C433EF;
	Mon, 12 Jun 2023 15:59:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686585572;
	bh=z0WMMgSkGpwwbIelHYCs8zww4TNTCEKPRidFB13Bnvg=;
	h=From:To:Cc:Subject:Date:From;
	b=JS7SjHvjqZdhPG6eVrjAI68a4NanpjCtDY98IGzx/uVeSrmBEA3ifExlv3SsUirn6
	 xUFENJzjThVnNQRoWH3Mr5Xc4AASVKy0tegI5MyucCzJ9pnllGQANyNeQA7FqIWTCf
	 ibSzMJ/WQ6MuO/165GtUhkFezB+/2Ng+t92IqmuRGBU8njmlO9zsyvuonNzqhykxgx
	 XjEFxr6W6wROCD6EUJ0zsBrepLw/h8u8YALmN/nz4mh+0ycGMXTOeMAGErd1Om2YBe
	 qvEFnwhv63hhgBynOxejE/NENdZl3FFj7DA2WEM63cwm+UlCbs3F0IpP6PM3cjqLZO
	 di4PBsW6cpREg==
From: Jakub Kicinski <kuba@kernel.org>
To: davem@davemloft.net
Cc: netdev@vger.kernel.org,
	edumazet@google.com,
	pabeni@redhat.com,
	arkadiusz.kubalewski@intel.com,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 0/2] tools: ynl-gen: improvements for DPLL
Date: Mon, 12 Jun 2023 08:59:18 -0700
Message-Id: <20230612155920.1787579-1-kuba@kernel.org>
X-Mailer: git-send-email 2.40.1
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

A set of improvements needed to generate the kernel code for DPLL.

Jakub Kicinski (2):
  tools: ynl-gen: correct enum policies
  tools: ynl-gen: inherit policy in multi-attr

 tools/net/ynl/ynl-gen-c.py | 57 +++++++++++++++++++++++++-------------
 1 file changed, 37 insertions(+), 20 deletions(-)

-- 
2.40.1


