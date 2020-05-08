Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE3851C9FF0
	for <lists+netdev@lfdr.de>; Fri,  8 May 2020 03:09:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726797AbgEHBJH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 May 2020 21:09:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726612AbgEHBJG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 May 2020 21:09:06 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D322DC05BD43;
        Thu,  7 May 2020 18:09:06 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 9005E119376D7;
        Thu,  7 May 2020 18:09:06 -0700 (PDT)
Date:   Thu, 07 May 2020 18:09:06 -0700 (PDT)
Message-Id: <20200507.180906.1564204342326324600.davem@davemloft.net>
To:     hslester96@gmail.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: microchip: encx24j600: add missed kthread_stop
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200507151320.792759-1-hslester96@gmail.com>
References: <20200507151320.792759-1-hslester96@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 07 May 2020 18:09:06 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Chuhong Yuan <hslester96@gmail.com>
Date: Thu,  7 May 2020 23:13:20 +0800

> This driver calls kthread_run() in probe, but forgets to call
> kthread_stop() in probe failure and remove.
> Add the missed kthread_stop() to fix it.
> 
> Signed-off-by: Chuhong Yuan <hslester96@gmail.com>

Applied, thanks.
