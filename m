Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B9C79DDA9C
	for <lists+netdev@lfdr.de>; Sat, 19 Oct 2019 21:15:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726146AbfJSTOH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Oct 2019 15:14:07 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:42624 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726101AbfJSTOG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 19 Oct 2019 15:14:06 -0400
Received: from localhost (unknown [64.79.112.2])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 3BC30148FE66F;
        Sat, 19 Oct 2019 12:14:06 -0700 (PDT)
Date:   Sat, 19 Oct 2019 12:14:05 -0700 (PDT)
Message-Id: <20191019.121405.1167286770949885238.davem@davemloft.net>
To:     jakub.kicinski@netronome.com
Cc:     netdev@vger.kernel.org, oss-drivers@netronome.com,
        stephen@networkplumber.org, xiyou.wangcong@gmail.com
Subject: Re: [PATCH net v2 0/2] net: netem: fix further issues with packet
 corruption
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191018161658.26481-1-jakub.kicinski@netronome.com>
References: <20191018161658.26481-1-jakub.kicinski@netronome.com>
X-Mailer: Mew version 6.8 on Emacs 26.2
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 19 Oct 2019 12:14:06 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jakub Kicinski <jakub.kicinski@netronome.com>
Date: Fri, 18 Oct 2019 09:16:56 -0700

> This set is fixing two more issues with the netem packet corruption.
> 
> First patch (which was previously posted) avoids NULL pointer dereference
> if the first frame gets freed due to allocation or checksum failure.
> v2 improves the clarity of the code a little as requested by Cong.
> 
> Second patch ensures we don't return SUCCESS if the frame was in fact
> dropped. Thanks to this commit message for patch 1 no longer needs the
> "this will still break with a single-frame failure" disclaimer.

Series applied and queued up for -stable, thanks.
