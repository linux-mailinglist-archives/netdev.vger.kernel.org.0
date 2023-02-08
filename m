Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4F5A668EEB4
	for <lists+netdev@lfdr.de>; Wed,  8 Feb 2023 13:14:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231226AbjBHMON convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 8 Feb 2023 07:14:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231186AbjBHMOJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Feb 2023 07:14:09 -0500
Received: from outpost1.zedat.fu-berlin.de (outpost1.zedat.fu-berlin.de [130.133.4.66])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C543C212A4;
        Wed,  8 Feb 2023 04:14:04 -0800 (PST)
Received: from inpost2.zedat.fu-berlin.de ([130.133.4.69])
          by outpost.zedat.fu-berlin.de (Exim 4.95)
          with esmtps (TLS1.3)
          tls TLS_AES_256_GCM_SHA384
          (envelope-from <glaubitz@zedat.fu-berlin.de>)
          id 1pPjKb-0028L0-7w; Wed, 08 Feb 2023 13:13:45 +0100
Received: from p57bd9464.dip0.t-ipconnect.de ([87.189.148.100] helo=[192.168.178.81])
          by inpost2.zedat.fu-berlin.de (Exim 4.95)
          with esmtpsa (TLS1.3)
          tls TLS_AES_256_GCM_SHA384
          (envelope-from <glaubitz@physik.fu-berlin.de>)
          id 1pPjKa-000FU0-W6; Wed, 08 Feb 2023 13:13:45 +0100
Message-ID: <f6317e9073362b13b10df57de23e63945becea32.camel@physik.fu-berlin.de>
Subject: Re: remove arch/sh
From:   John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
To:     Randy Dunlap <rdunlap@infradead.org>,
        Christoph Hellwig <hch@lst.de>
Cc:     Yoshinori Sato <ysato@users.sourceforge.jp>,
        Rich Felker <dalias@libc.org>, Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        linux-kernel@vger.kernel.org, linux-watchdog@vger.kernel.org,
        devicetree@vger.kernel.org, linux-arch@vger.kernel.org,
        dmaengine@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-renesas-soc@vger.kernel.org, linux-i2c@vger.kernel.org,
        linux-input@vger.kernel.org, linux-media@vger.kernel.org,
        linux-mmc@vger.kernel.org, linux-mtd@lists.infradead.org,
        netdev@vger.kernel.org, linux-gpio@vger.kernel.org,
        linux-rtc@vger.kernel.org, linux-spi@vger.kernel.org,
        linux-serial@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-fbdev@vger.kernel.org, alsa-devel@alsa-project.org,
        linux-sh@vger.kernel.org
Date:   Wed, 08 Feb 2023 13:13:43 +0100
In-Reply-To: <0e26bf17-864e-eb22-0d07-5b91af4fde92@infradead.org>
References: <20230113062339.1909087-1-hch@lst.de>
         <11e2e0a8-eabe-2d8c-d612-9cdd4bcc3648@physik.fu-berlin.de>
         <20230116071306.GA15848@lst.de>
         <40dc1bc1-d9cd-d9be-188e-5167ebae235c@physik.fu-berlin.de>
         <20230203071423.GA24833@lst.de>
         <60ed320c8f5286e8dbbf71be29b760339fd25069.camel@physik.fu-berlin.de>
         <0e26bf17-864e-eb22-0d07-5b91af4fde92@infradead.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
User-Agent: Evolution 3.46.3 
MIME-Version: 1.0
X-Original-Sender: glaubitz@physik.fu-berlin.de
X-Originating-IP: 87.189.148.100
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Randy!

On Tue, 2023-02-07 at 17:31 -0800, Randy Dunlap wrote:
> 
> On 2/7/23 01:06, John Paul Adrian Glaubitz wrote:
> > Hello Christoph!
> > 
> > On Fri, 2023-02-03 at 08:14 +0100, Christoph Hellwig wrote:
> > > On Mon, Jan 16, 2023 at 09:52:10AM +0100, John Paul Adrian Glaubitz wrote:
> > > > We have had a discussion between multiple people invested in the SuperH port and
> > > > I have decided to volunteer as a co-maintainer of the port to support Rich Felker
> > > > when he isn't available.
> > > 
> > > So, this still isn't reflected in MAINTAINERS in linux-next.  When
> > > do you plan to take over?  What platforms will remain supported and
> > > what can we start dropping due to being unused and unmaintained?
> > 
> > I'm getting everything ready now with Geert's help and I have a probably dumb
> > question regarding the MAINTAINERS file change: Shall I just add myself as an
> > additional maintainer first or shall I also drop Yoshinori Sato?
> > 
> > Also, is it desirable to add a "T:" entry for the kernel tree?
> 
> Yes, definitely.

Geert has suggested to wait with adding a tree source to the entry until I get my
own kernel.org account. I have enough GPG signatures from multiple kernel developers
on my GPG key, so I think it shouldn't be too difficult to qualify for an account.

Adrian

-- 
 .''`.  John Paul Adrian Glaubitz
: :' :  Debian Developer
`. `'   Physicist
  `-    GPG: 62FF 8A75 84E0 2956 9546  0006 7426 3B37 F5B5 F913
