Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B12DE2533E6
	for <lists+netdev@lfdr.de>; Wed, 26 Aug 2020 17:43:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727992AbgHZPm7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Aug 2020 11:42:59 -0400
Received: from mga17.intel.com ([192.55.52.151]:40712 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727807AbgHZPm6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 26 Aug 2020 11:42:58 -0400
IronPort-SDR: okkZAJpvIlZUeL0I5Xua4eMmQyvlrVBvEoJKFZwaB/I67DZs4Drvzq8VTqTLQzDBlj491OuyN7
 pXaPSjU/fiUg==
X-IronPort-AV: E=McAfee;i="6000,8403,9725"; a="136379103"
X-IronPort-AV: E=Sophos;i="5.76,356,1592895600"; 
   d="scan'208";a="136379103"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Aug 2020 08:42:54 -0700
IronPort-SDR: LD8RtHzeJvZ2OBtbBg48mglSJ2vTl8cHqDXHd+zFo6oo56VUfPVIIbdim3P82Cda0AAMSQBAn5
 yFUBFfUZNuuA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.76,356,1592895600"; 
   d="scan'208";a="373417047"
Received: from ranger.igk.intel.com ([10.102.21.164])
  by orsmga001.jf.intel.com with ESMTP; 26 Aug 2020 08:42:50 -0700
Date:   Wed, 26 Aug 2020 17:36:35 +0200
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     "Jubran, Samih" <sameehj@amazon.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Woodhouse, David" <dwmw@amazon.co.uk>,
        "Machulsky, Zorik" <zorik@amazon.com>,
        "Matushevsky, Alexander" <matua@amazon.com>,
        "Bshara, Saeed" <saeedb@amazon.com>,
        "Wilson, Matt" <msw@amazon.com>,
        "Liguori, Anthony" <aliguori@amazon.com>,
        "Bshara, Nafea" <nafea@amazon.com>,
        "Tzalik, Guy" <gtzalik@amazon.com>,
        "Belgazal, Netanel" <netanel@amazon.com>,
        "Saidi, Ali" <alisaidi@amazon.com>,
        "Herrenschmidt, Benjamin" <benh@amazon.com>,
        "Kiyanovski, Arthur" <akiyano@amazon.com>,
        "Dagan, Noam" <ndagan@amazon.com>
Subject: Re: [PATCH V2 net-next 1/4] net: ena: ethtool: use unsigned long for
 pointer arithmetics
Message-ID: <20200826153635.GA51212@ranger.igk.intel.com>
References: <20200819134349.22129-1-sameehj@amazon.com>
 <20200819134349.22129-2-sameehj@amazon.com>
 <20200819141716.GE2403519@lunn.ch>
 <91c86d46b724411d9f788396816be30d@EX13D11EUB002.ant.amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <91c86d46b724411d9f788396816be30d@EX13D11EUB002.ant.amazon.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 20, 2020 at 12:13:15PM +0000, Jubran, Samih wrote:
> 
> 
> > -----Original Message-----
> > From: Andrew Lunn <andrew@lunn.ch>
> > Sent: Wednesday, August 19, 2020 5:17 PM
> > To: Jubran, Samih <sameehj@amazon.com>
> > Cc: davem@davemloft.net; netdev@vger.kernel.org; Woodhouse, David
> > <dwmw@amazon.co.uk>; Machulsky, Zorik <zorik@amazon.com>;
> > Matushevsky, Alexander <matua@amazon.com>; Bshara, Saeed
> > <saeedb@amazon.com>; Wilson, Matt <msw@amazon.com>; Liguori,
> > Anthony <aliguori@amazon.com>; Bshara, Nafea <nafea@amazon.com>;
> > Tzalik, Guy <gtzalik@amazon.com>; Belgazal, Netanel
> > <netanel@amazon.com>; Saidi, Ali <alisaidi@amazon.com>; Herrenschmidt,
> > Benjamin <benh@amazon.com>; Kiyanovski, Arthur
> > <akiyano@amazon.com>; Dagan, Noam <ndagan@amazon.com>
> > Subject: RE: [EXTERNAL] [PATCH V2 net-next 1/4] net: ena: ethtool: use
> > unsigned long for pointer arithmetics
> > 
> > CAUTION: This email originated from outside of the organization. Do not click
> > links or open attachments unless you can confirm the sender and know the
> > content is safe.
> > 
> > 
> > 
> > On Wed, Aug 19, 2020 at 01:43:46PM +0000, sameehj@amazon.com wrote:
> > > From: Sameeh Jubran <sameehj@amazon.com>
> > >
> > > unsigned long is the type for doing maths on pointers.
> > 
> > Maths on pointers is perfectly valid. The real issue here is you have all your
> > types mixed up.
> 
> The stat_offset field has the bytes from the start of the struct, the math is perfectly valid IMO¸
> I have also went for the extra step and tested it using prints.
> 
> > 
> > > -                     ptr = (u64 *)((uintptr_t)&ring->tx_stats +
> > > -                             (uintptr_t)ena_stats->stat_offset);
> > > +                     ptr = (u64 *)((unsigned long)&ring->tx_stats +
> > > +                             ena_stats->stat_offset);
> > 
> > struct ena_ring {
> > ...
> >         union {
> >                 struct ena_stats_tx tx_stats;
> >                 struct ena_stats_rx rx_stats;
> >         };
> > 
> > struct ena_stats_tx {
> >         u64 cnt;
> >         u64 bytes;
> >         u64 queue_stop;
> >         u64 prepare_ctx_err;
> >         u64 queue_wakeup;
> >         ...
> > }
> > 
> > &ring->tx_stats will give you a struct *ena_stats_tx. Arithmetic on that,
> > adding 1 for example, takes you forward a full ena_stats_tx structure. Not
> > what you want.
> > 
> > &ring->tx_stats.cnt however, will give you a u64 *. Adding 1 to that will give
> > you bytes, etc.
> 
> 
> If I understand you well, the alternative approach you are suggesting is:
> 
> ptr = &ring->tx_stats.cnt + ena_stats->stat_offset;

I don't want to stir up the pot, but do you really need the offsetof() of
each member in the stats struct? Couldn't you piggyback on assumption that
these stats need to be u64 and just walk the struct with pointer?

	struct ena_ring *ring;
	int offset;
	int i, j;
	u8 *ptr;

	for (i = 0; i < adapter->num_io_queues; i++) {
		/* Tx stats */
		ring = &adapter->tx_ring[i];
		ptr = (u8 *)&ring->tx_stats;

		for (j = 0; j < ENA_STATS_ARRAY_TX; j++) {
			ena_safe_update_stat((u64 *)ptr, (*data)++, &ring->syncp);
			ptr += sizeof(u64);
		}
	}

I find this as a simpler and lighter solution. There might be issues with
code typed in email client, but you get the idea.

> 
> of course we need to convert the stat_offset field to be in 8 bytes resolution instead.
> 
> This approach has a potential bug hidden in it. If in the future
> someone decides to expand the "ena_stats_tx" struct and add a field preceding cnt,
> cnt will no longer be the beginning of the struct, which will cause a bug."
> 
> Therefore, if you have another way to do this, please share it. Otherwise I'd
> rather leave this code as it is for the sake of robustness.
> 
> > 
> >      Andrew
