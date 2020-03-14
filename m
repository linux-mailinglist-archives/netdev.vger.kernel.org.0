Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E7BAF18591D
	for <lists+netdev@lfdr.de>; Sun, 15 Mar 2020 03:35:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726873AbgCOCfC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Mar 2020 22:35:02 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:34850 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726667AbgCOCfC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 14 Mar 2020 22:35:02 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 3166115A16D83;
        Fri, 13 Mar 2020 21:04:43 -0700 (PDT)
Date:   Fri, 13 Mar 2020 21:04:42 -0700 (PDT)
Message-Id: <20200313.210442.895090359857849379.davem@davemloft.net>
To:     kuba@kernel.org
Cc:     saeedm@mellanox.com, netdev@vger.kernel.org
Subject: Re: [pull request][net-next 00/14] Mellanox, mlx5 updates
 2020-03-13
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200313193721.40c78dbc@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <20200314011622.64939-1-saeedm@mellanox.com>
        <20200313193721.40c78dbc@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 13 Mar 2020 21:04:43 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jakub Kicinski <kuba@kernel.org>
Date: Fri, 13 Mar 2020 19:37:21 -0700

> On Fri, 13 Mar 2020 18:16:08 -0700 Saeed Mahameed wrote:
>> Hi Dave,
>> 
>> This series adds misc updates to mlx5 driver
>> For more information please see tag log below.
>> 
>> Please pull and let me know if there is any problem.
> 
> My questions on the patches are mostly curiosity, so:
> 
> Acked-by: Jakub Kicinski <kuba@kernel.org>

Pulled, thanks everyone.
