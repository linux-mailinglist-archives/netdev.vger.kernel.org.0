Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 08D2846DE1
	for <lists+netdev@lfdr.de>; Sat, 15 Jun 2019 04:46:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726327AbfFOCqZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jun 2019 22:46:25 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:57690 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725809AbfFOCqZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Jun 2019 22:46:25 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 860B412B05D24;
        Fri, 14 Jun 2019 19:46:24 -0700 (PDT)
Date:   Fri, 14 Jun 2019 19:46:23 -0700 (PDT)
Message-Id: <20190614.194623.2091149271541522629.davem@davemloft.net>
To:     saeedm@mellanox.com
Cc:     netdev@vger.kernel.org, jiri@mellanox.com
Subject: Re: [pull request][net-next v2 00/15] Mellanox, mlx5 Firmware
 devlink health and sw reset
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190613203825.31049-1-saeedm@mellanox.com>
References: <20190613203825.31049-1-saeedm@mellanox.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 14 Jun 2019 19:46:24 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Saeed Mahameed <saeedm@mellanox.com>
Date: Thu, 13 Jun 2019 20:39:13 +0000

> This series provides the support for mlx5 Firmware devlink health and
> sw reset.
> 
> For more information please see tag log below.
> 
> Please pull and let me know if there is any problem.
> 
> This is a re-spin of a previously sent series on 5.2 kernel
> release.
> 
> v2:
>  - Improved mlx5 kernel documentation
>  - Addressed Jiri's comments:
>       Proper linkage to region and snapshot in devlink core.
>       Format trace dumps using fmsg helpers.

Pulled, thanks Saeed.
