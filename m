Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B8DAC3ABC6
	for <lists+netdev@lfdr.de>; Sun,  9 Jun 2019 22:32:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729070AbfFIUcO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 Jun 2019 16:32:14 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:45436 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725933AbfFIUcO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 9 Jun 2019 16:32:14 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id D3A6E14DF40D6;
        Sun,  9 Jun 2019 13:32:13 -0700 (PDT)
Date:   Sun, 09 Jun 2019 13:32:13 -0700 (PDT)
Message-Id: <20190609.133213.127991801665240939.davem@davemloft.net>
To:     festevam@gmail.com
Cc:     fugang.duan@nxp.com, netdev@vger.kernel.org
Subject: Re: [PATCH v3 net-next] net: fec_main: Use dev_err() instead of
 pr_err()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190607121418.16760-1-festevam@gmail.com>
References: <20190607121418.16760-1-festevam@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 09 Jun 2019 13:32:14 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Fabio Estevam <festevam@gmail.com>
Date: Fri,  7 Jun 2019 09:14:18 -0300

> dev_err() is more appropriate for printing error messages inside
> drivers, so switch to dev_err().
> 
> Signed-off-by: Fabio Estevam <festevam@gmail.com>
> ---
> Changes since v2:
> - Use dev_err() instead of netdev_err() - Andy

Applied.
