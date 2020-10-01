Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 27E0F2807B5
	for <lists+netdev@lfdr.de>; Thu,  1 Oct 2020 21:26:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730093AbgJAT0M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Oct 2020 15:26:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729990AbgJAT0L (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Oct 2020 15:26:11 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5EAF2C0613D0
        for <netdev@vger.kernel.org>; Thu,  1 Oct 2020 12:26:11 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 422BE14431F57;
        Thu,  1 Oct 2020 12:09:23 -0700 (PDT)
Date:   Thu, 01 Oct 2020 12:26:10 -0700 (PDT)
Message-Id: <20201001.122610.1876945323502036999.davem@davemloft.net>
To:     saeed@kernel.org
Cc:     kuba@kernel.org, netdev@vger.kernel.org, saeedm@nvidia.com
Subject: Re: [pull request][net-next 00/15] mlx5 updates 2020-09-30
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20201001043302.48113-1-saeed@kernel.org>
References: <20201001043302.48113-1-saeed@kernel.org>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Thu, 01 Oct 2020 12:09:23 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: saeed@kernel.org
Date: Wed, 30 Sep 2020 21:32:47 -0700

> While the other Software steering buddy allocator series is being
> debated, I thought it is fine to submit this series which provides
> misc and small updates to mlx5 driver.
> 
> For more information please see tag log below.
> 
> This series doesn't conflict with the other ongoing mlx5 net and
> net-next submissions.
> Please pull and let me know if there is any problem.

Looks good, pulled, thanks.
