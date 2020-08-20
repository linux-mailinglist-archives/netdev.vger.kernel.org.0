Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 715B124C614
	for <lists+netdev@lfdr.de>; Thu, 20 Aug 2020 21:03:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726793AbgHTTD1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Aug 2020 15:03:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725823AbgHTTD1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Aug 2020 15:03:27 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BCB3C061385
        for <netdev@vger.kernel.org>; Thu, 20 Aug 2020 12:03:27 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id CFD5212815BC1;
        Thu, 20 Aug 2020 11:46:40 -0700 (PDT)
Date:   Thu, 20 Aug 2020 12:03:26 -0700 (PDT)
Message-Id: <20200820.120326.1043906895052143406.davem@davemloft.net>
To:     rahul.kundu@chelsio.com
Cc:     netdev@vger.kernel.org, vishal@chelsio.com,
        rahul.lakkireddy@chelsio.com, dt@chelsio.com
Subject: Re: [PATCH net-next] cxgb4: insert IPv6 filter rules in next free
 region
From:   David Miller <davem@davemloft.net>
In-Reply-To: <0b35dad8bf171816a20ca6b8ba1c38aa96aeeaeb.1597919928.git.rahul.kundu@chelsio.com>
References: <0b35dad8bf171816a20ca6b8ba1c38aa96aeeaeb.1597919928.git.rahul.kundu@chelsio.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 20 Aug 2020 11:46:41 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Rahul Kundu <rahul.kundu@chelsio.com>
Date: Thu, 20 Aug 2020 16:31:36 +0530

> IPv6 filters can occupy up to 4 slots and will exhaust HPFILTER
> region much sooner. So, continue searching for free slots in the
> HASH or NORMAL filter regions, as long as the rule's priority does
> not conflict with existing rules in those regions.
> 
> Signed-off-by: Rahul Kundu <rahul.kundu@chelsio.com>

Applied, thank you.
