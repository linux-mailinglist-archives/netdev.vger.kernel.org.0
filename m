Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 73ADE18DEB
	for <lists+netdev@lfdr.de>; Thu,  9 May 2019 18:22:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726710AbfEIQWg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 May 2019 12:22:36 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:36452 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726469AbfEIQWf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 May 2019 12:22:35 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d8])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 224DE14CF8672;
        Thu,  9 May 2019 09:22:35 -0700 (PDT)
Date:   Thu, 09 May 2019 09:22:34 -0700 (PDT)
Message-Id: <20190509.092234.285409406486740265.davem@davemloft.net>
To:     jasowang@redhat.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        yuehaibing@huawei.com, xiyou.wangcong@gmail.com,
        weiyongjun1@huawei.com, eric.dumazet@gmail.com
Subject: Re: [PATCH net V3 1/2] tuntap: fix dividing by zero in ebpf queue
 selection
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1557372018-18544-1-git-send-email-jasowang@redhat.com>
References: <1557372018-18544-1-git-send-email-jasowang@redhat.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 09 May 2019 09:22:35 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jason Wang <jasowang@redhat.com>
Date: Wed,  8 May 2019 23:20:17 -0400

> We need check if tun->numqueues is zero (e.g for the persist device)
> before trying to use it for modular arithmetic.
> 
> Reported-by: Eric Dumazet <eric.dumazet@gmail.com>
> Fixes: 96f84061620c6("tun: add eBPF based queue selection method")
> Signed-off-by: Jason Wang <jasowang@redhat.com>

Applied and queued up for -stable.
