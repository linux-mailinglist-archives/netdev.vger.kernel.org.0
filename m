Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 68008989EE
	for <lists+netdev@lfdr.de>; Thu, 22 Aug 2019 05:45:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729135AbfHVDn7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Aug 2019 23:43:59 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:37776 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726894AbfHVDn7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Aug 2019 23:43:59 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 53F791513ABC4;
        Wed, 21 Aug 2019 20:43:59 -0700 (PDT)
Date:   Wed, 21 Aug 2019 20:43:58 -0700 (PDT)
Message-Id: <20190821.204358.259052512970648142.davem@davemloft.net>
To:     lirongqing@baidu.com
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH] net: fix icmp_socket_deliver argument 2 input
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1566269160-11031-1-git-send-email-lirongqing@baidu.com>
References: <1566269160-11031-1-git-send-email-lirongqing@baidu.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 21 Aug 2019 20:43:59 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Li RongQing <lirongqing@baidu.com>
Date: Tue, 20 Aug 2019 10:46:00 +0800

> it expects a unsigned int, but got a __be32
> 
> Signed-off-by: Li RongQing <lirongqing@baidu.com>
> Signed-off-by: Zhang Yu <zhangyu31@baidu.com>

Applied, but this causes no functional problems because all of the
per-protocol handlers ignore the info argument for redirects.
