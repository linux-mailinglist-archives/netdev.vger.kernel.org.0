Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4422C244F50
	for <lists+netdev@lfdr.de>; Fri, 14 Aug 2020 22:53:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726812AbgHNUxc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Aug 2020 16:53:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726229AbgHNUxa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Aug 2020 16:53:30 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1C68C061385
        for <netdev@vger.kernel.org>; Fri, 14 Aug 2020 13:53:29 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id DA42612746C4E;
        Fri, 14 Aug 2020 13:36:39 -0700 (PDT)
Date:   Fri, 14 Aug 2020 13:53:22 -0700 (PDT)
Message-Id: <20200814.135322.1338232335956882142.davem@davemloft.net>
To:     ljp@linux.ibm.com
Cc:     netdev@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH net 0/5] refactoring of ibmvnic code
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200814075921.88745-1-ljp@linux.ibm.com>
References: <20200814075921.88745-1-ljp@linux.ibm.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 14 Aug 2020 13:36:40 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Lijun Pan <ljp@linux.ibm.com>
Date: Fri, 14 Aug 2020 02:59:16 -0500

> This patch series refactor reset_init and init functions,
> improve the debugging messages, and make some other cosmetic changes
> to make the code easier to read and debug.

Cosmetic changes and cleanups are not appropriate at this time as
the net-next tree is closed.

Please repost these changes when the net-next tree opens back up.
