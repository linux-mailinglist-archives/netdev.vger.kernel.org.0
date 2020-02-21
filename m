Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 053FD168774
	for <lists+netdev@lfdr.de>; Fri, 21 Feb 2020 20:35:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726541AbgBUTfV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Feb 2020 14:35:21 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:40370 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726160AbgBUTfV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Feb 2020 14:35:21 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 9F439141C8A46;
        Fri, 21 Feb 2020 11:35:20 -0800 (PST)
Date:   Fri, 21 Feb 2020 11:35:20 -0800 (PST)
Message-Id: <20200221.113520.1105280751683846601.davem@davemloft.net>
To:     kuba@kernel.org
Cc:     leon@kernel.org, leonro@mellanox.com, netdev@vger.kernel.org
Subject: Re: [PATCH net-next 00/16] Clean driver, module and FW versions
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200220171714.60a70238@kicinski-fedora-PC1C0HJN>
References: <20200220145855.255704-1-leon@kernel.org>
        <20200220171714.60a70238@kicinski-fedora-PC1C0HJN>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 21 Feb 2020 11:35:20 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jakub Kicinski <kuba@kernel.org>
Date: Thu, 20 Feb 2020 17:17:14 -0800

> A few minor nit picks I registered, IDK how hard we want to press 
> on these:
> 
>  - it seems in couple places you remove the last user of DRV_RELDATE,
>    but not the define. In case of bonding maybe we can remove the date
>    too. IDK what value it brings in the description, other than perhaps
>    humoring people;
>  - we should probably give people a heads up by CCing maintainers
>    (regardless of how dumb we find not bothering to read the ML as
>    a maintainer);
>  - one on the FW below..
> 
>> As part of this series, I deleted various creative attempts to mark
>> absence of FW. There is no need to set "N/A" in ethtool ->fw_version
>> field and it is enough to do not set it.
> 
> These seem reasonable to me, although in abundance of caution it could
> be a good idea to have them as separate commits so we can revert more
> easily. Worse come to worst.

Leon please address this feedback as it seems reasonable to me.
