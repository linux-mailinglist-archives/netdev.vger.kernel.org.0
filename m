Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6619223E37F
	for <lists+netdev@lfdr.de>; Thu,  6 Aug 2020 23:23:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726221AbgHFVXV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Aug 2020 17:23:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725812AbgHFVXU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Aug 2020 17:23:20 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7C62C061574;
        Thu,  6 Aug 2020 14:23:20 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id DD6E811DB3159;
        Thu,  6 Aug 2020 14:06:30 -0700 (PDT)
Date:   Thu, 06 Aug 2020 14:23:11 -0700 (PDT)
Message-Id: <20200806.142311.94169513118353100.davem@davemloft.net>
To:     christophe.jaillet@wanadoo.fr
Cc:     kuba@kernel.org, snelson@pensando.io, mhabets@solarflare.com,
        vaibhavgupta40@gmail.com, mst@redhat.com, mkubecek@suse.cz,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] epic100: switch from 'pci_' to 'dma_' API
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200806201935.733641-1-christophe.jaillet@wanadoo.fr>
References: <20200806201935.733641-1-christophe.jaillet@wanadoo.fr>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 06 Aug 2020 14:06:31 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Date: Thu,  6 Aug 2020 22:19:35 +0200

> The wrappers in include/linux/pci-dma-compat.h should go away.

Christophe, the net-next tree is closed so I'd like to ask that you
defer submitting these conversion patches until the net-next
tree opens back up again.

Thank you.

