Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 31CCE25A191
	for <lists+netdev@lfdr.de>; Wed,  2 Sep 2020 00:37:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726536AbgIAWhr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Sep 2020 18:37:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726116AbgIAWhr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Sep 2020 18:37:47 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE3CEC061244
        for <netdev@vger.kernel.org>; Tue,  1 Sep 2020 15:37:46 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 1B3131365946E;
        Tue,  1 Sep 2020 15:21:00 -0700 (PDT)
Date:   Tue, 01 Sep 2020 15:37:46 -0700 (PDT)
Message-Id: <20200901.153746.1482515150768289752.davem@davemloft.net>
To:     sunil.kovvuri@gmail.com
Cc:     netdev@vger.kernel.org, sgoutham@marvell.com
Subject: Re: [PATCH net-next] octeontx2-pf: Add UDP segmentation offload
 support
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1598952702-23946-1-git-send-email-sunil.kovvuri@gmail.com>
References: <1598952702-23946-1-git-send-email-sunil.kovvuri@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Tue, 01 Sep 2020 15:21:00 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: <sunil.kovvuri@gmail.com>
Date: Tue, 1 Sep 2020 15:01:42 +0530

> From: Sunil Goutham <sgoutham@marvell.com>
> 
> Defines UDP segmentation algorithm in hardware and supports
> offloading UDP segmentation.
> 
> Signed-off-by: Sunil Goutham <sgoutham@marvell.com>

Applied, thank you.
