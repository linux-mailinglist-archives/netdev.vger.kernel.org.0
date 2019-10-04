Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9087BCC4CE
	for <lists+netdev@lfdr.de>; Fri,  4 Oct 2019 23:29:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729079AbfJDV3a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Oct 2019 17:29:30 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:59214 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725775AbfJDV33 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Oct 2019 17:29:29 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id C5B1314F0FA9E;
        Fri,  4 Oct 2019 14:29:27 -0700 (PDT)
Date:   Fri, 04 Oct 2019 14:29:27 -0700 (PDT)
Message-Id: <20191004.142927.1793162422918575893.davem@davemloft.net>
To:     adobriyan@gmail.com
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH] igmp: uninline ip_mc_validate_checksum()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191003212652.GA13122@avx2>
References: <20191003212652.GA13122@avx2>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 04 Oct 2019 14:29:27 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alexey Dobriyan <adobriyan@gmail.com>
Date: Fri, 4 Oct 2019 00:26:52 +0300

> This function is only used via function pointer.
> 
> "inline" doesn't hurt given that taking address of an inline function
> forces out-of-line version but it doesn't help either.
> 
> Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>

Applied.
