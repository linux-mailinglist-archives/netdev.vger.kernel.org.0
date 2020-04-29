Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC8AC1BE5E4
	for <lists+netdev@lfdr.de>; Wed, 29 Apr 2020 20:11:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726974AbgD2SLl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Apr 2020 14:11:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726423AbgD2SLl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Apr 2020 14:11:41 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27FF3C03C1AE;
        Wed, 29 Apr 2020 11:11:41 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id CB3B611F5F61A;
        Wed, 29 Apr 2020 11:11:38 -0700 (PDT)
Date:   Wed, 29 Apr 2020 11:11:35 -0700 (PDT)
Message-Id: <20200429.111135.1012491992605250039.davem@davemloft.net>
To:     wei.liu@kernel.org
Cc:     natechancellor@gmail.com, kys@microsoft.com,
        haiyangz@microsoft.com, sthemmin@microsoft.com,
        linux-hyperv@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, clang-built-linux@googlegroups.com,
        samitolvanen@google.com
Subject: Re: [PATCH v2] hv_netvsc: Fix netvsc_start_xmit's return type
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200429101055.rdrpchkypbkwxscj@debian>
References: <20200428100828.aslw3pn5nhwtlsnt@liuwe-devbox-debian-v2.j3c5onc20sse1dnehy4noqpfcg.zx.internal.cloudapp.net>
        <20200428175455.2109973-1-natechancellor@gmail.com>
        <20200429101055.rdrpchkypbkwxscj@debian>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 29 Apr 2020 11:11:39 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Wei Liu <wei.liu@kernel.org>
Date: Wed, 29 Apr 2020 11:10:55 +0100

> Do you want this to go through net tree? I can submit it via hyperv tree
> if that's preferred.

I'll be taking this, thanks.
