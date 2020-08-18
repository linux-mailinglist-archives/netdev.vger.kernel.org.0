Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 352A1248EAB
	for <lists+netdev@lfdr.de>; Tue, 18 Aug 2020 21:29:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726671AbgHRT3X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Aug 2020 15:29:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726585AbgHRT3W (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Aug 2020 15:29:22 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 986ACC061389
        for <netdev@vger.kernel.org>; Tue, 18 Aug 2020 12:29:21 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 032D71279CD10;
        Tue, 18 Aug 2020 12:12:28 -0700 (PDT)
Date:   Tue, 18 Aug 2020 12:29:11 -0700 (PDT)
Message-Id: <20200818.122911.832794587934053908.davem@davemloft.net>
To:     johannes@sipsolutions.net
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH v2 0/3] netlink: allow NLA_BINARY length range
 validation
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200818081733.10892-1-johannes@sipsolutions.net>
References: <20200818081733.10892-1-johannes@sipsolutions.net>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 18 Aug 2020 12:12:29 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Johannes Berg <johannes@sipsolutions.net>
Date: Tue, 18 Aug 2020 10:17:30 +0200

> In quite a few places (perhaps particularly in wireless) we need to
> validation an NLA_BINARY attribute with both a minimum and a maximum
> length. Currently, we can do either of the two, but not both, given
> that we have NLA_MIN_LEN (minimum length) and NLA_BINARY (maximum).
> 
> Extend the range mechanisms that we use for integer validation to
> apply to NLA_BINARY as well.
 ...

Series applied, thanks Johannes.
