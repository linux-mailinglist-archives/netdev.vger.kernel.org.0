Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A6E34FC25A
	for <lists+netdev@lfdr.de>; Thu, 14 Nov 2019 10:09:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727521AbfKNJJk convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 14 Nov 2019 04:09:40 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:44716 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725920AbfKNJJj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Nov 2019 04:09:39 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 903B3140CF8AE;
        Thu, 14 Nov 2019 01:09:37 -0800 (PST)
Date:   Thu, 14 Nov 2019 01:09:35 -0800 (PST)
Message-Id: <20191114.010935.1214456698424489397.davem@davemloft.net>
To:     jouni.hogander@unikie.com
Cc:     netdev@vger.kernel.org, socketcan@hartkopp.net,
        lukas.bulwahn@gmail.com
Subject: Re: [PATCH] slip: Fix memory leak in slip_open error path
From:   David Miller <davem@davemloft.net>
In-Reply-To: <87sgmqapi4.fsf@unikie.com>
References: <20191113114502.22462-1-jouni.hogander@unikie.com>
        <87sgmqapi4.fsf@unikie.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 14 Nov 2019 01:09:37 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: jouni.hogander@unikie.com (Jouni Högander)
Date: Thu, 14 Nov 2019 09:25:23 +0200

> Observed panic in another error path in my overnight Syzkaller run with
> this patch. Better not to apply it. Sorry for inconvenience.

I already did, please send a revert or a fix.
