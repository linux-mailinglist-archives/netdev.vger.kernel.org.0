Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D1718D991D
	for <lists+netdev@lfdr.de>; Wed, 16 Oct 2019 20:25:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390933AbfJPSZf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Oct 2019 14:25:35 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:52636 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730253AbfJPSZf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Oct 2019 14:25:35 -0400
Received: from localhost (unknown [IPv6:2603:3023:50c:85e1:5314:1b70:2a53:887e])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id BC55C1425BD91;
        Wed, 16 Oct 2019 11:25:34 -0700 (PDT)
Date:   Wed, 16 Oct 2019 14:25:34 -0400 (EDT)
Message-Id: <20191016.142534.1360443052637911866.davem@davemloft.net>
To:     lucien.xin@gmail.com
Cc:     netdev@vger.kernel.org, linux-sctp@vger.kernel.org,
        marcelo.leitner@gmail.com, nhorman@tuxdriver.com,
        david.laight@aculab.com
Subject: Re: [PATCHv3 net-next 0/5] sctp: update from rfc7829
From:   David Miller <davem@davemloft.net>
In-Reply-To: <cover.1571033544.git.lucien.xin@gmail.com>
References: <cover.1571033544.git.lucien.xin@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.2
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 16 Oct 2019 11:25:35 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Xin Long <lucien.xin@gmail.com>
Date: Mon, 14 Oct 2019 14:14:43 +0800

> SCTP-PF was implemented based on a Internet-Draft in 2012:
> 
>   https://tools.ietf.org/html/draft-nishida-tsvwg-sctp-failover-05
> 
> It's been updated quite a few by rfc7829 in 2016.
> 
> This patchset adds the following features:

Sorry but I'm tossing these until an knowledgable SCTP person can
look at them.
