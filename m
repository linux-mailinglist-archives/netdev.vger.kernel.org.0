Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF48B250E1E
	for <lists+netdev@lfdr.de>; Tue, 25 Aug 2020 03:18:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728213AbgHYBSp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Aug 2020 21:18:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726041AbgHYBSo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Aug 2020 21:18:44 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DB5AC061574
        for <netdev@vger.kernel.org>; Mon, 24 Aug 2020 18:18:44 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id AA4C61295779E;
        Mon, 24 Aug 2020 18:01:57 -0700 (PDT)
Date:   Mon, 24 Aug 2020 18:18:43 -0700 (PDT)
Message-Id: <20200824.181843.938451977411019472.davem@davemloft.net>
To:     sw@simonwunderlich.de
Cc:     netdev@vger.kernel.org, b.a.t.m.a.n@lists.open-mesh.org
Subject: Re: [PATCH 0/5] pull request for net-next: batman-adv 2020-08-24
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200824162741.880-1-sw@simonwunderlich.de>
References: <20200824162741.880-1-sw@simonwunderlich.de>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 24 Aug 2020 18:01:57 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Simon Wunderlich <sw@simonwunderlich.de>
Date: Mon, 24 Aug 2020 18:27:36 +0200

> here is a small cleanup pull request of batman-adv to go into net-next.
> 
> Please pull or let me know of any problem!

Also pulled, thank you.
