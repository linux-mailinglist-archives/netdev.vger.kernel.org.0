Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 54A351DA4BF
	for <lists+netdev@lfdr.de>; Wed, 20 May 2020 00:43:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728054AbgESWmF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 May 2020 18:42:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727966AbgESWmE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 May 2020 18:42:04 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C510C061A0E;
        Tue, 19 May 2020 15:42:04 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 10180128F0061;
        Tue, 19 May 2020 15:42:04 -0700 (PDT)
Date:   Tue, 19 May 2020 15:42:02 -0700 (PDT)
Message-Id: <20200519.154202.2088276192882746951.davem@davemloft.net>
To:     tangbin@cmss.chinamobile.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        zhangshengju@cmss.chinamobile.com
Subject: Re: [PATCH] net/amd: Remove the extra blank lines
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200519111529.12016-1-tangbin@cmss.chinamobile.com>
References: <20200519111529.12016-1-tangbin@cmss.chinamobile.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 19 May 2020 15:42:04 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Please put these patches into a proper, numbered, patch series with
an appropriate header posting.

Some of these patches do not apply cleanly to the net-next tree, which
is where these changes should be targetted.  Please respin.

Thank you.
