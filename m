Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D7BC266A43
	for <lists+netdev@lfdr.de>; Fri, 11 Sep 2020 23:46:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725961AbgIKVqP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Sep 2020 17:46:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725852AbgIKVqP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Sep 2020 17:46:15 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DB3EC061573;
        Fri, 11 Sep 2020 14:46:15 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id B2DCB1366AF4D;
        Fri, 11 Sep 2020 14:29:27 -0700 (PDT)
Date:   Fri, 11 Sep 2020 14:46:13 -0700 (PDT)
Message-Id: <20200911.144613.2034716029328930606.davem@davemloft.net>
To:     o.rempel@pengutronix.de
Cc:     jcliburn@gmail.com, chris.snook@gmail.com, andrew@lunn.ch,
        kernel@pengutronix.de, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1 0/2] ag71xx: add ethtool and flow control support 
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200911082528.27121-1-o.rempel@pengutronix.de>
References: <20200911082528.27121-1-o.rempel@pengutronix.de>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Fri, 11 Sep 2020 14:29:28 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Oleksij Rempel <o.rempel@pengutronix.de>
Date: Fri, 11 Sep 2020 10:25:26 +0200

> The main target of this patches is to provide flow control support
> for ag71xx driver. To be able to validate this functionality, I also
> added ethtool support with HW counters. So, this patches was validated
> with iperf3 and counters showing Pause frames send or received by this
> NIC.

Series applied, thank you.
