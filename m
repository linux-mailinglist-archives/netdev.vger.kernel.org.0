Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 63D1D284C81
	for <lists+netdev@lfdr.de>; Tue,  6 Oct 2020 15:26:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725962AbgJFN0W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Oct 2020 09:26:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725902AbgJFN0U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Oct 2020 09:26:20 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F40CC061755
        for <netdev@vger.kernel.org>; Tue,  6 Oct 2020 06:26:20 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 5E4A6127C85A6;
        Tue,  6 Oct 2020 06:09:31 -0700 (PDT)
Date:   Tue, 06 Oct 2020 06:26:18 -0700 (PDT)
Message-Id: <20201006.062618.628708952352439429.davem@davemloft.net>
To:     johannes@sipsolutions.net
Cc:     kuba@kernel.org, netdev@vger.kernel.org, kernel-team@fb.com,
        jiri@resnulli.us, andrew@lunn.ch, mkubecek@suse.cz
Subject: Re: [PATCH net-next v2 0/7] ethtool: allow dumping policies to
 user space
From:   David Miller <davem@davemloft.net>
In-Reply-To: <7586c9e77f6aa43e598103ccc25b43415752507d.camel@sipsolutions.net>
References: <20201005220739.2581920-1-kuba@kernel.org>
        <7586c9e77f6aa43e598103ccc25b43415752507d.camel@sipsolutions.net>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Tue, 06 Oct 2020 06:09:31 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Johannes Berg <johannes@sipsolutions.net>
Date: Tue, 06 Oct 2020 08:43:17 +0200

> On Mon, 2020-10-05 at 15:07 -0700, Jakub Kicinski wrote:
>> Hi!
>> 
>> This series wires up ethtool policies to ops, so they can be
>> dumped to user space for feature discovery.
>> 
>> First patch wires up GET commands, and second patch wires up SETs.
>> 
>> The policy tables are trimmed to save space and LoC.
>> 
>> Next - take care of linking up nested policies for the header
>> (which is the policy what we actually care about). And once header
>> policy is linked make sure that attribute range validation for flags
>> is done by policy, not a conditions in the code. New type of policy
>> is needed to validate masks (patch 6).
>> 
>> Netlink as always staying a step ahead of all the other kernel
>> API interfaces :)
 ...
> Reviewed-by: Johannes Berg <johannes@sipsolutions.net>

Series applied, thanks everyone.
