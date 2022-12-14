Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4517364C6F1
	for <lists+netdev@lfdr.de>; Wed, 14 Dec 2022 11:18:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237276AbiLNKSg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Dec 2022 05:18:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229739AbiLNKSf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Dec 2022 05:18:35 -0500
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51E35FD22
        for <netdev@vger.kernel.org>; Wed, 14 Dec 2022 02:18:33 -0800 (PST)
Received: by mail-ej1-x62f.google.com with SMTP id x22so43305455ejs.11
        for <netdev@vger.kernel.org>; Wed, 14 Dec 2022 02:18:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=mLalDC+faDZhVjo0ECWibu1fmKTUBj0rla2gydjMZrM=;
        b=RxOR8bIy+HJRPAp6Peto06EWFY8DKwNgommhbORx1wsPoAAv6Q8dwMFMj/GLNHQalT
         EoSgmQuFST1hIYgaG5ATbGo1pfNcoJ6C9+kelhG6oaVeeqvwV9IUy30tRX1zMJRD4X3W
         vD8lzsXRckJsbMuuc8MSaVb9ceVkqwHt0+leBnqI/NxlVMsNT49H5EK0YTRAnUJIMW7y
         oNWKZNi959DESwfoZMmIvUO+UrCRXluaioxezFZQiGf3GfZ1Kwt5zI6nqqOxFbPkYStM
         W/RWRQl8/9lbLor8l3afS8gP0cmWDJ7HV9vQTZ8tB1fVx6bJp/18ITUnM7XMkFyTJgpS
         DVKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mLalDC+faDZhVjo0ECWibu1fmKTUBj0rla2gydjMZrM=;
        b=DGyPSQ3P54IEARhwyRs5X6bLEyOZkWBHTrePEURvT1n4dMPSmitP6kHQgM69FE94mZ
         Yo3NuAuU0+Slu3ysPBnnDFcHaLVzPurBmGIzi8SgVSV66tho+ceM9N3v+UgUbFMCXa2x
         iBO1z5Lby04gIMibEvRjhyRPmFdRayopBhaiSTa1OynTct6gsyiTcvQd8YsJ5XZMndEM
         oD5TdQhHSHZ7OsH3RH/jAqYNrVPaFEFfB1jHqLiWmn/PJFJ/Z1RMTCJE4gJtNVHxau5C
         W8V3VaKhoAgjaHGGGC4yUwXq51oUNNklieOJg4nu+bJe6F0f9Kng0lGGT4hh6ipoSmnp
         JPRQ==
X-Gm-Message-State: ANoB5pkoRCddi/M26/0CTcDpBjshn2FhDedwppm6xbUOJGPouGTYC94i
        AWcOPBYcqe2YBdvJ+Pu7MYMjDA==
X-Google-Smtp-Source: AA0mqf7054axkoyePS2xnMsSz7v3kbLmSaLz2+Y9T8DQhpB1uheYt81n1MMkrcoXNsEL693SJS72XA==
X-Received: by 2002:a17:906:144f:b0:7c1:28a9:c277 with SMTP id q15-20020a170906144f00b007c128a9c277mr21590331ejc.6.1671013111900;
        Wed, 14 Dec 2022 02:18:31 -0800 (PST)
Received: from blmsp ([185.238.219.17])
        by smtp.gmail.com with ESMTPSA id 17-20020a170906311100b0073d81b0882asm5664082ejx.7.2022.12.14.02.18.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Dec 2022 02:18:31 -0800 (PST)
Date:   Wed, 14 Dec 2022 11:18:30 +0100
From:   Markus Schneider-Pargmann <msp@baylibre.com>
To:     Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     Chandrasekar Ramakrishnan <rcsekar@samsung.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Subject: Re: [PATCH 02/15] can: m_can: Wakeup net queue once tx was issued
Message-ID: <20221214101830.vmujo3js66aozik2@blmsp>
References: <20221116205308.2996556-1-msp@baylibre.com>
 <20221116205308.2996556-3-msp@baylibre.com>
 <20221130172100.ef4xn6j6kzrymdyn@pengutronix.de>
 <20221214091406.g6vim5hvlkm34naf@blmsp>
 <20221214091820.geugui5ws3f7a5ng@pengutronix.de>
 <20221214092201.xpb3rnwp5rtvrpkr@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20221214092201.xpb3rnwp5rtvrpkr@pengutronix.de>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 14, 2022 at 10:22:01AM +0100, Marc Kleine-Budde wrote:
> On 14.12.2022 10:18:20, Marc Kleine-Budde wrote:
> > On 14.12.2022 10:14:06, Markus Schneider-Pargmann wrote:
> > > Hi Marc,
> > > 
> > > On Wed, Nov 30, 2022 at 06:21:00PM +0100, Marc Kleine-Budde wrote:
> > > > On 16.11.2022 21:52:55, Markus Schneider-Pargmann wrote:
> > > > > Currently the driver waits to wakeup the queue until the interrupt for
> > > > > the transmit event is received and acknowledged. If we want to use the
> > > > > hardware FIFO, this is too late.
> > > > > 
> > > > > Instead release the queue as soon as the transmit was transferred into
> > > > > the hardware FIFO. We are then ready for the next transmit to be
> > > > > transferred.
> > > > 
> > > > If you want to really speed up the TX path, remove the worker and use
> > > > the spi_async() API from the xmit callback, see mcp251xfd_start_xmit().
> > > > 
> > > > Extra bonus if you implement xmit_more() and transfer more than 1 skb
> > > > per SPI transfer.
> > > 
> > > Just a quick question here, I mplemented a xmit_more() call and I am
> > > testing it right now, but it always returns false even under high
> > > pressure. The device has a txqueuelen set to 1000. Do I need to turn
> > > some other knob for this to work?
> > 
> > AFAIK you need BQL support: see 0084e298acfe ("can: mcp251xfd: add BQL support").
> > 
> > The etas_es58x driver implements xmit_more(), I added the Author Vincent
> > on Cc.
> 
> Have a look at netdev_queue_set_dql_min_limit() in the etas driver.

Thank you, I need to implement BQL, I wasn't aware of that. I may need
to delay this a bit just to get some feedback on the current state of my
patches, so I know what I need to work on first.

But it seems to be just accounting... Anyways, thank you :)

Best,
Markus
