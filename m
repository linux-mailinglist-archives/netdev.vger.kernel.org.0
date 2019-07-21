Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DAA336F4BF
	for <lists+netdev@lfdr.de>; Sun, 21 Jul 2019 20:45:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727164AbfGUSpv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 21 Jul 2019 14:45:51 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:33700 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726946AbfGUSpv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 21 Jul 2019 14:45:51 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id C08EE15258BDD;
        Sun, 21 Jul 2019 11:45:49 -0700 (PDT)
Date:   Sun, 21 Jul 2019 11:45:49 -0700 (PDT)
Message-Id: <20190721.114549.696172160733707996.davem@davemloft.net>
To:     yanjun.zhu@oracle.com
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCHv2 0/2] forcedeth: recv cache to make NIC work steadily
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1563713633-25528-1-git-send-email-yanjun.zhu@oracle.com>
References: <1563713633-25528-1-git-send-email-yanjun.zhu@oracle.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 21 Jul 2019 11:45:49 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


I made it abundantly clear that I am completely not supportive of
changes like this.

If anything, we need to improve the behavior of the core kernel
allocators, and the mid-level networking interfaces which use them,
to fix problems like this.

It is absolutely not sustainable to have every driver implement
a cache of some sort to "improve" allocation behavior.

Sorry, there is no way in the world I'm applying changes like
these.
