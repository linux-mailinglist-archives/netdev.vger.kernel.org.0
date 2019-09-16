Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 450A0B3575
	for <lists+netdev@lfdr.de>; Mon, 16 Sep 2019 09:21:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727109AbfIPHVW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Sep 2019 03:21:22 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:44452 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725776AbfIPHVW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Sep 2019 03:21:22 -0400
Received: from localhost (unknown [85.119.46.8])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id ACDF3151FC637;
        Mon, 16 Sep 2019 00:21:20 -0700 (PDT)
Date:   Mon, 16 Sep 2019 09:21:19 +0200 (CEST)
Message-Id: <20190916.092119.234345556645404894.davem@davemloft.net>
To:     vladbu@mellanox.com
Cc:     netdev@vger.kernel.org, jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        jiri@resnulli.us
Subject: Re: [PATCH net-next 0/3] More fixes for unlocked cls hardware
 offload API refactoring
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190913152841.15755-1-vladbu@mellanox.com>
References: <20190913152841.15755-1-vladbu@mellanox.com>
X-Mailer: Mew version 6.8 on Emacs 26.2
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 16 Sep 2019 00:21:22 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vlad Buslov <vladbu@mellanox.com>
Date: Fri, 13 Sep 2019 18:28:38 +0300

> Two fixes for my "Refactor cls hardware offload API to support
> rtnl-independent drivers" series and refactoring patch that implements
> infrastructure necessary for the fixes.

Series applied, thanks.
