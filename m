Return-Path: <netdev+bounces-2809-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A5759704105
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 00:38:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1DF8F1C20D3F
	for <lists+netdev@lfdr.de>; Mon, 15 May 2023 22:38:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A538119509;
	Mon, 15 May 2023 22:38:05 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8ADB62FB2
	for <netdev@vger.kernel.org>; Mon, 15 May 2023 22:38:05 +0000 (UTC)
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B946A5DA;
	Mon, 15 May 2023 15:38:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
	s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
	Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
	Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
	bh=jnDRWuNSWsp6KYhPmlwWmea/YvyxX4wTa6fZnl4J24c=; b=EYbU0a3j0wQDP84sU0LLnS8jpc
	1iKmZBD8ldErq0TIqmefbrbJX1Ady1G/gcNtqBPmoQGIP7LDcXk/kKywuZyEb7OczTerVF4+WTQ7G
	WtbmEVw0JSD2pUaPJ/gpoLB10zwUZ5QXojqWRsBRdUrAFPCIE2f4J1ny78oy1COkOkog=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
	(envelope-from <andrew@lunn.ch>)
	id 1pygp8-00CwZS-89; Tue, 16 May 2023 00:37:46 +0200
Date: Tue, 16 May 2023 00:37:46 +0200
From: Andrew Lunn <andrew@lunn.ch>
To: Marco Migliore <m.migliore@tiesse.com>
Cc: Florian Fainelli <f.fainelli@gmail.com>,
	Vladimir Oltean <olteanv@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: dsa: mv88e6xxx: Fix mv88e6393x EPC write command
 offset
Message-ID: <93b20305-72e2-4916-aa72-7595a776917f@lunn.ch>
References: <20230515220918.80709-1-m.migliore@tiesse.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230515220918.80709-1-m.migliore@tiesse.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Tue, May 16, 2023 at 12:09:18AM +0200, Marco Migliore wrote:
> According to datasheet, the command opcode must be specified
> into bits [14:12] of the Extended Port Control register (EPC).
> 
> Signed-off-by: Marco Migliore <m.migliore@tiesse.com>

Hi Marco

Please read the netdev FAQ:

https://www.kernel.org/doc/html/latest/process/maintainer-netdev.html#netdev-faq

Please add a Fixes: tag, to indicate the patch which introduced the
problem and needs fixing. Also, set the subject to indicate this is
for the net tree.

Thanks
	Andrew

