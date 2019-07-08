Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 742E562C4D
	for <lists+netdev@lfdr.de>; Tue,  9 Jul 2019 01:08:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725980AbfGHXIF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jul 2019 19:08:05 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:59956 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725866AbfGHXIF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Jul 2019 19:08:05 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id AB03312DAF003;
        Mon,  8 Jul 2019 16:08:04 -0700 (PDT)
Date:   Mon, 08 Jul 2019 16:08:04 -0700 (PDT)
Message-Id: <20190708.160804.2026506853635876959.davem@davemloft.net>
To:     ap420073@gmail.com
Cc:     pshelar@ovn.org, netdev@vger.kernel.org, dev@openvswitch.org
Subject: Re: [PATCH net-next] net: openvswitch: do not update max_headroom
 if new headroom is equal to old headroom
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190705160809.5202-1-ap420073@gmail.com>
References: <20190705160809.5202-1-ap420073@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 08 Jul 2019 16:08:04 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Taehee Yoo <ap420073@gmail.com>
Date: Sat,  6 Jul 2019 01:08:09 +0900

> When a vport is deleted, the maximum headroom size would be changed.
> If the vport which has the largest headroom is deleted,
> the new max_headroom would be set.
> But, if the new headroom size is equal to the old headroom size,
> updating routine is unnecessary.
> 
> Signed-off-by: Taehee Yoo <ap420073@gmail.com>

I'm not so sure about the logic here and I'd therefore like an OVS expert
to review this.

Thanks.
