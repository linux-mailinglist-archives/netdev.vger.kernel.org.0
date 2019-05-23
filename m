Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6510E2739F
	for <lists+netdev@lfdr.de>; Thu, 23 May 2019 02:59:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729698AbfEWA6z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 May 2019 20:58:55 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:37130 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727854AbfEWA6y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 May 2019 20:58:54 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d8])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 423061504392A;
        Wed, 22 May 2019 17:58:54 -0700 (PDT)
Date:   Wed, 22 May 2019 17:58:53 -0700 (PDT)
Message-Id: <20190522.175853.757415013082722487.davem@davemloft.net>
To:     edumazet@google.com
Cc:     netdev@vger.kernel.org, eric.dumazet@gmail.com
Subject: Re: [PATCH net-next] ipv4/igmp: shrink struct ip_sf_list
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190522220025.78765-1-edumazet@google.com>
References: <20190522220025.78765-1-edumazet@google.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 22 May 2019 17:58:54 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>
Date: Wed, 22 May 2019 15:00:25 -0700

> Removing two 4 bytes holes allows to use kmalloc-32
> kmem cache instead of kmalloc-64 on 64bit kernels.
> 
> Signed-off-by: Eric Dumazet <edumazet@google.com>

Applied.
