Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9529A680F7
	for <lists+netdev@lfdr.de>; Sun, 14 Jul 2019 21:13:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728838AbfGNTNQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 14 Jul 2019 15:13:16 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:53618 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728125AbfGNTNQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 14 Jul 2019 15:13:16 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 4895414E7A6EB;
        Sun, 14 Jul 2019 12:13:15 -0700 (PDT)
Date:   Sun, 14 Jul 2019 12:13:12 -0700 (PDT)
Message-Id: <20190714.121312.1192239158322085095.davem@davemloft.net>
To:     efremov@linux.com
Cc:     csully@google.com, sagis@google.com, jonolson@google.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] gve: Remove the exporting of gve_probe
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190714120225.15279-1-efremov@linux.com>
References: <20190714120225.15279-1-efremov@linux.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 14 Jul 2019 12:13:15 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Denis Efremov <efremov@linux.com>
Date: Sun, 14 Jul 2019 15:02:25 +0300

> The function gve_probe is declared static and marked EXPORT_SYMBOL, which
> is at best an odd combination. Because the function is not used outside of
> the drivers/net/ethernet/google/gve/gve_main.c file it is defined in, this
> commit removes the EXPORT_SYMBOL() marking.
> 
> Signed-off-by: Denis Efremov <efremov@linux.com>

Applied, thanks.
