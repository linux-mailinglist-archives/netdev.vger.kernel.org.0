Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F3F01D40B4
	for <lists+netdev@lfdr.de>; Fri, 15 May 2020 00:19:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728371AbgENWTa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 May 2020 18:19:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727995AbgENWTa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 May 2020 18:19:30 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85D3EC061A0C
        for <netdev@vger.kernel.org>; Thu, 14 May 2020 15:19:30 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 1026813D68D17;
        Thu, 14 May 2020 15:19:30 -0700 (PDT)
Date:   Thu, 14 May 2020 15:19:29 -0700 (PDT)
Message-Id: <20200514.151929.1785601932136047699.davem@davemloft.net>
To:     pabeni@redhat.com
Cc:     netdev@vger.kernel.org, edumazet@google.com, cpaasch@apple.com
Subject: Re: [PATCH net-next 0/3] mptcp: fix MP_JOIN failure handling
From:   David Miller <davem@davemloft.net>
In-Reply-To: <cover.1589383730.git.pabeni@redhat.com>
References: <cover.1589383730.git.pabeni@redhat.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 14 May 2020 15:19:30 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Paolo, please respond to the feedback you received for patch #1.

Thank you.
