Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B9B0279559
	for <lists+netdev@lfdr.de>; Sat, 26 Sep 2020 02:06:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729557AbgIZAGC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Sep 2020 20:06:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725208AbgIZAGC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Sep 2020 20:06:02 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 464E4C0613CE
        for <netdev@vger.kernel.org>; Fri, 25 Sep 2020 17:06:02 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 78A1E13BA118C;
        Fri, 25 Sep 2020 16:49:14 -0700 (PDT)
Date:   Fri, 25 Sep 2020 17:06:01 -0700 (PDT)
Message-Id: <20200925.170601.1686580053294951464.davem@davemloft.net>
To:     edumazet@google.com
Cc:     netdev@vger.kernel.org, eric.dumazet@gmail.com
Subject: Re: [PATCH net 0/2] bonding/team: basic dev->needed_headroom
 support
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200925133808.1242950-1-edumazet@google.com>
References: <20200925133808.1242950-1-edumazet@google.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Fri, 25 Sep 2020 16:49:14 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>
Date: Fri, 25 Sep 2020 06:38:06 -0700

> Both bonding and team drivers support non-ethernet devices,
> but missed proper dev->needed_headroom initializations.
> 
> syzbot found a crash caused by bonding, I mirrored the fix in team as well.

Series applied, thanks Eric.
