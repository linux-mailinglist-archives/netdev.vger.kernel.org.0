Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 60C061D3DEF
	for <lists+netdev@lfdr.de>; Thu, 14 May 2020 21:50:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728616AbgENTuM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 May 2020 15:50:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727833AbgENTuM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 May 2020 15:50:12 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 920E7C061A0C;
        Thu, 14 May 2020 12:50:12 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id B59DA128CF137;
        Thu, 14 May 2020 12:50:11 -0700 (PDT)
Date:   Thu, 14 May 2020 12:50:11 -0700 (PDT)
Message-Id: <20200514.125011.743722610194113216.davem@davemloft.net>
To:     madhuparnabhowmik10@gmail.com
Cc:     kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org, kuba@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        sfr@canb.auug.org.au, frextrite@gmail.com, joel@joelfernandes.org,
        paulmck@kernel.org, cai@lca.pw
Subject: Re: [PATCH] Fix suspicious RCU usage warning
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200514070409.GA3174@madhuparna-HP-Notebook>
References: <20200513061610.22313-1-madhuparnabhowmik10@gmail.com>
        <20200513.120010.124458176293400943.davem@davemloft.net>
        <20200514070409.GA3174@madhuparna-HP-Notebook>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 14 May 2020 12:50:12 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Madhuparna Bhowmik <madhuparnabhowmik10@gmail.com>
Date: Thu, 14 May 2020 12:34:09 +0530

> Sorry for this malformed patch, I have sent a patch with all these
> corrections.

It still needs more work, see Jakub's feedback.

Thank you.
