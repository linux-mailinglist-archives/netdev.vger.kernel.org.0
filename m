Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 02DFE5893F
	for <lists+netdev@lfdr.de>; Thu, 27 Jun 2019 19:47:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727142AbfF0Rrn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jun 2019 13:47:43 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:57324 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726730AbfF0Rrn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jun 2019 13:47:43 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id DFF51126A7C4D;
        Thu, 27 Jun 2019 10:47:42 -0700 (PDT)
Date:   Thu, 27 Jun 2019 10:47:42 -0700 (PDT)
Message-Id: <20190627.104742.976893262207337850.davem@davemloft.net>
To:     huangfq.daxian@gmail.com
Cc:     doshir@vmware.com, pv-drivers@vmware.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 79/87] net: vmxnet3: remove memset after
 dma_alloc_coherent
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190627174509.5829-1-huangfq.daxian@gmail.com>
References: <20190627174509.5829-1-huangfq.daxian@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 27 Jun 2019 10:47:43 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


I'd kindly request that you separate these sets of changes into one
set per subsystem and submit them properly that way.

I'm really not going to sift through 87 patches and pull out the ones
individually that got to my tree(s).  That's your job to collect them
into appropriate groups properly.

Thank you.
