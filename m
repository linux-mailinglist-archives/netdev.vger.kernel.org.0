Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C598C136570
	for <lists+netdev@lfdr.de>; Fri, 10 Jan 2020 03:37:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730880AbgAJChV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jan 2020 21:37:21 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:60760 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730764AbgAJChV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jan 2020 21:37:21 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1c3::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id C211A1573659E;
        Thu,  9 Jan 2020 18:37:20 -0800 (PST)
Date:   Thu, 09 Jan 2020 18:37:20 -0800 (PST)
Message-Id: <20200109.183720.1582414687576585504.davem@davemloft.net>
To:     lirongqing@baidu.com
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH][net-next] flow_dissector: fix document for
 skb_flow_get_icmp_tci
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1578531596-6369-1-git-send-email-lirongqing@baidu.com>
References: <1578531596-6369-1-git-send-email-lirongqing@baidu.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 09 Jan 2020 18:37:20 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Li RongQing <lirongqing@baidu.com>
Date: Thu,  9 Jan 2020 08:59:56 +0800

> using correct input parameter name to fix the below warning:
> 
> net/core/flow_dissector.c:242: warning: Function parameter or member 'thoff' not described in 'skb_flow_get_icmp_tci'
> net/core/flow_dissector.c:242: warning: Excess function parameter 'toff' description in 'skb_flow_get_icmp_tci'
> 
> Signed-off-by: Li RongQing <lirongqing@baidu.com>

Applied.
