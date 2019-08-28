Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CA9F8A0CA6
	for <lists+netdev@lfdr.de>; Wed, 28 Aug 2019 23:45:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726944AbfH1Vp3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Aug 2019 17:45:29 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:37364 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726658AbfH1Vp3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Aug 2019 17:45:29 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 053F4153A41AF;
        Wed, 28 Aug 2019 14:45:28 -0700 (PDT)
Date:   Wed, 28 Aug 2019 14:43:14 -0700 (PDT)
Message-Id: <20190828.144314.1351404772449745186.davem@davemloft.net>
To:     edumazet@google.com
Cc:     netdev@vger.kernel.org, eric.dumazet@gmail.com
Subject: Re: [PATCH net-next] ipv6: shrink struct ipv6_mc_socklist
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190827070812.150106-1-edumazet@google.com>
References: <20190827070812.150106-1-edumazet@google.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 28 Aug 2019 14:45:29 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>
Date: Tue, 27 Aug 2019 00:08:12 -0700

> Remove two holes on 64bit arches, to bring the size
> to one cache line exactly.
> 
> Signed-off-by: Eric Dumazet <edumazet@google.com>

Applied.
