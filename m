Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 39B511B8285
	for <lists+netdev@lfdr.de>; Sat, 25 Apr 2020 01:46:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726107AbgDXXqZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Apr 2020 19:46:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725932AbgDXXqZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Apr 2020 19:46:25 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01650C09B049
        for <netdev@vger.kernel.org>; Fri, 24 Apr 2020 16:46:25 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id A93A614F4664B;
        Fri, 24 Apr 2020 16:46:24 -0700 (PDT)
Date:   Fri, 24 Apr 2020 16:46:23 -0700 (PDT)
Message-Id: <20200424.164623.63284832307405084.davem@davemloft.net>
To:     roy@marples.name
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH net] netlink: Align NLA_ALIGNTO with the other ALIGNTO
 macros
From:   David Miller <davem@davemloft.net>
In-Reply-To: <f8725c2b-635f-1da9-d2f6-4f34777b194a@marples.name>
References: <f8725c2b-635f-1da9-d2f6-4f34777b194a@marples.name>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 24 Apr 2020 16:46:24 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Roy Marples <roy@marples.name>
Date: Thu, 23 Apr 2020 17:53:08 +0100

> This avoids sign conversion errors.
> 
> Signed-off-by: Roy Marples <roy@marples.name>

This has as much chance to break things as it has to fix them.

I'm not applying this, sorry.
