Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D5A0C422A99
	for <lists+netdev@lfdr.de>; Tue,  5 Oct 2021 16:14:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236531AbhJEOQA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Oct 2021 10:16:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236546AbhJEOPJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Oct 2021 10:15:09 -0400
Received: from mail.aperture-lab.de (mail.aperture-lab.de [IPv6:2a01:4f8:c2c:665b::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7A00C0617BE;
        Tue,  5 Oct 2021 07:12:31 -0700 (PDT)
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id B339041025;
        Tue,  5 Oct 2021 16:12:23 +0200 (CEST)
Date:   Tue, 5 Oct 2021 16:12:20 +0200
From:   Linus =?utf-8?Q?L=C3=BCssing?= <linus.luessing@c0d3.blue>
To:     Kalle Valo <kvalo@codeaurora.org>, Felix Fietkau <nbd@nbd.name>,
        Sujith Manoharan <c_manoha@qca.qualcomm.com>,
        ath9k-devel@qca.qualcomm.com
Cc:     linux-wireless@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "John W . Linville" <linville@tuxdriver.com>,
        Felix Fietkau <nbd@openwrt.org>,
        Simon Wunderlich <sw@simonwunderlich.de>,
        Sven Eckelmann <sven@narfation.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] ath9k: interrupt fixes on queue reset
Message-ID: <YVxdRHvpiHVpdu4H@sellars>
References: <20210914192515.9273-1-linus.luessing@c0d3.blue>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210914192515.9273-1-linus.luessing@c0d3.blue>
X-Last-TLS-Session-Version: TLSv1.3
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 14, 2021 at 09:25:12PM +0200, Linus Lüssing wrote:
> Hi,
> 
> The following are two patches for ath9k to fix a potential interrupt
> storm (PATCH 2/3) and to fix potentially resetting the wifi chip while
> its interrupts were accidentally reenabled (PATCH 3/3).
> 
> PATCH 1/3 adds the possibility to trigger the ath9k queue reset through
> the ath9k reset file in debugfs. Which was helpful to reproduce and debug
> this issue and might help for future debugging.
> 
> PATCH 2/3 and PATCH 3/3 should be applicable for stable.
> 
> Regards, Linus
> 

I've marked PATCH 3/3 as "rejected" in Patchwork now due to
Felix's legitimate remarks. For patches 1/3 and and 2/3 I'd
still like to see them merged upstream if there is no objection
to those.

Regars, Linus
