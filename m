Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5B2ABA4033
	for <lists+netdev@lfdr.de>; Sat, 31 Aug 2019 00:12:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728181AbfH3WMT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Aug 2019 18:12:19 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:42756 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728143AbfH3WMT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Aug 2019 18:12:19 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 90313154FFFC4;
        Fri, 30 Aug 2019 15:12:18 -0700 (PDT)
Date:   Fri, 30 Aug 2019 15:12:18 -0700 (PDT)
Message-Id: <20190830.151218.920102326255154077.davem@davemloft.net>
To:     vladbu@mellanox.com
Cc:     netdev@vger.kernel.org, jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        jiri@resnulli.us, saeedm@mellanox.com, idosch@mellanox.com,
        sergei.shtylyov@cogentembedded.com
Subject: Re: [PATCH net-next v2 0/2] Fixes for unlocked cls hardware
 offload API refactoring
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190829161517.20935-1-vladbu@mellanox.com>
References: <20190829161517.20935-1-vladbu@mellanox.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 30 Aug 2019 15:12:18 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vlad Buslov <vladbu@mellanox.com>
Date: Thu, 29 Aug 2019 19:15:15 +0300

> Two fixes for my "Refactor cls hardware offload API to support
> rtnl-independent drivers" series.

Series applied, thanks Vlad.
