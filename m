Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 43D70273765
	for <lists+netdev@lfdr.de>; Tue, 22 Sep 2020 02:27:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729337AbgIVA1h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Sep 2020 20:27:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728571AbgIVA1c (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Sep 2020 20:27:32 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E026C061755
        for <netdev@vger.kernel.org>; Mon, 21 Sep 2020 17:27:32 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 1E534127DB65D;
        Mon, 21 Sep 2020 17:10:44 -0700 (PDT)
Date:   Mon, 21 Sep 2020 17:27:30 -0700 (PDT)
Message-Id: <20200921.172730.1820631295790245739.davem@davemloft.net>
To:     jacob.e.keller@intel.com
Cc:     netdev@vger.kernel.org, jiri@mellanox.com, kuba@kernel.org,
        corbet@lwn.net, michael.chan@broadcom.com, luobin9@huawei.com,
        saeedm@mellanox.com, leon@kernel.org, idosch@mellanox.com,
        danieller@mellanox.com, snelson@pensando.io
Subject: Re: [net-next v8 0/5] devlink flash update overwrite mask
From:   David Miller <davem@davemloft.net>
In-Reply-To: <9f363bc5-ae2d-619c-03fc-abf6c21b4614@intel.com>
References: <20200921223128.1204467-1-jacob.e.keller@intel.com>
        <9f363bc5-ae2d-619c-03fc-abf6c21b4614@intel.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Mon, 21 Sep 2020 17:10:44 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jacob Keller <jacob.e.keller@intel.com>
Date: Mon, 21 Sep 2020 15:42:21 -0700

> On 9/21/2020 3:31 PM, Jacob Keller wrote:
>> (This is essentially a resend of v7 because some of the patches didn't hit
>> the netdev list last Friday due to an SMTP server issue here)
>> 
> 
> Heh. Apparently it's not fixed yet. I am sorry for those on the CC list
> for this spam.

You don't need to use the mailing list, just run:

host -a fmsmga106.fm.intel.com

For example, and as long as that returns "NXDOMAIN" the problem is
going to continue.
