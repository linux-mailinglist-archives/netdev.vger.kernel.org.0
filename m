Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 34B5D12A962
	for <lists+netdev@lfdr.de>; Thu, 26 Dec 2019 01:23:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726903AbfLZATa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Dec 2019 19:19:30 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:36568 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726879AbfLZATa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Dec 2019 19:19:30 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1c3::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 07BF71537E7BB;
        Wed, 25 Dec 2019 16:19:30 -0800 (PST)
Date:   Wed, 25 Dec 2019 16:19:27 -0800 (PST)
Message-Id: <20191225.161927.1679721474728857271.davem@davemloft.net>
To:     tom@herbertland.com
Cc:     netdev@vger.kernel.org, simon.horman@netronome.com,
        willemdebruijn.kernel@gmail.com
Subject: Re: [PATCH v7 net-next 0/9] ipv6: Extension header infrastructure
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1577210148-7328-1-git-send-email-tom@herbertland.com>
References: <1577210148-7328-1-git-send-email-tom@herbertland.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 25 Dec 2019 16:19:30 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tom Herbert <tom@herbertland.com>
Date: Tue, 24 Dec 2019 09:55:39 -0800

> This patchset improves the IPv6 extension header infrastructure
> to make extension headers more usable and scalable.
> 
>   - Reorganize extension header files to separate out common
>     API components
>   - Create common TLV handler that will can be used in other use
>     cases (e.g. segment routing TLVs, UDP options)
>   - Allow registration of TLV handlers
>   - Elaborate on the TLV tables to include more characteristics
>   - Add a netlink interface to set TLV parameters (such as
>     alignment requirements, authorization to send, etc.)
>   - Enhance validation of TLVs being sent. Validation is strict
>     (unless overridden by admin) following that sending clause
>     of the robustness principle
>   - Allow non-privileged users to set Hop-by-Hop and Destination
>     Options if authorized by the admin

I see no explanation as to why we want to do this, nor why any of this
is desirable at all or at any level.

So as in the past, I will keep pushing back on this series because I
see no real well defined, reasonable, impetus for it.

Sorry.
