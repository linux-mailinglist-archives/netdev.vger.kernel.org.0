Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4C5B012AF91
	for <lists+netdev@lfdr.de>; Fri, 27 Dec 2019 00:15:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726893AbfLZXPk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Dec 2019 18:15:40 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:44462 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726277AbfLZXPj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Dec 2019 18:15:39 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1c3::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 44FBE15393581;
        Thu, 26 Dec 2019 15:15:39 -0800 (PST)
Date:   Thu, 26 Dec 2019 15:15:38 -0800 (PST)
Message-Id: <20191226.151538.1355208508125983444.davem@davemloft.net>
To:     madalin.bucur@oss.nxp.com
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH net,v2] net: phy: aquantia: add suspend / resume ops
 for AQR105
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1577088370-21954-1-git-send-email-madalin.bucur@oss.nxp.com>
References: <1577088370-21954-1-git-send-email-madalin.bucur@oss.nxp.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 26 Dec 2019 15:15:39 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Madalin Bucur <madalin.bucur@oss.nxp.com>
Date: Mon, 23 Dec 2019 10:06:10 +0200

> The suspend/resume code for AQR107 works on AQR105 too.
> This patch fixes issues with the partner not seeing the link down
> when the interface using AQR105 is brought down.
> 
> Fixes: bee8259dd31f ("net: phy: add driver for aquantia phy")
> Signed-off-by: Madalin Bucur <madalin.bucur@oss.nxp.com>
> ---
> 
> Changes from v1: add Fixes: tag

Applied and queued up for -stable, thanks.
