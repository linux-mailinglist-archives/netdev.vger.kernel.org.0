Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6165729D532
	for <lists+netdev@lfdr.de>; Wed, 28 Oct 2020 22:59:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729266AbgJ1V7M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Oct 2020 17:59:12 -0400
Received: from mail.nic.cz ([217.31.204.67]:41696 "EHLO mail.nic.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728675AbgJ1V7L (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 28 Oct 2020 17:59:11 -0400
Received: from localhost (unknown [IPv6:2a0e:b107:ae1:0:3e97:eff:fe61:c680])
        by mail.nic.cz (Postfix) with ESMTPSA id 64B27140757;
        Wed, 28 Oct 2020 03:03:10 +0100 (CET)
Date:   Wed, 28 Oct 2020 03:03:04 +0100
From:   Marek Behun <marek.behun@nic.cz>
To:     Pavana Sharma <pavana.sharma@digi.com>
Cc:     f.fainelli@gmail.com, andrew@lunn.ch, davem@davemloft.net,
        gregkh@linuxfoundation.org, kuba@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        vivien.didelot@gmail.com
Subject: Re: [PATCH v5 3/3] net: dsa: mv88e6xxx: Add support for mv88e6393x
 family of Marvell
Message-ID: <20201028030304.2ba00b2d@nic.cz>
In-Reply-To: <e5fdcddeda21884a21162e441d1e8a04994f2825.1603837679.git.pavana.sharma@digi.com>
References: <cover.1603837678.git.pavana.sharma@digi.com>
        <e5fdcddeda21884a21162e441d1e8a04994f2825.1603837679.git.pavana.sharma@digi.com>
X-Mailer: Claws Mail 3.17.6 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-100.0 required=5.9 tests=SHORTCIRCUIT,
        USER_IN_WELCOMELIST,USER_IN_WHITELIST shortcircuit=ham
        autolearn=disabled version=3.4.2
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on mail.nic.cz
X-Virus-Scanned: clamav-milter 0.102.2 at mail
X-Virus-Status: Clean
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Pavana,

please add me to Cc for this.

Does USXGMII mode work? There are some erratas for for 10gb serdes mode.

Also you should split this patch. The code that refactores the
serdes_get_lane methods should be in a separate patch.

I have a device with this switch and also a SFP module which can
operate with USXGMII. I would like to get USXGMII mode to work before
this support is added, if possible. For some reason though I was unable
to get it to work, I will have to look at those erratas.

Marek
