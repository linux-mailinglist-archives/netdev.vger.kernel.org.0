Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C7134228C84
	for <lists+netdev@lfdr.de>; Wed, 22 Jul 2020 01:12:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731373AbgGUXLx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jul 2020 19:11:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726148AbgGUXLx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jul 2020 19:11:53 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58C78C061794;
        Tue, 21 Jul 2020 16:11:53 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id B789B11E45904;
        Tue, 21 Jul 2020 15:55:07 -0700 (PDT)
Date:   Tue, 21 Jul 2020 16:11:51 -0700 (PDT)
Message-Id: <20200721.161151.1372351247735835232.davem@davemloft.net>
To:     paolo.pisati@canonical.com
Cc:     kuba@kernel.org, shuah@kernel.org, willemb@google.com,
        jianyang@google.com, netdev@vger.kernel.org,
        linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] selftest: txtimestamp: fix net ns entry logic
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200721161710.80797-1-paolo.pisati@canonical.com>
References: <CA+FuTSeN8SONXySGys8b2EtTqJmHDKw1XVoDte0vzUPg=yuH5g@mail.gmail.com>
        <20200721161710.80797-1-paolo.pisati@canonical.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 21 Jul 2020 15:55:08 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Paolo Pisati <paolo.pisati@canonical.com>
Date: Tue, 21 Jul 2020 18:17:10 +0200

> According to 'man 8 ip-netns', if `ip netns identify` returns an empty string,
> there's no net namespace associated with current PID: fix the net ns entrance
> logic.
> 
> Signed-off-by: Paolo Pisati <paolo.pisati@canonical.com>

Applied, thanks.
