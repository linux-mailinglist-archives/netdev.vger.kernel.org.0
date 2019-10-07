Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 857DCCE4B4
	for <lists+netdev@lfdr.de>; Mon,  7 Oct 2019 16:08:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727958AbfJGOI0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Oct 2019 10:08:26 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:53082 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727324AbfJGOI0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Oct 2019 10:08:26 -0400
Received: from localhost (unknown [144.121.20.163])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id D0F9D1421825C;
        Mon,  7 Oct 2019 07:08:25 -0700 (PDT)
Date:   Mon, 07 Oct 2019 16:08:24 +0200 (CEST)
Message-Id: <20191007.160824.670886075628882232.davem@davemloft.net>
To:     ioana.ciornei@nxp.com
Cc:     netdev@vger.kernel.org, andrew@lunn.ch
Subject: Re: [PATCH net-next v2 0/3] dpaa2-eth: misc cleanup
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1570448308-16248-1-git-send-email-ioana.ciornei@nxp.com>
References: <1570448308-16248-1-git-send-email-ioana.ciornei@nxp.com>
X-Mailer: Mew version 6.8 on Emacs 26.2
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 07 Oct 2019 07:08:26 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ioana Ciornei <ioana.ciornei@nxp.com>
Date: Mon,  7 Oct 2019 14:38:25 +0300

> This patch set consists of some cleanup patches ranging from removing dead
> code to fixing a minor issue in ethtool stats. Also, unbounded while loops
> are removed from the driver by adding a maximum number of retries for DPIO
> portal commands.
> 
> Changes in v2:
>  - return -ETIMEDOUT where possible if the number of retries is hit

Series applied.
