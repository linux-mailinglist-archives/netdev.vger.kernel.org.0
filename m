Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6D1B595351
	for <lists+netdev@lfdr.de>; Tue, 20 Aug 2019 03:23:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728800AbfHTBXN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Aug 2019 21:23:13 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:39252 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728647AbfHTBXN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Aug 2019 21:23:13 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 7970814B8DDBD;
        Mon, 19 Aug 2019 18:23:12 -0700 (PDT)
Date:   Mon, 19 Aug 2019 18:23:11 -0700 (PDT)
Message-Id: <20190819.182311.2133857752691097436.davem@davemloft.net>
To:     lirongqing@baidu.com
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH][net-next] net: remove empty inet_exit_net
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1566216315-18506-1-git-send-email-lirongqing@baidu.com>
References: <1566216315-18506-1-git-send-email-lirongqing@baidu.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 19 Aug 2019 18:23:12 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Li RongQing <lirongqing@baidu.com>
Date: Mon, 19 Aug 2019 20:05:15 +0800

> Pointer members of an object with static storage duration, if not
> explicitly initialized, will be initialized to a NULL pointer. The
> net namespace API checks if this pointer is not NULL before using it,
> it are safe to remove the function.
> 
> Signed-off-by: Li RongQing <lirongqing@baidu.com>

Applied.
