Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CD78DEE7CB
	for <lists+netdev@lfdr.de>; Mon,  4 Nov 2019 19:58:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729461AbfKDS6X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Nov 2019 13:58:23 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:49916 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728332AbfKDS6W (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Nov 2019 13:58:22 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 0DBD8151D3B94;
        Mon,  4 Nov 2019 10:58:21 -0800 (PST)
Date:   Mon, 04 Nov 2019 10:58:19 -0800 (PST)
Message-Id: <20191104.105819.2064664721682565230.davem@davemloft.net>
To:     namhyung@kernel.org
Cc:     tj@kernel.org, hannes@cmpxchg.org, lizefan@huawei.com,
        linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org,
        rafael@kernel.org, liu.song.a23@gmail.com, cgroups@vger.kernel.org,
        nhorman@tuxdriver.com, netdev@vger.kernel.org
Subject: Re: [PATCH v2 2/2] cgroup: Use 64bit id from kernfs
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191104084520.398584-3-namhyung@kernel.org>
References: <20191104084520.398584-1-namhyung@kernel.org>
        <20191104084520.398584-3-namhyung@kernel.org>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 04 Nov 2019 10:58:22 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Namhyung Kim <namhyung@kernel.org>
Date: Mon,  4 Nov 2019 17:45:20 +0900

> From: Tejun Heo <tj@kernel.org>
> 
> Use 64 bit id allocated by kernfs instead of using its own idr since
> it seems not used for saving any information no more.  So let's get
> rid of the cgroup_idr from cgroup_root.
> 
> The index of netprio_map is also changed to u64.
> 
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Neil Horman <nhorman@tuxdriver.com>
> Cc: netdev@vger.kernel.org
> Signed-off-by: Tejun Heo <tj@kernel.org>
> [namhyung: split cgroup changes and fix netprio_map access]
> Signed-off-by: Namhyung Kim <namhyung@kernel.org>

Acked-by: David S. Miller <davem@davemloft.net>
