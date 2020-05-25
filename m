Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A54691E0457
	for <lists+netdev@lfdr.de>; Mon, 25 May 2020 03:15:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388194AbgEYBPS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 May 2020 21:15:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388136AbgEYBPR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 24 May 2020 21:15:17 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AACF1C061A0E
        for <netdev@vger.kernel.org>; Sun, 24 May 2020 18:15:17 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 5836A127FD8F3;
        Sun, 24 May 2020 18:15:15 -0700 (PDT)
Date:   Sun, 24 May 2020 18:15:12 -0700 (PDT)
Message-Id: <20200524.181512.1222378110120420383.davem@davemloft.net>
To:     W_Armin@gmx.de
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH v2] Fix various coding-style issues and improve
 printk() usage
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200524222732.GA18675@mx-linux-amd>
References: <20200524222732.GA18675@mx-linux-amd>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 24 May 2020 18:15:15 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Please repost this with a proper subsystem/driver prefix in your Subject line
and the appropriate target GIT tree inside the [] brackets.

F.e. Subject: [PATCH v3 net] ne2k-pci: Fix various coding-style ...
