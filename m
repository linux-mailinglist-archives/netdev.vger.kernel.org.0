Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5592517879C
	for <lists+netdev@lfdr.de>; Wed,  4 Mar 2020 02:36:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728370AbgCDBgZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Mar 2020 20:36:25 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:38128 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728317AbgCDBgZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Mar 2020 20:36:25 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id C9B7C15AD7913;
        Tue,  3 Mar 2020 17:36:24 -0800 (PST)
Date:   Tue, 03 Mar 2020 17:36:22 -0800 (PST)
Message-Id: <20200303.173622.784416257680252915.davem@davemloft.net>
To:     jacob.e.keller@intel.com
Cc:     netdev@vger.kernel.org, jiri@resnulli.us
Subject: Re: [PATCH] devlink: remove trigger command from devlink-region.rst
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200302222119.52140-1-jacob.e.keller@intel.com>
References: <20200302222119.52140-1-jacob.e.keller@intel.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 03 Mar 2020 17:36:25 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jacob Keller <jacob.e.keller@intel.com>
Date: Mon,  2 Mar 2020 14:21:19 -0800

> The devlink trigger command does not exist. While rewriting the
> documentation for devlink into the reStructuredText format,
> documentation for the trigger command was accidentally merged in. This
> occurred because the author was also working on a potential extension to
> devlink regions which included this trigger command, and accidentally
> squashed the documentation incorrectly.
> 
> Further review eventually settled on using the previously unused "new"
> command instead of creating a new trigger command.
> 
> Fix this by removing mention of the trigger command from the
> documentation.
> 
> Fixes: 0b0f945f5458 ("devlink: add a file documenting devlink regions", 2020-01-10)
> Noticed-by: Jiri Pirko <jiri@resnulli.us>
> Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>

Applied, thanks.
