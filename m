Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B3D52581B5
	for <lists+netdev@lfdr.de>; Mon, 31 Aug 2020 21:23:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729518AbgHaTXE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Aug 2020 15:23:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728785AbgHaTXE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Aug 2020 15:23:04 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AEE94C061573;
        Mon, 31 Aug 2020 12:23:04 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id CB9C412889ED4;
        Mon, 31 Aug 2020 12:06:16 -0700 (PDT)
Date:   Mon, 31 Aug 2020 12:23:02 -0700 (PDT)
Message-Id: <20200831.122302.1503509345904601478.davem@davemloft.net>
To:     xie.he.0141@gmail.com
Cc:     kuba@kernel.org, khc@pm.waw.pl, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, ms@dev.tdt.de
Subject: Re: [PATCH net] drivers/net/wan/hdlc_cisco: Add hard_header_len
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200828070752.54444-1-xie.he.0141@gmail.com>
References: <20200828070752.54444-1-xie.he.0141@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 31 Aug 2020 12:06:17 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Xie He <xie.he.0141@gmail.com>
Date: Fri, 28 Aug 2020 00:07:52 -0700

> This driver didn't set hard_header_len. This patch sets hard_header_len
> for it according to its header_ops->create function.
> 
> This driver's header_ops->create function (cisco_hard_header) creates
> a header of (struct hdlc_header), so hard_header_len should be set to
> sizeof(struct hdlc_header).
> 
> Cc: Martin Schiller <ms@dev.tdt.de>
> Signed-off-by: Xie He <xie.he.0141@gmail.com>

Applied, thanks.
