Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4062221A806
	for <lists+netdev@lfdr.de>; Thu,  9 Jul 2020 21:46:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726363AbgGITqC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jul 2020 15:46:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726260AbgGITqC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jul 2020 15:46:02 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15436C08C5CE;
        Thu,  9 Jul 2020 12:46:02 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 8AE301279621D;
        Thu,  9 Jul 2020 12:46:01 -0700 (PDT)
Date:   Thu, 09 Jul 2020 12:46:00 -0700 (PDT)
Message-Id: <20200709.124600.1376090134337246963.davem@davemloft.net>
To:     cphealy@gmail.com
Cc:     andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] net: dsa: mv88e6xxx: Add serdes read/write
 dynamic debug
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200709184318.4192-1-cphealy@gmail.com>
References: <20200709184318.4192-1-cphealy@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 09 Jul 2020 12:46:01 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Chris Healy <cphealy@gmail.com>
Date: Thu,  9 Jul 2020 11:43:18 -0700

> Add deb_dbg print statements in both serdes_read and serdes_write
> functions.
> 
> Signed-off-by: Chris Healy <cphealy@gmail.com>

Please just use tracepoints or similar for this.
