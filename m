Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B9B5C4A6CD9
	for <lists+netdev@lfdr.de>; Wed,  2 Feb 2022 09:23:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244838AbiBBIXg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Feb 2022 03:23:36 -0500
Received: from esa.microchip.iphmx.com ([68.232.154.123]:59809 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232819AbiBBIXf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Feb 2022 03:23:35 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1643790215; x=1675326215;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=hUxXJB/MFTpDGZzjslWTKCHu/RO2F8xgwXTvG5hiDj4=;
  b=HvJqKCcQvJFDMJHkwPWwbWFu7GK23QK7te5/e+xbJmoLTNLNrXwpKzX4
   lSyXpXTqSG4htt+9MUdRL1pVi3Gy5JDmcJodJ6lP5dw2igDcZ0KG+6vc1
   hh1dhYRkZy2e9YZZ2pTcCwsmh65GdjXvjRLeOo+b5aJdk+T/+7HgHDXQp
   6ZNqSq44kgf0JIyMMeNS34UBx3XALNnJqr3dTs5EYUHJVXzt4/QVU9uC6
   e8k3xx8/TYREpqBRazoB4wx9DYMv++89hUtWwczvzagwU/sxJbPUuNRm5
   4QamBpvWN/xvFPsqOCu/sqpmubjfEEc3W/JSTxQ3+tWS1iQEFy9BNydsZ
   g==;
IronPort-SDR: YyVtIIfwXMOfwXScxh+92rh6NGLKeAwx3vCMJtkaXPhZ4+hOY6P6Dlkyf0DifaJ9wB2GTrtpsl
 3YGJCvtIyjYpkKzkR2OCR9qdeGvV/dqsvvNbJILhTOdhRqMX/ONDPzvlXCYaLhoUZNTcZmfHTL
 0pw7Ib93YckHt2pgxrKWQ0Xfky5vwGfFRRUXKB2UMa4It6+frbUVvcZDvgjTl+cHXAAiVWveK0
 CLBnf28UwPHmCiwl5ofovNtMo5B8b5SYJ35iaxNwJgaz6hZyUlsPAvyeq7UImqQnbAKeT+QmnE
 3mpqEKrC31c59hco0fgGl/4z
X-IronPort-AV: E=Sophos;i="5.88,336,1635231600"; 
   d="scan'208";a="84412676"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 02 Feb 2022 01:23:34 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Wed, 2 Feb 2022 01:23:34 -0700
Received: from den-dk-m31857.microchip.com (10.10.115.15) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server id
 15.1.2375.17 via Frontend Transport; Wed, 2 Feb 2022 01:23:32 -0700
Message-ID: <d55ed1f583c31df17e98300ca91996a2446f4523.camel@microchip.com>
Subject: Re: [PATCH net] net: sparx5: do not refer to skb after passing it on
From:   Steen Hegelund <steen.hegelund@microchip.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     "David S. Miller" <davem@davemloft.net>,
        <UNGLinuxDriver@microchip.com>, <netdev@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        kernel test robot <lkp@intel.com>
Date:   Wed, 2 Feb 2022 09:23:00 +0100
In-Reply-To: <20220201200521.179857d7@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <20220201143057.3533830-1-steen.hegelund@microchip.com>
         <20220201200521.179857d7@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.3 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jacub,

Thanks for the feedback.

I will update according to your suggestions.

BR
Steen

On Tue, 2022-02-01 at 20:05 -0800, Jakub Kicinski wrote:
> EXTERNAL EMAIL: Do not click links or open attachments unless you know the content is safe
> 
> On Tue, 1 Feb 2022 15:30:57 +0100 Steen Hegelund wrote:
> > Do not try to use any SKB fields after the packet has been passed up in the
> > receive stack.
> > 
> > This error was reported as shown below:
> 
> No need to spell it out, the tags speak for themselves.
> 
> > Reported-by: kernel test robot <lkp@intel.com>
> > Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
> > 
> 
> Drop this...
> 
> > Fixes: f3cad2611a77 (net: sparx5: add hostmode with phylink support)
> > 
> 
> and this empty line - all the tags should be together.
> 
> > Signed-off-by: Steen Hegelund <steen.hegelund@microchip.com>
> > ---
> >  drivers/net/ethernet/microchip/sparx5/sparx5_packet.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_packet.c
> > b/drivers/net/ethernet/microchip/sparx5/sparx5_packet.c
> > index dc7e5ea6ec15..ebdce4b35686 100644
> > --- a/drivers/net/ethernet/microchip/sparx5/sparx5_packet.c
> > +++ b/drivers/net/ethernet/microchip/sparx5/sparx5_packet.c
> > @@ -145,8 +145,8 @@ static void sparx5_xtr_grp(struct sparx5 *sparx5, u8 grp, bool byte_swap)
> >       skb_put(skb, byte_cnt - ETH_FCS_LEN);
> >       eth_skb_pad(skb);
> >       skb->protocol = eth_type_trans(skb, netdev);
> > -     netif_rx(skb);
> >       netdev->stats.rx_bytes += skb->len;
> > +     netif_rx(skb);
> >       netdev->stats.rx_packets++;
> 
> sorry to nit pick - wouldn't it be neater if both the stats were
> updated together?  Looks a little strange that netif_rx() is in
> between the two now.
> 
> >  }
> > 
> > --
> > 2.35.1
> > 
> 

