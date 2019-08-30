Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A1B6AA3F88
	for <lists+netdev@lfdr.de>; Fri, 30 Aug 2019 23:15:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728209AbfH3VPJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Aug 2019 17:15:09 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:42008 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727991AbfH3VPJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Aug 2019 17:15:09 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 860B1154FE28F;
        Fri, 30 Aug 2019 14:15:08 -0700 (PDT)
Date:   Fri, 30 Aug 2019 14:15:08 -0700 (PDT)
Message-Id: <20190830.141508.762893998883327616.davem@davemloft.net>
To:     colin.king@canonical.com
Cc:     m.grzeschik@pengutronix.de, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH][V2] arcnet: capmode: remove redundant assignment to
 pointer pkt
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190828231450.22424-1-colin.king@canonical.com>
References: <20190828231450.22424-1-colin.king@canonical.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 30 Aug 2019 14:15:08 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Colin King <colin.king@canonical.com>
Date: Thu, 29 Aug 2019 00:14:50 +0100

> From: Colin Ian King <colin.king@canonical.com>
> 
> Pointer pkt is being initialized with a value that is never read
> and pkt is being re-assigned a little later on. The assignment is
> redundant and hence can be removed.
> 
> Addresses-Coverity: ("Ununsed value")
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> ---
> 
> V2: fix typo in patch description, pkg -> pkt

Applied to net-next.
