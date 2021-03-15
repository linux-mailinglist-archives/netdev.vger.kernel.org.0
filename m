Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7EAF033AB92
	for <lists+netdev@lfdr.de>; Mon, 15 Mar 2021 07:26:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229742AbhCOGZg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Mar 2021 02:25:36 -0400
Received: from esa.microchip.iphmx.com ([68.232.153.233]:39652 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229937AbhCOGZS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Mar 2021 02:25:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1615789518; x=1647325518;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=O+FmMMaqc9xAOeMmwyghT8YhOnNX8N7qYqYTwq/coSE=;
  b=FjN/bTo8A0aDYS2p4MeQl424XguObctpd4mGG2xQCbM8e8bLWLFi+p9K
   k2KOgoMoT7EEuiNYQJXu1zNXDypE+7JFLG4Ez+JnkOBRkrQmCZcXoaQ0P
   d22LecKgV+yrcDYzhWPUeh2Voy4AGMnGxfOph+d7ga7xJ+AzkjPzTLzyz
   hNMiDMAWZeF1AUTppi8aSY7C65TOMXivqc0A0REMwwktjLqnmcuArqfkY
   FmwOcyVIQ7t+iwQwkpwB+7amXkzDlynrffA3AnnDuwYr2MJywkkbO4NZQ
   vMUzwwDiAiwMu0BF0mvbE95vqd+ei7j6NgQ2D/lRLnDY6jtc8Vnu0vjP3
   Q==;
IronPort-SDR: Yr38vcY2kWvsYdFY91dEu1esAxnn2Xzpk2/yZHF90rQYBqtDAh6/YNKTVtvc1Uq5Vod11Ep/Q2
 m75YGgy1Bw1d9xcGCeot9+6KpM4/+suv8VagbeJojBPtVDcVdKmVVYzwfnqfJy4lPY3AG1eX61
 yTBxcJTbCgolGWh4+BqE5lAVFz2REcp9Z+l/XPP2S2WMPtVaztWnyztJFlbiXOFNeQQbWbNRL9
 uTyzT+kdXajcF0sFrEmz1hZyUyl5/iV5udEmK87OU9ufceBjKoBIji8iDy9S/SLMA2ganmJy2S
 rdU=
X-IronPort-AV: E=Sophos;i="5.81,249,1610434800"; 
   d="scan'208";a="113209632"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 14 Mar 2021 23:25:18 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Sun, 14 Mar 2021 23:25:17 -0700
Received: from CHE-LT-I21427U.microchip.com (10.10.115.15) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server id
 15.1.2176.2 via Frontend Transport; Sun, 14 Mar 2021 23:25:13 -0700
Message-ID: <a5ae36fda31281e0aa2f94e374158f46338ea1bb.camel@microchip.com>
Subject: Re: [PATCH net-next 3/8] net: dsa: microchip: add DSA support for
 microchip lan937x
From:   Prasanna Vengateshan Varadharajan 
        <prasanna.vengateshan@microchip.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     <olteanv@gmail.com>, <netdev@vger.kernel.org>,
        <robh+dt@kernel.org>, <kuba@kernel.org>,
        <vivien.didelot@gmail.com>, <f.fainelli@gmail.com>,
        <davem@davemloft.net>, <UNGLinuxDriver@microchip.com>,
        <Woojung.Huh@microchip.com>, <linux-kernel@vger.kernel.org>,
        <devicetree@vger.kernel.org>
Date:   Mon, 15 Mar 2021 11:55:11 +0530
In-Reply-To: <YB1HrTfUvgXbcsTr@lunn.ch>
References: <20210128064112.372883-1-prasanna.vengateshan@microchip.com>
         <20210128064112.372883-4-prasanna.vengateshan@microchip.com>
         <YBNf715MJ9OfaXfV@lunn.ch>
         <b565944e72a0af12dec0430bd819eb6b755d84b4.camel@microchip.com>
         <YB1HrTfUvgXbcsTr@lunn.ch>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.4-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 2021-02-05 at 14:27 +0100, Andrew Lunn wrote:
> EXTERNAL EMAIL: Do not click links or open attachments unless you
> know the content is safe
> 
> > > > +bool lan937x_is_internal_tx_phy_port(struct ksz_device *dev,
> > > > int
> > > > port)
> > > > +{
> > > > +     /* Check if the port is internal tx phy port */
> > > 
> > > What is an internal TX phy port? Is it actually a conventional t2
> > > Fast
> > > Ethernet port, as opposed to a t1 port?
> > This is 100 Base-Tx phy which is compliant with
> > 802.3/802.3u standards. Two of the SKUs have both T1 and TX
> > integrated
> > Phys as mentioned in the patch intro mail.
> 
> I don't think we have a good name for a conventional fast Ethernet.
> But since we call the other T1, since it has a single pair, maybe use
> T2, since Fast Ethernet uses 2 pair. I would also suggest a comment
> near this code explaining what T1 and T2 mean.
This is compliant with 802.3u (100 Base-Tx) as i mentioned above. So
naming it as "T2" would not match. Can we name it as "100BTX" instead
of Tx? Thanks.


