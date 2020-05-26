Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF6551E323E
	for <lists+netdev@lfdr.de>; Wed, 27 May 2020 00:19:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390600AbgEZWT5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 May 2020 18:19:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389929AbgEZWT5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 May 2020 18:19:57 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B801C061A0F
        for <netdev@vger.kernel.org>; Tue, 26 May 2020 15:19:57 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 1E5A6120ED4B8;
        Tue, 26 May 2020 15:19:57 -0700 (PDT)
Date:   Tue, 26 May 2020 15:19:56 -0700 (PDT)
Message-Id: <20200526.151956.337627935559352027.davem@davemloft.net>
To:     sw@simonwunderlich.de
Cc:     netdev@vger.kernel.org, b.a.t.m.a.n@lists.open-mesh.org
Subject: Re: [PATCH 0/3] pull request for net-next: batman-adv 2020-05-26
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200526100007.10501-1-sw@simonwunderlich.de>
References: <20200526100007.10501-1-sw@simonwunderlich.de>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 26 May 2020 15:19:57 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Simon Wunderlich <sw@simonwunderlich.de>
Date: Tue, 26 May 2020 12:00:04 +0200

> here is a small cleanup pull request of batman-adv to go into net-next.
> 
> Please pull or let me know of any problem!

Pulled, thanks Simon.
