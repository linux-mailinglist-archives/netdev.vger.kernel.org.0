Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2310320CC3B
	for <lists+netdev@lfdr.de>; Mon, 29 Jun 2020 05:45:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726094AbgF2Dpu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 28 Jun 2020 23:45:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725998AbgF2Dpu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 28 Jun 2020 23:45:50 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B86CC03E979;
        Sun, 28 Jun 2020 20:45:50 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id BC2ED129A828B;
        Sun, 28 Jun 2020 20:45:49 -0700 (PDT)
Date:   Sun, 28 Jun 2020 20:45:49 -0700 (PDT)
Message-Id: <20200628.204549.1864334210736765028.davem@davemloft.net>
To:     olteanv@gmail.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net] lib: packing: add documentation for pbuflen
 argument
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200628144935.700891-1-olteanv@gmail.com>
References: <20200628144935.700891-1-olteanv@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 28 Jun 2020 20:45:49 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <olteanv@gmail.com>
Date: Sun, 28 Jun 2020 17:49:35 +0300

> Fixes sparse warning:
> 
> Function parameter or member 'pbuflen' not described in 'packing'
> 
> Fixes: 554aae35007e ("lib: Add support for generic packing operations")
> Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
> ---
> Hi David, since the original "packing" submission went in through your
> tree, could you please take this patch as well?

Sure, applied, thank you.
