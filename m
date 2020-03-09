Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A8CFF17D877
	for <lists+netdev@lfdr.de>; Mon,  9 Mar 2020 05:09:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726149AbgCIEJP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Mar 2020 00:09:15 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:53906 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725857AbgCIEJO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Mar 2020 00:09:14 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 46466158B55F7;
        Sun,  8 Mar 2020 21:09:13 -0700 (PDT)
Date:   Sun, 08 Mar 2020 21:09:12 -0700 (PDT)
Message-Id: <20200308.210912.1633299574639128341.davem@davemloft.net>
To:     jiri@resnulli.us
Cc:     netdev@vger.kernel.org, kuba@kernel.org, saeedm@mellanox.com,
        leon@kernel.org, michael.chan@broadcom.com, vishal@chelsio.com,
        jeffrey.t.kirsher@intel.com, idosch@mellanox.com,
        aelior@marvell.com, peppe.cavallaro@st.com,
        alexandre.torgue@st.com, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, pablo@netfilter.org,
        ecree@solarflare.com, mlxsw@mellanox.com
Subject: Re: [patch net-next v4 00/10] net: allow user specify TC action HW
 stats type
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200307114020.8664-1-jiri@resnulli.us>
References: <20200307114020.8664-1-jiri@resnulli.us>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 08 Mar 2020 21:09:14 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@resnulli.us>
Date: Sat,  7 Mar 2020 12:40:10 +0100

> Currently, when user adds a TC action and the action gets offloaded,
> the user expects the HW stats to be counted and included in stats dump.
> However, since drivers may implement different types of counting, there
> is no way to specify which one the user is interested in.
> 
> For example for mlx5, only delayed counters are available as the driver
> periodically polls for updated stats.
> 
> In case of mlxsw, the counters are queried on dump time. However, the
> HW resources for this type of counters is quite limited (couple of
> thousands). This limits the amount of supported offloaded filters
> significantly. Without counter assigned, the HW is capable to carry
> millions of those.
> 
> On top of that, mlxsw HW is able to support delayed counters as well in
> greater numbers. That is going to be added in a follow-up patch.
> 
> This patchset allows user to specify one of the following types of HW
> stats for added action:
> immediate - queried during dump time
> delayed - polled from HW periodically or sent by HW in async manner
> disabled - no stats needed
> 
> Note that if "hw_stats" option is not passed, user does not care about
> the type, just expects any type of stats.
> 
> Examples:
 ...

Series applied, thanks Jiri.
