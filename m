Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AD32299FA2
	for <lists+netdev@lfdr.de>; Thu, 22 Aug 2019 21:16:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391756AbfHVTOc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Aug 2019 15:14:32 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:47488 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389212AbfHVTOc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Aug 2019 15:14:32 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 7E830153413D3;
        Thu, 22 Aug 2019 12:14:31 -0700 (PDT)
Date:   Thu, 22 Aug 2019 12:14:30 -0700 (PDT)
Message-Id: <20190822.121430.1623821241154451911.davem@davemloft.net>
To:     colin.king@canonical.com
Cc:     dsahern@kernel.org, kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org,
        netdev@vger.kernel.org, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] nexthops: remove redundant assignment to variable err
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190822125340.30783-1-colin.king@canonical.com>
References: <20190822125340.30783-1-colin.king@canonical.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 22 Aug 2019 12:14:31 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Colin King <colin.king@canonical.com>
Date: Thu, 22 Aug 2019 13:53:40 +0100

> From: Colin Ian King <colin.king@canonical.com>
> 
> Variable err is initialized to a value that is never read and it is
> re-assigned later. The initialization is redundant and can be removed.
> 
> Addresses-Coverity: ("Unused Value")
> Signed-off-by: Colin Ian King <colin.king@canonical.com>

Applied to net-next.
