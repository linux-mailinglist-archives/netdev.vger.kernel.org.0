Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8652EB2671
	for <lists+netdev@lfdr.de>; Fri, 13 Sep 2019 22:07:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388306AbfIMUG7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Sep 2019 16:06:59 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:48710 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730185AbfIMUG7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Sep 2019 16:06:59 -0400
Received: from localhost (93-63-141-166.ip28.fastwebnet.it [93.63.141.166])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id ED4C41539B17F;
        Fri, 13 Sep 2019 13:06:56 -0700 (PDT)
Date:   Fri, 13 Sep 2019 21:06:55 +0100 (WEST)
Message-Id: <20190913.210655.1982553055937864765.davem@davemloft.net>
To:     maowenan@huawei.com
Cc:     vyasevich@gmail.com, nhorman@tuxdriver.com,
        marcelo.leitner@gmail.com, linux-sctp@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH v2 net 0/3] fix memory leak for sctp_do_bind
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190912040219.67517-1-maowenan@huawei.com>
References: <7a450679-40ca-8a84-4cba-7a16f22ea3c0@huawei.com>
        <20190912040219.67517-1-maowenan@huawei.com>
X-Mailer: Mew version 6.8 on Emacs 26.2
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 13 Sep 2019 13:06:58 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Mao Wenan <maowenan@huawei.com>
Date: Thu, 12 Sep 2019 12:02:16 +0800

> First two patches are to do cleanup, remove redundant assignment,
> and change return type of sctp_get_port_local.
> Third patch is to fix memory leak for sctp_do_bind if failed
> to bind address.
> 
> ---
>  v2: add one patch to change return type of sctp_get_port_local.

Series applied with Fixes: tag removed from patch #1.

Thanks.
