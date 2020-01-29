Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8660D14CA61
	for <lists+netdev@lfdr.de>; Wed, 29 Jan 2020 13:10:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726260AbgA2MKA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jan 2020 07:10:00 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:60130 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726177AbgA2MKA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jan 2020 07:10:00 -0500
Received: from localhost (unknown [IPv6:2001:982:756:1:57a7:3bfd:5e85:defb])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 99DAE14B79E35;
        Wed, 29 Jan 2020 04:09:57 -0800 (PST)
Date:   Wed, 29 Jan 2020 13:09:54 +0100 (CET)
Message-Id: <20200129.130954.13079744457854627.davem@davemloft.net>
To:     olteanv@gmail.com
Cc:     vinicius.gomes@intel.com, netdev@vger.kernel.org, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, jiri@resnulli.us,
        vladimir.oltean@nxp.com, po.liu@nxp.com
Subject: Re: [PATCH net v2 2/3] taprio: Allow users not to specify "flags"
 when changing schedules
From:   David Miller <davem@davemloft.net>
In-Reply-To: <CA+h21hoDDULPuhkEDCby0RBs+3r0angFVvyvazvedRTdWX_UYQ@mail.gmail.com>
References: <20200128235227.3942256-3-vinicius.gomes@intel.com>
        <20200129.111245.1611718557356636170.davem@davemloft.net>
        <CA+h21hoDDULPuhkEDCby0RBs+3r0angFVvyvazvedRTdWX_UYQ@mail.gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 29 Jan 2020 04:09:59 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <olteanv@gmail.com>
Date: Wed, 29 Jan 2020 13:24:30 +0200

> At some point, the 5.3 kernel will go EOL. When would be a good time
> to make the "flags" optional on "tc qdisc replace", without concerns
> about different behavior across versions?

5.3, and 5.4, and... and how long do distros ship that kernel?

This is why it is absolutely critical to flesh out all public
facing interface concerns before the feature is merged into
the tree rather than later.
