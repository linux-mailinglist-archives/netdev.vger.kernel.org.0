Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 245CF282775
	for <lists+netdev@lfdr.de>; Sun,  4 Oct 2020 01:51:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726197AbgJCXvd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 3 Oct 2020 19:51:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726091AbgJCXvd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 3 Oct 2020 19:51:33 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D022EC0613D0;
        Sat,  3 Oct 2020 16:51:32 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 6453511E3E4C6;
        Sat,  3 Oct 2020 16:34:44 -0700 (PDT)
Date:   Sat, 03 Oct 2020 16:51:30 -0700 (PDT)
Message-Id: <20201003.165130.1283065479384343885.davem@davemloft.net>
To:     jwi@linux.ibm.com
Cc:     kuba@kernel.org, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org, hca@linux.ibm.com,
        ubraun@linux.ibm.com, kgraul@linux.ibm.com
Subject: Re: [PATCH net-next 0/2] net/iucv: updates 2020-10-01
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20201001172127.98541-1-jwi@linux.ibm.com>
References: <20201001172127.98541-1-jwi@linux.ibm.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Sat, 03 Oct 2020 16:34:44 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Julian Wiedmann <jwi@linux.ibm.com>
Date: Thu,  1 Oct 2020 19:21:25 +0200

> please apply the following patch series for iucv to netdev's net-next
> tree.
> 
> Just two (rare) patches, and both deal with smatch warnings.

Series applied, thanks.
