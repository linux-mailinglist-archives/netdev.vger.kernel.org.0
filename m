Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 468496F597
	for <lists+netdev@lfdr.de>; Sun, 21 Jul 2019 22:31:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727366AbfGUUbi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 21 Jul 2019 16:31:38 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:34708 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726748AbfGUUbi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 21 Jul 2019 16:31:38 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 79FD615265E1C;
        Sun, 21 Jul 2019 13:31:37 -0700 (PDT)
Date:   Sun, 21 Jul 2019 13:31:37 -0700 (PDT)
Message-Id: <20190721.133137.1744555681294107147.davem@davemloft.net>
To:     vvs@virtuozzo.com
Cc:     linux-kernel@vger.kernel.org, zbr@ioremap.net,
        stanislav.kinsburskiy@gmail.com, netdev@vger.kernel.org
Subject: Re: [PATCH] connector: remove redundant input callback from cn_dev
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1f53c1fb-c42e-fb78-7b2b-ad6c4712fe72@virtuozzo.com>
References: <1f53c1fb-c42e-fb78-7b2b-ad6c4712fe72@virtuozzo.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 21 Jul 2019 13:31:37 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vasily Averin <vvs@virtuozzo.com>
Date: Thu, 18 Jul 2019 07:26:46 +0300

> A small cleanup: this callback is never used.
> Originally fixed by Stanislav Kinsburskiy <skinsbursky@virtuozzo.com>
> for OpenVZ7 bug OVZ-6877
> 
> cc: stanislav.kinsburskiy@gmail.com
> Signed-off-by: Vasily Averin <vvs@virtuozzo.com>

Applied.
