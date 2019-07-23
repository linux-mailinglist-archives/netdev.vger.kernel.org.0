Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 66E1A71F99
	for <lists+netdev@lfdr.de>; Tue, 23 Jul 2019 20:50:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732058AbfGWSuH convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 23 Jul 2019 14:50:07 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:35076 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726621AbfGWSuH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Jul 2019 14:50:07 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id E8BF7153B91FC;
        Tue, 23 Jul 2019 11:50:06 -0700 (PDT)
Date:   Tue, 23 Jul 2019 11:50:06 -0700 (PDT)
Message-Id: <20190723.115006.370638410899452293.davem@davemloft.net>
To:     willy@infradead.org
Cc:     opensource@vdorst.com, kbuild-all@01.org, netdev@vger.kernel.org
Subject: Re: [net-next:master 13/14]
 drivers/net/ethernet/faraday/ftgmac100.c:777:13: error: 'skb_frag_t {aka
 struct bio_vec}' has no member named 'size'
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190723115238.GJ363@bombadil.infradead.org>
References: <201907231400.Q5QaKepi%lkp@intel.com>
        <20190723085844.Horde.ehPsGFdWI2BCQdl_UyzJxlS@www.vdorst.com>
        <20190723115238.GJ363@bombadil.infradead.org>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 23 Jul 2019 11:50:07 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Matthew Wilcox <willy@infradead.org>
Date: Tue, 23 Jul 2019 04:52:38 -0700

> On Tue, Jul 23, 2019 at 08:58:44AM +0000, René van Dorst wrote:
>> Hi Matthew,
>> 
>> I see the same issue for the mediatek/mtk_eth_soc driver.
> 
> Thanks, Rene.  The root problem for both of these drivers is that neither
> are built on x86 with CONFIG_COMPILE_TEST.  Is it possible to fix this?
> 
> An untested patch to fix both of these problems (and two more that I
> spotted):

I took care of the ftgmac100 case in the net-next tree, sorry I didn't see
this first...
