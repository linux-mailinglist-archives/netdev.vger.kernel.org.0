Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B2371E8E94
	for <lists+netdev@lfdr.de>; Tue, 29 Oct 2019 18:48:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730051AbfJ2RsQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Oct 2019 13:48:16 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:57528 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726566AbfJ2RsP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Oct 2019 13:48:15 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 6D6BD14CDECD3;
        Tue, 29 Oct 2019 10:48:14 -0700 (PDT)
Date:   Tue, 29 Oct 2019 10:48:14 -0700 (PDT)
Message-Id: <20191029.104814.1303198183585893748.davem@davemloft.net>
To:     colin.king@canonical.com
Cc:     epomozov@marvell.com, igor.russkikh@aquantia.com,
        dmitry.bezrukov@aquantia.com, sergey.samoilenko@aquantia.com,
        netdev@vger.kernel.org, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH][next] net: aquantia: fix unintention integer overflow
 on left shift
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191025115811.20433-1-colin.king@canonical.com>
References: <20191025115811.20433-1-colin.king@canonical.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 29 Oct 2019 10:48:14 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Colin King <colin.king@canonical.com>
Date: Fri, 25 Oct 2019 12:58:11 +0100

> From: Colin Ian King <colin.king@canonical.com>
> 
> Shifting the integer value 1 is evaluated using 32-bit
> arithmetic and then used in an expression that expects a 64-bit
> value, so there is potentially an integer overflow. Fix this
> by using the BIT_ULL macro to perform the shift and avoid the
> overflow.
> 
> Addresses-Coverity: ("Unintentional integer overflow")
> Fixes: 04a1839950d9 ("net: aquantia: implement data PTP datapath")
> Signed-off-by: Colin Ian King <colin.king@canonical.com>

Applied.
