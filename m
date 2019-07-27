Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 75E3D77BD4
	for <lists+netdev@lfdr.de>; Sat, 27 Jul 2019 22:32:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388369AbfG0UcV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 27 Jul 2019 16:32:21 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:39908 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387841AbfG0UcV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 27 Jul 2019 16:32:21 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 82C31153409D9;
        Sat, 27 Jul 2019 13:32:20 -0700 (PDT)
Date:   Sat, 27 Jul 2019 13:32:20 -0700 (PDT)
Message-Id: <20190727.133220.1577010813654823977.davem@davemloft.net>
To:     colin.king@canonical.com
Cc:     dsahern@gmail.com, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: neigh: remove redundant assignment to variable
 bucket
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190726094611.3597-1-colin.king@canonical.com>
References: <20190726094611.3597-1-colin.king@canonical.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 27 Jul 2019 13:32:20 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Colin King <colin.king@canonical.com>
Date: Fri, 26 Jul 2019 10:46:11 +0100

> From: Colin Ian King <colin.king@canonical.com>
> 
> The variable bucket is being initialized with a value that is never
> read and it is being updated later with a new value in a following
> for-loop. The initialization is redundant and can be removed.
> 
> Addresses-Coverity: ("Unused value")
> Signed-off-by: Colin Ian King <colin.king@canonical.com>

Applied to net-next.
