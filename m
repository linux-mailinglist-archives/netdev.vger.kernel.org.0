Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4378D4541E
	for <lists+netdev@lfdr.de>; Fri, 14 Jun 2019 07:42:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725972AbfFNFl7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jun 2019 01:41:59 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:37310 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725801AbfFNFl7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Jun 2019 01:41:59 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 7DFA814DD924D;
        Thu, 13 Jun 2019 22:41:58 -0700 (PDT)
Date:   Thu, 13 Jun 2019 22:41:58 -0700 (PDT)
Message-Id: <20190613.224158.681315027941410948.davem@davemloft.net>
To:     hancock@sedsystems.ca
Cc:     netdev@vger.kernel.org, anirudh@xilinx.com, John.Linn@xilinx.com,
        andrew@lunn.ch
Subject: Re: [PATCH net-next] net: axienet: move use of resource after
 validity check
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1560272162-14856-1-git-send-email-hancock@sedsystems.ca>
References: <1560272162-14856-1-git-send-email-hancock@sedsystems.ca>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 13 Jun 2019 22:41:58 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Robert Hancock <hancock@sedsystems.ca>
Date: Tue, 11 Jun 2019 10:56:02 -0600

> We were accessing the pointer returned from platform_get_resource before
> checking if it was valid, causing an oops if it was not. Move this access
> after the call to devm_ioremap_resource which does the validity check.
> 
> Signed-off-by: Robert Hancock <hancock@sedsystems.ca>

Applied.
