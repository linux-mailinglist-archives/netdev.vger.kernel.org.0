Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 35A1B217865
	for <lists+netdev@lfdr.de>; Tue,  7 Jul 2020 21:57:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728776AbgGGT5Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jul 2020 15:57:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728523AbgGGT5Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jul 2020 15:57:24 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2916DC061755;
        Tue,  7 Jul 2020 12:57:24 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 0BCD9120F93E0;
        Tue,  7 Jul 2020 12:57:23 -0700 (PDT)
Date:   Tue, 07 Jul 2020 12:57:22 -0700 (PDT)
Message-Id: <20200707.125722.100914573433329091.davem@davemloft.net>
To:     vaibhavgupta40@gmail.com
Cc:     helgaas@kernel.org, bhelgaas@google.com, bjorn@helgaas.com,
        vaibhav.varodek@gmail.com, kuba@kernel.org, sfr@canb.auug.org.au,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-kernel-mentees@lists.linuxfoundation.org,
        skhan@linuxfoundation.org
Subject: Re: [PATCH net-next] sun/niu: add __maybe_unused attribute to PM
 functions
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200707074121.230686-1-vaibhavgupta40@gmail.com>
References: <20200707074121.230686-1-vaibhavgupta40@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 07 Jul 2020 12:57:23 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vaibhav Gupta <vaibhavgupta40@gmail.com>
Date: Tue,  7 Jul 2020 13:11:22 +0530

> The upgraded .suspend() and .resume() throw
> "defined but not used [-Wunused-function]" warning for certain
> configurations.
> 
> Mark them with "__maybe_unused" attribute.
> 
> Compile-tested only.
> 
> Fixes: b0db0cc2f695 ("sun/niu: use generic power management")
> Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
> Signed-off-by: Vaibhav Gupta <vaibhavgupta40@gmail.com>

Applied.
