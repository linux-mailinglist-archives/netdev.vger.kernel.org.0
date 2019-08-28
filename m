Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EC0D9A0CB3
	for <lists+netdev@lfdr.de>; Wed, 28 Aug 2019 23:49:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726944AbfH1VtU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Aug 2019 17:49:20 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:37422 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726725AbfH1VtU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Aug 2019 17:49:20 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 37E19153A41DD;
        Wed, 28 Aug 2019 14:49:20 -0700 (PDT)
Date:   Wed, 28 Aug 2019 14:49:19 -0700 (PDT)
Message-Id: <20190828.144919.1567909381208986532.davem@davemloft.net>
To:     colin.king@canonical.com
Cc:     m.grzeschik@pengutronix.de, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] arcnet: capmode: remove redundant assignment to
 pointer pkt
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190827112954.26677-1-colin.king@canonical.com>
References: <20190827112954.26677-1-colin.king@canonical.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 28 Aug 2019 14:49:20 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Please fix the typo spotted by Sergei.
