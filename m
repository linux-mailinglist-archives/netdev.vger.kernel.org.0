Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 37C0C13739
	for <lists+netdev@lfdr.de>; Sat,  4 May 2019 06:06:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726258AbfEDEGL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 May 2019 00:06:11 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:55718 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725648AbfEDEGL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 May 2019 00:06:11 -0400
Received: from localhost (unknown [75.104.87.19])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 21FF014D7C2D7;
        Fri,  3 May 2019 21:05:54 -0700 (PDT)
Date:   Sat, 04 May 2019 00:05:45 -0400 (EDT)
Message-Id: <20190504.000545.1402535421214277538.davem@davemloft.net>
To:     gustavo@embeddedor.com
Cc:     inaky.perez-gonzalez@intel.com, linux-wimax@intel.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] wimax/i2400m: use struct_size() helper
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190501032732.GA17956@embeddedor>
References: <20190501032732.GA17956@embeddedor>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 03 May 2019 21:06:10 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Date: Tue, 30 Apr 2019 22:27:32 -0500

> Make use of the struct_size() helper instead of an open-coded version
> in order to avoid any potential type mistakes, in particular in the
> context in which this code is being used.
> 
> So, replace code of the following form:
> 
> sizeof(*tx_msg) + le16_to_cpu(tx_msg->num_pls) * sizeof(tx_msg->pld[0]);
> 
> with:
> 
> struct_size(tx_msg, pld, le16_to_cpu(tx_msg->num_pls));
> 
> This code was detected with the help of Coccinelle.
> 
> Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>

Applied.
