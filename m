Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7E662102EC3
	for <lists+netdev@lfdr.de>; Tue, 19 Nov 2019 23:02:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727194AbfKSWCZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Nov 2019 17:02:25 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:45528 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726911AbfKSWCZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Nov 2019 17:02:25 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 22106140F5809;
        Tue, 19 Nov 2019 14:02:25 -0800 (PST)
Date:   Tue, 19 Nov 2019 14:02:22 -0800 (PST)
Message-Id: <20191119.140222.1092498595946013025.davem@davemloft.net>
To:     jakub.kicinski@netronome.com
Cc:     sunil.kovvuri@gmail.com, netdev@vger.kernel.org,
        sgoutham@marvell.com
Subject: Re: [PATCH v2 00/15] octeontx2-af: SSO, TIM HW blocks and other
 config support
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191119134638.6814285a@cakuba.netronome.com>
References: <1574162259-28181-1-git-send-email-sunil.kovvuri@gmail.com>
        <20191119134638.6814285a@cakuba.netronome.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 19 Nov 2019 14:02:25 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jakub Kicinski <jakub.kicinski@netronome.com>
Date: Tue, 19 Nov 2019 13:46:38 -0800

> As I asked in my review of patch 4 in v1, please provide us with
> accurate description of how does a system with a octeontx2 operate.
> Best in the form of RST documentation in the Documentation/ directory,
> otherwise it's very hard for upstream folks to review what you're doing.

Yes, please do this.

Some of us are strongly suspecting that there is a third agent (via
an SDK or similar) that programs part of this chip in a complete system
and if that is the case you must fully disclose how all of this is
intended to work.

Right now nobody has any idea what any of these new feature components
are, how there are used, how they are configured by the user, etc.

And the choices of things to put into debugfs seem completely arbitrary.

In short, these octeontx2 submissions are for huge complicated chip
and lack any wholistic description of how this stuff works,
understandable by those reviewing your changes rather than those who
are experts about this networking chip.

Thank you.

