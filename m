Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 04DAE17288D
	for <lists+netdev@lfdr.de>; Thu, 27 Feb 2020 20:27:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729835AbgB0T1h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Feb 2020 14:27:37 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:44022 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727186AbgB0T1g (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Feb 2020 14:27:36 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 89CA11211040F;
        Thu, 27 Feb 2020 11:27:36 -0800 (PST)
Date:   Thu, 27 Feb 2020 11:27:35 -0800 (PST)
Message-Id: <20200227.112735.1994937905151986650.davem@davemloft.net>
To:     rmk+kernel@armlinux.org.uk
Cc:     ioana.ciornei@nxp.com, netdev@vger.kernel.org
Subject: Re: [PATCH] dpaa2-eth: add support for mii ioctls
From:   David Miller <davem@davemloft.net>
In-Reply-To: <E1j7Hq1-0004Fc-MX@rmk-PC.armlinux.org.uk>
References: <E1j7Hq1-0004Fc-MX@rmk-PC.armlinux.org.uk>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 27 Feb 2020 11:27:36 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Russell King <rmk+kernel@armlinux.org.uk>
Date: Thu, 27 Feb 2020 12:00:21 +0000

> Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>

Applied.
