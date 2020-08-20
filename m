Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AAD4424C70E
	for <lists+netdev@lfdr.de>; Thu, 20 Aug 2020 23:15:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728695AbgHTVPU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Aug 2020 17:15:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726781AbgHTVPT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Aug 2020 17:15:19 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA86FC061385;
        Thu, 20 Aug 2020 14:15:18 -0700 (PDT)
Received: from localhost (c-76-104-128-192.hsd1.wa.comcast.net [76.104.128.192])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id BD1D8128405DE;
        Thu, 20 Aug 2020 13:58:28 -0700 (PDT)
Date:   Thu, 20 Aug 2020 14:15:10 -0700 (PDT)
Message-Id: <20200820.141510.1395453798289903622.davem@davemloft.net>
To:     christophe.jaillet@wanadoo.fr
Cc:     kuba@kernel.org, snelson@pensando.io, mhabets@solarflare.com,
        vaibhavgupta40@gmail.com, mst@redhat.com, mkubecek@suse.cz,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] epic100: switch from 'pci_' to 'dma_' API
From:   David Miller <davem@davemloft.net>
In-Reply-To: <9b8ad131-3c2e-37b7-392c-79fab1a2f2bb@wanadoo.fr>
References: <20200806201935.733641-1-christophe.jaillet@wanadoo.fr>
        <20200806.142311.94169513118353100.davem@davemloft.net>
        <9b8ad131-3c2e-37b7-392c-79fab1a2f2bb@wanadoo.fr>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 20 Aug 2020 13:58:29 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Date: Thu, 20 Aug 2020 18:28:25 +0200

> should I resend the few conversion patches sent at the wrong time or
> are they stored somewhere, and will be processed when some time is
> available for it?

Please resend, thank you.
