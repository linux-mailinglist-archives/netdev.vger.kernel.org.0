Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D35843699B
	for <lists+netdev@lfdr.de>; Thu,  6 Jun 2019 03:49:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726682AbfFFBtD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jun 2019 21:49:03 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:44098 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726613AbfFFBtD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Jun 2019 21:49:03 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 88305144DC6C5;
        Wed,  5 Jun 2019 18:49:02 -0700 (PDT)
Date:   Wed, 05 Jun 2019 18:49:02 -0700 (PDT)
Message-Id: <20190605.184902.257610327160365131.davem@davemloft.net>
To:     liuzhiqiang26@huawei.com
Cc:     edumazet@google.com, netdev@vger.kernel.org,
        mingfangsen@huawei.com, zhoukang7@huawei.com,
        wangxiaogang3@huawei.com
Subject: Re: [PATCH net] inet_connection_sock: remove unused parameter of
 reqsk_queue_unlink func
From:   David Miller <davem@davemloft.net>
In-Reply-To: <546c6d2f-39ca-521d-7009-d80df735bd9e@huawei.com>
References: <CANn89iK+4QC7bbku5MUczzKnWgL6HG9JAT6+03Q2paxBKhC4Xw@mail.gmail.com>
        <40f32663-f100-169c-4d1b-79d64d68a5f9@huawei.com>
        <546c6d2f-39ca-521d-7009-d80df735bd9e@huawei.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 05 Jun 2019 18:49:02 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Zhiqiang Liu <liuzhiqiang26@huawei.com>
Date: Wed, 5 Jun 2019 18:49:49 +0800

> small cleanup: "struct request_sock_queue *queue" parameter of reqsk_queue_unlink
> func is never used in the func, so we can remove it.
> 
> Signed-off-by: Zhiqiang Liu <liuzhiqiang26@huawei.com>

Applied, thanks.
