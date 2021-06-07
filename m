Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 842A539E008
	for <lists+netdev@lfdr.de>; Mon,  7 Jun 2021 17:14:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230331AbhFGPQB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Jun 2021 11:16:01 -0400
Received: from esa.microchip.iphmx.com ([68.232.153.233]:10421 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230217AbhFGPQB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Jun 2021 11:16:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1623078851; x=1654614851;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=q8+rgy0vGdMzTpiBtaX39mKJCCp8xkoYwC+MRbRFD/o=;
  b=hl/QFfV8vNebBMNWthwXqrp3VFXH0UbxHssaQPSgKeys/Sv2ZR9kI22j
   qWLyIta6gdG46uxu82fy8cQJEzqgJ+fT+RcRQZM2jpnhI2W35jRdy7XYp
   MlH9fclrpM5MZEvFgXxVIAV0VB7sohIsgd5iZeJHPSTJTbuMRJi0IUODP
   E3eRtCtlkB9nmfZaDzUW01xu4H7xORytTIO7J/DBvu/5RK4eG3HfTfhFG
   gct1do6CBIXsE6imQSR7xTaizvHq5f5NmURiqSM51GDBPmy+GfMYzX5jR
   4jwSmcX/obCPIMsckXdpT3ztrXN4N+lqqhs1MR5vaK9GpkXLF/nNWC6M9
   g==;
IronPort-SDR: Q0EAM9Z89WgxgeLhBYqnldf4//d6JHDNCNbyXjyNZT1895VA+ZlFcbCrMLfxyjo2kxyDCr6bjF
 1bbRi0/y866wD+sG0GMaVflaBL0zJoCp7W5gdjkWZXnzwcn3DcBt7FF4coFRQ45ZDSXjNJYb7C
 /gF8KgzAaNckyJqb4pjjTXTHjw2aVv+3vZKLreAPd20E4klIFCJc0vt+9U1vrYVNYGSJrpU6i/
 qDpn89otFAaF6G4mDEG0ga1xjTK4X2VQ9jcLRmJEOPTY0LArLwpFFiq3mC6T3N4gs9XbuBY2jJ
 kqU=
X-IronPort-AV: E=Sophos;i="5.83,255,1616482800"; 
   d="scan'208";a="123799459"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 07 Jun 2021 08:14:10 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Mon, 7 Jun 2021 08:14:09 -0700
Received: from den-her-m31857h.microchip.com (10.10.115.15) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server id
 15.1.2176.2 via Frontend Transport; Mon, 7 Jun 2021 08:14:05 -0700
Message-ID: <3577c361b26e8d70c8bf6dad4029060985f75d3d.camel@microchip.com>
Subject: Re: [PATCH net-next v3 04/10] net: sparx5: add port module support
From:   Steen Hegelund <steen.hegelund@microchip.com>
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
CC:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Madalin Bucur <madalin.bucur@oss.nxp.com>,
        Mark Einon <mark.einon@gmail.com>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        "Simon Horman" <simon.horman@netronome.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        Bjarni Jonasson <bjarni.jonasson@microchip.com>,
        Lars Povlsen <lars.povlsen@microchip.com>
Date:   Mon, 7 Jun 2021 17:14:04 +0200
In-Reply-To: <20210607131231.GF22278@shell.armlinux.org.uk>
References: <20210604085600.3014532-1-steen.hegelund@microchip.com>
         <20210604085600.3014532-5-steen.hegelund@microchip.com>
         <20210607092136.GA22278@shell.armlinux.org.uk>
         <d5ffe24ce7fbe5dd4cc0b98449b0594b086e3ba9.camel@microchip.com>
         <20210607131231.GF22278@shell.armlinux.org.uk>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Russell,

Thanks for your comments,

On Mon, 2021-06-07 at 14:12 +0100, Russell King (Oracle) wrote:
> EXTERNAL EMAIL: Do not click links or open attachments unless you know the content is safe
> 
> Hi,
> 
> On Mon, Jun 07, 2021 at 02:46:44PM +0200, Steen Hegelund wrote:
> > Hi Russell,
> > 
> > Thanks for your comments.
> > 
> > On Mon, 2021-06-07 at 10:21 +0100, Russell King (Oracle) wrote:
> > > It looks to me like the phylink code in your patch series is based on
> > > an older version of phylink and hasn't been updated for the split PCS
> > > support - you seem to be munging the PCS parts in with the MAC
> > > callbacks. If so, please update to the modern way of dealing with this.
> > > 
> > > If that isn't the case, please explain why you are not using the split
> > > PCS support.
> > 
> > I need to be able to let the user set the speed to get the link up.
> > 
> > So far I have only been able to get the user configured speeds via the mac_ops, but if this is
> > also
> > possible via the pcs_ops, there should not anything preventing me from using these ops instead.
> > 
> > Will the pcs_ops also support this?
> 
> I really don't understand what you're saying here, so I can't answer.
> 
> What exactly do you mean "user configured speeds" ? Please give
> examples of exactly what you're wanting to do.

I have added an example to the response in the other email thread.

> 
> --
> RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
> FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!


-- 
BR
Steen

-=-=-=-=-=-=-=-=-=-=-=-=-=-=
steen.hegelund@microchip.com


