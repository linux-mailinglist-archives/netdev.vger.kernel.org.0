Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ED31B316A4
	for <lists+netdev@lfdr.de>; Fri, 31 May 2019 23:32:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726485AbfEaVcg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 May 2019 17:32:36 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:50882 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725913AbfEaVcf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 May 2019 17:32:35 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 5DA9215010A22;
        Fri, 31 May 2019 14:32:35 -0700 (PDT)
Date:   Fri, 31 May 2019 14:32:34 -0700 (PDT)
Message-Id: <20190531.143234.987211580520731403.davem@davemloft.net>
To:     ssuryaextr@gmail.com
Cc:     netdev@vger.kernel.org, dsahern@gmail.com, dsahern@kernel.org
Subject: Re: [PATCH net] vrf: Increment Icmp6InMsgs on the original netdev
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190530050815.20352-1-ssuryaextr@gmail.com>
References: <20190530050815.20352-1-ssuryaextr@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 31 May 2019 14:32:35 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Stephen Suryaputra <ssuryaextr@gmail.com>
Date: Thu, 30 May 2019 01:08:15 -0400

> Get the ingress interface and increment ICMP counters based on that
> instead of skb->dev when the the dev is a VRF device.
> 
> This is a follow up on the following message:
> https://www.spinics.net/lists/netdev/msg560268.html
> 
> Signed-off-by: Stephen Suryaputra <ssuryaextr@gmail.com>

David, please review.
