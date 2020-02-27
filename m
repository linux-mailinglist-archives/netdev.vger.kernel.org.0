Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 193F417285A
	for <lists+netdev@lfdr.de>; Thu, 27 Feb 2020 20:11:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729418AbgB0TLS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Feb 2020 14:11:18 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:43836 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729120AbgB0TLS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Feb 2020 14:11:18 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id C6CA0120F5DE3;
        Thu, 27 Feb 2020 11:11:17 -0800 (PST)
Date:   Thu, 27 Feb 2020 11:11:17 -0800 (PST)
Message-Id: <20200227.111117.5692097018564115.davem@davemloft.net>
To:     jiri@resnulli.us
Cc:     netdev@vger.kernel.org, kuba@kernel.org, idosch@mellanox.com,
        mlxsw@mellanox.com, shuah@kernel.org
Subject: Re: [patch net-next 00/16] selftests: updates for mlxsw driver test
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200227075021.3472-1-jiri@resnulli.us>
References: <20200227075021.3472-1-jiri@resnulli.us>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 27 Feb 2020 11:11:18 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@resnulli.us>
Date: Thu, 27 Feb 2020 08:50:05 +0100

> From: Jiri Pirko <jiri@mellanox.com>
> 
> This patchset contains tweaks to the existing tests and is also adding
> couple of new ones, namely tests for shared buffer and red offload.

Series applied, thanks Jiri.
