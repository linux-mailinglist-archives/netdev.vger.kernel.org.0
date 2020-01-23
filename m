Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 23382147291
	for <lists+netdev@lfdr.de>; Thu, 23 Jan 2020 21:27:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727296AbgAWU1x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jan 2020 15:27:53 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:33814 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726167AbgAWU1x (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jan 2020 15:27:53 -0500
Received: from localhost (unknown [62.209.224.147])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id F330214EAD04B;
        Thu, 23 Jan 2020 12:27:51 -0800 (PST)
Date:   Thu, 23 Jan 2020 21:27:50 +0100 (CET)
Message-Id: <20200123.212750.1668203540290678607.davem@davemloft.net>
To:     saeedm@mellanox.com
Cc:     netdev@vger.kernel.org
Subject: Re: [pull request][net-next 00/15] Mellanox, mlx5
 mlx5-updates-2020-01-22
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200123063827.685230-1-saeedm@mellanox.com>
References: <20200123063827.685230-1-saeedm@mellanox.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 23 Jan 2020 12:27:52 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Saeed Mahameed <saeedm@mellanox.com>
Date: Thu, 23 Jan 2020 06:39:35 +0000

> This series adds misc updates to mlx5 driver, and the support for full
> ethtool statistics for the uplink representor netdev.
> For more information please see tag log below.
> 
> Please pull and let me know if there is any problem.

Pulled, thanks Saeed.
