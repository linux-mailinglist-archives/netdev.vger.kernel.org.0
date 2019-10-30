Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7D089E9439
	for <lists+netdev@lfdr.de>; Wed, 30 Oct 2019 01:51:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726686AbfJ3AvT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Oct 2019 20:51:19 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:33732 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726135AbfJ3AvT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Oct 2019 20:51:19 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id E16DF1404B87B;
        Tue, 29 Oct 2019 17:51:18 -0700 (PDT)
Date:   Tue, 29 Oct 2019 17:51:18 -0700 (PDT)
Message-Id: <20191029.175118.1799810828442095962.davem@davemloft.net>
To:     saurav.girepunje@gmail.com
Cc:     sgoutham@cavium.com, rric@kernel.org,
        linux-arm-kernel@lists.infradead.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, saurav.girepunje@hotmail.com
Subject: Re: [PATCH] cavium: thunder: Fix use true/false for bool type
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191028200949.GA28902@saurav>
References: <20191028200949.GA28902@saurav>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 29 Oct 2019 17:51:19 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Saurav Girepunje <saurav.girepunje@gmail.com>
Date: Tue, 29 Oct 2019 01:39:50 +0530

> use true/false on bool type variables for assignment.
> 
> Signed-off-by: Saurav Girepunje <saurav.girepunje@gmail.com>

Applied to net-next.
