Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6E9BA191D79
	for <lists+netdev@lfdr.de>; Wed, 25 Mar 2020 00:24:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727060AbgCXXYX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Mar 2020 19:24:23 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:37860 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726257AbgCXXYX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Mar 2020 19:24:23 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 072BB159F4FAA;
        Tue, 24 Mar 2020 16:24:22 -0700 (PDT)
Date:   Tue, 24 Mar 2020 16:24:22 -0700 (PDT)
Message-Id: <20200324.162422.797841980156612399.davem@davemloft.net>
To:     rajur@chelsio.com
Cc:     netdev@vger.kernel.org, vishal@chelsio.com, nirranjan@chelsio.com,
        dt@chelsio.com
Subject: Re: [PATCH net] cxgb4/ptp: pass the sign of offset delta in FW CMD
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200324114000.5985-1-rajur@chelsio.com>
References: <20200324114000.5985-1-rajur@chelsio.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 24 Mar 2020 16:24:23 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Raju Rangoju <rajur@chelsio.com>
Date: Tue, 24 Mar 2020 17:10:00 +0530

> cxgb4_ptp_fineadjtime() doesn't pass the signedness of offset delta
> in FW_PTP_CMD. Fix it by passing correct sign.
> 
> Signed-off-by: Raju Rangoju <rajur@chelsio.com>

Applied, thanks.
