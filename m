Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E7C3226A83
	for <lists+netdev@lfdr.de>; Mon, 20 Jul 2020 18:36:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388834AbgGTQfL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jul 2020 12:35:11 -0400
Received: from mx4.wp.pl ([212.77.101.11]:45144 "EHLO mx4.wp.pl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731566AbgGTPyd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 20 Jul 2020 11:54:33 -0400
Received: (wp-smtpd smtp.wp.pl 16606 invoked from network); 20 Jul 2020 17:54:30 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=wp.pl; s=1024a;
          t=1595260471; bh=Y0bZYOg1d1EJBOpSBHiUjDo02WQDRKDZBBBZtcRjU7Y=;
          h=From:To:Cc:Subject;
          b=FYBCbTFUnDIBtbI8nTQmeLGktKbYGctKcXLK3jORi7mXETEucsm7LCdpr4Bf1uKX8
           bbYHCWx/1KOkegDqDqRBH/pctdGFLWPUKKjFjq5ON0hd/U10aiHTiJHn9vsPgTrx73
           9GR+tLSiaIUzFWokKbrx3Qq3gQwhVaQ05ylNKn3E=
Received: from unknown (HELO kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com) (kubakici@wp.pl@[163.114.132.7])
          (envelope-sender <kubakici@wp.pl>)
          by smtp.wp.pl (WP-SMTPD) with ECDHE-RSA-AES256-GCM-SHA384 encrypted SMTP
          for <navid.emamdoost@gmail.com>; 20 Jul 2020 17:54:30 +0200
Date:   Mon, 20 Jul 2020 08:54:22 -0700
From:   Jakub Kicinski <kubakici@wp.pl>
To:     Navid Emamdoost <navid.emamdoost@gmail.com>
Cc:     Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mt7601u: add missing release on skb in
 mt7601u_mcu_msg_send
Message-ID: <20200720085422.40539aa4@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200718052630.11032-1-navid.emamdoost@gmail.com>
References: <20200718052630.11032-1-navid.emamdoost@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-WP-MailID: 86ad31f636f93e20d39630a6dd07675f
X-WP-AV: skaner antywirusowy Poczty Wirtualnej Polski
X-WP-SPAM: NO 0000001 [geJz]                               
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 18 Jul 2020 00:26:29 -0500 Navid Emamdoost wrote:
> In the implementation of mt7601u_mcu_msg_send(), skb is supposed to be
> consumed on all execution paths. Release skb before returning if
> test_bit() fails.
> 
> Signed-off-by: Navid Emamdoost <navid.emamdoost@gmail.com>

Acked-by: Jakub Kicinski <kubakici@wp.pl>
