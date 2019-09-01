Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 30681A47F1
	for <lists+netdev@lfdr.de>; Sun,  1 Sep 2019 08:51:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728744AbfIAGvm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 1 Sep 2019 02:51:42 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:34502 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728617AbfIAGvm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 1 Sep 2019 02:51:42 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 81CC214CE0E78;
        Sat, 31 Aug 2019 23:51:41 -0700 (PDT)
Date:   Sat, 31 Aug 2019 23:51:40 -0700 (PDT)
Message-Id: <20190831.235140.41717819509316735.davem@davemloft.net>
To:     rmc032@bucknell.edu
Cc:     opendmb@gmail.com, f.fainelli@gmail.com,
        bcm-kernel-feedback-list@broadcom.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: bcmgenet: use ethtool_op_get_ts_info()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190830184955.GA27521@pop-os.localdomain>
References: <20190830184955.GA27521@pop-os.localdomain>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 31 Aug 2019 23:51:41 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: "Ryan M. Collins" <rmc032@bucknell.edu>
Date: Fri, 30 Aug 2019 14:49:55 -0400

> This change enables the use of SW timestamping on the Raspberry Pi 4.
> 
> bcmgenet's transmit function bcmgenet_xmit() implements software
> timestamping. However the SOF_TIMESTAMPING_TX_SOFTWARE capability was
> missing and only SOF_TIMESTAMPING_RX_SOFTWARE was announced. By using
> ethtool_ops bcmgenet_ethtool_ops() as get_ts_info(), the
> SOF_TIMESTAMPING_TX_SOFTWARE capability is announced.
> 
> Similar to commit a8f5cb9e7991 ("smsc95xx: use ethtool_op_get_ts_info()")
> 
> Signed-off-by: Ryan M. Collins <rmc032@bucknell.edu>

Applied.
