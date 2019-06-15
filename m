Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 70B1F47219
	for <lists+netdev@lfdr.de>; Sat, 15 Jun 2019 22:39:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727012AbfFOUiw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 Jun 2019 16:38:52 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:39418 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726490AbfFOUiw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 15 Jun 2019 16:38:52 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 1587B14EB9021;
        Sat, 15 Jun 2019 13:38:52 -0700 (PDT)
Date:   Sat, 15 Jun 2019 13:38:51 -0700 (PDT)
Message-Id: <20190615.133851.553488737561865526.davem@davemloft.net>
To:     christophe.jaillet@wanadoo.fr
Cc:     aviad.krawczyk@huawei.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH net-next] hinic: Use devm_kasprintf instead of hard
 coding it
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190613195412.1702-1-christophe.jaillet@wanadoo.fr>
References: <20190613195412.1702-1-christophe.jaillet@wanadoo.fr>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 15 Jun 2019 13:38:52 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Date: Thu, 13 Jun 2019 21:54:12 +0200

> 'devm_kasprintf' is less verbose than:
>    snprintf(NULL, 0, ...);
>    devm_kzalloc(...);
>    sprintf
> so use it instead.
> 
> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

Applied.
