Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 95C5B559B3
	for <lists+netdev@lfdr.de>; Tue, 25 Jun 2019 23:09:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726329AbfFYVJf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jun 2019 17:09:35 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:51274 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725782AbfFYVJe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jun 2019 17:09:34 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 5F90213411C1E;
        Tue, 25 Jun 2019 14:09:34 -0700 (PDT)
Date:   Tue, 25 Jun 2019 14:09:34 -0700 (PDT)
Message-Id: <20190625.140934.145849418200881936.davem@davemloft.net>
To:     jakub.kicinski@netronome.com
Cc:     netdev@vger.kernel.org, oss-drivers@netronome.com,
        nafea@amazon.com, dwmw2@infradead.org, sameehj@amazon.com,
        zorik@amazon.com, saeedb@amazon.com, netanel@amazon.com
Subject: Re: [PATCH net-next] Revert "net: ena: ethtool: add extra
 properties retrieval via get_priv_flags"
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190625165956.19278-1-jakub.kicinski@netronome.com>
References: <20190625165956.19278-1-jakub.kicinski@netronome.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 25 Jun 2019 14:09:34 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jakub Kicinski <jakub.kicinski@netronome.com>
Date: Tue, 25 Jun 2019 09:59:56 -0700

> This reverts commit 315c28d2b714 ("net: ena: ethtool: add extra properties retrieval via get_priv_flags").
> 
> As discussed at netconf and on the mailing list we can't allow
> for the the abuse of private flags for exposing arbitrary device
> labels.
> 
> Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>

Applied, thanks Jakub.
