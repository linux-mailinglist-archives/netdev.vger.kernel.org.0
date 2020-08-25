Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BAE2A250DB0
	for <lists+netdev@lfdr.de>; Tue, 25 Aug 2020 02:35:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728271AbgHYAe4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Aug 2020 20:34:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727014AbgHYAez (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Aug 2020 20:34:55 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21687C061574;
        Mon, 24 Aug 2020 17:34:55 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 9598E1294C716;
        Mon, 24 Aug 2020 17:18:08 -0700 (PDT)
Date:   Mon, 24 Aug 2020 17:34:54 -0700 (PDT)
Message-Id: <20200824.173454.206331628247587976.davem@davemloft.net>
To:     dinghao.liu@zju.edu.cn
Cc:     kjlu@umn.edu, colin.king@canonical.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] NFC: st95hf: Fix memleak in st95hf_in_send_cmd
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200823072346.17140-1-dinghao.liu@zju.edu.cn>
References: <20200823072346.17140-1-dinghao.liu@zju.edu.cn>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 24 Aug 2020 17:18:08 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dinghao Liu <dinghao.liu@zju.edu.cn>
Date: Sun, 23 Aug 2020 15:23:43 +0800

> When down_killable() fails, skb_resp should be freed
> just like when st95hf_spi_send() fails.
> 
> Signed-off-by: Dinghao Liu <dinghao.liu@zju.edu.cn>

Applied, thank you.
