Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2BCC922AEC
	for <lists+netdev@lfdr.de>; Mon, 20 May 2019 06:41:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730000AbfETElL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 May 2019 00:41:11 -0400
Received: from mail-pl1-f195.google.com ([209.85.214.195]:46182 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727539AbfETElL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 May 2019 00:41:11 -0400
Received: by mail-pl1-f195.google.com with SMTP id r18so6077083pls.13;
        Sun, 19 May 2019 21:41:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=hQw5aECgY9hKK5rZ7g8MBM09I6jNL0ROWQsBCMlAOrQ=;
        b=CHlsGg1p7a9hc3+KkJoUw8ok0htU3vc27YzRVP8CMdqBhgkmGeNP91gS+yuP3utt5G
         oRlTos/xF2Rejcsd0BkEVMmQrs7XKf/dae6xidzWuR+xFI5AILwFC0Hlk5g0UvwEkbzW
         1iZdLSnjXW9taDvh8QeuNJmhAT1sawmbt2Pf0k75DF7p1fs8uZA4cI+YDo/ekFDDS72w
         onIWHPVbYxSv7jLjDoRrXA+L2q5UJH/WIyaj2D6PFQccc65Ma5Vf/ZVcs+1OxyWsjq1D
         MpNfsnRt/2BBgrbsH9ZIil3AoE5FMa0lZKhAo1p4GsQTR9eWVhx2LNBmJ50+FQR2Mjst
         SqaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=hQw5aECgY9hKK5rZ7g8MBM09I6jNL0ROWQsBCMlAOrQ=;
        b=n1D80zL2FLEzoy/SEBJd/0SDkpxgckWHEQzRKeii1OQsiDdUOgPNS6bWNbGYgkM3ZH
         gBSB1E0Xs2DZ+cWQpVkzM9OdgK8iAW9XdaweEyo/7coSZTCJWL8Gzh0mKevuLongYRr+
         tt8iOQPepsRriVgLw+ZR5/S7UrSFXV4P664MQpNfBpLaTeuH8F7LYmISchdBAIiU/Zub
         b5ezv3ICl+rvQK98Dwu/T6Kj26msOHO2ERgnZW34ll/kXLg0BJp0VG/+pD2mhwaU7zU1
         1AEvEXIsNZ1/jCct1xans6nTG60aXNwHBGSVviBjzg5dbEhY0CVJft8gu22vsyKvJ7XP
         tAAQ==
X-Gm-Message-State: APjAAAW2hI3+RfWqDeETWfq8yEFpYa5Fz5ITzo/2hGW+LZ/eQq4dTdJA
        oz91+5uQHJy29qcplugT9LU=
X-Google-Smtp-Source: APXvYqygdq7byHUUQ6kGF5vwKhQcPMMTp8G+OKse6Q0yeghSrgx1i3NizEAosJMWB5h7sP2z/RCo7g==
X-Received: by 2002:a17:902:6b03:: with SMTP id o3mr23433791plk.85.1558327270669;
        Sun, 19 May 2019 21:41:10 -0700 (PDT)
Received: from localhost (c-73-222-71-142.hsd1.ca.comcast.net. [73.222.71.142])
        by smtp.gmail.com with ESMTPSA id m123sm21780054pfm.39.2019.05.19.21.41.09
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Sun, 19 May 2019 21:41:09 -0700 (PDT)
Date:   Sun, 19 May 2019 21:41:07 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     "Y.b. Lu" <yangbo.lu@nxp.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Shawn Guo <shawnguo@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [EXT] Re: [PATCH 1/3] enetc: add hardware timestamping support
Message-ID: <20190520044107.ugro6zb7vkveyjw5@localhost>
References: <20190516100028.48256-1-yangbo.lu@nxp.com>
 <20190516100028.48256-2-yangbo.lu@nxp.com>
 <20190516143251.akbt3ns6ue2jrhl5@localhost>
 <VI1PR0401MB2237FB387B3F5ABC70EE4285F8060@VI1PR0401MB2237.eurprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <VI1PR0401MB2237FB387B3F5ABC70EE4285F8060@VI1PR0401MB2237.eurprd04.prod.outlook.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 20, 2019 at 03:20:23AM +0000, Y.b. Lu wrote:
> > > +config FSL_ENETC_HW_TIMESTAMPING
> > > +     bool "ENETC hardware timestamping support"
> > > +     depends on FSL_ENETC || FSL_ENETC_VF
> > > +     help
> > > +       Enable hardware timestamping support on the Ethernet packets
> > > +       using the SO_TIMESTAMPING API. Because the RX BD ring dynamic
> > > +       allocation hasn't been supported and it's too expensive to use
> > 
> > s/it's/it is/
> 
> [Y.b. Lu] Will modify it. BTW, may I know what's the purpose of dropping single quote character? For searching, script checking, or something else?

Simply because "it's" is informal speech, but the Kconfig help is
formal technical documentation.  (Or at least it should be!)

Thanks,
Richard
