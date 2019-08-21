Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1B97898535
	for <lists+netdev@lfdr.de>; Wed, 21 Aug 2019 22:09:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727022AbfHUUIi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Aug 2019 16:08:38 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:33012 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726330AbfHUUIh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Aug 2019 16:08:37 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 6B99014C287B9;
        Wed, 21 Aug 2019 13:08:37 -0700 (PDT)
Date:   Wed, 21 Aug 2019 13:08:36 -0700 (PDT)
Message-Id: <20190821.130836.1248010321237115756.davem@davemloft.net>
To:     rppt@linux.ibm.com
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH] trivial: netns: fix typo in 'struct net.passive'
 description
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1566386969-6813-1-git-send-email-rppt@linux.ibm.com>
References: <1566386969-6813-1-git-send-email-rppt@linux.ibm.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 21 Aug 2019 13:08:37 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Mike Rapoport <rppt@linux.ibm.com>
Date: Wed, 21 Aug 2019 14:29:29 +0300

> Replace 'decided' with 'decide' so that comment would be
> 
> /* To decide when the network namespace should be freed. */
> 
> Signed-off-by: Mike Rapoport <rppt@linux.ibm.com>

Applied.
