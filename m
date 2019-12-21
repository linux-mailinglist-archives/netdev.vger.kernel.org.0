Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4AA32128797
	for <lists+netdev@lfdr.de>; Sat, 21 Dec 2019 06:36:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726057AbfLUFgY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 21 Dec 2019 00:36:24 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:56978 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725773AbfLUFgY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 21 Dec 2019 00:36:24 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1c3::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id CFFFC153D7128;
        Fri, 20 Dec 2019 21:36:23 -0800 (PST)
Date:   Fri, 20 Dec 2019 21:36:23 -0800 (PST)
Message-Id: <20191220.213623.2272694380359701966.davem@davemloft.net>
To:     madalin.bucur@nxp.com, madalin.bucur@oss.nxp.com
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH net] net: phy: aquantia: add suspend / resume ops for
 AQR105
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1576765022-10928-1-git-send-email-madalin.bucur@oss.nxp.com>
References: <1576765022-10928-1-git-send-email-madalin.bucur@oss.nxp.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 20 Dec 2019 21:36:24 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Madalin Bucur <madalin.bucur@oss.nxp.com>
Date: Thu, 19 Dec 2019 16:17:02 +0200

> The suspend/resume code for AQR107 works on AQR105 too.
> This patch fixes issues with the partner not seeing the link down
> when the interface using AQR105 is brought down.
> 
> Signed-off-by: Madalin Bucur <madalin.bucur@oss.nxp.com>

For bug fixes please provide an appropriate Fixes: tag.
