Return-Path: <netdev+bounces-4327-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id CB9E770C153
	for <lists+netdev@lfdr.de>; Mon, 22 May 2023 16:42:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 56F2D1C20AE8
	for <lists+netdev@lfdr.de>; Mon, 22 May 2023 14:42:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 81F0113AEF;
	Mon, 22 May 2023 14:42:15 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72DADD53A
	for <netdev@vger.kernel.org>; Mon, 22 May 2023 14:42:15 +0000 (UTC)
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A38411F;
	Mon, 22 May 2023 07:42:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
	s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
	Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
	Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
	bh=yfi//GuVvnr5PG0d0W18/s2Qr7V1R3hb5jrrCaCC3TI=; b=anG5KyX3cDc/wpxOdVMDgva8g1
	96+jO8g6+JTdj0nXlDFytD2t8ZuhNjId6uKXNV/1aWUW+jJ6QmgA/zBULGq+MIE45x/2f3m1lwZMk
	TcSkJXgu3Z98UaovUT+/DIjlZ+CUJ8OZD+4YFVLvL47A1rPU8MlewUU03r/Mgp0zTs4A=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
	(envelope-from <andrew@lunn.ch>)
	id 1q16ja-00DYOd-Ih; Mon, 22 May 2023 16:42:02 +0200
Date: Mon, 22 May 2023 16:42:02 +0200
From: Andrew Lunn <andrew@lunn.ch>
To: David Epping <david.epping@missinglinkelectronics.com>
Cc: Vladimir Oltean <olteanv@gmail.com>,
	Heiner Kallweit <hkallweit1@gmail.com>,
	Russell King <linux@armlinux.org.uk>,
	"David S . Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	UNGLinuxDriver@microchip.com
Subject: Re: [PATCH net 3/3] net: phy: mscc: enable VSC8501/2 RGMII RX clock
Message-ID: <70234187-3e7d-4932-8b07-42973337ecb1@lunn.ch>
References: <20230520160603.32458-1-david.epping@missinglinkelectronics.com>
 <20230520160603.32458-4-david.epping@missinglinkelectronics.com>
 <20230521134356.ar3itavhdypnvasc@skbuf>
 <20230521161650.GC2208@nucnuc.mle>
 <20230522095833.otk2nv24plmvarpt@skbuf>
 <20230522140057.GB18381@nucnuc.mle>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230522140057.GB18381@nucnuc.mle>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

> Its my first patch re-submission, so sorry for the noob question:
> Should I include your "pw-bot: changes-requested" tag with the third
> patch? Probably not.

No.

There is a robot listening to emails, and when it sees pw-bot: It uses
the label to change the state of the patch in patchworks:

https://patchwork.kernel.org/project/netdevbpf/list/

The robot does have some basic authentication, so it should actually
ignore such a line from you, since you are not a Maintainer. But even
so, you don't want to make your own new patches as needing changes.

    Andrew

