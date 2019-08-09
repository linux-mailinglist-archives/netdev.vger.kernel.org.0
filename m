Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E873588252
	for <lists+netdev@lfdr.de>; Fri,  9 Aug 2019 20:22:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407525AbfHISWa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Aug 2019 14:22:30 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:36068 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726216AbfHISW3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Aug 2019 14:22:29 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 8F4D1154319AD;
        Fri,  9 Aug 2019 11:22:28 -0700 (PDT)
Date:   Fri, 09 Aug 2019 11:22:28 -0700 (PDT)
Message-Id: <20190809.112228.285932738589703769.davem@davemloft.net>
To:     jiri@resnulli.us
Cc:     netdev@vger.kernel.org, tariqt@mellanox.com, valex@mellanox.com,
        mlxsw@mellanox.com
Subject: Re: [patch net-next] devlink: remove pointless data_len arg from
 region snapshot create
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190809132715.24282-1-jiri@resnulli.us>
References: <20190809132715.24282-1-jiri@resnulli.us>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 09 Aug 2019 11:22:28 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@resnulli.us>
Date: Fri,  9 Aug 2019 15:27:15 +0200

> From: Jiri Pirko <jiri@mellanox.com>
> 
> The size of the snapshot has to be the same as the size of the region,
> therefore no need to pass it again during snapshot creation. Remove the
> arg and use region->size instead.
> 
> Signed-off-by: Jiri Pirko <jiri@mellanox.com>

Applied.
