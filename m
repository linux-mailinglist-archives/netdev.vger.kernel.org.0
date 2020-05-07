Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6BFBB1C7E90
	for <lists+netdev@lfdr.de>; Thu,  7 May 2020 02:30:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726768AbgEGA35 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 May 2020 20:29:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726014AbgEGA35 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 May 2020 20:29:57 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3755CC061A0F
        for <netdev@vger.kernel.org>; Wed,  6 May 2020 17:29:57 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 867F51277CC81;
        Wed,  6 May 2020 17:29:56 -0700 (PDT)
Date:   Wed, 06 May 2020 17:29:55 -0700 (PDT)
Message-Id: <20200506.172955.622426428831381840.davem@davemloft.net>
To:     edumazet@google.com
Cc:     netdev@vger.kernel.org, eric.dumazet@gmail.com,
        ncardwell@google.com, ycheng@google.com
Subject: Re: [PATCH net-next 0/2] tcp: minor adjustments for low pacing
 rates
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200504182750.176486-1-edumazet@google.com>
References: <20200504182750.176486-1-edumazet@google.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 06 May 2020 17:29:56 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>
Date: Mon,  4 May 2020 11:27:48 -0700

> After pacing horizon addition, we have to adjust how we arm rto
> timer, otherwise we might freeze very low pacing rate flows.

Series applied, thanks Eric.
