Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A4A041363B
	for <lists+netdev@lfdr.de>; Tue, 21 Sep 2021 17:32:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233948AbhIUPdj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Sep 2021 11:33:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233821AbhIUPdf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Sep 2021 11:33:35 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A911C061574
        for <netdev@vger.kernel.org>; Tue, 21 Sep 2021 08:32:06 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1mShkZ-0007I9-LF; Tue, 21 Sep 2021 17:32:03 +0200
Date:   Tue, 21 Sep 2021 17:32:03 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Alexander Kuznetsov <wwfq@yandex-team.ru>, netdev@vger.kernel.org,
        zeil@yandex-team.ru
Subject: Re: [PATCH] ipv6: enable net.ipv6.route sysctls in network namespace
Message-ID: <20210921153203.GK15906@breakpoint.cc>
References: <20210921062204.16571-1-wwfq@yandex-team.ru>
 <20210921060909.380179f0@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210921060909.380179f0@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jakub Kicinski <kuba@kernel.org> wrote:
> On Tue, 21 Sep 2021 09:22:04 +0300 Alexander Kuznetsov wrote:
> > We want to increase route cache size in network namespace
> > created with user namespace. Currently ipv6 route settings
> > are disabled for non-initial network namespaces.
> > Since routes are per network namespace it is safe
> > to enable these sysctls.

Are routes accounted towards memcg or something like that?

Otherwise userns could start eating up memory by cranking the limit
up to 11 and just adds a gazillion routes?
