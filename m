Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CF4B6640C2
	for <lists+netdev@lfdr.de>; Wed, 10 Jul 2019 07:37:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727112AbfGJFhJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Jul 2019 01:37:09 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:50402 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725932AbfGJFhJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Jul 2019 01:37:09 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 4101C13E9F129;
        Tue,  9 Jul 2019 22:37:08 -0700 (PDT)
Date:   Tue, 09 Jul 2019 22:36:57 -0700 (PDT)
Message-Id: <20190709.223657.1108624224137142530.davem@davemloft.net>
To:     natechancellor@gmail.com
Cc:     saeedm@mellanox.com, leon@kernel.org, borisp@mellanox.com,
        netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        linux-kernel@vger.kernel.org, clang-built-linux@googlegroups.com,
        ndesaulniers@google.com
Subject: Re: [PATCH v2] net/mlx5e: Refactor switch statements to avoid
 using uninitialized variables
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190710044748.3924-1-natechancellor@gmail.com>
References: <20190708231154.89969-1-natechancellor@gmail.com>
        <20190710044748.3924-1-natechancellor@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 09 Jul 2019 22:37:08 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


I applied your simpler addition of the return statement so that I could
get the net-next pull request out tonight, just FYI...
