Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 025A95C6FA
	for <lists+netdev@lfdr.de>; Tue,  2 Jul 2019 04:12:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727070AbfGBCMm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jul 2019 22:12:42 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:53962 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726362AbfGBCMm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Jul 2019 22:12:42 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 85A2114DE97D0;
        Mon,  1 Jul 2019 19:12:41 -0700 (PDT)
Date:   Mon, 01 Jul 2019 19:12:41 -0700 (PDT)
Message-Id: <20190701.191241.335884007515356911.davem@davemloft.net>
To:     jon.maloy@ericsson.com
Cc:     netdev@vger.kernel.org, gordan.mihaljevic@dektech.com.au,
        tung.q.nguyen@dektech.com.au, hoang.h.le@dektech.com.au,
        canh.d.luu@dektech.com.au, ying.xue@windriver.com,
        tipc-discussion@lists.sourceforge.net
Subject: Re: [net-next 1/1] tipc: embed jiffies in macro TIPC_BC_RETR_LIM
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1561734380-26868-1-git-send-email-jon.maloy@ericsson.com>
References: <1561734380-26868-1-git-send-email-jon.maloy@ericsson.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 01 Jul 2019 19:12:41 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jon Maloy <jon.maloy@ericsson.com>
Date: Fri, 28 Jun 2019 17:06:20 +0200

> The macro TIPC_BC_RETR_LIM is always used in combination with 'jiffies',
> so we can just as well perform the addition in the macro itself. This
> way, we get a few shorter code lines and one less line break.
> 
> Signed-off-by: Jon Maloy <jon.maloy@ericsson.com>

Applied.
