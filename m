Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8572F1E8890
	for <lists+netdev@lfdr.de>; Fri, 29 May 2020 22:08:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727024AbgE2UIu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 May 2020 16:08:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726866AbgE2UIu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 May 2020 16:08:50 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24660C03E969
        for <netdev@vger.kernel.org>; Fri, 29 May 2020 13:08:50 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 9292F128400B5;
        Fri, 29 May 2020 13:08:49 -0700 (PDT)
Date:   Fri, 29 May 2020 13:08:48 -0700 (PDT)
Message-Id: <20200529.130848.1639574617431082448.davem@davemloft.net>
To:     wangli8850@gmail.com
Cc:     netdev@vger.kernel.org, wangli09@kuaishou.com
Subject: Re: [PATCH] net: udp: remove the redundant assignment
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200529112321.18606-1-wangli09@kuaishou.com>
References: <20200529112321.18606-1-wangli09@kuaishou.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 29 May 2020 13:08:49 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Wang Li <wangli8850@gmail.com>
Date: Fri, 29 May 2020 19:23:21 +0800

> Signed-off-by: Wang Li <wangli09@kuaishou.com>

uh->check is read by the lco_csum() call, this assignment is not
redundant at all.

Please put more care into your changes.

Thank you.
