Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1CB891EAE63
	for <lists+netdev@lfdr.de>; Mon,  1 Jun 2020 20:53:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730762AbgFASxS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jun 2020 14:53:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728479AbgFASxQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Jun 2020 14:53:16 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDDB4C061A0E;
        Mon,  1 Jun 2020 11:53:15 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 7503E11D53F8B;
        Mon,  1 Jun 2020 11:53:15 -0700 (PDT)
Date:   Mon, 01 Jun 2020 11:53:14 -0700 (PDT)
Message-Id: <20200601.115314.1252090110544162221.davem@davemloft.net>
To:     baijiaju1990@gmail.com
Cc:     doshir@vmware.com, pv-drivers@vmware.com, kuba@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: vmxnet3: fix possible buffer overflow caused by
 bad DMA value in vmxnet3_get_rss()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200530024150.27308-1-baijiaju1990@gmail.com>
References: <20200530024150.27308-1-baijiaju1990@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 01 Jun 2020 11:53:15 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jia-Ju Bai <baijiaju1990@gmail.com>
Date: Sat, 30 May 2020 10:41:50 +0800

> The value adapter->rss_conf is stored in DMA memory, and it is assigned
> to rssConf, so rssConf->indTableSize can be modified at anytime by
> malicious hardware. Because rssConf->indTableSize is assigned to n,
> buffer overflow may occur when the code "rssConf->indTable[n]" is
> executed.
> 
> To fix this possible bug, n is checked after being used.
> 
> Signed-off-by: Jia-Ju Bai <baijiaju1990@gmail.com>

Applied, thanks.
