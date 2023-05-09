Return-Path: <netdev+bounces-1156-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 8ABB06FC5C8
	for <lists+netdev@lfdr.de>; Tue,  9 May 2023 14:05:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B774E1C20B35
	for <lists+netdev@lfdr.de>; Tue,  9 May 2023 12:05:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 84F8117ACF;
	Tue,  9 May 2023 12:05:16 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7432D13AE4
	for <netdev@vger.kernel.org>; Tue,  9 May 2023 12:05:16 +0000 (UTC)
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FA6F1BC7;
	Tue,  9 May 2023 05:05:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
	s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
	Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
	Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
	bh=3Qs2Qwd1unjmDZV7UVMVZ7LHI9e7CBXfk5Zsx17orGA=; b=3NPjVmIVUtQLaM0MeI52Hbq6QU
	K2bmbPX4VYwb4PJRYkCM9qs/r2IZPH5hZI0P4gPf5/ny8qacy10WZnuITbF0vNlQHpDO1o8n3ShoF
	vaRl2BnXvCv9lTjO7jkdkdjje+MZzbWCnWR3RN/h0MZrgMvJEHOlT87qKeHtxzzQs/9o=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
	(envelope-from <andrew@lunn.ch>)
	id 1pwM5N-00CIRh-S5; Tue, 09 May 2023 14:04:53 +0200
Date: Tue, 9 May 2023 14:04:53 +0200
From: Andrew Lunn <andrew@lunn.ch>
To: wuych <yunchuan@nfschina.com>
Cc: davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
	michael@walle.cc, zhaoxiao@uniontech.com, andrew@aj.id.au,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	kernel-janitors@vger.kernel.org
Subject: Re: [PATCH net-next] freescale:Remove unnecessary (void*) conversions
Message-ID: <b959308c-e8ea-46e3-9277-ed8b4a610e06@lunn.ch>
References: <20230509102501.41685-1-yunchuan@nfschina.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230509102501.41685-1-yunchuan@nfschina.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Tue, May 09, 2023 at 06:25:01PM +0800, wuych wrote:
> Pointer variables of void * type do not require type cast.
> 
> Signed-off-by: wuych <yunchuan@nfschina.com>

Hi Wuych

Please be a bit more specific with your subject prefix.

To get an idea what others have used, you can do:

git log --oneline drivers/net/ethernet/freescale/

c248b27cfc0a Merge git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net
e2fdfd711912 net: dpaa: avoid one skb_reset_mac_header() in dpaa_enable_tx_csum()
461bb5b97049 net: dpaa: Fix uninitialized variable in dpaa_stop()
16a2c7634442 net: enetc: include MAC Merge / FP registers in register dump
827145392a4a net: enetc: only commit preemptible TCs to hardware when MM TX is active
153b5b1d030d net: enetc: report mm tx-active based on tx-enabled and verify-status
59be75db5966 net: enetc: fix MAC Merge layer remaining enabled until a link down event
01e23b2b3bad net: enetc: add support for preemptible traffic classes
50764da37cbe net: enetc: rename "mqprio" to "qopt"
800e68c44ffe Merge git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net
5b7be2d4fd6e net: enetc: workaround for unresponsive pMAC after receiving express traffic
37f9b2a6c086 net: ethernet: Add missing depends on MDIO_DEVRES
d9c960675adc Merge git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net
abc33494ddd5 net: fec: make use of MDIO C45 quirk
dc0a7b520071 Merge git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net
99d0f3a1095f net: dpaa2-mac: use Autoneg bit rather than an_enabled
c79493c3ccf0 net: enetc: fix aggregate RMON counters not showing the ranges
1a87e641d8a5 net: Use of_property_read_bool() for boolean properties
8ff99ad04c2e Merge tag 'phy-for-6.3' of git://git.kernel.org/pub/scm/linux/kernel/git/phy/linux-phy
1c93e48cc391 net: dpaa2-eth: do not always set xsk support in xdp_features flag

So at least add net. And since you only touch xgmac, you could use

net: xgmac: 

If you had touch multiple drivers within freescale then net:
freescale: would be better.

These prefixes are important. Reviewers tend to have interest in
specific parts of the kernel. The prefix is what draws their
attention, makes them look at a patch or not.

	   Andrew

