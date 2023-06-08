Return-Path: <netdev+bounces-9165-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CAFB7727ACD
	for <lists+netdev@lfdr.de>; Thu,  8 Jun 2023 11:05:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4E511281654
	for <lists+netdev@lfdr.de>; Thu,  8 Jun 2023 09:05:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C73D99470;
	Thu,  8 Jun 2023 09:05:49 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAF8B3B3FA
	for <netdev@vger.kernel.org>; Thu,  8 Jun 2023 09:05:49 +0000 (UTC)
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A344D1BF0;
	Thu,  8 Jun 2023 02:05:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1686215147; x=1717751147;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=yf4CcN2E3OFNl2sqMvdX0I8YC7KPN8Kso0doViaOOUo=;
  b=WbPpCHxU2+kKgoQsV5hLKmQvyq3SEOCastaVjbN6TeT4Co1r3KKpBkPE
   RBfHh8vh0CidD+h6oGUE6DXwUVzESEOZrnJ039Vue7BSgae+rUlFhr8ym
   YMp8O9tkxXugOXrCfinW9Rw0RMsxnern61bTtzO0IGvAbdNjdGfkEYwkj
   4TerhDTSVmPHy7/78qcGaw9nrYZ8gpQOfQRRIGFzLQlY5Eu3r66PHFjti
   cY0PiYFMZ2gU+R3uT/ZuHcvPx2uEEv6Ww6TYPCe7KQf7GJ7Xbo95RXndS
   0xZSWfBqsGxnt/ZTqKNjuBn/Pl6Pwxj8mwc5qTedqp5lVtdUPRuvAKgg0
   g==;
X-IronPort-AV: E=Sophos;i="6.00,226,1681196400"; 
   d="scan'208";a="219393888"
X-Amp-Result: SKIPPED(no attachment in message)
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 08 Jun 2023 02:05:42 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Thu, 8 Jun 2023 02:05:42 -0700
Received: from localhost (10.10.115.15) by chn-vm-ex04.mchp-main.com
 (10.10.85.152) with Microsoft SMTP Server id 15.1.2507.21 via Frontend
 Transport; Thu, 8 Jun 2023 02:05:42 -0700
Date: Thu, 8 Jun 2023 11:05:41 +0200
From: Horatiu Vultur <horatiu.vultur@microchip.com>
To: Richard Cochran <richardcochran@gmail.com>
CC: <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<andrew@lunn.ch>, <hkallweit1@gmail.com>, <linux@armlinux.org.uk>,
	<davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
	<pabeni@redhat.com>
Subject: Re: [PATCH net-next] net: micrel: Change to receive timestamp in the
 frame for lan8841
Message-ID: <20230608090541.23ldnmzr5r56bgf7@soft-dev3-1>
References: <20230607070948.1746768-1-horatiu.vultur@microchip.com>
 <ZIDCpPbCFCxKBV2k@hoboy.vegasvil.org>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <ZIDCpPbCFCxKBV2k@hoboy.vegasvil.org>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Hi Richard,

The 06/07/2023 10:47, Richard Cochran wrote:
> 
> On Wed, Jun 07, 2023 at 09:09:48AM +0200, Horatiu Vultur wrote:
> 
> > Doing these changes to start to get the received timestamp in the
> > reserved field of the header, will give a great CPU usage performance.
> > Running ptp4l with logSyncInterval of -9 will give a ~50% CPU
> > improvment.
> 
> Really?

I have run a simple top on the PC while running ptp4l.

This is the output without this patch:
  PID  PPID USER     STAT   VSZ %VSZ %CPU COMMAND
  136     2 root     DW       0   0%  58% [irq/33-e2004118]
  141   133 root     R     2232   0%  23% ptp4l -f /tmp/linux.cfg

And this is the output with the patch:
  142   134 root     S     2232   0%  15% ptp4l -f /tmp/linux.cfg
   36     2 root     DW       0   0%  15% [ptp0]
  137     2 root     SW       0   0%   0% [irq/33-e2004118]

If you think I should do better measurements, I am open to suggestions.

