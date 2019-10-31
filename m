Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EB5C4EB675
	for <lists+netdev@lfdr.de>; Thu, 31 Oct 2019 18:55:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729190AbfJaRzR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Oct 2019 13:55:17 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:58382 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726602AbfJaRzP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 31 Oct 2019 13:55:15 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 7DEA114FAE5A5;
        Thu, 31 Oct 2019 10:55:14 -0700 (PDT)
Date:   Thu, 31 Oct 2019 10:55:13 -0700 (PDT)
Message-Id: <20191031.105513.442982327274718870.davem@davemloft.net>
To:     idosch@idosch.org
Cc:     netdev@vger.kernel.org, jiri@mellanox.com, mlxsw@mellanox.com,
        idosch@mellanox.com
Subject: Re: [PATCH net-next 00/16] mlxsw: Make port split code more generic
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191031094221.17526-1-idosch@idosch.org>
References: <20191031094221.17526-1-idosch@idosch.org>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 31 Oct 2019 10:55:14 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@idosch.org>
Date: Thu, 31 Oct 2019 11:42:05 +0200

> From: Ido Schimmel <idosch@mellanox.com>
> 
> Jiri says:
> 
> Currently, we assume some limitations and constant values which are not
> applicable for Spectrum-3 which has 8 lanes ports (instead of previous 4
> lanes).
> 
> This patch does 2 things:
> 
> 1) Generalizes the code to not use constants so it can work for 4, 8 and
>    possibly 16 lanes.
> 
> 2) Enforces some assumptions we had in the code but did not check.

Series looks good, applied to net-next.

Thanks.
