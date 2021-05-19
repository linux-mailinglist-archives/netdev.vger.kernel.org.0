Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 59B93389691
	for <lists+netdev@lfdr.de>; Wed, 19 May 2021 21:24:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231997AbhESTZS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 May 2021 15:25:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230486AbhESTZS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 May 2021 15:25:18 -0400
Received: from mail.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4237DC06175F;
        Wed, 19 May 2021 12:23:58 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        by mail.monkeyblade.net (Postfix) with ESMTPSA id 5AC0D4D25C1D0;
        Wed, 19 May 2021 12:23:57 -0700 (PDT)
Date:   Wed, 19 May 2021 12:23:56 -0700 (PDT)
Message-Id: <20210519.122356.1201315264426214403.davem@davemloft.net>
To:     anthony.l.nguyen@intel.com
Cc:     huangguangbin2@huawei.com, jesse.brandeburg@intel.com,
        kuba@kernel.org, lipeng321@huawei.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, intel-wired-lan@lists.osuosl.org,
        tanhuazhong@huawei.com
Subject: Re: [PATCH net-next 0/5] net: intel: some cleanups
From:   David Miller <davem@davemloft.net>
In-Reply-To: <194cf154afa7b56b22d4284cad537f1a6b697f61.camel@intel.com>
References: <1621404885-20075-1-git-send-email-huangguangbin2@huawei.com>
        <194cf154afa7b56b22d4284cad537f1a6b697f61.camel@intel.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.6.2 (mail.monkeyblade.net [0.0.0.0]); Wed, 19 May 2021 12:23:57 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>
Date: Wed, 19 May 2021 18:48:51 +0000

> On Wed, 2021-05-19 at 14:14 +0800, Guangbin Huang wrote:
>> This patchset adds some cleanups for intel e1000/e1000e ethernet
>> driver.
>> 
>> Hao Chen (5):
>>   net: e1000: remove repeated word "slot" for e1000_main.c
>>   net: e1000: remove repeated words for e1000_hw.c
>>   net: e1000e: remove repeated word "the" for ich8lan.c
>>   net: e1000e: remove repeated word "slot" for netdev.c
>>   net: e1000e: fix misspell word "retreived"
>> 
>>  drivers/net/ethernet/intel/e1000/e1000_hw.c   | 4 ++--
>>  drivers/net/ethernet/intel/e1000/e1000_main.c | 2 +-
>>  drivers/net/ethernet/intel/e1000e/ich8lan.c   | 2 +-
>>  drivers/net/ethernet/intel/e1000e/netdev.c    | 2 +-
>>  drivers/net/ethernet/intel/e1000e/phy.c       | 2 +-
>>  5 files changed, 6 insertions(+), 6 deletions(-)
>> 
> 
> Reviewed-by: Tony Nguyen <anthony.l.nguyen@intel.com>
> 
> Dave/Jakub - as these are just comment changes, did you want to pick
> this up?

Sure.
