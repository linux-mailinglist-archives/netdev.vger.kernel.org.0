Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9594C215F60
	for <lists+netdev@lfdr.de>; Mon,  6 Jul 2020 21:32:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726582AbgGFTb7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jul 2020 15:31:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725895AbgGFTb7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Jul 2020 15:31:59 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E5C7C061755
        for <netdev@vger.kernel.org>; Mon,  6 Jul 2020 12:31:59 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id A462B1278E9AE;
        Mon,  6 Jul 2020 12:31:58 -0700 (PDT)
Date:   Mon, 06 Jul 2020 12:31:57 -0700 (PDT)
Message-Id: <20200706.123157.1905347295748840781.davem@davemloft.net>
To:     chris@disavowed.jp
Cc:     netdev@vger.kernel.org, trivial@kernel.org
Subject: Re: [PATCH v2] net/appletalk: restore success case for
 atalk_proc_init()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200706111130.GC153765@mikkabi>
References: <20191009012630.GA106292@basementcat>
        <20191008185741.10afd266@cakuba.netronome.com>
        <20200706111130.GC153765@mikkabi>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 06 Jul 2020 12:31:58 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Chris <chris@disavowed.jp>
Date: Mon, 6 Jul 2020 20:11:30 +0900

> Fixes: e2bcd8b0ce6ee3410665765db0d44dd8b7e3b348 ("appletalk: use remove_proc_subtree to simplify procfs code")

12-digits of significance in SHA1 IDs in Fixes: tags please.

Also, if you mention the SHA1 ID in the Fixes tag you can elide it
from the commit message.
