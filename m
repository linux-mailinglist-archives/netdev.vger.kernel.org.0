Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2EDEC18E60E
	for <lists+netdev@lfdr.de>; Sun, 22 Mar 2020 03:45:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728227AbgCVCos (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 21 Mar 2020 22:44:48 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:34216 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726409AbgCVCos (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 21 Mar 2020 22:44:48 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 2492615AB51DC;
        Sat, 21 Mar 2020 19:44:47 -0700 (PDT)
Date:   Sat, 21 Mar 2020 19:44:42 -0700 (PDT)
Message-Id: <20200321.194442.1984083061754940574.davem@davemloft.net>
To:     luobin9@huawei.com
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        luoxianjun@huawei.com, yin.yinshi@huawei.com,
        cloud.wangxiaoyun@huawei.com
Subject: Re: [PATCH net 0/5] hinic: BugFixes
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200320231320.1001-1-luobin9@huawei.com>
References: <20200320231320.1001-1-luobin9@huawei.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 21 Mar 2020 19:44:47 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Luo bin <luobin9@huawei.com>
Date: Fri, 20 Mar 2020 23:13:15 +0000

> Fix a number of bugs which have been present since the first commit.
> 
> The bugs fixed in these patchs are hardly exposed unless given
> very specific conditions.

Series applied, thank you.
