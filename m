Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 323E924DFCB
	for <lists+netdev@lfdr.de>; Fri, 21 Aug 2020 20:38:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725991AbgHUSix (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Aug 2020 14:38:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725768AbgHUSix (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Aug 2020 14:38:53 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DC22C061573;
        Fri, 21 Aug 2020 11:38:53 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 91FBA1287B533;
        Fri, 21 Aug 2020 11:22:01 -0700 (PDT)
Date:   Fri, 21 Aug 2020 11:38:44 -0700 (PDT)
Message-Id: <20200821.113844.1413413632075759126.davem@davemloft.net>
To:     paul@paul-moore.com
Cc:     netdev@vger.kernel.org, selinux@vger.kernel.org,
        linux-security-module@vger.kernel.org,
        stephen.smalley.work@gmail.com
Subject: Re: [net-next PATCH] netlabel: fix problems with mapping removal
From:   David Miller <davem@davemloft.net>
In-Reply-To: <159797437409.20181.15427109610194880479.stgit@sifl>
References: <159797437409.20181.15427109610194880479.stgit@sifl>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 21 Aug 2020 11:22:01 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Paul Moore <paul@paul-moore.com>
Date: Thu, 20 Aug 2020 21:46:14 -0400

> This patch fixes two main problems seen when removing NetLabel
> mappings: memory leaks and potentially extra audit noise.

These are bug fixes therefore this needs to target the 'net' tree
and you must also provide appropriate "Fixes:" tags.

Thank you.
