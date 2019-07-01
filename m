Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1D5EE5C276
	for <lists+netdev@lfdr.de>; Mon,  1 Jul 2019 20:00:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726576AbfGASAN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jul 2019 14:00:13 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:46360 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725853AbfGASAN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Jul 2019 14:00:13 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 74C9B14C1A62F;
        Mon,  1 Jul 2019 11:00:12 -0700 (PDT)
Date:   Mon, 01 Jul 2019 11:00:11 -0700 (PDT)
Message-Id: <20190701.110011.200125223653333509.davem@davemloft.net>
To:     bnvandana@gmail.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        skhan@linuxfoundation.org, gregkh@linuxfoundation.org,
        linux-kernel-mentees@lists.linuxfoundation.org
Subject: Re: [PATCH] net:gue.h:Fix shifting signed 32-bit value by 31 bits
 problem
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190701141610.3681-1-bnvandana@gmail.com>
References: <20190701141610.3681-1-bnvandana@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 01 Jul 2019 11:00:12 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vandana BN <bnvandana@gmail.com>
Date: Mon,  1 Jul 2019 19:46:10 +0530

> Fix GUE_PFLAG_REMCSUM to use "U" cast to avoid shifting signed
> 32-bit value by 31 bits problem.
> 
> Signed-off-by: Vandana BN <bnvandana@gmail.com>

Applied.
