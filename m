Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 01A9824A67C
	for <lists+netdev@lfdr.de>; Wed, 19 Aug 2020 21:02:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726673AbgHSTCN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Aug 2020 15:02:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726211AbgHSTCL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Aug 2020 15:02:11 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0666BC061757
        for <netdev@vger.kernel.org>; Wed, 19 Aug 2020 12:02:10 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 0A2211296918D;
        Wed, 19 Aug 2020 11:45:17 -0700 (PDT)
Date:   Wed, 19 Aug 2020 12:01:59 -0700 (PDT)
Message-Id: <20200819.120159.603402982897229909.davem@davemloft.net>
To:     f.fainelli@gmail.com
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, vivien.didelot@gmail.com,
        kuba@kernel.org
Subject: Re: [PATCH net-next v2 0/2] net: dsa: loop: Expose VLAN table
 through devlink
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200819043218.19285-1-f.fainelli@gmail.com>
References: <20200819043218.19285-1-f.fainelli@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 19 Aug 2020 11:45:17 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Fainelli <f.fainelli@gmail.com>
Date: Tue, 18 Aug 2020 21:32:16 -0700

> Changes in v2:
> 
> - set the DSA configure_vlan_while_not_filtering boolean
> - return the actual occupancy

Series applied, thank you.
