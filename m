Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E704ADB5CD
	for <lists+netdev@lfdr.de>; Thu, 17 Oct 2019 20:20:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2503173AbfJQST6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Oct 2019 14:19:58 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:39806 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2438684AbfJQST4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Oct 2019 14:19:56 -0400
Received: from localhost (unknown [IPv6:2603:3023:50c:85e1:5314:1b70:2a53:887e])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 432191400EC70;
        Thu, 17 Oct 2019 11:19:56 -0700 (PDT)
Date:   Thu, 17 Oct 2019 14:19:55 -0400 (EDT)
Message-Id: <20191017.141955.1615614075310331285.davem@davemloft.net>
To:     oneukum@suse.com
Cc:     netdev@vger.kernel.org, johan@kernel.org
Subject: Re: [PATCH] usb: hso: obey DMA rules in tiocmget
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191017095339.25034-1-oneukum@suse.com>
References: <20191017095339.25034-1-oneukum@suse.com>
X-Mailer: Mew version 6.8 on Emacs 26.2
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 17 Oct 2019 11:19:56 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Oliver Neukum <oneukum@suse.com>
Date: Thu, 17 Oct 2019 11:53:38 +0200

> The serial state information must not be embedded into another
> data structure, as this interferes with cache handling for DMA
> on architectures without cache coherence..
> That would result in data corruption on some architectures
> Allocating it separately.
> 
> Signed-off-by: Oliver Neukum <oneukum@suse.com>

Applied, thanks Oliver.
