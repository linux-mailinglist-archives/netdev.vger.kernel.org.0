Return-Path: <netdev+bounces-8516-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 001127246E0
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 16:53:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5EFF61C20A83
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 14:53:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E0B141D2BD;
	Tue,  6 Jun 2023 14:53:21 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D306E37B97
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 14:53:21 +0000 (UTC)
Received: from relay2-d.mail.gandi.net (relay2-d.mail.gandi.net [217.70.183.194])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8848A1990;
	Tue,  6 Jun 2023 07:53:04 -0700 (PDT)
X-GND-Sasl: maxime.chevallier@bootlin.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
	t=1686063182;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=1nWvmzDxkh9OccWxqcWuPVSP3S+KkgZMKouYOFSnOoQ=;
	b=KFIa1Sv7Y5D32xjDjhpnj6Nlqa0AtFJiHuZf8TBvJaks65m+1dEDAA87gyJBSYEoVH6Oof
	2xd2Wy64nbhjuFVFxSaeyWo0So5Bgza8Lcby8GKbLVBg0mnFlOkBJp0L8M0AKEpVpuDEgk
	DNjY2yeR422Qi6LMQ+jTIYkYqw24UR+gzxk1xIyrgkb2m+MFctG7JytTp6sox8KuQp4VHM
	XQSs67Zh6T513xz8mgp1vk0PisRHfSayVYiRx6m/KuJW9u+TPJTBqeIzkyBj45vPrKUe5U
	BI+WAyHMOv5RJdHS+3am7TpkKKVKS6kesr/kkVpWMJIVXVaokQHu2n9qwzcn9w==
X-GND-Sasl: maxime.chevallier@bootlin.com
X-GND-Sasl: maxime.chevallier@bootlin.com
X-GND-Sasl: maxime.chevallier@bootlin.com
X-GND-Sasl: maxime.chevallier@bootlin.com
X-GND-Sasl: maxime.chevallier@bootlin.com
X-GND-Sasl: maxime.chevallier@bootlin.com
X-GND-Sasl: maxime.chevallier@bootlin.com
X-GND-Sasl: maxime.chevallier@bootlin.com
X-GND-Sasl: maxime.chevallier@bootlin.com
X-GND-Sasl: maxime.chevallier@bootlin.com
X-GND-Sasl: maxime.chevallier@bootlin.com
X-GND-Sasl: maxime.chevallier@bootlin.com
X-GND-Sasl: maxime.chevallier@bootlin.com
X-GND-Sasl: maxime.chevallier@bootlin.com
X-GND-Sasl: maxime.chevallier@bootlin.com
X-GND-Sasl: maxime.chevallier@bootlin.com
X-GND-Sasl: maxime.chevallier@bootlin.com
X-GND-Sasl: maxime.chevallier@bootlin.com
X-GND-Sasl: maxime.chevallier@bootlin.com
X-GND-Sasl: maxime.chevallier@bootlin.com
Received: by mail.gandi.net (Postfix) with ESMTPSA id EF9A440003;
	Tue,  6 Jun 2023 14:52:58 +0000 (UTC)
Date: Tue, 6 Jun 2023 16:52:52 +0200
From: Maxime Chevallier <maxime.chevallier@bootlin.com>
To: "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc: davem@davemloft.net, netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org, alexis.lothore@bootlin.com,
 thomas.petazzoni@bootlin.com, Andrew Lunn <andrew@lunn.ch>, Jakub Kicinski
 <kuba@kernel.org>, Eric Dumazet <edumazet@google.com>, Paolo Abeni
 <pabeni@redhat.com>, Florian Fainelli <f.fainelli@gmail.com>, Heiner
 Kallweit <hkallweit1@gmail.com>, Vladimir Oltean <vladimir.oltean@nxp.com>,
 Ioana Ciornei <ioana.ciornei@nxp.com>,
 linux-stm32@st-md-mailman.stormreply.com,
 linux-arm-kernel@lists.infradead.org, Maxime Coquelin
 <mcoquelin.stm32@gmail.com>, Jose Abreu <joabreu@synopsys.com>, Alexandre
 Torgue <alexandre.torgue@foss.st.com>, Giuseppe Cavallaro
 <peppe.cavallaro@st.com>, Simon Horman <simon.horman@corigine.com>
Subject: Re: [PATCH net-next v2 0/3] Followup fixes for the dwmac and altera
 lynx conversion
Message-ID: <20230606165252.34a1593c@pc-7.home>
In-Reply-To: <ZH9DlUqwm3YsNPu6@shell.armlinux.org.uk>
References: <20230606142144.308675-1-maxime.chevallier@bootlin.com>
	<ZH9DlUqwm3YsNPu6@shell.armlinux.org.uk>
Organization: Bootlin
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.37; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
	RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Hello Russell,

On Tue, 6 Jun 2023 15:32:53 +0100
"Russell King (Oracle)" <linux@armlinux.org.uk> wrote:

> On Tue, Jun 06, 2023 at 04:21:41PM +0200, Maxime Chevallier wrote:
> > Following the TSE PCS removal and port of altera_tse and dwmac_socfpga,
> > this series fixes some issues that slipped through the cracks.
> > 
> > Patch 1 fixes an unitialized struct in altera_tse
> > 
> > Patch 2 uses the correct Kconfig option for altera_tse
> > 
> > Patch 3 makes the Lynx PCS specific to dwmac_socfpga. This patch was
> > originally written by Russell, my modifications just moves the
> > #include<linux/pcs-lynx.h> around, to use it only in dwmac_socfpga.  
> 
> Hi Maxime,
> 
> I'm sorry, but I think you need an extra patch added to this series.

Gosh you're right... The same this also goes for altera_tse... 

> Other than that, the series looks good. Thanks.

I'll followup shortly then. Nice catch !

Thanks,

Maxime

