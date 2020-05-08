Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 687B71C9FDA
	for <lists+netdev@lfdr.de>; Fri,  8 May 2020 02:56:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726612AbgEHA4c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 May 2020 20:56:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726509AbgEHA4c (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 May 2020 20:56:32 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E048C05BD43
        for <netdev@vger.kernel.org>; Thu,  7 May 2020 17:56:32 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 099B911937794;
        Thu,  7 May 2020 17:56:30 -0700 (PDT)
Date:   Thu, 07 May 2020 17:56:30 -0700 (PDT)
Message-Id: <20200507.175630.494283287134243359.davem@davemloft.net>
To:     jacob.e.keller@intel.com
Cc:     netdev@vger.kernel.org, kuba@kernel.org, apw@canonical.com,
        joe@perches.com
Subject: Re: [PATCH net-next] net: remove newlines in NL_SET_ERR_MSG_MOD
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200507005827.3919243-1-jacob.e.keller@intel.com>
References: <20200507005827.3919243-1-jacob.e.keller@intel.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 07 May 2020 17:56:31 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jacob Keller <jacob.e.keller@intel.com>
Date: Wed,  6 May 2020 17:58:27 -0700

> The NL_SET_ERR_MSG_MOD macro is used to report a string describing an
> error message to userspace via the netlink extended ACK structure. It
> should not have a trailing newline.
> 
> Add a cocci script which catches cases where the newline marker is
> present. Using this script, fix the handful of cases which accidentally
> included a trailing new line.
> 
> I couldn't figure out a way to get a patch mode working, so this script
> only implements context, report, and org.
> 
> Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>

Applied, thank you.
