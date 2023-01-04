Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C3E865CEEE
	for <lists+netdev@lfdr.de>; Wed,  4 Jan 2023 10:00:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233699AbjADJAJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Jan 2023 04:00:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234753AbjADI7l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Jan 2023 03:59:41 -0500
Received: from mout.gmx.net (mout.gmx.net [212.227.15.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38F9D1BE9B
        for <netdev@vger.kernel.org>; Wed,  4 Jan 2023 00:59:39 -0800 (PST)
Received: from gmx.fr ([181.118.46.223]) by mail.gmx.net (mrgmx005
 [212.227.17.184]) with ESMTPSA (Nemesis) id 1MaJ3n-1pG1re0fmn-00WEgS; Wed, 04
 Jan 2023 09:59:19 +0100
Date:   Wed, 4 Jan 2023 04:59:13 -0400
From:   Jamie Gloudon <jamie.gloudon@gmx.fr>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Tony Nguyen <anthony.l.nguyen@intel.com>, davem@davemloft.net,
        kuba@kernel.org, pabeni@redhat.com, edumazet@google.com,
        netdev@vger.kernel.org, sasha.neftin@intel.com,
        Naama Meir <naamax.meir@linux.intel.com>
Subject: Re: [PATCH net-next 1/1] e1000e: Enable Link Partner Advertised
 Support
Message-ID: <Y7U/4Q0QKtkuexLu@gmx.fr>
References: <20230103230653.1102544-1-anthony.l.nguyen@intel.com>
 <Y7TMhVy5CdqqysRb@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y7TMhVy5CdqqysRb@lunn.ch>
X-Provags-ID: V03:K1:6WNqWKw2kwnR1UmxHD4vfvjhdO/PE0my1UXNva0jtWpbbY4ULhi
 b377OlRPFRmcoMi9AuR5NUmFOD/pOcsIdCGEholvjr1wJDvaT+uHgaUrQTy1rx/Hy48sbNa
 7Ge4+t2TkpYDccbV9YkWqSqVzXYR38w4Al2oY2bsKr42ZdqTd4Z3UlN9zdB3YYAE5auUHsB
 Ivx0FMAmTl3iCrlGCEluQ==
UI-OutboundReport: notjunk:1;M01:P0:ORF0tw4u8o4=;3j+xvhauWJI647Wz5watA9qAgrz
 CggYVnqq4VSaGo8bFgomiovI5DZOkls5h5jhMiDQxLO0Zwh/jz9DzvN73raX1SsZNYnHT9yba
 rJN3HA26rFmlGYCdGPK4Gg5hv2nprGTkrw/DbB3ETNCQDDEGg0/SrbyYTPq1/GvnJs2fXebRY
 MgoO1P2VF6az1oZABchfOEps0oxfWNiLgnPEfbSttbwM+X6Kwgn9nFFBhQaF0ZxoCdY3iEAaC
 3BfAW1xNLMONGDyib/WwjU4j6looAi6RLYmPnNQ0JctlTLuL4dJFVAAALRIN+vMB8wOjh382h
 qG5EIydOcxKFVMNVZ6aAsGPD+m5dWfxa6hF8hWe50dmwZg+nhIRJeae+9a2BZQHe43tl+Vau1
 xIiKyo60tSFYLW0NZv2xmgu7/9SKVf2VqxfWl3t1gq/c7TCx9TyFBKbSPeCFyxRii4v/zk/XK
 kMpYs7xEnGAl3a51m3V2v1Zq31xqCELif69lYPaAg0DQD9Kkcu/4kNIUpnIlQOkNamxlFrCpj
 Yu5e/huEVafucgl5Lo/npDjie3v/e2G2uUWt0OeyrjJh42iOa8aFSL3q/sIhTbpUV/beOpv+P
 PQxL6bH2OSlh7/XpNMjkucWjC74zvnSSL5ivyeNwE6EAhgUE+yIF4XDSO258bcYBHPrBffMRr
 BWuxK6D/ggA5dU0ApQ0S7yE/4qSmXLtEvE+JzzxGxqTXEaXGbw2BNgPHWnRSlvoF1t0Z17EGe
 j4A8SL/m3IzE4Cye0TH3eQdEHd6ythybF/frYwcNJdALrJPbIJyX0zKN6eQoZFTUIDZ0K8q5X
 baXbMPNYa2h248ygc7wvBkzIgrUH6OlaJigJNqydDU5ahJ20YkGXrey+IiHsaXO4/lmXnXaPM
 bCNDTI58jJerXT/xePl9w/JRXXCp9EFejIlJu+FwkSns+7ddJC+1x8cKqvYgOFHAML1V0wsug
 rx50dMGtiLBc7pH37dC8t4tqzoM=
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,FREEMAIL_FROM,
        RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 04, 2023 at 01:47:01AM +0100, Andrew Lunn wrote:
> > --- a/drivers/net/ethernet/intel/e1000e/phy.c
> > +++ b/drivers/net/ethernet/intel/e1000e/phy.c
> > @@ -2,6 +2,7 @@
> >  /* Copyright(c) 1999 - 2018 Intel Corporation. */
> >  
> >  #include "e1000.h"
> > +#include <linux/ethtool.h>
> >  
> >  static s32 e1000_wait_autoneg(struct e1000_hw *hw);
> >  static s32 e1000_access_phy_wakeup_reg_bm(struct e1000_hw *hw, u32 offset,
> > @@ -1011,6 +1012,8 @@ static s32 e1000_phy_setup_autoneg(struct e1000_hw *hw)
> >  		 */
> >  		mii_autoneg_adv_reg &=
> >  		    ~(ADVERTISE_PAUSE_ASYM | ADVERTISE_PAUSE_CAP);
> > +		phy->autoneg_advertised &=
> > +		    ~(ADVERTISED_Pause | ADVERTISED_Asym_Pause);
> >  		break;
> >  	case e1000_fc_rx_pause:
> >  		/* Rx Flow control is enabled, and Tx Flow control is
> > @@ -1024,6 +1027,8 @@ static s32 e1000_phy_setup_autoneg(struct e1000_hw *hw)
> >  		 */
> >  		mii_autoneg_adv_reg |=
> >  		    (ADVERTISE_PAUSE_ASYM | ADVERTISE_PAUSE_CAP);
> > +		phy->autoneg_advertised |=
> > +		    (ADVERTISED_Pause | ADVERTISED_Asym_Pause);
> >  		break;
> >  	case e1000_fc_tx_pause:
> >  		/* Tx Flow control is enabled, and Rx Flow control is
> > @@ -1031,6 +1036,8 @@ static s32 e1000_phy_setup_autoneg(struct e1000_hw *hw)
> >  		 */
> >  		mii_autoneg_adv_reg |= ADVERTISE_PAUSE_ASYM;
> >  		mii_autoneg_adv_reg &= ~ADVERTISE_PAUSE_CAP;
> > +		phy->autoneg_advertised |= ADVERTISED_Asym_Pause;
> > +		phy->autoneg_advertised &= ~ADVERTISED_Pause;
> >  		break;
> >  	case e1000_fc_full:
> >  		/* Flow control (both Rx and Tx) is enabled by a software
> > @@ -1038,6 +1045,8 @@ static s32 e1000_phy_setup_autoneg(struct e1000_hw *hw)
> >  		 */
> >  		mii_autoneg_adv_reg |=
> >  		    (ADVERTISE_PAUSE_ASYM | ADVERTISE_PAUSE_CAP);
> > +		phy->autoneg_advertised |=
> > +		    (ADVERTISED_Pause | ADVERTISED_Asym_Pause);
> >  		break;
> >  	default:
> >  		e_dbg("Flow control param set incorrectly\n");
> > -- 
> 
> I don't know this driver at all. What i don't see anywhere here is
> using the results of the pause auto-neg. Is there some code somewhere
> that looks at the local and link peer advertising values and runs a
> resolve algorithm to determine what pause should be used, and program
> it into the MAC?
> 
>     Andrew
This is a old patch i had laying around, If i remember correctly, phy->autoneg_advertised plugs in "Link partner
advertised pause frame use link" line in ethtool everytime the nic renegotiate.
