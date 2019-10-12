Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EA5C0D4C93
	for <lists+netdev@lfdr.de>; Sat, 12 Oct 2019 06:05:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726891AbfJLEFP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Oct 2019 00:05:15 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:55358 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725308AbfJLEFP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 12 Oct 2019 00:05:15 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 983A0150040C6;
        Fri, 11 Oct 2019 21:05:14 -0700 (PDT)
Date:   Fri, 11 Oct 2019 21:05:14 -0700 (PDT)
Message-Id: <20191011.210514.677858602435533198.davem@davemloft.net>
To:     jiri@resnulli.us
Cc:     netdev@vger.kernel.org, jakub.kicinski@netronome.com,
        ayal@mellanox.com, moshe@mellanox.com, eranbe@mellanox.com,
        mlxsw@mellanox.com
Subject: Re: [patch net-next v2 0/4] netdevsim: add devlink health
 reporters suppor
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191010131851.21438-1-jiri@resnulli.us>
References: <20191010131851.21438-1-jiri@resnulli.us>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 11 Oct 2019 21:05:14 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@resnulli.us>
Date: Thu, 10 Oct 2019 15:18:47 +0200

> From: Jiri Pirko <jiri@mellanox.com>
> 
> This patchset adds support for devlink health reporter interface
> testing. First 2 patches are small dependencies of the last 2.

Series applied, thanks Jiri.