> 
> > -static struct lan8814_ptp_rx_ts *lan8841_ptp_get_rx_ts(struct kszphy_ptp_priv *ptp_priv)
> > -{
> > -     struct phy_device *phydev = ptp_priv->phydev;
> > -     struct lan8814_ptp_rx_ts *rx_ts;
> > -     u32 sec, nsec;
> > -     u16 seq;
> > -
> > -     nsec = phy_read_mmd(phydev, 2, LAN8841_PTP_RX_INGRESS_NS_HI);
> > -     if (!(nsec & LAN8841_PTP_RX_INGRESS_NSEC_HI_VALID))
> > -             return NULL;
> > -
> > -     nsec = ((nsec & 0x3fff) << 16);
> > -     nsec = nsec | phy_read_mmd(phydev, 2, LAN8841_PTP_RX_INGRESS_NS_LO);
> > -
> > -     sec = phy_read_mmd(phydev, 2, LAN8841_PTP_RX_INGRESS_SEC_HI);
> > -     sec = sec << 16;
> > -     sec = sec | phy_read_mmd(phydev, 2, LAN8841_PTP_RX_INGRESS_SEC_LO);
> > -
> > -     seq = phy_read_mmd(phydev, 2, LAN8841_PTP_RX_MSG_HEADER2);
> 
> Before: 5x phy_read_mmd() per frame ...
> 
> > -     rx_ts = kzalloc(sizeof(*rx_ts), GFP_KERNEL);
> > -     if (!rx_ts)
> > -             return NULL;
> > -
> > -     rx_ts->seconds = sec;
> > -     rx_ts->nsec = nsec;
> > -     rx_ts->seq_id = seq;
> > -
> > -     return rx_ts;
> > -}
> 
> > +static void lan8841_ptp_getseconds(struct ptp_clock_info *ptp,
> > +                                struct timespec64 *ts)
> > +{
> > +     struct kszphy_ptp_priv *ptp_priv = container_of(ptp, struct kszphy_ptp_priv,
> > +                                                     ptp_clock_info);
> > +     struct phy_device *phydev = ptp_priv->phydev;
> > +     time64_t s;
> > +
> > +     mutex_lock(&ptp_priv->ptp_lock);
> > +     /* Issue the command to read the LTC */
> > +     phy_write_mmd(phydev, 2, LAN8841_PTP_CMD_CTL,
> > +                   LAN8841_PTP_CMD_CTL_PTP_LTC_READ);
> > +
> > +     /* Read the LTC */
> > +     s = phy_read_mmd(phydev, 2, LAN8841_PTP_LTC_RD_SEC_HI);
> > +     s <<= 16;
> > +     s |= phy_read_mmd(phydev, 2, LAN8841_PTP_LTC_RD_SEC_MID);
> > +     s <<= 16;
> > +     s |= phy_read_mmd(phydev, 2, LAN8841_PTP_LTC_RD_SEC_LO);
> 
> After: 4x phy_read_mmd() per frame.  How does that save 50% cpu?
> 
> > +     mutex_unlock(&ptp_priv->ptp_lock);
> > +
> > +     set_normalized_timespec64(ts, s, 0);
> > +}
> 
> 
> > +static long lan8841_ptp_do_aux_work(struct ptp_clock_info *ptp)
> > +{
> > +     struct kszphy_ptp_priv *ptp_priv = container_of(ptp, struct kszphy_ptp_priv,
> > +                                                     ptp_clock_info);
> > +     struct skb_shared_hwtstamps *shhwtstamps;
> > +     struct timespec64 ts;
> > +     struct sk_buff *skb;
> > +     u32 ts_header;
> > +
> > +     while ((skb = skb_dequeue(&ptp_priv->rx_queue)) != NULL) {
> > +             lan8841_ptp_getseconds(ptp, &ts);
> 
> No need to call this once per frame.  It would be sufficent to call it
> once every 2 seconds and cache the result.
> 
> > +             ts_header = __be32_to_cpu(LAN8841_SKB_CB(skb)->header->reserved2);
> > +
> > +             shhwtstamps = skb_hwtstamps(skb);
> > +             memset(shhwtstamps, 0, sizeof(*shhwtstamps));
> > +
> > +             /* Check for any wrap arounds for the second part */
> > +             if ((ts.tv_sec & GENMASK(1, 0)) < ts_header >> 30)
> > +                     ts.tv_sec -= GENMASK(1, 0) + 1;
> > +
> > +             shhwtstamps->hwtstamp =
> > +                     ktime_set((ts.tv_sec & ~(GENMASK(1, 0))) | ts_header >> 30,
> > +                               ts_header & GENMASK(29, 0));
> > +             LAN8841_SKB_CB(skb)->header->reserved2 = 0;
> > +
> > +             netif_rx(skb);
> > +     }
> > +
> > +     return -1;
> > +}
> 
> Thanks,
> Richard

-- 
/Horatiu

