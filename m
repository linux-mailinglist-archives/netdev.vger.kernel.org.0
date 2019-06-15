Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9EF7E47230
	for <lists+netdev@lfdr.de>; Sat, 15 Jun 2019 23:06:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726792AbfFOVGb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 Jun 2019 17:06:31 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:39784 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725535AbfFOVGb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 15 Jun 2019 17:06:31 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 7616514EC699F;
        Sat, 15 Jun 2019 14:06:29 -0700 (PDT)
Date:   Sat, 15 Jun 2019 14:06:29 -0700 (PDT)
Message-Id: <20190615.140629.470387183101622408.davem@davemloft.net>
To:     jiri@resnulli.us
Cc:     netdev@vger.kernel.org, jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        mlxsw@mellanox.com
Subject: Re: [patch net-next] net: sched: remove NET_CLS_IND config option
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190615090349.12036-1-jiri@resnulli.us>
References: <20190615090349.12036-1-jiri@resnulli.us>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 15 Jun 2019 14:06:29 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@resnulli.us>
Date: Sat, 15 Jun 2019 11:03:49 +0200

> From: Jiri Pirko <jiri@mellanox.com>
> 
> This config option makes only couple of lines optional.
> Two small helpers and an int in couple of cls structs.
> 
> Remove the config option and always compile this in.
> This saves the user from unexpected surprises when he adds
> a filter with ingress device match which is silently ignored
> in case the config option is not set.
> 
> Signed-off-by: Jiri Pirko <jiri@mellanox.com>

Ok, this seems reasonable, applied.
