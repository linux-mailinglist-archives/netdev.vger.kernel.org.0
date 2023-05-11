Return-Path: <netdev+bounces-1615-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 68F116FE8BE
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 02:34:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8942C28161E
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 00:34:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A4DCC39C;
	Thu, 11 May 2023 00:34:51 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A060365
	for <netdev@vger.kernel.org>; Thu, 11 May 2023 00:34:51 +0000 (UTC)
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE25459C0;
	Wed, 10 May 2023 17:34:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
	s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
	Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
	Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
	bh=SSQW4tiYATgQuO+xcl9Ah2yxbFicjpEMjAjRIi4512E=; b=rqYP6+DwsvXTDnOD+XdKZMKI3N
	lraYI8v8YK7uqcIb1lqBFELdQvLdZrHU+oqZ3mt6fc/6Ghy0IeTkaYyBgS+aq6k5vNGoEYsmsNtkB
	w6Uukusg7XsqbOrLuzS/JsUTAMwUU6OeBx7CX1dEJ38IiOEQ2p7ujRHPmPONDvN633PY=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
	(envelope-from <andrew@lunn.ch>)
	id 1pwuGb-00CUs0-Al; Thu, 11 May 2023 02:34:45 +0200
Date: Thu, 11 May 2023 02:34:45 +0200
From: Andrew Lunn <andrew@lunn.ch>
To: Daniel Golle <daniel@makrotopia.org>
Cc: netdev@vger.kernel.org, linux-mediatek@lists.infradead.org,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	Heiner Kallweit <hkallweit1@gmail.com>,
	Russell King <linux@armlinux.org.uk>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Subject: Re: [PATCH 1/8] net: phy: realtek: rtl8221: allow to configure
 SERDES mode
Message-ID: <303352e7-33f6-45d6-b93d-061f84a027da@lunn.ch>
References: <cover.1683756691.git.daniel@makrotopia.org>
 <302d982c5550f10d589735fc2e46cf27386c39f4.1683756691.git.daniel@makrotopia.org>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <302d982c5550f10d589735fc2e46cf27386c39f4.1683756691.git.daniel@makrotopia.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Thu, May 11, 2023 at 12:56:12AM +0200, Daniel Golle wrote:
> From: Alexander Couzens <lynxis@fe80.eu>

Hi Daniel

Why are we getting two copies of this patch from different people?

I would expect to see just this version, sent by Daniel Golle and the
first line being From: Alexander Couzens <lynxis@fe80.eu> to indicate
the primary author.

> Signed-off-by: Alexander Couzens <lynxis@fe80.eu>

Your Signed-off-by: should be here as well, since you are submitting
the patch.

    Andrew

