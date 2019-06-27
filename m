Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 217BE586E5
	for <lists+netdev@lfdr.de>; Thu, 27 Jun 2019 18:21:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726497AbfF0QVp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jun 2019 12:21:45 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:55848 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726315AbfF0QVp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jun 2019 12:21:45 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 70E5E14DB4EBB;
        Thu, 27 Jun 2019 09:21:44 -0700 (PDT)
Date:   Thu, 27 Jun 2019 09:21:41 -0700 (PDT)
Message-Id: <20190627.092141.2018343219230286586.davem@davemloft.net>
To:     marcelo.leitner@gmail.com
Cc:     lucien.xin@gmail.com, netdev@vger.kernel.org,
        linux-sctp@vger.kernel.org, nhorman@tuxdriver.com,
        syzkaller-bugs@googlegroups.com
Subject: Re: [PATCH net] sctp: not bind the socket in sctp_connect
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190627025915.GA2747@localhost.localdomain>
References: <35a0e4f6ca68185117c6e5517d8ac924cc2f9d05.1561537899.git.lucien.xin@gmail.com>
        <20190627025915.GA2747@localhost.localdomain>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 27 Jun 2019 09:21:44 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Date: Wed, 26 Jun 2019 23:59:15 -0300

> Please give me another day to review this one. Thanks.

Sure, no problem.

