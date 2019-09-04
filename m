Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CBA6DA9679
	for <lists+netdev@lfdr.de>; Thu,  5 Sep 2019 00:30:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729563AbfIDWa2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Sep 2019 18:30:28 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:38750 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727156AbfIDWa2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Sep 2019 18:30:28 -0400
Received: from localhost (unknown [62.21.130.100])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id B734E152863C3;
        Wed,  4 Sep 2019 15:30:26 -0700 (PDT)
Date:   Wed, 04 Sep 2019 15:30:25 -0700 (PDT)
Message-Id: <20190904.153025.189079402256558885.davem@davemloft.net>
To:     lucien.xin@gmail.com
Cc:     netdev@vger.kernel.org, linux-sctp@vger.kernel.org,
        marcelo.leitner@gmail.com, nhorman@tuxdriver.com
Subject: Re: [PATCH net] sctp: use transport pf_retrans in
 sctp_do_8_2_transport_strike
From:   David Miller <davem@davemloft.net>
In-Reply-To: <41769d6033d27d629798e060671a3b21f22e2a21.1567437861.git.lucien.xin@gmail.com>
References: <41769d6033d27d629798e060671a3b21f22e2a21.1567437861.git.lucien.xin@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.2
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 04 Sep 2019 15:30:27 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Xin Long <lucien.xin@gmail.com>
Date: Mon,  2 Sep 2019 23:24:21 +0800

> Transport should use its own pf_retrans to do the error_count
> check, instead of asoc's. Otherwise, it's meaningless to make
> pf_retrans per transport.
> 
> Fixes: 5aa93bcf66f4 ("sctp: Implement quick failover draft from tsvwg")
> Signed-off-by: Xin Long <lucien.xin@gmail.com>

Applied and queued up for -stable.
