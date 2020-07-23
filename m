Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7275322B606
	for <lists+netdev@lfdr.de>; Thu, 23 Jul 2020 20:47:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727929AbgGWSrl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jul 2020 14:47:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726349AbgGWSrl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jul 2020 14:47:41 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CE2EC0619DC
        for <netdev@vger.kernel.org>; Thu, 23 Jul 2020 11:47:41 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 0721113AFBA89;
        Thu, 23 Jul 2020 11:30:55 -0700 (PDT)
Date:   Thu, 23 Jul 2020 11:47:40 -0700 (PDT)
Message-Id: <20200723.114740.2116654801704929589.davem@davemloft.net>
To:     pabeni@redhat.com
Cc:     netdev@vger.kernel.org, mptcp@lists.01.org
Subject: Re: [PATCH net-next 0/8] mptcp: non backup subflows pre-reqs
From:   David Miller <davem@davemloft.net>
In-Reply-To: <cover.1595431326.git.pabeni@redhat.com>
References: <cover.1595431326.git.pabeni@redhat.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 23 Jul 2020 11:30:56 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Paolo Abeni <pabeni@redhat.com>
Date: Thu, 23 Jul 2020 13:02:28 +0200

> This series contains a bunch of MPTCP improvements loosely related to
> concurrent subflows xmit usage, currently under development.
> 
> The first 3 patches are actually bugfixes for issues that will become apparent
> as soon as we will enable the above feature.
> 
> The later patches improve the handling of incoming additional subflows,
> improving significantly the performances in stress tests based on a high new
> connection rate.

Series applied, thanks!
