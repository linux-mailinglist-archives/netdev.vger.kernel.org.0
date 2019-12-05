Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 813E111495E
	for <lists+netdev@lfdr.de>; Thu,  5 Dec 2019 23:37:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726298AbfLEWhW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Dec 2019 17:37:22 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:48650 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725988AbfLEWhW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Dec 2019 17:37:22 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1c3::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 7118B150AE465;
        Thu,  5 Dec 2019 14:37:21 -0800 (PST)
Date:   Thu, 05 Dec 2019 14:37:17 -0800 (PST)
Message-Id: <20191205.143717.568444634283796928.davem@davemloft.net>
To:     grygorii.strashko@ti.com
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, f.fainelli@gmail.com,
        nsekhar@ti.com, linux-kernel@vger.kernel.org, hkallweit1@gmail.com
Subject: Re: [PATCH] net: phy: dp83867: fix hfs boot in rgmii mode
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191204122232.18107-1-grygorii.strashko@ti.com>
References: <20191204122232.18107-1-grygorii.strashko@ti.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 05 Dec 2019 14:37:21 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Grygorii Strashko <grygorii.strashko@ti.com>
Date: Wed, 4 Dec 2019 14:22:32 +0200

> +	/* RX delay *must* be specified if internal delay of RX is used. */
 ...
> +	/* TX delay *must* be specified if internal delay of RX is used. */

Overzealous copy and paste here, the end of the second comment should say "TX"
instead of "RX".
