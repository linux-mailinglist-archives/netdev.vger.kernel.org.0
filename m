Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6070B1D6478
	for <lists+netdev@lfdr.de>; Sun, 17 May 2020 00:19:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726833AbgEPWTe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 May 2020 18:19:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726550AbgEPWTe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 16 May 2020 18:19:34 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BAACC061A0C
        for <netdev@vger.kernel.org>; Sat, 16 May 2020 15:19:34 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 797C3119385C8;
        Sat, 16 May 2020 15:19:33 -0700 (PDT)
Date:   Sat, 16 May 2020 15:19:32 -0700 (PDT)
Message-Id: <20200516.151932.575795129235955389.davem@davemloft.net>
To:     olteanv@gmail.com
Cc:     vinicius.gomes@intel.com, intel-wired-lan@lists.osuosl.org,
        jeffrey.t.kirsher@intel.com, netdev@vger.kernel.org,
        vladimir.oltean@nxp.com, po.liu@nxp.com, m-karicheri2@ti.com,
        Jose.Abreu@synopsys.com
Subject: Re: [next-queue RFC 0/4] ethtool: Add support for frame preemption
From:   David Miller <davem@davemloft.net>
In-Reply-To: <CA+h21hoNW_++QHRob+NbWC2k7y7sFec3kotSjTL6s8eZGGT+2Q@mail.gmail.com>
References: <20200516012948.3173993-1-vinicius.gomes@intel.com>
        <20200516.133739.285740119627243211.davem@davemloft.net>
        <CA+h21hoNW_++QHRob+NbWC2k7y7sFec3kotSjTL6s8eZGGT+2Q@mail.gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 16 May 2020 15:19:33 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <olteanv@gmail.com>
Date: Sun, 17 May 2020 00:03:39 +0300

> As to why this doesn't go to tc but to ethtool: why would it go to tc?

Maybe you can't %100 duplicate the on-the-wire special format and
whatever, but the queueing behavior ABSOLUTELY you can emulate in
software.

And then you have the proper hooks added for HW offload which can
do the on-the-wire stuff.

That's how we do these things, not with bolted on ethtool stuff.
