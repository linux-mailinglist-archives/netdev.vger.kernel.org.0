Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 46B84F9929
	for <lists+netdev@lfdr.de>; Tue, 12 Nov 2019 19:55:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726977AbfKLSzy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Nov 2019 13:55:54 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:47728 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726718AbfKLSzy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Nov 2019 13:55:54 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 06645154CC5B3;
        Tue, 12 Nov 2019 10:55:53 -0800 (PST)
Date:   Tue, 12 Nov 2019 10:55:53 -0800 (PST)
Message-Id: <20191112.105553.375219447113133169.davem@davemloft.net>
To:     zhengbin13@huawei.com
Cc:     irusskikh@marvell.com, netdev@vger.kernel.org
Subject: Re: [PATCH net-next v2 0/2] net: atlantic: make some symbol &
 function static
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1573541982-100413-1-git-send-email-zhengbin13@huawei.com>
References: <1573541982-100413-1-git-send-email-zhengbin13@huawei.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 12 Nov 2019 10:55:54 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: zhengbin <zhengbin13@huawei.com>
Date: Tue, 12 Nov 2019 14:59:40 +0800

> v1->v2: add Fixes tag

Series applied.
