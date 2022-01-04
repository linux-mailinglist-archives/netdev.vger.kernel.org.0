Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 50ED54842A1
	for <lists+netdev@lfdr.de>; Tue,  4 Jan 2022 14:38:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233753AbiADNit (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jan 2022 08:38:49 -0500
Received: from esa.microchip.iphmx.com ([68.232.153.233]:13976 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233727AbiADNip (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Jan 2022 08:38:45 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1641303525; x=1672839525;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=4tBpU8p77NKBam0vR6+WDIcpEDcMU61Ea9OWWZfa6Zw=;
  b=DbXUQInJfwoiDB9sUk9gfHQ0pKUg9InlRf3+nPr/vywC9x1NbLJ48fD5
   6UM3s0oHz2x08WN/c8FKiKEFJuKBUyOhUL6Z++fl7bhTUfNgsYbRLSiTM
   Gi2+49ZGn07IWPKcmz0zYPHuRAlyRfplKicGXVfQdW5p4BVPBwrBdvp1N
   3LRyOrtI/gQ894l9IVHy+dxHiqMkXPjNHDpRiLW6to1QGQgd1LokxR3Am
   ah3e568U9tbixn4oDkkISMWrh+HAx/SVs698hD7TPgSSMOWAb6OHNE1TV
   H4Wxl+VmxGUsCqGsJG1o64dqxUVypVpzmQJJf2qG9fu/jLnHaT8T9iB53
   Q==;
IronPort-SDR: 9j6vy0oJdhtisLYaaSDLtN4+C7TQKOk7JqZD0UC8NlQfC0FqZlb80ARpx+XpR+QeeWq7W5TJpm
 YhA49sxwljhZo2isU+5wsV9yG0MGmqmbODXAg8OHJv1wkHGFV6FtSvMFhy1QPrugRfZOPcuTJa
 whdHlYzwlOCR+p+CdApHz+8Kt0uY89GDS6frmCZIoHo0Jzk5zZyClgdlNsRSs2SYeHD18YkA7M
 w9QhGzlwmOkGqBSnO6gfh+HdaAWN/+q2gmYQHetEg8ev4lntKQ5GWD2yPG3A0dEpxoVCRAN9po
 6XNQ/sGpADLRGCl8OlxS3nTq
X-IronPort-AV: E=Sophos;i="5.88,261,1635231600"; 
   d="scan'208";a="157456816"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 04 Jan 2022 06:38:44 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Tue, 4 Jan 2022 06:38:44 -0700
Received: from localhost (10.10.115.15) by chn-vm-ex02.mchp-main.com
 (10.10.85.144) with Microsoft SMTP Server id 15.1.2375.17 via Frontend
 Transport; Tue, 4 Jan 2022 06:38:44 -0700
Date:   Tue, 4 Jan 2022 14:40:57 +0100
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "vivien.didelot@gmail.com" <vivien.didelot@gmail.com>,
        "andrew@lunn.ch" <andrew@lunn.ch>
Subject: Re: [PATCH net-next v2 1/3] net: lan966x: Add function
 lan966x_mac_ip_learn()
Message-ID: <20220104134057.wj3wxba2glnz5k74@soft-dev3-1.localhost>
References: <20220104101849.229195-1-horatiu.vultur@microchip.com>
 <20220104101849.229195-2-horatiu.vultur@microchip.com>
 <20220104111710.twaqos2fbmjfv5yu@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <20220104111710.twaqos2fbmjfv5yu@skbuf>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The 01/04/2022 11:17, Vladimir Oltean wrote:
> 
> On Tue, Jan 04, 2022 at 11:18:47AM +0100, Horatiu Vultur wrote:
> > Extend mac functionality with the function lan966x_mac_ip_learn. This
> > function adds an entry in the MAC table for IP multicast addresses.
> > These entries can copy a frame to the CPU but also can forward on the
> > front ports.
> > This functionality is needed for mdb support. In case the CPU and some
> > of the front ports subscribe to an IP multicast address.
> >
> > Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
> > ---
> >  .../ethernet/microchip/lan966x/lan966x_mac.c  | 33 ++++++++++++++++---
> >  .../ethernet/microchip/lan966x/lan966x_main.h |  5 +++
> >  .../ethernet/microchip/lan966x/lan966x_regs.h |  6 ++++
> >  3 files changed, 39 insertions(+), 5 deletions(-)
> >
> > diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_mac.c b/drivers/net/ethernet/microchip/lan966x/lan966x_mac.c
> > index efadb8d326cc..82eb6606e17f 100644
> > --- a/drivers/net/ethernet/microchip/lan966x/lan966x_mac.c
> > +++ b/drivers/net/ethernet/microchip/lan966x/lan966x_mac.c
> > @@ -68,17 +68,19 @@ static void lan966x_mac_select(struct lan966x *lan966x,
> >       lan_wr(mach, lan966x, ANA_MACHDATA);
> >  }
> >
> > -int lan966x_mac_learn(struct lan966x *lan966x, int port,
> > -                   const unsigned char mac[ETH_ALEN],
> > -                   unsigned int vid,
> > -                   enum macaccess_entry_type type)
> > +static int __lan966x_mac_learn(struct lan966x *lan966x, int pgid,
> > +                            bool cpu_copy,
> > +                            const unsigned char mac[ETH_ALEN],
> > +                            unsigned int vid,
> > +                            enum macaccess_entry_type type)
> >  {
> >       lan966x_mac_select(lan966x, mac, vid);
> >
> >       /* Issue a write command */
> >       lan_wr(ANA_MACACCESS_VALID_SET(1) |
> >              ANA_MACACCESS_CHANGE2SW_SET(0) |
> > -            ANA_MACACCESS_DEST_IDX_SET(port) |
> > +            ANA_MACACCESS_MAC_CPU_COPY_SET(cpu_copy) |
> > +            ANA_MACACCESS_DEST_IDX_SET(pgid) |
> >              ANA_MACACCESS_ENTRYTYPE_SET(type) |
> >              ANA_MACACCESS_MAC_TABLE_CMD_SET(MACACCESS_CMD_LEARN),
> >              lan966x, ANA_MACACCESS);
> > @@ -86,6 +88,27 @@ int lan966x_mac_learn(struct lan966x *lan966x, int port,
> >       return lan966x_mac_wait_for_completion(lan966x);
> >  }
> >
> > +int lan966x_mac_ip_learn(struct lan966x *lan966x,
> > +                      bool cpu_copy,
> > +                      const unsigned char mac[ETH_ALEN],
> > +                      unsigned int vid,
> > +                      enum macaccess_entry_type type)
> 
> I think it's worth mentioning in a comment above this function that the
> mask of front ports should be encoded into the address by now, via a
> call to lan966x_mdb_encode_mac().

Yes, I will do that.

> 
> > +{
> > +     WARN_ON(type != ENTRYTYPE_MACV4 && type != ENTRYTYPE_MACV6);
> > +
> > +     return __lan966x_mac_learn(lan966x, 0, cpu_copy, mac, vid, type);
> > +}
> > +
> > +int lan966x_mac_learn(struct lan966x *lan966x, int port,
> > +                   const unsigned char mac[ETH_ALEN],
> > +                   unsigned int vid,
> > +                   enum macaccess_entry_type type)
> > +{
> > +     WARN_ON(type != ENTRYTYPE_NORMAL && type != ENTRYTYPE_LOCKED);
> > +
> > +     return __lan966x_mac_learn(lan966x, port, false, mac, vid, type);
> > +}
> > +
> >  int lan966x_mac_forget(struct lan966x *lan966x,
> >                      const unsigned char mac[ETH_ALEN],
> >                      unsigned int vid,
> > diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_main.h b/drivers/net/ethernet/microchip/lan966x/lan966x_main.h
> > index c399b1256edc..f70e54526f53 100644
> > --- a/drivers/net/ethernet/microchip/lan966x/lan966x_main.h
> > +++ b/drivers/net/ethernet/microchip/lan966x/lan966x_main.h
> > @@ -157,6 +157,11 @@ int lan966x_port_pcs_set(struct lan966x_port *port,
> >                        struct lan966x_port_config *config);
> >  void lan966x_port_init(struct lan966x_port *port);
> >
> > +int lan966x_mac_ip_learn(struct lan966x *lan966x,
> > +                      bool cpu_copy,
> > +                      const unsigned char mac[ETH_ALEN],
> > +                      unsigned int vid,
> > +                      enum macaccess_entry_type type);
> >  int lan966x_mac_learn(struct lan966x *lan966x, int port,
> >                     const unsigned char mac[ETH_ALEN],
> >                     unsigned int vid,
> > diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_regs.h b/drivers/net/ethernet/microchip/lan966x/lan966x_regs.h
> > index a13c469e139a..797560172aca 100644
> > --- a/drivers/net/ethernet/microchip/lan966x/lan966x_regs.h
> > +++ b/drivers/net/ethernet/microchip/lan966x/lan966x_regs.h
> > @@ -169,6 +169,12 @@ enum lan966x_target {
> >  #define ANA_MACACCESS_CHANGE2SW_GET(x)\
> >       FIELD_GET(ANA_MACACCESS_CHANGE2SW, x)
> >
> > +#define ANA_MACACCESS_MAC_CPU_COPY               BIT(16)
> > +#define ANA_MACACCESS_MAC_CPU_COPY_SET(x)\
> > +     FIELD_PREP(ANA_MACACCESS_MAC_CPU_COPY, x)
> > +#define ANA_MACACCESS_MAC_CPU_COPY_GET(x)\
> > +     FIELD_GET(ANA_MACACCESS_MAC_CPU_COPY, x)
> 
> Could you please add a space between (x) and \.

Actually I prefer for now not to do that.
The reason is that in the entire file there is no space between (x) and
\.
What I can do is when I will add another feature that requires more
registes then I can change the entire file to have that space if it is
worth it.

> 
> > +
> >  #define ANA_MACACCESS_VALID                      BIT(12)
> >  #define ANA_MACACCESS_VALID_SET(x)\
> >       FIELD_PREP(ANA_MACACCESS_VALID, x)
> > --
> > 2.33.0
> >

-- 
/Horatiu
