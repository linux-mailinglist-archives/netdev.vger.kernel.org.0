Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3B7617C77B
	for <lists+netdev@lfdr.de>; Wed, 31 Jul 2019 17:50:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728244AbfGaPuU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Jul 2019 11:50:20 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:39488 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726675AbfGaPuU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Jul 2019 11:50:20 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id A077B12B8C6EC;
        Wed, 31 Jul 2019 08:50:19 -0700 (PDT)
Date:   Wed, 31 Jul 2019 08:50:19 -0700 (PDT)
Message-Id: <20190731.085019.1144909092253347155.davem@davemloft.net>
To:     pablo@netfilter.org
Cc:     netfilter-devel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH 0/8] netfilter fixes for net
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190731115157.27020-1-pablo@netfilter.org>
References: <20190731115157.27020-1-pablo@netfilter.org>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 31 Jul 2019 08:50:19 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Pablo Neira Ayuso <pablo@netfilter.org>
Date: Wed, 31 Jul 2019 13:51:49 +0200

> The following patchset contains Netfilter fixes for your net tree:
 ...
> You can pull these changes from:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf.git

Pulled, thanks.
