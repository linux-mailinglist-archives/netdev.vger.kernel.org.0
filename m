Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E330D5AB978
	for <lists+netdev@lfdr.de>; Fri,  2 Sep 2022 22:30:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229629AbiIBUaW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Sep 2022 16:30:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229504AbiIBUaT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Sep 2022 16:30:19 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52A7C63F24;
        Fri,  2 Sep 2022 13:30:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=6jN31VgQCCRw0E2mRT8jomR23ac2A5p7CJG0IlzW8UU=; b=Y/50yDLE6u8Ow435onwJCh+W40
        P/1T+18ej3hVxzr+xXrhq90lL9CBKEo6IacYzj51L8O5Z4xCyfy6SGViQnQH2RTPJPAfDDEvQKLY3
        TDFdgIC/hdFwI+FfrpkdKwRci+sHnB2cfZnc4nS+fltjA9eomaCRzDqhTEQpaySjQnQE=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1oUDIZ-00FR3g-JQ; Fri, 02 Sep 2022 22:29:55 +0200
Date:   Fri, 2 Sep 2022 22:29:55 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Jerry.Ray@microchip.com
Cc:     vivien.didelot@gmail.com, f.fainelli@gmail.com, olteanv@gmail.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] net: dsa: LAN9303: Add basic support for LAN9354
Message-ID: <YxJnw40yGUFGYopB@lunn.ch>
References: <20220829180037.31078-1-jerry.ray@microchip.com>
 <20220829180037.31078-2-jerry.ray@microchip.com>
 <Yw0RfRXGZKl+ZwOi@lunn.ch>
 <MWHPR11MB16938C27CC03D84BA2194DC3EF7A9@MWHPR11MB1693.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <MWHPR11MB16938C27CC03D84BA2194DC3EF7A9@MWHPR11MB1693.namprd11.prod.outlook.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> >Please validate that what you find on the board actually is what the compatible says it should be. If you don't validate it, there will be some DT blobs that have the wrong value, but probe fine. But then you cannot actually make use of the compatible string in the driver to do something different between the 9303 and the 9354 because some boards have the wrong compatible....

Please configure your mail client to stop corrupting emails. My reply
definitely did not have lines this long.

> >
> >     Andrew
> >
> 

> At this time, the driver is meant to support both devices equally.  In the future, I will be adding content that only applies to the LAN9354.  That is when I'm planning to add .data to the .compatible entries.

Which makes it even more important to validate the compatible against
what is actually on the board. As i said, in its current state, people
are going to get it wrong, and your .data won't work, since it will be
for a different chip to which is actually on the board.

    Andrew
