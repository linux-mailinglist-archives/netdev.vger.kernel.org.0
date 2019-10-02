Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C71DBC8C38
	for <lists+netdev@lfdr.de>; Wed,  2 Oct 2019 17:03:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726126AbfJBPDO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Oct 2019 11:03:14 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:60982 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725766AbfJBPDO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Oct 2019 11:03:14 -0400
Received: from localhost (unknown [IPv6:2603:3023:50c:85e1:b5c5:ae11:3e54:6a07])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 0B599148855A9;
        Wed,  2 Oct 2019 08:03:13 -0700 (PDT)
Date:   Wed, 02 Oct 2019 11:03:11 -0400 (EDT)
Message-Id: <20191002.110311.1817458025415587636.davem@davemloft.net>
To:     tuong.t.lien@dektech.com.au
Cc:     jon.maloy@ericsson.com, maloy@donjonn.com, ying.xue@windriver.com,
        netdev@vger.kernel.org, tipc-discussion@lists.sourceforge.net
Subject: Re: [net] tipc: fix unlimited bundling of small messages
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191002114943.19889-1-tuong.t.lien@dektech.com.au>
References: <20191002114943.19889-1-tuong.t.lien@dektech.com.au>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 02 Oct 2019 08:03:13 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tuong Lien <tuong.t.lien@dektech.com.au>
Date: Wed,  2 Oct 2019 18:49:43 +0700

> We have identified a problem with the "oversubscription" policy in the
> link transmission code.
 ...

Applied and queued up for -stable.
