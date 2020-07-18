Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A1219224B43
	for <lists+netdev@lfdr.de>; Sat, 18 Jul 2020 15:01:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726801AbgGRNAy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Jul 2020 09:00:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726569AbgGRNAx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Jul 2020 09:00:53 -0400
Received: from mail-ed1-x543.google.com (mail-ed1-x543.google.com [IPv6:2a00:1450:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C16DC0619D2;
        Sat, 18 Jul 2020 06:00:53 -0700 (PDT)
Received: by mail-ed1-x543.google.com with SMTP id by13so9699406edb.11;
        Sat, 18 Jul 2020 06:00:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=wvwI7PG7u4WygVMxMuxpjuz1VVodNa3mr+jTYDKQqdY=;
        b=PWs6+JA67ELakxN1UAnD7KrD3/Q2cHKbsFKL6dvuaAid/KCFX9VN9x8FJXQpB6HRlO
         b6e19bzchrCJTDbAofYwDuqGFtpIiUOCETcX5X06oTkK3EfBog5n3GVsYwe/SY0IeD6R
         JfaIePYi1MpapOQFdAqSCr+KMJ57aX0+6PSYxeyk8Wop/15FyLxSd77jBAjyJlHC9hjc
         W5BGzFKV5Z9faFiLUvLHGb2u2q6siGMbj7MgeyK/ozVPHJiLFP9Krzh5CftJOzEx9tcT
         m1wJ1D0/uOJYCDnc4IBqNxXyXjlitdZr646tO763+CYA6pW2W+SdYjKdeaxoQn4ang6D
         7IUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=wvwI7PG7u4WygVMxMuxpjuz1VVodNa3mr+jTYDKQqdY=;
        b=aPsQ6sdhw5VfczrtBltcLkSlTkemgYzW3+j4R2dCpgcjxWxQSPp+dUYvosh273FrIx
         C8PTBj0pd/JTZbLOOKbWQzsQxHTWThQxxDpOebxtOFCDZBjqK28ycSjxI/FDRHnAslC9
         cnYrBZep/dkRnMmYQYu0ux+L3m8EyFofZKoZku7xzmws8kuDarxBcLn5F7Z5a7BkhWIX
         F0T2D3ETLftqZiGkr3WtMD6CuSIOxIdBtSl4sOuRY1SklG4IUKZtFKh2B43IKq3MKg4W
         7fBbATVn2k9J5OrTk8oTFbUlWX0WC5PCRRaUAH7jNuDaMYRfMmqHHFvipOaosedPVq+C
         cZnA==
X-Gm-Message-State: AOAM532VbVHkPvbdwUrYtJfJQzDiFAjowItCRCFDfC2HbJ4mUYplDvHu
        npiHhyd0D0sLZxpiTcJoyg4=
X-Google-Smtp-Source: ABdhPJw0Kl7gozpb1AQjDyQgdbl42lLMCXrk/7ZBjHyU3aFA6pKgUij6b5WufeoN2GveZETwcfVc+w==
X-Received: by 2002:a50:e689:: with SMTP id z9mr13702222edm.131.1595077252055;
        Sat, 18 Jul 2020 06:00:52 -0700 (PDT)
Received: from skbuf ([188.25.219.134])
        by smtp.gmail.com with ESMTPSA id t2sm11191692eds.60.2020.07.18.06.00.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 18 Jul 2020 06:00:51 -0700 (PDT)
Date:   Sat, 18 Jul 2020 16:00:49 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Matthew Hagan <mnhagan88@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>, Jakub Kicinski <kuba@kernel.org>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, linux@armlinux.org.uk,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        John Crispin <john@phrozen.org>,
        Jonathan McDowell <noodles@earth.li>,
        Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org
Subject: Re: [PATCH 2/2] dt-bindings: net: dsa: qca8k: Add PORT0_PAD_CTRL
 properties
Message-ID: <20200718130049.jqw4ckfmnld5jcdd@skbuf>
References: <2e1776f997441792a44cd35a16f1e69f848816ce.1594668793.git.mnhagan88@gmail.com>
 <ea0a35ed686e6dace77e25cb70a8f39fdd1ea8ad.1594668793.git.mnhagan88@gmail.com>
 <20200716150925.0f3e01b8@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20200716223236.GA1314837@lunn.ch>
 <c86c4da0-a740-55cc-33dd-7a91e36c7738@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c86c4da0-a740-55cc-33dd-7a91e36c7738@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 17, 2020 at 08:26:02PM +0100, Matthew Hagan wrote:
> 
> 
> On 16/07/2020 23:32, Andrew Lunn wrote:
> > On Thu, Jul 16, 2020 at 03:09:25PM -0700, Jakub Kicinski wrote:
> >> On Mon, 13 Jul 2020 21:50:26 +0100 Matthew Hagan wrote:
> >>> Add names and decriptions of additional PORT0_PAD_CTRL properties.
> >>>
> >>> Signed-off-by: Matthew Hagan <mnhagan88@gmail.com>
> >>> ---
> >>>  Documentation/devicetree/bindings/net/dsa/qca8k.txt | 8 ++++++++
> >>>  1 file changed, 8 insertions(+)
> >>>
> >>> diff --git a/Documentation/devicetree/bindings/net/dsa/qca8k.txt b/Documentation/devicetree/bindings/net/dsa/qca8k.txt
> >>> index ccbc6d89325d..3d34c4f2e891 100644
> >>> --- a/Documentation/devicetree/bindings/net/dsa/qca8k.txt
> >>> +++ b/Documentation/devicetree/bindings/net/dsa/qca8k.txt
> >>> @@ -13,6 +13,14 @@ Optional properties:
> >>>  
> >>>  - reset-gpios: GPIO to be used to reset the whole device
> >>>  
> >>> +Optional MAC configuration properties:
> >>> +
> >>> +- qca,exchange-mac0-mac6:	If present, internally swaps MAC0 and MAC6.
> >>
> >> Perhaps we can say a little more here?
> >>
> >>> +- qca,sgmii-rxclk-falling-edge:	If present, sets receive clock phase to
> >>> +				falling edge.
> >>> +- qca,sgmii-txclk-falling-edge:	If present, sets transmit clock phase to
> >>> +				falling edge.
> >>
> >> These are not something that other vendors may implement and therefore
> >> something we may want to make generic? Andrew?
> > 
> > I've never seen any other vendor implement this. Which to me makes me
> > think this is a vendor extension, to Ciscos vendor extension of
> > 1000BaseX.
> > 
> > Matthew, do you have a real use cases of these? I don't see a DT patch
> > making use of them. And if you do, what is the PHY on the other end
> > which also allows you to invert the clocks?
> > 
> The use case I am working on is the Cisco Meraki MX65 which requires bit
> 18 set (qca,sgmii-txclk-falling-edge). On the other side is a BCM58625
> SRAB with ports 4 and 5 in SGMII mode. There is no special polarity
> configuration set on this side though I do have very limited info on
> what is available. The settings I have replicate the vendor
> configuration extracted from the device.
> 
> The qca,sgmii-rxclk-falling-edge option (bit 19) is commonly used
> according to the device trees found in the OpenWrt, which is still using
> the ar8216 driver. With a count through the ar8327-initvals I see bit 19
> set on 18 of 22 devices using SGMII on MAC0.
> >        Andrew
> > 
> 
> Matthew

Let's say I'm a user. When would I need to set
qca,sgmii-txclk-falling-edge and/or qca,sgmii-rxclk-falling-edge, and
wwhen would I need not to?

Thanks,
-Vladimir
