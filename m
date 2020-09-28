Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A7FA27B571
	for <lists+netdev@lfdr.de>; Mon, 28 Sep 2020 21:38:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726768AbgI1Thy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Sep 2020 15:37:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:37286 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726442AbgI1Thy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 28 Sep 2020 15:37:54 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 92F302076A;
        Mon, 28 Sep 2020 19:37:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601321874;
        bh=j56OtWOsLwRmRuTveOc1Sa5oBvWMvAjKxQ4ujUVpBhc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=jiBXwXZSoLdsJ2LGczAISiJDU2XSLKBQAL6caYshml7mMBTwlIyEzXBTlUjQlfvUZ
         IxAW0y4VJWvNOorSPbQyteqOe3Xasvs0ehZH/gJ4JsscHvdcWUWmqWSlyEPIs2SjD9
         PZw/ejxBV32wQ/yAfW2FcWqoRu5wxF9inFgxu204=
Date:   Mon, 28 Sep 2020 12:37:52 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Willy Liu <willy.liu@realtek.com>
Cc:     <andrew@lunn.ch>, <hkallweit1@gmail.com>, <linux@armlinux.org.uk>,
        <davem@davemloft.net>, <fancer.lancer@gmail.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <ryankao@realtek.com>, <kevans@FreeBSD.org>
Subject: Re: [PATCH net v3] net: phy: realtek: fix rtl8211e rx/tx delay
 config
Message-ID: <20200928123752.7d87a758@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <1601272343-32672-1-git-send-email-willy.liu@realtek.com>
References: <1601272343-32672-1-git-send-email-willy.liu@realtek.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 28 Sep 2020 13:52:23 +0800 Willy Liu wrote:
> diff --git a/drivers/net/phy/realtek.c b/drivers/net/phy/realtek.c
> old mode 100644
> new mode 100755

Please don't change the file mode to executable.

Checkpatch should warn you about this.
