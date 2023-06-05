Return-Path: <netdev+bounces-8018-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 2217E7226DA
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 15:05:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8E4A61C20C3D
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 13:05:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2C66C19902;
	Mon,  5 Jun 2023 13:05:45 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E1446ABC
	for <netdev@vger.kernel.org>; Mon,  5 Jun 2023 13:05:44 +0000 (UTC)
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2A771B1
	for <netdev@vger.kernel.org>; Mon,  5 Jun 2023 06:05:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
	s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
	Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
	Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
	bh=Sdg7S5Ic8VZCDOb4PFm7j9KptOOMSbWUxv3w7UnjvBk=; b=x//yB0AAFzW9nbXY3yjtHqPk3F
	W6mKmAnutPP5sxXVKRzOTeojDqy6HHGumzVwNUoE92ekbLZaJqr5LiVxThaKMcYuEbcKDDcvI1M3N
	U/axx51m4yg/AvVzd1CBKE3oDVcO9xwncF+BH006+/u1C48NAEDKUVfbosM4I3eix4xc=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
	(envelope-from <andrew@lunn.ch>)
	id 1q69tv-00Ett6-0b; Mon, 05 Jun 2023 15:05:35 +0200
Date: Mon, 5 Jun 2023 15:05:35 +0200
From: Andrew Lunn <andrew@lunn.ch>
To: Mengyuan Lou <mengyuanlou@net-swift.com>
Cc: netdev@vger.kernel.org, jiawenwu@trustnetic.com
Subject: Re: [RFC,PATCH net-next 0/3] wangxun nics add wol ncsi support
Message-ID: <24c946cd-7c03-4836-9747-cb030ae6bf06@lunn.ch>
References: <6B6FE1F43BAECDA0+20230605095527.57898-1-mengyuanlou@net-swift.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6B6FE1F43BAECDA0+20230605095527.57898-1-mengyuanlou@net-swift.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Mon, Jun 05, 2023 at 05:52:49PM +0800, Mengyuan Lou wrote:
> Add support for wangxun nics support WOL or NCSI, which phy should
> not to supsend.

Please split this into two. Include the NCSI Maintainers and the PHY
Maintainers for the NCSI/PHY patches.

	Andrew

