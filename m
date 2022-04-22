Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C002150BB96
	for <lists+netdev@lfdr.de>; Fri, 22 Apr 2022 17:22:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1449388AbiDVPZH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Apr 2022 11:25:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237924AbiDVPZG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Apr 2022 11:25:06 -0400
Received: from smtp8.emailarray.com (smtp8.emailarray.com [65.39.216.67])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF35C554AA
        for <netdev@vger.kernel.org>; Fri, 22 Apr 2022 08:22:12 -0700 (PDT)
Received: (qmail 13482 invoked by uid 89); 22 Apr 2022 15:22:11 -0000
Received: from unknown (HELO localhost) (amxlbW9uQGZsdWdzdmFtcC5jb21AMTc0LjIxLjE0NC4yOQ==) (POLARISLOCAL)  
  by smtp8.emailarray.com with SMTP; 22 Apr 2022 15:22:11 -0000
Date:   Fri, 22 Apr 2022 08:22:09 -0700
From:   Jonathan Lemon <jonathan.lemon@gmail.com>
To:     Lasse Johnsen <lasse@timebeat.app>
Cc:     Richard Cochran <richardcochran@gmail.com>, netdev@vger.kernel.org,
        Gordon Hollingworth <gordon@raspberrypi.com>,
        Ahmad Byagowi <clk@fb.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        bcm-kernel-feedback-list@broadcom.com,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Subject: Re: [PATCH net-next v2] net: phy: broadcom: 1588 support on
 bcm54210pe
Message-ID: <20220422152209.cwofghzr2wyxopek@bsd-mbp.local>
References: <928593CA-9CE9-4A54-B84A-9973126E026D@timebeat.app>
 <20220421144825.GA11810@hoboy.vegasvil.org>
 <208820C3-E4C8-4B75-B926-15BCD844CE96@timebeat.app>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <208820C3-E4C8-4B75-B926-15BCD844CE96@timebeat.app>
X-Spam-Status: No, score=0.7 required=5.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
        FORGED_GMAIL_RCVD,FREEMAIL_FROM,NML_ADSP_CUSTOM_MED,SPF_HELO_NONE,
        SPF_SOFTFAIL,UNPARSEABLE_RELAY autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 22, 2022 at 04:08:18PM +0100, Lasse Johnsen wrote:
> > On 21 Apr 2022, at 15:48, Richard Cochran <richardcochran@gmail.com> wrote:
> > Moreover: Does this device provide in-band Rx time stamps?  If so, why
> > not use them?
> 
> This is the first generation PHY and it does not do in-band RX. I asked BCM and studied the documentation. I’m sure I’m allowed to say, that the second generation 40nm BCM PHY (which - "I am not making this up" is available in 3 versions: BCM54210, BCM54210S and BCM54210SE - not “PE”) - supports in-band rx timestamps. However, as a matter of curiosity, BCM utilise the field in the header now used for minor versioning in 1588-2019, so in due course using this silicon feature will be a significant challenge.

Actually, it does support in-band RX timestamps.  Doing this would be
cleaner, and you'd only need to capture TX timestamps.
-- 
Jonathan
