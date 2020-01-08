Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 845C8134E78
	for <lists+netdev@lfdr.de>; Wed,  8 Jan 2020 22:09:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727370AbgAHVJe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jan 2020 16:09:34 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:47842 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726836AbgAHVJd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jan 2020 16:09:33 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1c3::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id D713D1584D0BD;
        Wed,  8 Jan 2020 13:09:32 -0800 (PST)
Date:   Wed, 08 Jan 2020 13:09:32 -0800 (PST)
Message-Id: <20200108.130932.721413767130819084.davem@davemloft.net>
To:     vijaykhemka@fb.com
Cc:     sam@mendozajonas.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, joel@jms.id.au,
        linux-aspeed@lists.ozlabs.org, sdasari@fb.com
Subject: Re: [net-next PATCH] net/ncsi: Send device address as source
 address
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200107193034.1322431-1-vijaykhemka@fb.com>
References: <20200107193034.1322431-1-vijaykhemka@fb.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 08 Jan 2020 13:09:33 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vijay Khemka <vijaykhemka@fb.com>
Date: Tue, 7 Jan 2020 11:30:33 -0800

> After receiving device mac address from device, send this as
> a source address for further commands instead of broadcast
> address.
> 
> This will help in multi host NIC cards.
> 
> Signed-off-by: Vijay Khemka <vijaykhemka@fb.com>

Applied to net-next, thanks.
