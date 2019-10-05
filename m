Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 16379CCD50
	for <lists+netdev@lfdr.de>; Sun,  6 Oct 2019 01:34:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726083AbfJEXea (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Oct 2019 19:34:30 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:40380 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725801AbfJEXea (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 5 Oct 2019 19:34:30 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 4046313411135;
        Sat,  5 Oct 2019 16:34:29 -0700 (PDT)
Date:   Sat, 05 Oct 2019 16:34:28 -0700 (PDT)
Message-Id: <20191005.163428.1513584913244211030.davem@davemloft.net>
To:     jiri@resnulli.us
Cc:     netdev@vger.kernel.org, idosch@mellanox.com,
        jakub.kicinski@netronome.com, petrm@mellanox.com,
        tariqt@mellanox.com, saeedm@mellanox.com, shuah@kernel.org,
        mlxsw@mellanox.com
Subject: Re: [patch net-next 0/3] create netdevsim instances in namespace
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191005061033.24235-1-jiri@resnulli.us>
References: <20191005061033.24235-1-jiri@resnulli.us>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 05 Oct 2019 16:34:29 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@resnulli.us>
Date: Sat,  5 Oct 2019 08:10:30 +0200

> From: Jiri Pirko <jiri@mellanox.com>
> 
> Allow user to create netdevsim devlink and netdevice instances in a
> network namespace according to the namespace where the user resides in.
> Add a selftest to test this.

Series applied.
