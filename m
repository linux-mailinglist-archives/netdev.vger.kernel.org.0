Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6C35B127361
	for <lists+netdev@lfdr.de>; Fri, 20 Dec 2019 03:10:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727191AbfLTCKX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Dec 2019 21:10:23 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:45298 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727016AbfLTCKX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Dec 2019 21:10:23 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1c3::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 7FECF154169B9;
        Thu, 19 Dec 2019 18:10:22 -0800 (PST)
Date:   Thu, 19 Dec 2019 18:10:21 -0800 (PST)
Message-Id: <20191219.181021.2116507375239676187.davem@davemloft.net>
To:     f.fainelli@gmail.com
Cc:     netdev@vger.kernel.org, jakub.kicinski@netronome.com,
        bcm-kernel-feedback-list@broadcom.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] net: systemport: Set correct DMA mask
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191218002950.2125-1-f.fainelli@gmail.com>
References: <20191218002950.2125-1-f.fainelli@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 19 Dec 2019 18:10:22 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Fainelli <f.fainelli@gmail.com>
Date: Tue, 17 Dec 2019 16:29:50 -0800

> SYSTEMPORT is capabable of doing up to 40-bit of physical addresses, set
> an appropriate DMA mask to permit that.
> 
> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>

Applied, thanks Florian.
