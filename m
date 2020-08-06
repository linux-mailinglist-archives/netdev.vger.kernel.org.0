Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F52923D4D3
	for <lists+netdev@lfdr.de>; Thu,  6 Aug 2020 02:45:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726197AbgHFApK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Aug 2020 20:45:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726524AbgHFApC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Aug 2020 20:45:02 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8D82C061574
        for <netdev@vger.kernel.org>; Wed,  5 Aug 2020 17:45:00 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 8FF40156879FB;
        Wed,  5 Aug 2020 17:28:14 -0700 (PDT)
Date:   Wed, 05 Aug 2020 17:44:59 -0700 (PDT)
Message-Id: <20200805.174459.1359984879106309016.davem@davemloft.net>
To:     oneukum@suse.com
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH 0/3] misc bug fixes for the hso driver 
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200805120709.4676-1-oneukum@suse.com>
References: <20200805120709.4676-1-oneukum@suse.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 05 Aug 2020 17:28:14 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Oliver Neukum <oneukum@suse.com>
Date: Wed,  5 Aug 2020 14:07:06 +0200

> 1. Code reuse led to an unregistration of a net driver that has not been
> registered
> 2. The kernel complains generically if kmalloc with GFP_KERNEL fails
> 3. A race that can lead to an URB that is in use being reused or
> a use after free

Series applied, thanks Oliver.
