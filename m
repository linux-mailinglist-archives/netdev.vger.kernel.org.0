Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1C91C60DD8
	for <lists+netdev@lfdr.de>; Sat,  6 Jul 2019 00:30:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725962AbfGEWau (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Jul 2019 18:30:50 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:43590 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725764AbfGEWat (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Jul 2019 18:30:49 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 7EC3915042889;
        Fri,  5 Jul 2019 15:30:49 -0700 (PDT)
Date:   Fri, 05 Jul 2019 15:30:49 -0700 (PDT)
Message-Id: <20190705.153049.639967138983606349.davem@davemloft.net>
To:     lirongqing@baidu.com
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH][net-next] net: remove unused parameter from
 skb_checksum_try_convert
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1562231006-16341-1-git-send-email-lirongqing@baidu.com>
References: <1562231006-16341-1-git-send-email-lirongqing@baidu.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 05 Jul 2019 15:30:49 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Li RongQing <lirongqing@baidu.com>
Date: Thu,  4 Jul 2019 17:03:26 +0800

> the check parameter is never used
> 
> Signed-off-by: Li RongQing <lirongqing@baidu.com>

Applied.
