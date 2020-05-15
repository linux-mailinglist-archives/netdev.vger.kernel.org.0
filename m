Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 67E781D4225
	for <lists+netdev@lfdr.de>; Fri, 15 May 2020 02:37:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727922AbgEOAg6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 May 2020 20:36:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727123AbgEOAg6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 May 2020 20:36:58 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 161ABC061A0C
        for <netdev@vger.kernel.org>; Thu, 14 May 2020 17:36:58 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 418C214CE118F;
        Thu, 14 May 2020 17:36:57 -0700 (PDT)
Date:   Thu, 14 May 2020 17:36:56 -0700 (PDT)
Message-Id: <20200514.173656.904859689209825339.davem@davemloft.net>
To:     kuba@kernel.org
Cc:     jiri@resnulli.us, jacob.e.keller@intel.com, netdev@vger.kernel.org,
        kernel-team@fb.com
Subject: Re: [PATCH net-next] devlink: refactor end checks in
 devlink_nl_cmd_region_read_dumpit
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200513172822.2663102-1-kuba@kernel.org>
References: <20200513172822.2663102-1-kuba@kernel.org>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 14 May 2020 17:36:57 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jakub Kicinski <kuba@kernel.org>
Date: Wed, 13 May 2020 10:28:22 -0700

> Clean up after recent fixes, move address calculations
> around and change the variable init, so that we can have
> just one start_offset == end_offset check.
> 
> Make the check a little stricter to preserve the -EINVAL
> error if requested start offset is larger than the region
> itself.
> 
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>

Applied, thanks.
