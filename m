Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 85013433B4B
	for <lists+netdev@lfdr.de>; Tue, 19 Oct 2021 17:53:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233693AbhJSPz2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Oct 2021 11:55:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233722AbhJSPzX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Oct 2021 11:55:23 -0400
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9577EC06161C
        for <netdev@vger.kernel.org>; Tue, 19 Oct 2021 08:53:10 -0700 (PDT)
Received: by mail-wm1-x32c.google.com with SMTP id g39so8466887wmp.3
        for <netdev@vger.kernel.org>; Tue, 19 Oct 2021 08:53:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=MEYczlvn+sDQDgpqyNJyvotYqA1JPQB0pEp3NFQIWlQ=;
        b=aqZRkEqqF92D40NS6wOIfWs08C2MH6tTKKGoRAXYXO7KDe1wK4ZcNFxDddeSyo2E+8
         M+gwDIc0eeWtb6wbFrOzMPIe82vsitA7wsZAqhMxnGhuHLAY6NpICTHWGPEyydpwD4GO
         SIPFlyQFksyPNNDRCkZ3iggnYjtFyX3yUbmc5KVU2QNkkeiqgzvqDESYkxuJ9GeaSICR
         lg2Uz6ViW7/i+ixFJz8XFmw9zu9JZSkC7j+gzkmsSlcW35pKUFL9yVlMiPdriGt9l7VO
         BLMfJP20SXL8cCEkifAzQv/QbeZG0OnYL+CI/k7k1JCRY4JnLSm0uR9LZXoXD6o5GTsg
         xUqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :in-reply-to:user-agent;
        bh=MEYczlvn+sDQDgpqyNJyvotYqA1JPQB0pEp3NFQIWlQ=;
        b=jp7Zu66KX6gbzBtO1CauDSAHkcWI5XQZtJj9NeGVCAFZzU9Ys33VMCUFVLTPh3lB0j
         sGoC4G7TrnXAkpN3JlDrcrfXRO3P4iW+L+UyvY9ktd85H5LP02LA9ALc3ydA2bxxcwec
         pnxPjaPHiUg/KtkA/nFdZtijnihkoCEhsp40J50N+H0JNdcQMrZ8Nu+tR+76xm1d38n3
         cYs+YdNvMYxkFzNqQT35mq8jj8OiWSQQaX1zvTG5ghQLCiEkRIJGxb0McYx0Ty3LfO5c
         qh83UbzeMXfnRognHz14DJtlivVI1WmfKsAeCn/sae14oCOeNWnv6bCONEBHIoPoJ0lT
         aUxA==
X-Gm-Message-State: AOAM531ICuUFVKP5mGdVszC0B4ArNliz1ksNk/loyyw6RFZmwyBgmXBI
        uWNoQ47COy1aB7zWgiVaYmr1zBeSMq8=
X-Google-Smtp-Source: ABdhPJz6oCIQtDZHBP+o9TsRUb+xQq7Y39X5e+HWXGsZhbauPL1ev3vM1w3hzztUTPUkqQkkhQEhFg==
X-Received: by 2002:a05:600c:208:: with SMTP id 8mr6670691wmi.173.1634658789226;
        Tue, 19 Oct 2021 08:53:09 -0700 (PDT)
Received: from gmail.com ([81.168.73.77])
        by smtp.gmail.com with ESMTPSA id s3sm1405495wmh.30.2021.10.19.08.53.07
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 19 Oct 2021 08:53:08 -0700 (PDT)
Date:   Tue, 19 Oct 2021 16:53:06 +0100
From:   Martin Habets <habetsm.xilinx@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>, Erik Ekman <erik@kryo.se>
Cc:     Edward Cree <ecree.xilinx@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: Re: [PATCH] sfc: Export fibre-specific link modes for 1/10G
Message-ID: <20211019155306.ibxzmsixwb5rd6wx@gmail.com>
Mail-Followup-To: Andrew Lunn <andrew@lunn.ch>, Erik Ekman <erik@kryo.se>,
        Edward Cree <ecree.xilinx@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
References: <20211018183709.124744-1-erik@kryo.se>
 <YW7k6JVh5LxMNP98@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YW7k6JVh5LxMNP98@lunn.ch>
User-Agent: NeoMutt/20170113 (1.7.2)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 19, 2021 at 05:31:52PM +0200, Andrew Lunn wrote:
> On Mon, Oct 18, 2021 at 08:37:08PM +0200, Erik Ekman wrote:
> > These modes were added to ethtool.h in 5711a98221443 ("net: ethtool: add support
> > for 1000BaseX and missing 10G link modes") back in 2016.
> > 
> > Only setting CR mode for 10G, similar to how 25/40/50/100G modes are set up.
> > 
> > Tested using SFN5122F-R7 (with 2 SFP+ ports) and a 1000BASE-BX10 SFP module.
> 
> Did you test with a Copper SFP modules? 
> 
> > +++ b/drivers/net/ethernet/sfc/mcdi_port_common.c
> > @@ -133,9 +133,9 @@ void mcdi_to_ethtool_linkset(u32 media, u32 cap, unsigned long *linkset)
> >  	case MC_CMD_MEDIA_QSFP_PLUS:
> >  		SET_BIT(FIBRE);
> >  		if (cap & (1 << MC_CMD_PHY_CAP_1000FDX_LBN))
> > -			SET_BIT(1000baseT_Full);
> > +			SET_BIT(1000baseX_Full);
> 
> I'm wondering if you should have both? The MAC is doing 1000BaseX. But
> it could then be connected to a copper PHY which then does
> 1000baseT_Full? At 1G, it is however more likely to be using SGMII,
> not 1000BaseX.

Yes, they should both be set. We actually did a 10Gbase-T version of Siena,
the SFN51x1T.

Martin
