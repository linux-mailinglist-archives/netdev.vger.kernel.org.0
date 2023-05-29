Return-Path: <netdev+bounces-6090-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 98325714CBD
	for <lists+netdev@lfdr.de>; Mon, 29 May 2023 17:11:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 473B9280DFD
	for <lists+netdev@lfdr.de>; Mon, 29 May 2023 15:11:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6CCD68C0D;
	Mon, 29 May 2023 15:11:33 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59A6E3FD4
	for <netdev@vger.kernel.org>; Mon, 29 May 2023 15:11:33 +0000 (UTC)
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3FAA9F
	for <netdev@vger.kernel.org>; Mon, 29 May 2023 08:11:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
	s=20171124; h=In-Reply-To:Content-Transfer-Encoding:Content-Disposition:
	Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:From:
	Sender:Reply-To:Subject:Date:Message-ID:To:Cc:MIME-Version:Content-Type:
	Content-Transfer-Encoding:Content-ID:Content-Description:Content-Disposition:
	In-Reply-To:References; bh=Qkkxoo9M6CA0DyAoUMwjg/mZ775Y6x4pLLJus21COjc=; b=0t
	BRHLpG4Qsgcya+BCzQutwLFU+RBPKt5OqvKY/xQGvIXgGcION+FWlLK7frmhWF9GhcXm3Sllvs5+A
	F3E00m7RtrWX4ctePAx1zCO+r/D7BJbsjcr9ApWVfAYZrMsI+NvC15nkOQzHaLIDhu/BYa9G6iBLA
	ZwJjtiSDb7cLoKQ=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
	(envelope-from <andrew@lunn.ch>)
	id 1q3eWu-00EEmu-Nb; Mon, 29 May 2023 17:11:28 +0200
Date: Mon, 29 May 2023 17:11:28 +0200
From: Andrew Lunn <andrew@lunn.ch>
To: Marek =?iso-8859-1?Q?Beh=FAn?= <marek.behun@nic.cz>
Cc: Michal Smulski <msmulski2@gmail.com>, f.fainelli@gmail.com,
	olteanv@gmail.com, netdev@vger.kernel.org,
	Michal Smulski <michal.smulski@ooma.com>
Subject: Re: [PATCH net-next v2] net: dsa: mv88e6xxx: implement USXGMII mode
 for mv88e6393x
Message-ID: <512cef84-b7f0-4532-86a3-6972d05ca25d@lunn.ch>
References: <20230527172024.9154-1-michal.smulski@ooma.com>
 <20230528092522.47enrnrslgflovmx@kandell>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230528092522.47enrnrslgflovmx@kandell>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Sun, May 28, 2023 at 11:25:22AM +0200, Marek Behún wrote:
> You need also to implement serdes_pcs_get_state for USXGMII.
> 
> Preferably by adding USXGMII relevant register constants into
> include/uapi/linux/mii.h, and using them to parse state register.

And if a standard is being followed here, please try to make the code
as helpers, so other USXGMII implementations can use them.

Thanks

	Andrew

