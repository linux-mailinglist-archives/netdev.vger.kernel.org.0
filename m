Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A23268F40A
	for <lists+netdev@lfdr.de>; Thu, 15 Aug 2019 21:01:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732211AbfHOTBh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Aug 2019 15:01:37 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:48416 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729798AbfHOTBg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Aug 2019 15:01:36 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 4EE6813CF1FE7;
        Thu, 15 Aug 2019 12:01:36 -0700 (PDT)
Date:   Thu, 15 Aug 2019 12:01:35 -0700 (PDT)
Message-Id: <20190815.120135.2248360317765060891.davem@davemloft.net>
To:     jiri@resnulli.us
Cc:     netdev@vger.kernel.org, jakub.kicinski@netronome.com,
        mlxsw@mellanox.com
Subject: Re: [patch net-next v3 0/2] selftests: netdevsim: add devlink
 paramstests
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190815134229.8884-1-jiri@resnulli.us>
References: <20190815134229.8884-1-jiri@resnulli.us>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 15 Aug 2019 12:01:36 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@resnulli.us>
Date: Thu, 15 Aug 2019 15:42:27 +0200

> From: Jiri Pirko <jiri@mellanox.com>
> 
> The first patch is just a helper addition as a dependency of the actual
> test in patch number two.

Series applied.
