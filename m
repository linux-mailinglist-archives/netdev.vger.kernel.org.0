Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C5CF1E88A8
	for <lists+netdev@lfdr.de>; Fri, 29 May 2020 22:11:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728269AbgE2ULa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 May 2020 16:11:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726866AbgE2ULa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 May 2020 16:11:30 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 172C6C03E969;
        Fri, 29 May 2020 13:11:30 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 068FF12837646;
        Fri, 29 May 2020 13:11:28 -0700 (PDT)
Date:   Fri, 29 May 2020 13:11:28 -0700 (PDT)
Message-Id: <20200529.131128.495042470763103913.davem@davemloft.net>
To:     hch@lst.de
Cc:     kuba@kernel.org, vyasevich@gmail.com, nhorman@tuxdriver.com,
        marcelo.leitner@gmail.com, David.Laight@ACULAB.COM,
        linux-sctp@vger.kernel.org, linux-kernel@vger.kernel.org,
        cluster-devel@redhat.com, netdev@vger.kernel.org
Subject: Re: remove kernel_setsockopt v4
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200529120943.101454-1-hch@lst.de>
References: <20200529120943.101454-1-hch@lst.de>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 29 May 2020 13:11:29 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Christoph Hellwig <hch@lst.de>
Date: Fri, 29 May 2020 14:09:39 +0200

> now that only the dlm calls to sctp are left for kernel_setsockopt,
> while we haven't really made much progress with the sctp setsockopt
> refactoring, how about this small series that splits out a
> sctp_setsockopt_bindx_kernel that takes a kernel space address array
> to share more code as requested by Marcelo.  This should fit in with
> whatever variant of the refator of sctp setsockopt we go with, but
> just solved the immediate problem for now.
 ...

Series applied, thanks.
