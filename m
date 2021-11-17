Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4DEB1454349
	for <lists+netdev@lfdr.de>; Wed, 17 Nov 2021 10:07:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234789AbhKQJJ6 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 17 Nov 2021 04:09:58 -0500
Received: from relay8-d.mail.gandi.net ([217.70.183.201]:41541 "EHLO
        relay8-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230064AbhKQJJ6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Nov 2021 04:09:58 -0500
Received: (Authenticated sender: pbl@bestov.io)
        by relay8-d.mail.gandi.net (Postfix) with ESMTPSA id E08141BF20F;
        Wed, 17 Nov 2021 09:06:55 +0000 (UTC)
Mime-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset=UTF-8
Subject: Re: [PATCH v2] ipv4/raw: support binding to nonlocal addresses
From:   "Riccardo Paolo Bestetti" <pbl@bestov.io>
To:     "Jakub Kicinski" <kuba@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        "Hideaki YOSHIFUJI" <yoshfuji@linux-ipv6.org>,
        "David Ahern" <dsahern@kernel.org>,
        "Shuah Khan" <shuah@kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-kselftest@vger.kernel.org>
Date:   Wed, 17 Nov 2021 09:05:33 +0100
Message-Id: <CFRWE8SRLDE4.3IOLDJ2DK69ZR@enhorning>
In-Reply-To: <20211116194413.32c7f584@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed Nov 17, 2021 at 4:44 AM CET, Jakub Kicinski wrote:
> On Mon, 15 Nov 2021 00:09:44 +0100 Riccardo Paolo Bestetti wrote:
> > Add support to inet v4 raw sockets for binding to nonlocal addresses
> > through the IP_FREEBIND and IP_TRANSPARENT socket options, as well as
> > the ipv4.ip_nonlocal_bind kernel parameter.
>
> FWIW this patch did not make it to patchwork or any of the mailing
> lists. Not immediately obvious why. Can you try re-sending?

It did end up on patchwork[1] last time I sent it. At the time net-next
was closed, so you asked me to send it again when it re-opened. I
probably screwed up the message ID this time around.

As of why it didn't end up on the mailing lists - I have no clue! They
are definitely CC'd.

I re-sent it. Hopefully everything worked this time!

Riccardo

[1] https://patchwork.kernel.org/project/netdevbpf/patch/20211102141921.197561-1-pbl@bestov.io/

