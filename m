Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0B9A25C247
	for <lists+netdev@lfdr.de>; Mon,  1 Jul 2019 19:49:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730003AbfGARtH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jul 2019 13:49:07 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:46206 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729972AbfGARtE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Jul 2019 13:49:04 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 03A8F14C03B04;
        Mon,  1 Jul 2019 10:49:03 -0700 (PDT)
Date:   Mon, 01 Jul 2019 10:49:03 -0700 (PDT)
Message-Id: <20190701.104903.1353371516845397024.davem@davemloft.net>
To:     bnvandana@gmail.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        skhan@linuxfoundation.org, gregkh@linuxfoundation.org,
        linux-kernel-mentees@lists.linuxfoundation.org
Subject: Re: [PATCH] net: dst.h: Fix shifting signed 32-bit value by 31
 bits problem
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190701115539.6738-1-bnvandana@gmail.com>
References: <20190701115539.6738-1-bnvandana@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 01 Jul 2019 10:49:04 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vandana BN <bnvandana@gmail.com>
Date: Mon,  1 Jul 2019 17:25:39 +0530

> Fix DST_FEATURE_ECN_CA to use "U" cast to avoid shifting signed
> 32-bit value by 31 bits problem.
> 
> Signed-off-by: Vandana BN <bnvandana@gmail.com>

Applied.
