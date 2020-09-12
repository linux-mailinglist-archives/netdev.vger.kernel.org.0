Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8942E2676D5
	for <lists+netdev@lfdr.de>; Sat, 12 Sep 2020 02:31:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725882AbgILAbC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Sep 2020 20:31:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725824AbgILAa6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Sep 2020 20:30:58 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18A7FC061573
        for <netdev@vger.kernel.org>; Fri, 11 Sep 2020 17:30:58 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 9FA651216DC7A;
        Fri, 11 Sep 2020 17:14:10 -0700 (PDT)
Date:   Fri, 11 Sep 2020 17:30:56 -0700 (PDT)
Message-Id: <20200911.173056.2215749149768128684.davem@davemloft.net>
To:     olteanv@gmail.com
Cc:     jakub.kicinski@netronome.com, andrew@lunn.ch, f.fainelli@gmail.com,
        vivien.didelot@gmail.com, netdev@vger.kernel.org
Subject: Re: [PATCH v2 net-next 0/4] DSA tag_8021q cleanup
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200910164857.1221202-1-olteanv@gmail.com>
References: <20200910164857.1221202-1-olteanv@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Fri, 11 Sep 2020 17:14:11 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <olteanv@gmail.com>
Date: Thu, 10 Sep 2020 19:48:53 +0300

> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> This small series tries to consolidate the VLAN handling in DSA a little
> bit. It reworks tag_8021q to be minimally invasive to the dsa_switch_ops
> structure. This makes the rest of the code a bit easier to follow.

Series applied, thank you.
