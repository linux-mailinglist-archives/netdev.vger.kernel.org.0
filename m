Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F325E20F1A
	for <lists+netdev@lfdr.de>; Thu, 16 May 2019 21:15:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727014AbfEPTP1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 May 2019 15:15:27 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:60126 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726677AbfEPTP0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 May 2019 15:15:26 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d8])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 130E912D8E1EE;
        Thu, 16 May 2019 12:15:26 -0700 (PDT)
Date:   Thu, 16 May 2019 12:15:25 -0700 (PDT)
Message-Id: <20190516.121525.1138059417412741913.davem@davemloft.net>
To:     madalin.bucur@nxp.com
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, hkallweit1@gmail.com
Subject: Re: [PATCH v2] net: phy: aquantia: readd XGMII support for AQR107
From:   David Miller <davem@davemloft.net>
In-Reply-To: <VI1PR04MB556702627553CF4C8B65EE9FEC090@VI1PR04MB5567.eurprd04.prod.outlook.com>
References: <VI1PR04MB556702627553CF4C8B65EE9FEC090@VI1PR04MB5567.eurprd04.prod.outlook.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 16 May 2019 12:15:26 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Madalin-cristian Bucur <madalin.bucur@nxp.com>
Date: Wed, 15 May 2019 15:07:44 +0000

> XGMII interface mode no longer works on AQR107 after the recent changes,
> adding back support.
> 
> Fixes: 570c8a7d5303 ("net: phy: aquantia: check for supported interface modes in config_init")
> Signed-off-by: Madalin Bucur <madalin.bucur@nxp.com>

Applied, thanks.
