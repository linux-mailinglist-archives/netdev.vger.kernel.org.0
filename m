Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E477B2676B8
	for <lists+netdev@lfdr.de>; Sat, 12 Sep 2020 02:15:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725901AbgILAPg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Sep 2020 20:15:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725824AbgILAPg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Sep 2020 20:15:36 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25B71C061573
        for <netdev@vger.kernel.org>; Fri, 11 Sep 2020 17:15:36 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 914F611FFCA47;
        Fri, 11 Sep 2020 16:58:48 -0700 (PDT)
Date:   Fri, 11 Sep 2020 17:15:34 -0700 (PDT)
Message-Id: <20200911.171534.1288502042201048095.davem@davemloft.net>
To:     kuba@kernel.org
Cc:     ecree@solarflare.com, linux-net-drivers@solarflare.com,
        netdev@vger.kernel.org
Subject: Re: [PATCH v2 net-next 0/7] sfc: encap offloads on EF10
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200911160726.42c974c8@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <27a1329b-fe09-d8e0-1d43-2e53e2793748@solarflare.com>
        <20200911160726.42c974c8@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Fri, 11 Sep 2020 16:58:48 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jakub Kicinski <kuba@kernel.org>
Date: Fri, 11 Sep 2020 16:07:26 -0700

> On Fri, 11 Sep 2020 23:37:10 +0100 Edward Cree wrote:
>> EF10 NICs from the 8000 series onwards support TX offloads (checksumming,
>>  TSO) on VXLAN- and NVGRE-encapsulated packets.  This series adds driver
>>  support for these offloads.
>> 
>> Changes from v1:
>>  * Fix 'no TXQ of type' error handling in patch #1 (and clear up the
>>    misleading comment that inspired the wrong version)
>>  * Add comment in patch #5 explaining what the deal with TSOv3 is
> 
> Reviewed-by: Jakub Kicinski <kuba@kernel.org>

Series applied, thanks.
