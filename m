Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F216517B3D2
	for <lists+netdev@lfdr.de>; Fri,  6 Mar 2020 02:38:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726282AbgCFBia (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Mar 2020 20:38:30 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:58564 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726162AbgCFBia (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Mar 2020 20:38:30 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id E0C2D1556B091;
        Thu,  5 Mar 2020 17:38:29 -0800 (PST)
Date:   Thu, 05 Mar 2020 17:38:29 -0800 (PST)
Message-Id: <20200305.173829.752350510076125241.davem@davemloft.net>
To:     willy@infradead.org
Cc:     tlfalcon@linux.ibm.com, netdev@vger.kernel.org
Subject: Re: [PATCH] ibmveth: Remove unused page_offset macro
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200304035455.GA29971@bombadil.infradead.org>
References: <20200304035455.GA29971@bombadil.infradead.org>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 05 Mar 2020 17:38:30 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Matthew Wilcox <willy@infradead.org>
Date: Tue, 3 Mar 2020 19:54:55 -0800

> From: Matthew Wilcox (Oracle) <willy@infradead.org>
> 
> We already have a function called page_offset(), and this macro
> is unused, so just delete it.
> 
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>

Applied to net-next, thanks!
