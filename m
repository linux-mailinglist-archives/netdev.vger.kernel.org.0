Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5BAE21E04BE
	for <lists+netdev@lfdr.de>; Mon, 25 May 2020 04:33:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388707AbgEYCdS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 May 2020 22:33:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388699AbgEYCdS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 24 May 2020 22:33:18 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90959C061A0E
        for <netdev@vger.kernel.org>; Sun, 24 May 2020 19:33:18 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 508E91280D09D;
        Sun, 24 May 2020 19:33:18 -0700 (PDT)
Date:   Sun, 24 May 2020 19:33:17 -0700 (PDT)
Message-Id: <20200524.193317.884228561320046464.davem@davemloft.net>
To:     W_Armin@gmx.de
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH v2] Fix various coding-style issues and improve
 printk() usage
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200524.181512.1222378110120420383.davem@davemloft.net>
References: <20200524222732.GA18675@mx-linux-amd>
        <20200524.181512.1222378110120420383.davem@davemloft.net>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 24 May 2020 19:33:18 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Miller <davem@davemloft.net>
Date: Sun, 24 May 2020 18:15:12 -0700 (PDT)

> 
> Please repost this with a proper subsystem/driver prefix in your Subject line
> and the appropriate target GIT tree inside the [] brackets.
> 
> F.e. Subject: [PATCH v3 net] ne2k-pci: Fix various coding-style ...

Actually in this case "net-next" instead of "net" would be appropriate.
