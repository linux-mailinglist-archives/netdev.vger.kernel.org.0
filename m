Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D6E8AD0F49
	for <lists+netdev@lfdr.de>; Wed,  9 Oct 2019 14:58:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731138AbfJIM63 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Oct 2019 08:58:29 -0400
Received: from skyboo.net ([5.252.110.31]:38702 "EHLO skyboo.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730765AbfJIM63 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 9 Oct 2019 08:58:29 -0400
X-Greylist: delayed 2265 seconds by postgrey-1.27 at vger.kernel.org; Wed, 09 Oct 2019 08:58:28 EDT
Received: from [10.1.0.1] (helo=nemesis.skyboo.net)
        by skyboo.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.91)
        (envelope-from <manio@skyboo.net>)
        id 1iIAxN-0003Ad-GO; Wed, 09 Oct 2019 14:20:41 +0200
Date:   Wed, 9 Oct 2019 14:20:41 +0200
From:   Mariusz Bialonczyk <manio@skyboo.net>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Francois Romieu <romieu@fr.zoreil.com>
Message-Id: <20191009142041.1e8d9cb0d79ed91a38d03b0a@skyboo.net>
In-Reply-To: <c6cac9fa-36fe-dded-a0a7-082326c3cc36@gmail.com>
References: <20190913114424.540c1d257c4083eace242bbf@skyboo.net>
        <c55484e7-9dfb-0e5e-3887-278a334ac831@gmail.com>
        <20191008102706.e3f57ffe3e779802898a99ee@skyboo.net>
        <c6cac9fa-36fe-dded-a0a7-082326c3cc36@gmail.com>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 10.1.0.1
X-SA-Exim-Rcpt-To: hkallweit1@gmail.com, netdev@vger.kernel.org, romieu@fr.zoreil.com
X-SA-Exim-Mail-From: manio@skyboo.net
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on nemesis.skyboo.net
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=5.0 tests=ALL_TRUSTED,BAYES_00,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.1
Subject: Re: RTL8169 question
X-SA-Exim-Version: 4.2.1 (built Tue, 02 Aug 2016 21:08:31 +0000)
X-SA-Exim-Scanned: Yes (on skyboo.net)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 8 Oct 2019 22:04:45 +0200
Heiner Kallweit <hkallweit1@gmail.com> wrote:

> Thanks for the comprehensive analysis! Comparing the chip registers before
> and after suspend your BIOS seems to change registers on resume from suspend,
> and the driver doesn't configure jumbo when resuming. This may explain the
> issue. The combination jumbo + suspend + BIOS bug seems to be quite rare,
> else I think we should have seen such a report years ago already.
I see.

> Could you please check whether the following patch fixes the issue for you?
I've tested your patch with minor change when applying on top of the current
master tree.

The result is: it is working great!
No more problems, that I was observing before.
Thank you very much, Heiner!

You can add:
Reported-by: Mariusz Bialonczyk <manio@skyboo.net>
Tested-by: Mariusz Bialonczyk <manio@skyboo.net>

regards,
-- 
Mariusz Białończyk | xmpp/e-mail: manio@skyboo.net
http://manio.skyboo.net | https://github.com/manio
