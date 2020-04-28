Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 48D9E1BCD1F
	for <lists+netdev@lfdr.de>; Tue, 28 Apr 2020 22:11:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726548AbgD1ULt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Apr 2020 16:11:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726180AbgD1ULs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Apr 2020 16:11:48 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D9F9C03C1AB;
        Tue, 28 Apr 2020 13:11:46 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 1A5C3120ED563;
        Tue, 28 Apr 2020 13:11:45 -0700 (PDT)
Date:   Tue, 28 Apr 2020 13:11:43 -0700 (PDT)
Message-Id: <20200428.131143.378850463944291442.davem@davemloft.net>
To:     mchehab+huawei@kernel.org
Cc:     linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        corbet@lwn.net, netdev@vger.kernel.org, linux-hams@vger.kernel.org,
        intel-wired-lan@lists.osuosl.org,
        linux-decnet-user@lists.sourceforge.net,
        ceph-devel@vger.kernel.org, bpf@vger.kernel.org,
        linux-atm-general@lists.sourceforge.net, lvs-devel@vger.kernel.org
Subject: Re: [PATCH 00/38] net: manually convert files to ReST format -
 part 1
From:   David Miller <davem@davemloft.net>
In-Reply-To: <cover.1588024424.git.mchehab+huawei@kernel.org>
References: <cover.1588024424.git.mchehab+huawei@kernel.org>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 28 Apr 2020 13:11:45 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Date: Tue, 28 Apr 2020 00:01:15 +0200

> There are very few documents upstream that aren't converted upstream.
> 
> This series convert part of the networking text files into ReST.
> It is part of a bigger set of patches, which were split on parts,
> in order to make reviewing task easier.
> 
> The full series (including those ones) are at:
> 
> 	https://git.linuxtv.org/mchehab/experimental.git/log/?h=net-docs
> 
> And the documents, converted to HTML via the building system
> are at:
> 
> 	https://www.infradead.org/~mchehab/kernel_docs/networking/

These look good as far as I can tell.

Jon, do you mind if I merge this via the networking tree?

Thanks.
