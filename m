Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 90CB01B8BAE
	for <lists+netdev@lfdr.de>; Sun, 26 Apr 2020 05:38:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726113AbgDZDiJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Apr 2020 23:38:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725945AbgDZDiJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 Apr 2020 23:38:09 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A47DC061A0C
        for <netdev@vger.kernel.org>; Sat, 25 Apr 2020 20:38:09 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 54A2B159FC800;
        Sat, 25 Apr 2020 20:38:09 -0700 (PDT)
Date:   Sat, 25 Apr 2020 20:38:08 -0700 (PDT)
Message-Id: <20200425.203808.2112576495787193342.davem@davemloft.net>
To:     ioana.ciornei@nxp.com
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH net-next] dpaa2-eth: add channel stat to debugfs
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200424093318.27490-1-ioana.ciornei@nxp.com>
References: <20200424093318.27490-1-ioana.ciornei@nxp.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 25 Apr 2020 20:38:09 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ioana Ciornei <ioana.ciornei@nxp.com>
Date: Fri, 24 Apr 2020 12:33:18 +0300

> Compute the average number of frames processed for each CDAN (Channel
> Data Availability Notification) and export it to debugfs detailed
> channel stats.
> 
> Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>

Applied.
