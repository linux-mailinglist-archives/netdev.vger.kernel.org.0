Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5BE47756C4
	for <lists+netdev@lfdr.de>; Thu, 25 Jul 2019 20:21:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726178AbfGYSVJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Jul 2019 14:21:09 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:36776 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725800AbfGYSVJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Jul 2019 14:21:09 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id B1B721401558C;
        Thu, 25 Jul 2019 11:21:08 -0700 (PDT)
Date:   Thu, 25 Jul 2019 11:21:08 -0700 (PDT)
Message-Id: <20190725.112108.2287417619951369896.davem@davemloft.net>
To:     rosenp@gmail.com
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH] net-next: ag71xx: Rearrange ag711xx struct to remove
 holes
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190723034309.16492-1-rosenp@gmail.com>
References: <20190723034309.16492-1-rosenp@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 25 Jul 2019 11:21:08 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Rosen Penev <rosenp@gmail.com>
Date: Mon, 22 Jul 2019 20:43:09 -0700

> Removed ____cacheline_aligned attribute to ring structs. This actually
> causes holes in the ag71xx struc as well as lower performance.

If you are legitimizing a change because of performance you must provide
detailed performance results that support this reason.

I'm not applying this patch until you respin it with the required
information.

Thank you.
