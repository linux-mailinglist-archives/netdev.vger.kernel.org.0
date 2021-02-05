Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4CD753111D6
	for <lists+netdev@lfdr.de>; Fri,  5 Feb 2021 21:06:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233197AbhBESUB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Feb 2021 13:20:01 -0500
Received: from 95-165-96-9.static.spd-mgts.ru ([95.165.96.9]:37920 "EHLO
        blackbox.su" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232956AbhBEPTi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 5 Feb 2021 10:19:38 -0500
Received: from metabook.localnet (metabook.metanet [192.168.2.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by blackbox.su (Postfix) with ESMTPSA id C7CC482F55;
        Fri,  5 Feb 2021 20:01:01 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=blackbox.su; s=mail;
        t=1612544461; bh=8d8pym2XIrk7WkGR4fNOkdwFEs3C+isJyx94BLKbO9E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NyGPq26wY9ROwjybDXexHkEG9WrPo8sXFAT8Qf2drMN8C2TGnzWJKfFbiv7kl5GYt
         gk1bWhviOobmpG1WjncBxew6T1UcETxwvZvaKOM33TypT6VZYQZoQpasHxa/NLI6J4
         UbdQCrPpr1xAlMcbGPDNbR6QuEHfawHL+Qx6YjjgALxbT3GGiyLUa9UHvRhXne+06L
         +HggHUSP2JAPLa7C5m4TdBwVKiXzteU4MMK53OWPC4NvdZDArSVqlvfTP7DZq+Bucr
         xNgOmb2vRIOhV4FMwfOGXuCHhSfTWJFsU35j14xtREY0A4fyubKA8N9QdYsNzwvrf7
         nirLMTJfFkevA==
From:   Sergej Bauer <sbauer@blackbox.su>
To:     Sven Van Asbroeck <thesven73@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>, Markus.Elfring@web.de,
        Alexey Denisov <rtgbnm@gmail.com>,
        Tim Harvey <tharvey@gateworks.com>,
        Anders =?ISO-8859-1?Q?R=F8nningen?= <anders@ronningen.priv.no>,
        Bryan Whitehead <bryan.whitehead@microchip.com>,
        "maintainer:MICROCHIP LAN743X ETHERNET DRIVER" 
        <UNGLinuxDriver@microchip.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "open list:MICROCHIP LAN743X ETHERNET DRIVER" 
        <netdev@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next v1 1/6] lan743x: boost performance on cpu archs w/o dma cache snooping
Date:   Fri, 05 Feb 2021 19:59:55 +0300
Message-ID: <2417165.5kqOOugWi4@metabook>
In-Reply-To: <CAGngYiUwzzmF2iPyBmrWBW_Oe=ffNbpxrZSyyQ6U_kLmNV56xg@mail.gmail.com>
References: <CAGngYiUgjsgWYP76NKnrhbQthWbceaiugTFL=UVh_KvDuRhQUw@mail.gmail.com> <20210205150936.23010-1-sbauer@blackbox.su> <CAGngYiUwzzmF2iPyBmrWBW_Oe=ffNbpxrZSyyQ6U_kLmNV56xg@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

sOn Friday, February 5, 2021 7:39:40 PM MSK Sven Van Asbroeck wrote:
> Hi Sergej,
> 
> On Fri, Feb 5, 2021 at 10:09 AM Sergej Bauer <sbauer@blackbox.su> wrote:
> > Tests after applying patches [2/6] and [3/6] are:
> > $ ifmtu eth7 500
> > $ sudo test_ber -l eth7 -c 1000 -n 1000000 -f500 --no-conf
> 
> Thank you! Is there a way for me to run test_ber myself?
> Is this a standard, or a bespoke testing tool?
It's kind of bespoke... A part of framework to assist HW guys in developing
PHY-device. But the project is finished, so I could ask for permission to send
the source to you.



