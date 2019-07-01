Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7DCB15C272
	for <lists+netdev@lfdr.de>; Mon,  1 Jul 2019 19:59:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730340AbfGAR7r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jul 2019 13:59:47 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:46340 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728121AbfGAR7r (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Jul 2019 13:59:47 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id A97DE14C1A62F;
        Mon,  1 Jul 2019 10:59:46 -0700 (PDT)
Date:   Mon, 01 Jul 2019 10:59:46 -0700 (PDT)
Message-Id: <20190701.105946.1823078842876393723.davem@davemloft.net>
To:     edumazet@google.com
Cc:     netdev@vger.kernel.org, eric.dumazet@gmail.com
Subject: Re: [PATCH net-next] ipv6: icmp: allow flowlabel reflection in
 echo replies
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190701133936.15238-1-edumazet@google.com>
References: <20190701133936.15238-1-edumazet@google.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 01 Jul 2019 10:59:46 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>
Date: Mon,  1 Jul 2019 06:39:36 -0700

> Extend flowlabel_reflect bitmask to allow conditional
> reflection of incoming flowlabels in echo replies.
> 
> Note this has precedence against auto flowlabels.
> 
> Add flowlabel_reflect enum to replace hard coded
> values.
> 
> Signed-off-by: Eric Dumazet <edumazet@google.com>

Applied, thanks Eric.
