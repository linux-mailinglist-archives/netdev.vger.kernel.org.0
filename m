Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3FA761A38CF
	for <lists+netdev@lfdr.de>; Thu,  9 Apr 2020 19:20:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726740AbgDIRUh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Apr 2020 13:20:37 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:33364 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726692AbgDIRUh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Apr 2020 13:20:37 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id A88DB128D4B44;
        Thu,  9 Apr 2020 10:20:36 -0700 (PDT)
Date:   Thu, 09 Apr 2020 10:20:35 -0700 (PDT)
Message-Id: <20200409.102035.13094168508101122.davem@davemloft.net>
To:     dqfext@gmail.com
Cc:     netdev@vger.kernel.org, opensource@vdorst.com, john@phrozen.org,
        vivien.didelot@gmail.com, f.fainelli@gmail.com, andrew@lunn.ch,
        sean.wang@mediatek.com, weijie.gao@mediatek.com
Subject: Re: [PATCH net-next] net: dsa: mt7530: enable jumbo frame
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200409155409.12043-1-dqfext@gmail.com>
References: <20200409155409.12043-1-dqfext@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 09 Apr 2020 10:20:37 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: DENG Qingfang <dqfext@gmail.com>
Date: Thu,  9 Apr 2020 23:54:09 +0800

> +static void
> +mt7530_set_jumbo(struct mt7530_priv *priv, u8 kilobytes)
> +{
> +	if (kilobytes > 15)
> +		kilobytes = 15;
 ...
> +	/* Enable jumbo frame up to 15 KB */
> +	mt7530_set_jumbo(priv, 15);

You've made the test quite pointless, honestly.
