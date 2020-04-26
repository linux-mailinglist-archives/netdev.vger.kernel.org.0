Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC5D51B8BBB
	for <lists+netdev@lfdr.de>; Sun, 26 Apr 2020 05:43:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726332AbgDZDnV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Apr 2020 23:43:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725943AbgDZDnU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 Apr 2020 23:43:20 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FF32C061A0C;
        Sat, 25 Apr 2020 20:43:20 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 81265159FE254;
        Sat, 25 Apr 2020 20:43:19 -0700 (PDT)
Date:   Sat, 25 Apr 2020 20:43:18 -0700 (PDT)
Message-Id: <20200425.204318.2085505541872793394.davem@davemloft.net>
To:     yuehaibing@huawei.com
Cc:     gerrit@erg.abdn.ac.uk, kuba@kernel.org, tglx@linutronix.de,
        dccp@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] dccp: remove unused inline function
 dccp_set_seqno
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200424131334.37532-1-yuehaibing@huawei.com>
References: <20200424131334.37532-1-yuehaibing@huawei.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 25 Apr 2020 20:43:19 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: YueHaibing <yuehaibing@huawei.com>
Date: Fri, 24 Apr 2020 21:13:34 +0800

> There's no callers in-tree since commit 792b48780e8b ("dccp: Implement
> both feature-local and feature-remote Sequence Window feature")
> 
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>

Applied.
