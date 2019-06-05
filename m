Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B50AF36453
	for <lists+netdev@lfdr.de>; Wed,  5 Jun 2019 21:13:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726532AbfFETNB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jun 2019 15:13:01 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:38412 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726280AbfFETNB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Jun 2019 15:13:01 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id E7FC41510F004;
        Wed,  5 Jun 2019 12:13:00 -0700 (PDT)
Date:   Wed, 05 Jun 2019 12:13:00 -0700 (PDT)
Message-Id: <20190605.121300.1860314739201231483.davem@davemloft.net>
To:     festevam@gmail.com
Cc:     fugang.duan@nxp.com, netdev@vger.kernel.org
Subject: Re: [PATCH v3 net-next] net: fec_ptp: Use dev_err() instead of
 pr_err()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190605131035.9267-1-festevam@gmail.com>
References: <20190605131035.9267-1-festevam@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 05 Jun 2019 12:13:01 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Fabio Estevam <festevam@gmail.com>
Date: Wed,  5 Jun 2019 10:10:35 -0300

> dev_err() is more appropriate for printing error messages inside
> drivers, so switch to dev_err().
> 
> Signed-off-by: Fabio Estevam <festevam@gmail.com>
> Acked-by: Fugang Duan <fugang.duan@nxp.com>
> ---
> Changes since v2:
> - Made it a standalone patch
> - Collected Andy's Ack

Applied.
