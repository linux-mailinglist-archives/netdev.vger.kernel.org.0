Return-Path: <netdev+bounces-8849-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id AE2E472607A
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 15:06:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4956C281249
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 13:06:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8E18113AD6;
	Wed,  7 Jun 2023 13:06:50 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8041E139F
	for <netdev@vger.kernel.org>; Wed,  7 Jun 2023 13:06:50 +0000 (UTC)
Received: from relay3-d.mail.gandi.net (relay3-d.mail.gandi.net [217.70.183.195])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3889C1735;
	Wed,  7 Jun 2023 06:06:48 -0700 (PDT)
X-GND-Sasl: maxime.chevallier@bootlin.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
	t=1686143206;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ggWob9vtY0Djr17PY8lKC6mFlnjKE6vYyx6twxFu3PY=;
	b=hdjmQS6guLefKbW5moM86dBnkb2Hs7N3ZQ+u+EmbR1UWxNARCh6c/vl8JTKyTyxCuUDerG
	0DlBVcLYtg69k2yNJ3TNGC+WQqeszDJSIlBS9L+D+YuZL0A6Q93m1QqClt7/s3f9WjlqTx
	MoumXnXcrEdzz25YcPtMeqNJ1qKeIhClm7J4lb45YYpnteJPfTPwQYvubqg3zowjD6kJw/
	/5ws7IGuuQlJVI6wqoVXaB2jjsehXInDf2IfSoDG4xAJnImNd51gC8CEh5L5IN4CPOMh9z
	OfbqmpwpLdM0VqkPhrO2WWELfWzgFsWuLyrmQH8eDbP98SBO4O4yM7W0xApWtQ==
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
X-GND-Sasl: maxime.chevallier@bootlin.com
X-GND-Sasl: maxime.chevallier@bootlin.com
Received: by mail.gandi.net (Postfix) with ESMTPSA id A396E6000D;
	Wed,  7 Jun 2023 13:06:42 +0000 (UTC)
Date: Wed, 7 Jun 2023 16:53:24 +0200
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
 <peppe.cavallaro@st.com>, Simon Horman <simon.horman@corigine.com>, Maciej
 Fijalkowski <maciej.fijalkowski@intel.com>, Feiyang Chen
 <chenfeiyang@loongson.cn>
Subject: Re: [PATCH net-next v4 4/5] net: altera_tse: explicitly disable
 autoscan on the regmap-mdio bus
Message-ID: <20230607165324.37f981f5@pc-7.home>
In-Reply-To: <ZIB3gQ7Ul5gi5/RC@shell.armlinux.org.uk>
References: <20230607135941.407054-1-maxime.chevallier@bootlin.com>
	<20230607135941.407054-5-maxime.chevallier@bootlin.com>
	<ZIB3gQ7Ul5gi5/RC@shell.armlinux.org.uk>
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

On Wed, 7 Jun 2023 13:26:41 +0100
"Russell King (Oracle)" <linux@armlinux.org.uk> wrote:

> On Wed, Jun 07, 2023 at 03:59:40PM +0200, Maxime Chevallier wrote:
> > Set the .autoscan flag to false on the regmap-mdio bus, to avoid using a
> > random uninitialized value. We don't want autoscan in this case as the
> > mdio device is a PCS and not a PHY.  
> 
> Isn't this now covered by patch 1's memset of mrc?
> 

Yes it is, however I thought it could be fine keeping it set explicitely
anyway, as we do have a PCS on that bus and we don't want any autoscan
happening. Since these two drivers are the first users of mdio_regmap,
my hope is that we could get these reference usages covering all fields.

Should I drop this ?

Maxime

