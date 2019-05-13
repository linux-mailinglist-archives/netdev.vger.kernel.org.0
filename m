Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D48211BA87
	for <lists+netdev@lfdr.de>; Mon, 13 May 2019 18:02:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730323AbfEMQC0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 May 2019 12:02:26 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:39124 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730274AbfEMQC0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 May 2019 12:02:26 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d8])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 30A2A14E14FD8;
        Mon, 13 May 2019 09:02:26 -0700 (PDT)
Date:   Mon, 13 May 2019 09:02:25 -0700 (PDT)
Message-Id: <20190513.090225.1322335894294749204.davem@davemloft.net>
To:     pablo@netfilter.org
Cc:     netfilter-devel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH 00/13] Netfilter fixes for net
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190513095630.32443-1-pablo@netfilter.org>
References: <20190513095630.32443-1-pablo@netfilter.org>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 13 May 2019 09:02:26 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Pablo Neira Ayuso <pablo@netfilter.org>
Date: Mon, 13 May 2019 11:56:17 +0200

> The following patchset contains Netfilter fixes for net:
 ...
> This batch comes with a conflict that can be fixed with this patch:

Thanks for this.

> You can pull these changes from:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf.git

Pulled, thanks again.
