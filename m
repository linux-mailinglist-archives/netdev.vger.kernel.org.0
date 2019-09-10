Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A0376AF085
	for <lists+netdev@lfdr.de>; Tue, 10 Sep 2019 19:33:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437085AbfIJRdf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Sep 2019 13:33:35 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:59938 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2436774AbfIJRdf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Sep 2019 13:33:35 -0400
Received: from localhost (unknown [88.214.187.211])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 6303E154F0CBE;
        Tue, 10 Sep 2019 10:33:33 -0700 (PDT)
Date:   Tue, 10 Sep 2019 19:33:31 +0200 (CEST)
Message-Id: <20190910.193331.2286136885426226233.davem@davemloft.net>
To:     lucien.xin@gmail.com
Cc:     netdev@vger.kernel.org, linux-sctp@vger.kernel.org,
        marcelo.leitner@gmail.com, nhorman@tuxdriver.com
Subject: Re: [PATCH net] sctp: fix the missing put_user when dumping
 transport thresholds
From:   David Miller <davem@davemloft.net>
In-Reply-To: <3fa4f7700c93f06530c80bc666d1696cb7c077de.1568014409.git.lucien.xin@gmail.com>
References: <3fa4f7700c93f06530c80bc666d1696cb7c077de.1568014409.git.lucien.xin@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.2
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 10 Sep 2019 10:33:34 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Xin Long <lucien.xin@gmail.com>
Date: Mon,  9 Sep 2019 15:33:29 +0800

> This issue causes SCTP_PEER_ADDR_THLDS sockopt not to be able to dump
> a transport thresholds info.
> 
> Fix it by adding 'goto' put_user in sctp_getsockopt_paddr_thresholds.
> 
> Fixes: 8add543e369d ("sctp: add SCTP_FUTURE_ASSOC for SCTP_PEER_ADDR_THLDS sockopt")
> Signed-off-by: Xin Long <lucien.xin@gmail.com>

Applied and queued up for -stable, thanks.
