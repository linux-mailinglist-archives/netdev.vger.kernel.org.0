Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 11083137BF1
	for <lists+netdev@lfdr.de>; Sat, 11 Jan 2020 08:11:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728510AbgAKHLf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Jan 2020 02:11:35 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:44208 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728471AbgAKHLf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Jan 2020 02:11:35 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1c3::f0c])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 6EBBF14FA41BF;
        Fri, 10 Jan 2020 23:11:34 -0800 (PST)
Date:   Fri, 10 Jan 2020 23:11:33 -0800 (PST)
Message-Id: <20200110.231133.366069857384555250.davem@davemloft.net>
To:     yuehaibing@huawei.com
Cc:     ast@kernel.org, daniel@iogearbox.net, jakub.kicinski@netronome.com,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH net-next] sfc: remove duplicated include from ef10.c
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200110013517.37685-1-yuehaibing@huawei.com>
References: <20200110013517.37685-1-yuehaibing@huawei.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 10 Jan 2020 23:11:34 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: YueHaibing <yuehaibing@huawei.com>
Date: Fri, 10 Jan 2020 01:35:17 +0000

> Remove duplicated include.
> 
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>

Applied, thanks.
