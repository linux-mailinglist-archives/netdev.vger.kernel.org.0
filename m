Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7EECFE95A2
	for <lists+netdev@lfdr.de>; Wed, 30 Oct 2019 05:14:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726451AbfJ3EOI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Oct 2019 00:14:08 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:35376 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725855AbfJ3EOI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Oct 2019 00:14:08 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 09FA914B7C52E;
        Tue, 29 Oct 2019 21:14:07 -0700 (PDT)
Date:   Tue, 29 Oct 2019 21:14:07 -0700 (PDT)
Message-Id: <20191029.211407.790828950610293560.davem@davemloft.net>
To:     yanjun.zhu@oracle.com
Cc:     jakub.kicinski@netronome.com, rain.1986.08.12@gmail.com,
        netdev@vger.kernel.org
Subject: Re: [PATCHv3 1/1] net: forcedeth: add xmit_more support
From:   David Miller <davem@davemloft.net>
In-Reply-To: <068ef3ce-eb72-b5db-1845-1350dfad3019@oracle.com>
References: <1572319812-27196-1-git-send-email-yanjun.zhu@oracle.com>
        <20191029103244.3139a6aa@cakuba.hsd1.ca.comcast.net>
        <068ef3ce-eb72-b5db-1845-1350dfad3019@oracle.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 29 Oct 2019 21:14:08 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Zhu Yanjun <yanjun.zhu@oracle.com>
Date: Wed, 30 Oct 2019 12:18:43 +0800

> If igb does not handle DMA error, it is not appropriate for us to
> handle DMA error.
> 
> After igb fixes this DMA error, I will follow.;-)

Sorry, this is an invalid and unaceptable argument.

Just because a bug exists in another driver, does not mean you
can copy that bug into your driver.

Fix the check, do things properly, and resubmit your patch only after
you've done that.

Thank you.
