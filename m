Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 31A886BF7FD
	for <lists+netdev@lfdr.de>; Sat, 18 Mar 2023 06:27:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230042AbjCRF1G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Mar 2023 01:27:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229517AbjCRF1F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Mar 2023 01:27:05 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C625E92BE4;
        Fri, 17 Mar 2023 22:27:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1505C60A0C;
        Sat, 18 Mar 2023 05:27:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08C95C433D2;
        Sat, 18 Mar 2023 05:27:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679117223;
        bh=r4+BqP3YSFtjbv0/3mAVAwU8CYroXzeU3ygvL9ZK6no=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=u5nsWYtljKwlJbqnqxDA3eiTLKleC3/EU5gUGHeZ7yQPAjtoN0XidGcLChStmtYUB
         4aNApDQAC4CaHvXWGzxdinMfp6VWuPw0eNorlO3MgC47eyQOtGwaBD1zLqHFplU5Bl
         7Dwks9NNQJIt0iv+cIbpIdP+zJiQkvKU7vgPwL+GdYGMdLXE8/ba5ofThEuMdBQfYq
         GW7H5tXQfW3wWKCG4UGtT10I38axlYHjomIZd6LXvF2pTswd4iI0LsbQ/uFY7oiaVy
         yexBVceaUZLmC/ZsWb5jyLe2o7z4lTgE+Rz5DA9/vIYV4CcoRLyfUV4CutK4rRGKik
         K4tv5v9OoHQcg==
Date:   Fri, 17 Mar 2023 22:27:02 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Szymon Heidrich <szymon.heidrich@gmail.com>
Cc:     woojung.huh@microchip.com, UNGLinuxDriver@microchip.com,
        davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
        linux-usb@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel test robot <lkp@intel.com>
Subject: Re: [PATCH v2] net: usb: lan78xx: Limit packet length to skb->len
Message-ID: <20230317222702.1bfd2613@kernel.org>
In-Reply-To: <20230317173606.91426-1-szymon.heidrich@gmail.com>
References: <202303180031.EsiDo4qY-lkp@intel.com>
        <20230317173606.91426-1-szymon.heidrich@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 17 Mar 2023 18:36:06 +0100 Szymon Heidrich wrote:
> Fixes: 55d7de9de6c3 ("Microchip's LAN7800 family USB 2/3 to 10/100/1000 Ethernet device driver")
> Signed-off-by: Szymon Heidrich <szymon.heidrich@gmail.com>
> Reported-by: kernel test robot <lkp@intel.com>

I'd drop the Reported-by: tag in this case, since it makes it look like
the bot reported the bug you're fixing, rather than merely reported a
build issue.

When you repost please avoid posting in reply to previous version.
Makes the review queue easier to organize for mentainers.
