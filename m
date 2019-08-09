Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 95BFA8835A
	for <lists+netdev@lfdr.de>; Fri,  9 Aug 2019 21:37:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726137AbfHIThq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Aug 2019 15:37:46 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:36980 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725904AbfHIThq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Aug 2019 15:37:46 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 9DCF91264D994;
        Fri,  9 Aug 2019 12:37:44 -0700 (PDT)
Date:   Fri, 09 Aug 2019 12:37:41 -0700 (PDT)
Message-Id: <20190809.123741.733240603302377585.davem@davemloft.net>
To:     pablo@netfilter.org
Cc:     netfilter-devel@vger.kernel.org, netdev@vger.kernel.org,
        marcelo.leitner@gmail.com, jiri@resnulli.us, wenxu@ucloud.cn,
        saeedm@mellanox.com, paulb@mellanox.com, gerlitz.or@gmail.com,
        jakub.kicinski@netronome.com
Subject: Re: [PATCH 0/2 net,v4] flow_offload hardware priority fixes
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190806160310.6663-1-pablo@netfilter.org>
References: <20190806160310.6663-1-pablo@netfilter.org>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 09 Aug 2019 12:37:46 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Pablo Neira Ayuso <pablo@netfilter.org>
Date: Tue,  6 Aug 2019 18:03:08 +0200

> This patchset contains two updates for the flow_offload users:
> 
> 1) Pass the major tc priority to drivers so they do not have to
>    lshift it. This is a preparation patch for the fix coming in
>    patch #2.
> 
> 2) Set the hardware priority from the netfilter basechain priority,
>    some drivers break when using the existing hardware priority
>    number that is set to zero.

Series applied.
