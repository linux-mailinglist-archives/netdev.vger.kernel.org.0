Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 99E292000C8
	for <lists+netdev@lfdr.de>; Fri, 19 Jun 2020 05:32:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729779AbgFSDcG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Jun 2020 23:32:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728117AbgFSDcG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Jun 2020 23:32:06 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B70EC06174E
        for <netdev@vger.kernel.org>; Thu, 18 Jun 2020 20:32:06 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id C1690120ED49C;
        Thu, 18 Jun 2020 20:32:05 -0700 (PDT)
Date:   Thu, 18 Jun 2020 20:32:04 -0700 (PDT)
Message-Id: <20200618.203204.1109556592791399326.davem@davemloft.net>
To:     martinvarghesenokia@gmail.com
Cc:     netdev@vger.kernel.org, martin.varghese@nokia.com
Subject: Re: [PATCH net v3] bareudp: Fixed multiproto mode configuration
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1592413223-9098-1-git-send-email-martinvarghesenokia@gmail.com>
References: <1592413223-9098-1-git-send-email-martinvarghesenokia@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 18 Jun 2020 20:32:05 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Martin Varghese <martinvarghesenokia@gmail.com>
Date: Wed, 17 Jun 2020 22:30:23 +0530

> From: Martin <martin.varghese@nokia.com>
> 
> Code to handle multiproto configuration is missing.
> 
> Fixes: 4b5f67232d95 ("net: Special handling for IP & MPLS")
> Signed-off-by: Martin <martin.varghese@nokia.com>

Applied and queued up for v5.7 -stable, thanks.

