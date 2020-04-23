Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E35D1B5289
	for <lists+netdev@lfdr.de>; Thu, 23 Apr 2020 04:29:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726577AbgDWC3l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Apr 2020 22:29:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726271AbgDWC3l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Apr 2020 22:29:41 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0412C03C1AA;
        Wed, 22 Apr 2020 19:29:40 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id B3DC4127AA060;
        Wed, 22 Apr 2020 19:29:40 -0700 (PDT)
Date:   Wed, 22 Apr 2020 19:29:40 -0700 (PDT)
Message-Id: <20200422.192940.1685473383760448858.davem@davemloft.net>
To:     stephen@networkplumber.org
Cc:     netdev@vger.kernel.org, linux-doc@vger.kernel.org
Subject: Re: [PATCH] Documentation: add documentation of ping_group_range
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200421203448.17937-1-stephen@networkplumber.org>
References: <20200421203448.17937-1-stephen@networkplumber.org>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 22 Apr 2020 19:29:40 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Stephen Hemminger <stephen@networkplumber.org>
Date: Tue, 21 Apr 2020 13:34:48 -0700

> Support for non-root users to send ICMP ECHO requests was added
> back in Linux 3.0 kernel, but the documentation for the sysctl
> to enable it has been missing.
> 
> Signed-off-by: Stephen Hemminger <stephen@networkplumber.org>

Applied, thanks.
