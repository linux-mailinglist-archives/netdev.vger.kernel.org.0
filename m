Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5BFAE8F40D
	for <lists+netdev@lfdr.de>; Thu, 15 Aug 2019 21:03:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730300AbfHOTDB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Aug 2019 15:03:01 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:48466 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729407AbfHOTDA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Aug 2019 15:03:00 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 3E49813F237EA;
        Thu, 15 Aug 2019 12:03:00 -0700 (PDT)
Date:   Thu, 15 Aug 2019 12:02:59 -0700 (PDT)
Message-Id: <20190815.120259.1946520536868502329.davem@davemloft.net>
To:     jiri@resnulli.us
Cc:     netdev@vger.kernel.org, jakub.kicinski@netronome.com,
        mlxsw@mellanox.com
Subject: Re: [patch net-next v4 0/2] netdevsim: implement support for
 devlink region and snapshots
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190815134634.9858-1-jiri@resnulli.us>
References: <20190815134634.9858-1-jiri@resnulli.us>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 15 Aug 2019 12:03:00 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@resnulli.us>
Date: Thu, 15 Aug 2019 15:46:32 +0200

> From: Jiri Pirko <jiri@mellanox.com>
> 
> Implement devlink region support for netdevsim and test it.
> 
> ---
> Note the selftest patch depends on "[patch net-next] selftests:
> netdevsim: add devlink params tests" patch sent earlier today.

Series applied.
