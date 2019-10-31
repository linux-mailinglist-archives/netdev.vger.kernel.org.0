Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0479FEB8CA
	for <lists+netdev@lfdr.de>; Thu, 31 Oct 2019 22:13:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729885AbfJaVNf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Oct 2019 17:13:35 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:32818 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728514AbfJaVNf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 31 Oct 2019 17:13:35 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id D306B1500028E;
        Thu, 31 Oct 2019 14:13:34 -0700 (PDT)
Date:   Thu, 31 Oct 2019 14:13:34 -0700 (PDT)
Message-Id: <20191031.141334.860083978503478801.davem@davemloft.net>
To:     hch@lst.de
Cc:     tbogendoerfer@suse.de, linux-mips@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: ioc3_eth DMA API fixes
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191030211233.30157-1-hch@lst.de>
References: <20191030211233.30157-1-hch@lst.de>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 31 Oct 2019 14:13:35 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Christoph Hellwig <hch@lst.de>
Date: Wed, 30 Oct 2019 14:12:29 -0700

> Hi Dave and Thomas,
> 
> please take a look at this series which fixes DMA API usage in the ioc3
> ethernet driver.  At least the first one is a nasty abuse of internal
> APIs introduced in 5.4-rc which I'd prefer to be fixed before 5.4 final.

Please add the alignment code for 16K or whatever they need and I'll apply
this series.

Thanks.
