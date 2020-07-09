Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6CB9321A7E9
	for <lists+netdev@lfdr.de>; Thu,  9 Jul 2020 21:39:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726323AbgGITjB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jul 2020 15:39:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726213AbgGITjB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jul 2020 15:39:01 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11DE8C08C5CE
        for <netdev@vger.kernel.org>; Thu,  9 Jul 2020 12:39:01 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 85AAC12795F9D;
        Thu,  9 Jul 2020 12:39:00 -0700 (PDT)
Date:   Thu, 09 Jul 2020 12:38:59 -0700 (PDT)
Message-Id: <20200709.123859.1982048822159692342.davem@davemloft.net>
To:     pabeni@redhat.com
Cc:     netdev@vger.kernel.org, edumazet@google.com, mptcp@lists.01.org
Subject: Re: [PATCH net-next 0/4] mptcp: introduce msk diag interface
From:   David Miller <davem@davemloft.net>
In-Reply-To: <cover.1594292774.git.pabeni@redhat.com>
References: <cover.1594292774.git.pabeni@redhat.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 09 Jul 2020 12:39:00 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Paolo Abeni <pabeni@redhat.com>
Date: Thu,  9 Jul 2020 15:12:38 +0200

> This series implements the diag interface for the MPTCP sockets.
> 
> Since the MPTCP protocol value can't be represented with the
> current diag uAPI, the first patch introduces an extended attribute
> allowing user-space to specify lager protocol values.
> 
> The token APIs are then extended to allow traversing the
> whole token container.
> 
> Patch 3 carries the actual diag interface implementation, and 
> later patch bring-in some functional self-tests.

Series applied, thanks.
