Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D21DEB213C
	for <lists+netdev@lfdr.de>; Fri, 13 Sep 2019 15:49:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389495AbfIMNkR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Sep 2019 09:40:17 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:43948 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388387AbfIMNkQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Sep 2019 09:40:16 -0400
Received: from localhost (93-63-141-166.ip28.fastwebnet.it [93.63.141.166])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 74A8514C612A5;
        Fri, 13 Sep 2019 06:40:15 -0700 (PDT)
Date:   Fri, 13 Sep 2019 14:40:10 +0100 (WEST)
Message-Id: <20190913.144010.502199587356682472.davem@davemloft.net>
To:     pablo@netfilter.org
Cc:     netfilter-devel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH 00/27] Netfilter updates for net-next
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190913113102.15776-1-pablo@netfilter.org>
References: <20190913113102.15776-1-pablo@netfilter.org>
X-Mailer: Mew version 6.8 on Emacs 26.2
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 13 Sep 2019 06:40:16 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Pablo Neira Ayuso <pablo@netfilter.org>
Date: Fri, 13 Sep 2019 13:30:35 +0200

> The following patchset contains Netfilter updates for net-next:
 ...
> You can pull these changes from:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf-next.git

Looks good, pulled.
