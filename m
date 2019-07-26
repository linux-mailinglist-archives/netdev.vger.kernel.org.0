Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C54DF77333
	for <lists+netdev@lfdr.de>; Fri, 26 Jul 2019 23:06:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728181AbfGZVF6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jul 2019 17:05:58 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:55070 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726102AbfGZVF6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Jul 2019 17:05:58 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id BEC3612665372;
        Fri, 26 Jul 2019 14:05:57 -0700 (PDT)
Date:   Fri, 26 Jul 2019 14:05:57 -0700 (PDT)
Message-Id: <20190726.140557.1125275118286592756.davem@davemloft.net>
To:     michal.kalderon@marvell.com
Cc:     ariel.elior@marvell.com, netdev@vger.kernel.org
Subject: Re: [PATCH] qed: RDMA - Fix the hw_ver returned in device
 attributes
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190725105955.12492-1-michal.kalderon@marvell.com>
References: <20190725105955.12492-1-michal.kalderon@marvell.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 26 Jul 2019 14:05:57 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Michal Kalderon <michal.kalderon@marvell.com>
Date: Thu, 25 Jul 2019 13:59:55 +0300

> The hw_ver field was initialized to zero. Return the chip revision.
> This is relevant for rdma driver.
> 
> Signed-off-by: Michal Kalderon <michal.kalderon@marvell.com>

Applied.
