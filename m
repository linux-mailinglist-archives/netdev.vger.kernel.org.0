Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 604F821E021
	for <lists+netdev@lfdr.de>; Mon, 13 Jul 2020 20:50:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726863AbgGMSuJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jul 2020 14:50:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726830AbgGMSuI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jul 2020 14:50:08 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83AB1C061755
        for <netdev@vger.kernel.org>; Mon, 13 Jul 2020 11:50:08 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 1546212959C75;
        Mon, 13 Jul 2020 11:50:08 -0700 (PDT)
Date:   Mon, 13 Jul 2020 11:50:07 -0700 (PDT)
Message-Id: <20200713.115007.1453440698173777798.davem@davemloft.net>
To:     penguin-kernel@I-love.SAKURA.ne.jp
Cc:     kuba@kernel.org, netdev@vger.kernel.org, lkp@intel.com
Subject: Re: [PATCH] net: fddi: skfp: Remove addr_to_string().
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200713045330.3721-1-penguin-kernel@I-love.SAKURA.ne.jp>
References: <20200713045330.3721-1-penguin-kernel@I-love.SAKURA.ne.jp>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 13 Jul 2020 11:50:08 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Date: Mon, 13 Jul 2020 13:53:30 +0900

> kbuild test robot found that addr_to_string() is available only when
> DEBUG is defined. And I found that what that function is doing is
> what %pM will do. Thus, replace %s with %pM and remove thread-unsafe
> addr_to_string() function.
> 
> Reported-by: kbuild test robot <lkp@intel.com>
> Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>

Applied to net-next, thanks.
