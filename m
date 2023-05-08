Return-Path: <netdev+bounces-905-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3C8166FB4FE
	for <lists+netdev@lfdr.de>; Mon,  8 May 2023 18:23:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E92DA280FC5
	for <lists+netdev@lfdr.de>; Mon,  8 May 2023 16:23:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 143185247;
	Mon,  8 May 2023 16:23:30 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C47120F9
	for <netdev@vger.kernel.org>; Mon,  8 May 2023 16:23:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10CD4C433EF;
	Mon,  8 May 2023 16:23:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1683563008;
	bh=bQbuP5tpsVNV1Hmt3JVYQK3SuCN6BCvnVZesjv33iB4=;
	h=Date:From:To:Cc:Subject:From;
	b=opZqAkdkeZ4xBVhGX0OUZVTP6EYQMwgcqwmN0fvvXnGJNixjn5lWkNPdSB25iw0F+
	 AzXjVo5xMq6U9trcupTl3B66tiItPThIjB1wdq1TGcd9YRf5w9rI4H4JN24M/CYGWJ
	 3H1JLua6ver2SyOwD2AK73tpmJEQow2ku2yipX4vdDvlPN5Aw+XSFushM5DUjsWy5e
	 8B7fqXfxjxWcTRTRNULMSnQWZZqpTlWohybk+qFBRh9V3D04/V6eyYwEzRhReHhJpg
	 RhuWszskqo1r9h4LHtFK7t9+F+dZQJUS8j83Ng1jp4ivhk3Zqplp3mjNsMiH8JkKrl
	 LB9SzkviAAo+Q==
Date: Mon, 8 May 2023 09:23:27 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Cc: David Miller <davem@davemloft.net>, Paolo Abeni <pabeni@redhat.com>
Subject: [ANN] net-next is OPEN
Message-ID: <20230508092327.2619196f@kernel.org>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

Hi!

net-next is now open for patches!


Minor general development - I've created a mail bot for updating the
patch state in patchwork. You should be able to discard your own series
from patchwork by replying to it with "pw-bot: changes-requested" on
a separate line somewhere in the email. The author of the patch and
the From in the reply must match exactly.

The code is in "public alpha" so it may crash / not work, feel free 
to ping me if that happens. I'll send a separate announcement once
it feels more stable.

There is a public activity log here:
https://patchwork.hopto.org/pw-bot.html

