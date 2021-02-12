Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08D6E3197FB
	for <lists+netdev@lfdr.de>; Fri, 12 Feb 2021 02:33:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229702AbhBLBby (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Feb 2021 20:31:54 -0500
Received: from 95-165-96-9.static.spd-mgts.ru ([95.165.96.9]:40888 "EHLO
        blackbox.su" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229623AbhBLBbw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 11 Feb 2021 20:31:52 -0500
Received: from metamini.metanet (metamini.metanet [192.168.2.5])
        by blackbox.su (Postfix) with ESMTP id F1F82815EF;
        Fri, 12 Feb 2021 04:31:10 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=blackbox.su; s=mail;
        t=1613093471; bh=XmhQsA4n+EXmRwxvePR3/LbVyc3ah2XQcOg1CtufDX4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VQduOX7EJckNGByJL8BgV6u9SySoV4mMPyLzUDUbZTR/V5FL/6SCBq2WOLfd+xceW
         aW0R2UesDJGxdaFlhmg4AfP2IxxSa+uJKeuYW/1Kb+VIfHhY3j7qof9qxlpODaKTn2
         QJYqXsvWd61q0h3DCjO7leyBXsF+ZoiP9jiGN1fORo3+yFO3YNbjm3CtH34U3We9nY
         uOcLZlB407AIpQX7o46DrZuPW8WDLSqXUBG2B71ou7MNFGzgp31DoVTxF/MUof6Nmx
         us6FlHSll/op65mo7gRipiKWqlP3/GwYLa1sjSnZL2jAMAXmzMG0SFtxWUZusOmfvz
         5zjU6RR612Jfw==
From:   Sergej Bauer <sbauer@blackbox.su>
To:     thesven73@gmail.com
Cc:     andrew@lunn.ch, Markus.Elfring@web.de, rtgbnm@gmail.com,
        tharvey@gateworks.com, anders@ronningen.priv.no,
        sbauer@blackbox.su,
        Bryan Whitehead <bryan.whitehead@microchip.com>,
        UNGLinuxDriver@microchip.com (maintainer:MICROCHIP LAN743X ETHERNET
        DRIVER), "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev@vger.kernel.org (open list:MICROCHIP LAN743X ETHERNET DRIVER),
        linux-kernel@vger.kernel.org (open list)
Subject: Re: [PATCH net-next v2 1/5] lan743x: boost performance on cpu archs w/o dma cache snooping
Date:   Fri, 12 Feb 2021 04:31:09 +0300
Message-Id: <20210212013109.23255-1-sbauer@blackbox.su>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <CAGngYiUx78x1nj4Kr0m6sn4-yJnVYcuHGOGVfHgQZ11+8SVo+Q@mail.gmail.com>
References: <CAGngYiUx78x1nj4Kr0m6sn4-yJnVYcuHGOGVfHgQZ11+8SVo+Q@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Friday, February 12, 2021 3:27:40 AM MSK you wrote:
> Hi Sergej, thank you for testing this !
Don't mention it, it's just a small assistance
 
> On Thu, Feb 11, 2021 at 7:18 PM Sergej Bauer <sbauer@blackbox.su> wrote:
> > although whole set of tests might be an overly extensive, but after
> > applying patch v2 [1/5]
> > tests are:
> I am unfamiliar with the test_ber tool. Does this patch improve things?
v1 does a great job
number of lost packets decreased by 2.5-3 times
except of this, without the patch I have bit error rate about 0.423531 with MTU=1500
and now with this patch BER=0.

resuls of v2 are about the same as results of v1
tomorrow I can test it in more wide range of frame sizes.

tomorrow I can test v2 again, if it needs to be tested again.

