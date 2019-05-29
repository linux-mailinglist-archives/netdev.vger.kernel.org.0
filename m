Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 100F32D2CF
	for <lists+netdev@lfdr.de>; Wed, 29 May 2019 02:22:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727291AbfE2AW3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 May 2019 20:22:29 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:54416 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726515AbfE2AW3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 May 2019 20:22:29 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d8])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id C7F4B1400E0CC;
        Tue, 28 May 2019 17:22:28 -0700 (PDT)
Date:   Tue, 28 May 2019 17:22:28 -0700 (PDT)
Message-Id: <20190528.172228.538185057761802273.davem@davemloft.net>
To:     edumazet@google.com
Cc:     netdev@vger.kernel.org, eric.dumazet@gmail.com
Subject: Re: [PATCH net-next 0/3] inet: frags: followup to
 'inet-frags-avoid-possible-races-at-netns-dismantle'
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190527235649.45274-1-edumazet@google.com>
References: <20190527235649.45274-1-edumazet@google.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 28 May 2019 17:22:28 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>
Date: Mon, 27 May 2019 16:56:46 -0700

> Latest patch series ('inet-frags-avoid-possible-races-at-netns-dismantle')
> brought another syzbot report shown in the third patch changelog.
> 
> While fixing the issue, I had to call inet_frags_fini() later
> in IPv6 and ilowpan.
> 
> Also I believe a completion is needed to ensure proper dismantle
> at module removal.

Series applied.
