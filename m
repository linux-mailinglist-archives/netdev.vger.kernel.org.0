Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2BF4D60B21B
	for <lists+netdev@lfdr.de>; Mon, 24 Oct 2022 18:43:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234666AbiJXQmi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Oct 2022 12:42:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231881AbiJXQlr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Oct 2022 12:41:47 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9AC080EA5;
        Mon, 24 Oct 2022 08:28:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:
        Content-Transfer-Encoding:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Reply-To:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=BrxfrDUbPsUFpThWqA9RSxt3bESyLFU8TgRiCKoKos4=; b=hUFyDn4iEM2Umosu5AGmbJVVWt
        Gd8sS4dlaaccEMpfxIA+FTJfDLsCW3BaDAKG3WhFItnfHCxaubrTdZcHF8xD8CMyGl3OmKYss13IE
        cf7PvX1v+ed7wIBYbKJjEjVdhn9MaeL34ZUWWMpOrhVUUo9bZHo4GVCsmH33ynRef9Y1jXHk6l4fg
        G8iouAdGGN7jn0NThsBLmMWXfD+Xc0Zq7a7DnyNRFXx9xAcR78IQiUioEthdkXoKBCJEAQ2fpzM3Y
        CHABnGcBjLNwmN00otsMN4Yv0UHBCNvxhe1dp3ZPOwFbs7nuc1SQJMrsZ+/bVPXsQK4n67mIGfEfg
        ncRzNHSA==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:34932)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1omysw-0003Fd-7H; Mon, 24 Oct 2022 15:57:02 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1omysk-0007DB-GY; Mon, 24 Oct 2022 15:56:50 +0100
Date:   Mon, 24 Oct 2022 15:56:50 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Frank Wunderlich <frank-w@public-files.de>
Cc:     Frank Wunderlich <linux@fw-web.de>,
        linux-mediatek@lists.infradead.org,
        Alexander Couzens <lynxis@fe80.eu>,
        Felix Fietkau <nbd@nbd.name>, John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: Re: Re: Re: [PATCH v2] net: mtk_sgmii: implement mtk_pcs_ops
Message-ID: <Y1ansgmD69AcITWx@shell.armlinux.org.uk>
References: <Y1UMrvk2A9aAcjo5@shell.armlinux.org.uk>
 <trinity-5350c2bc-473d-408f-a25a-16b34bbfcba7-1666537529990@3c-app-gmx-bs01>
 <Y1Vh5U96W2u/GCnx@shell.armlinux.org.uk>
 <trinity-1d4cc306-d1a4-4ccf-b853-d315553515ce-1666543305596@3c-app-gmx-bs01>
 <Y1V/asUompZKj0ct@shell.armlinux.org.uk>
 <trinity-ac9a840b-cb06-4710-827a-4c4423686074-1666551838763@3c-app-gmx-bs01>
 <trinity-169e3c3f-3a64-485c-9a43-b7cc595531a9-1666552897046@3c-app-gmx-bs01>
 <Y1Wfc+M/zVdw9Di3@shell.armlinux.org.uk>
 <Y1Zah4+hyFk50JC6@shell.armlinux.org.uk>
 <trinity-d2f74581-c020-4473-a5f4-0fc591233293-1666622740261@3c-app-gmx-bap55>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <trinity-d2f74581-c020-4473-a5f4-0fc591233293-1666622740261@3c-app-gmx-bap55>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 24, 2022 at 04:45:40PM +0200, Frank Wunderlich wrote:
> Hi
> > Gesendet: Montag, 24. Oktober 2022 um 11:27 Uhr
> > Von: "Russell King (Oracle)" <linux@armlinux.org.uk>
> 
> > Here's the combined patch for where I would like mtk_sgmii to get to.
> >
> > It looks like this PCS is similar to what we know as pcs-lynx.c, but
> > there do seem to be differences - the duplex bit for example appears
> > to be inverted.
> >
> > Please confirm whether this still works for you, thanks.
> 
> basicly Patch works, but i get some (1-50) retransmitts on iperf3 on first interval in tx-mode (on r3 without -R), other 9 are clean. reverse mode is mostly clean.
> run iperf3 multiple times, every first interval has retransmitts. same for gmac0 (fixed-link 2500baseX)
> 
> i notice that you have changed the timer again to 10000000 for 1000/2500baseX...maybe use here the default value too like the older code does?

You obviously missed my explanation. I will instead quote the 802.3
standard which covers 1000base-X:

37.3.1.4 Timers

 link_timer
          Timer used to ensure Auto-Negotiation protocol stability and
	  register read/write by the management interface.

	  Duration: 10 ms, tolerance +10 ms, –0 s.

For SGMII, the situation is different. Here is what the SGMII
specification says:

  The link_timer inside the Auto-Negotiation has been changed from 10
  msec to 1.6 msec to ensure a prompt update of the link status.

So, 10ms is correct for 1000base-X, and 1.6ms correct for SGMII.

However, feel free to check whether changing it solves that issue, but
also check whether it could be some ARP related issue - remember, if
two endpoints haven't communicated, they need to ARP to get the other
end's ethernet addresses which adds extra latency, and may result in
some packet loss in high packet queuing rate situations.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
