Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8CDCF2CDB0B
	for <lists+netdev@lfdr.de>; Thu,  3 Dec 2020 17:24:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731165AbgLCQVz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Dec 2020 11:21:55 -0500
Received: from mailout04.rmx.de ([94.199.90.94]:36478 "EHLO mailout04.rmx.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730881AbgLCQVz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 3 Dec 2020 11:21:55 -0500
Received: from kdin01.retarus.com (kdin01.dmz1.retloc [172.19.17.48])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mailout04.rmx.de (Postfix) with ESMTPS id 4Cn1Kz6Cn8z3qyHn;
        Thu,  3 Dec 2020 17:21:11 +0100 (CET)
Received: from mta.arri.de (unknown [217.111.95.66])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by kdin01.retarus.com (Postfix) with ESMTPS id 4Cn1Kq6jBwz2xCj;
        Thu,  3 Dec 2020 17:21:03 +0100 (CET)
Received: from n95hx1g2.localnet (192.168.54.174) by mta.arri.de
 (192.168.100.104) with Microsoft SMTP Server (TLS) id 14.3.487.0; Thu, 3 Dec
 2020 17:20:37 +0100
From:   Christian Eggers <ceggers@arri.de>
To:     Vladimir Oltean <olteanv@gmail.com>
CC:     Richard Cochran <richardcochran@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Rob Herring <robh+dt@kernel.org>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Kurt Kanzenbach <kurt.kanzenbach@linutronix.de>,
        George McCollister <george.mccollister@gmail.com>,
        Marek Vasut <marex@denx.de>,
        Helmut Grohne <helmut.grohne@intenta.de>,
        Paul Barker <pbarker@konsulko.com>,
        "Codrin Ciubotariu" <codrin.ciubotariu@microchip.com>,
        Tristram Ha <Tristram.Ha@microchip.com>,
        Woojung Huh <woojung.huh@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        netdev <netdev@vger.kernel.org>,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" 
        <devicetree@vger.kernel.org>, lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next v5 9/9] net: dsa: microchip: ksz9477: add periodic output support
Date:   Thu, 3 Dec 2020 17:20:36 +0100
Message-ID: <2436656.VLTSFkEMrK@n95hx1g2>
Organization: Arnold & Richter Cine Technik GmbH & Co. Betriebs KG
In-Reply-To: <CA+h21hqtgaFOgiSdho879ZfaRsMtp44kcFuq3zyW4Jb811gPSw@mail.gmail.com>
References: <20201203102117.8995-1-ceggers@arri.de> <11406377.LS7tM95F4J@n95hx1g2> <CA+h21hqtgaFOgiSdho879ZfaRsMtp44kcFuq3zyW4Jb811gPSw@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Originating-IP: [192.168.54.174]
X-RMX-ID: 20201203-172103-ypvHKDKNQjmH-0@out01.hq
X-RMX-SOURCE: 217.111.95.66
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thursday, 3 December 2020, 16:52:46 CET, Vladimir Oltean wrote:
> On Thu, 3 Dec 2020 at 17:36, Christian Eggers <ceggers@arri.de> wrote:
> > Should ptp_sysfs be extended with a "pulse" attribute with calls
> > enable() with only PTP_PEROUT_DUTY_CYCLE set?
> 
> Use tools/testing/selftests/ptp/testptp.

Thanks for the hint. Last time I looked at it (5.4), it used to have
no "pulse" feature (as the ioctl() interface).

Maybe I should also add support for PTP_PEROUT_PHASE to the KSZ driver.

regards
Christian



