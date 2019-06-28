Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6831E59383
	for <lists+netdev@lfdr.de>; Fri, 28 Jun 2019 07:38:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726673AbfF1Fit (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jun 2019 01:38:49 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:38446 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726240AbfF1Fit (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Jun 2019 01:38:49 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id A338E14C7E611;
        Thu, 27 Jun 2019 22:38:48 -0700 (PDT)
Date:   Thu, 27 Jun 2019 22:38:48 -0700 (PDT)
Message-Id: <20190627.223848.1576307240470126188.davem@davemloft.net>
To:     sergej.benilov@googlemail.com
Cc:     venza@brownhat.org, netdev@vger.kernel.org
Subject: Re: [PATCH] sis900: remove TxIDLE
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190624212102.15844-1-sergej.benilov@googlemail.com>
References: <20190624212102.15844-1-sergej.benilov@googlemail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 27 Jun 2019 22:38:48 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sergej Benilov <sergej.benilov@googlemail.com>
Date: Mon, 24 Jun 2019 23:21:02 +0200

> Before "sis900: fix TX completion" patch, TX completion was done on TxIDLE interrupt.
> TX completion also was the only thing done on TxIDLE interrupt.
> Since "sis900: fix TX completion", TX completion is done on TxDESC interrupt.
> So it is not necessary any more to set and to check for TxIDLE.
> 
> Eliminate TxIDLE from sis900.
> Correct some typos, too.
> 
> Signed-off-by: Sergej Benilov <sergej.benilov@googlemail.com>

Applied to net-next.
