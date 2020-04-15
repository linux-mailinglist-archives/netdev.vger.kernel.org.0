Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 33CE91AB42F
	for <lists+netdev@lfdr.de>; Thu, 16 Apr 2020 01:23:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389233AbgDOXXR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Apr 2020 19:23:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389210AbgDOXXP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Apr 2020 19:23:15 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FE65C061A0C
        for <netdev@vger.kernel.org>; Wed, 15 Apr 2020 16:23:15 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id CA8BC120ED569;
        Wed, 15 Apr 2020 16:23:14 -0700 (PDT)
Date:   Wed, 15 Apr 2020 16:23:14 -0700 (PDT)
Message-Id: <20200415.162314.1375403568829030937.davem@davemloft.net>
To:     cambda@linux.alibaba.com
Cc:     netdev@vger.kernel.org, edumazet@google.com,
        dust.li@linux.alibaba.com, tonylu@linux.alibaba.com
Subject: Re: [PATCH net-next] Documentation: Fix tcp_challenge_ack_limit
 default value
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200415095404.5673-1-cambda@linux.alibaba.com>
References: <20200415095404.5673-1-cambda@linux.alibaba.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 15 Apr 2020 16:23:15 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Cambda Zhu <cambda@linux.alibaba.com>
Date: Wed, 15 Apr 2020 17:54:04 +0800

> The default value of tcp_challenge_ack_limit has been changed from
> 100 to 1000 and this patch fixes its documentation.
> 
> Signed-off-by: Cambda Zhu <cambda@linux.alibaba.com>

As a documentation fix I'm applying this to 'net'.
