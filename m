Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9CBED1B6760
	for <lists+netdev@lfdr.de>; Fri, 24 Apr 2020 01:00:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727913AbgDWW77 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Apr 2020 18:59:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726062AbgDWW77 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Apr 2020 18:59:59 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59CE7C09B042
        for <netdev@vger.kernel.org>; Thu, 23 Apr 2020 15:59:59 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id B0078127EB5A5;
        Thu, 23 Apr 2020 15:59:57 -0700 (PDT)
Date:   Thu, 23 Apr 2020 15:59:56 -0700 (PDT)
Message-Id: <20200423.155956.49944775917212535.davem@davemloft.net>
To:     corbet@lwn.net
Cc:     netdev@vger.kernel.org, rubini@gnu.org, jan.kiszka@siemens.com,
        ralf@linux-mips.org, kstewart@linuxfoundation.org,
        oliver.fendt@siemens.com
Subject: Re: [PATCH] net: meth: remove spurious copyright text
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200423093903.171b3999@lwn.net>
References: <20200423093903.171b3999@lwn.net>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 23 Apr 2020 15:59:58 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jonathan Corbet <corbet@lwn.net>
Date: Thu, 23 Apr 2020 09:39:03 -0600

> Evidently, at some point in the pre-githistorious past,
> drivers/net/ethernet/sgi/meth.h somehow contained some code from the
> "snull" driver from the Linux Device Drivers book.  A comment crediting
> that source, asserting copyright ownership by the LDD authors, and imposing
> the LDD2 license terms was duly added to the file.
> 
> Any code that may have been derived from snull is long gone, and the
> distribution terms are not GPL-compatible.  Since the copyright claim is
> not based in fact (if it ever was), simply remove it and the distribution
> terms as well.
> 
> Reported-by: Jan Kiszka <jan.kiszka@siemens.com>
> Acked-by: Alessandro Rubini <rubini@gnudd.com>
> CC: Ralf Baechle <ralf@linux-mips.org>
> CC: Kate Stewart <kstewart@linuxfoundation.org>
> CC: "Fendt, Oliver" <oliver.fendt@siemens.com>
> Signed-off-by: Jonathan Corbet <corbet@lwn.net>

Applied, thank you.
