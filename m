Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE90328DB0F
	for <lists+netdev@lfdr.de>; Wed, 14 Oct 2020 10:20:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729169AbgJNITm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Oct 2020 04:19:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728945AbgJNITe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Oct 2020 04:19:34 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86540C051131;
        Wed, 14 Oct 2020 01:02:19 -0700 (PDT)
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.94)
        (envelope-from <johannes@sipsolutions.net>)
        id 1kSbj1-005Zm4-FC; Wed, 14 Oct 2020 10:01:31 +0200
Message-ID: <fde05983ff9bc6584ad7ee5136b9f9f17902e600.camel@sipsolutions.net>
Subject: Re: [PATCH net-next v2 00/12] net: add and use function
 dev_fetch_sw_netstats for fetching pcpu_sw_netstats
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Heiner Kallweit <hkallweit1@gmail.com>,
        Leon Romanovsky <leon@kernel.org>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        =?ISO-8859-1?Q?Bj=F8rn?= Mork <bjorn@mork.no>,
        Oliver Neukum <oneukum@suse.com>,
        Igor Mitsyanko <imitsyanko@quantenna.com>,
        Sergey Matyukevich <geomatsi@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Pravin B Shelar <pshelar@ovn.org>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        linux-rdma@vger.kernel.org,
        Linux USB Mailing List <linux-usb@vger.kernel.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        bridge@lists.linux-foundation.org
Date:   Wed, 14 Oct 2020 10:01:20 +0200
In-Reply-To: <cb02626b-71bd-360d-c864-5dac2a1a7603@gmail.com> (sfid-20201014_095918_492295_7EC63AAF)
References: <d77b65de-1793-f808-66b5-aaa4e7c8a8f0@gmail.com>
         <20201013173951.25677bcc@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
         <20201014054250.GB6305@unreal>
         <3be8fd19-1c7e-0e05-6039-e5404b2682b9@gmail.com>
         <20201014075310.GG6305@unreal>
         <cb02626b-71bd-360d-c864-5dac2a1a7603@gmail.com>
         (sfid-20201014_095918_492295_7EC63AAF)
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2020-10-14 at 09:59 +0200, Heiner Kallweit wrote:
> 
> > Do you have a link? What is the benefit and how can we use it?
> > 
> https://www.mail-archive.com/linux-kernel@vger.kernel.org/msg1873080.html

There was also a long discussion a year or so back, starting at

http://lore.kernel.org/r/7b73e1b7-cc34-982d-2a9c-acf62b88da16@linuxfoundation.org

johannes

