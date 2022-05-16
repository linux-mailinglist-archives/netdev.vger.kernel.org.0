Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0F418528DDE
	for <lists+netdev@lfdr.de>; Mon, 16 May 2022 21:21:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345382AbiEPTVz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 May 2022 15:21:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345352AbiEPTVz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 May 2022 15:21:55 -0400
Received: from mailgw.felk.cvut.cz (mailgw.felk.cvut.cz [147.32.82.15])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF9CF19FA3;
        Mon, 16 May 2022 12:21:51 -0700 (PDT)
Received: from mailgw.felk.cvut.cz (localhost.localdomain [127.0.0.1])
        by mailgw.felk.cvut.cz (Proxmox) with ESMTP id 6327030B2943;
        Mon, 16 May 2022 21:21:49 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        cmp.felk.cvut.cz; h=cc:cc:content-transfer-encoding:content-type
        :content-type:date:from:from:in-reply-to:message-id:mime-version
        :references:reply-to:subject:subject:to:to; s=felkmail; bh=D25+b
        sYPPdD75osljot245ly0xJRX+XEY5UOuZmKOpc=; b=geG4M6+JzNolfnKk+mVPV
        61e/Q86dMa0avgUlWzXALoQsKdJ6B2c8m+ZQ/mFgxMiiBlGGwL8pWJCKT0lAx3pW
        N66Di9bprba+Tq1g6C2F+3D8f/aoPF6TouA3WZExfQ4O9pS2t8pHila22OGTVXYA
        Zd5fAjTk+1oCzuNe4nOFqoTFN7rHVDQ4rwKHm6h2qPgITmXEz6x5QsVRBHSALvaT
        f4UP0R0iL1x2NqUrUrJ/jLkF2XFnn+5YjMFkcfV65krf4VqFELin4e5Btig1BUB0
        jlZLOyB1F+3IO0knR2z5NXw71GkWgYUxznVyKDl+x2PhC43nEcMqdczqxO8wW9XX
        g==
Received: from cmp.felk.cvut.cz (haar.felk.cvut.cz [147.32.84.19])
        by mailgw.felk.cvut.cz (Proxmox) with ESMTPS id B38D730B2941;
        Mon, 16 May 2022 21:21:48 +0200 (CEST)
Received: from haar.felk.cvut.cz (localhost [127.0.0.1])
        by cmp.felk.cvut.cz (8.14.0/8.12.3/SuSE Linux 0.6) with ESMTP id 24GJLm6n031667;
        Mon, 16 May 2022 21:21:48 +0200
Received: (from pisa@localhost)
        by haar.felk.cvut.cz (8.14.0/8.13.7/Submit) id 24GJLmNC031666;
        Mon, 16 May 2022 21:21:48 +0200
X-Authentication-Warning: haar.felk.cvut.cz: pisa set sender to pisa@cmp.felk.cvut.cz using -f
From:   Pavel Pisa <pisa@cmp.felk.cvut.cz>
To:     "Marc Kleine-Budde" <mkl@pengutronix.de>,
        Rob Herring <robh@kernel.org>
Subject: Re: [RFC PATCH 2/3] dt-bindings: can: ctucanfd: add properties for HW timestamping
Date:   Mon, 16 May 2022 21:21:42 +0200
User-Agent: KMail/1.9.10
Cc:     Matej Vasilevski <matej.vasilevski@seznam.cz>,
        linux-can@vger.kernel.org, devicetree@vger.kernel.org,
        netdev@vger.kernel.org, ondrej.ille@gmail.com,
        martin.jerabek01@gmail.com
References: <20220512232706.24575-1-matej.vasilevski@seznam.cz> <20220516160250.GA2724701-robh@kernel.org> <20220516163445.qxz3xlohuquqwbwl@pengutronix.de>
In-Reply-To: <20220516163445.qxz3xlohuquqwbwl@pengutronix.de>
X-KMail-QuotePrefix: > 
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <202205162121.42800.pisa@cmp.felk.cvut.cz>
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,NICE_REPLY_A,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Rob and Marc,

thanks for comment and help.

This patch is marked as RFC and not intended for direct
application. We plan to gather feetback, adjust code
and probably even IP core HDL based on suggestions,
then we plan more testing and when we will be ready and
time allows, new version with plea for merge will provided. 

On Monday 16 of May 2022 18:34:45 Marc Kleine-Budde wrote:
> On 16.05.2022 11:02:50, Rob Herring wrote:
> > On Fri, May 13, 2022 at 01:27:06AM +0200, Matej Vasilevski wrote:
> > > Extend dt-bindings for CTU CAN-FD IP core with necessary properties
> > > to enable HW timestamping for platform devices. Since the timestamping
> > > counter is provided by the system integrator usign those IP cores in
> > > their FPGA design, we need to have the properties specified in device
> > > tree.
> > >
> > > Signed-off-by: Matej Vasilevski <matej.vasilevski@seznam.cz>
> > > ---
> > >  .../bindings/net/can/ctu,ctucanfd.yaml        | 34 +++++++++++++++++--
> > >  1 file changed, 31 insertions(+), 3 deletions(-)
> >
> > What's the base for this patch? Doesn't apply for me.

It is based on the series of complete CTU CAN FD support
which has been accepted into net-next.
The DTC part has gone through your review and has been
ACKed longer time ago. We have spent considerable time
to resolve suggested driver changes - headers files generation
from HDL tool chain, etc.

We inline to version when most of the info will be directly
provided by the core HW except for optional second clocks
probably.

Best wishes,

Pavel

> > > diff --git
> > > a/Documentation/devicetree/bindings/net/can/ctu,ctucanfd.yaml
> > > b/Documentation/devicetree/bindings/net/can/ctu,ctucanfd.yaml index
> > > fb34d971dcb3..c3693dadbcd8 100644
> > > --- a/Documentation/devicetree/bindings/net/can/ctu,ctucanfd.yaml
> > > +++ b/Documentation/devicetree/bindings/net/can/ctu,ctucanfd.yaml
> > > @@ -41,9 +41,35 @@ properties:
> > >
> > >    clocks:
> > >      description: |
> > > -      phandle of reference clock (100 MHz is appropriate
> > > -      for FPGA implementation on Zynq-7000 system).
> > > +      Phandle of reference clock (100 MHz is appropriate for FPGA
> > > +      implementation on Zynq-7000 system). If you wish to use
> > > timestamps +      from the core, add a second phandle with the clock
> > > used for timestamping +      (can be the same as the first clock).
> > > +    maxItems: 2
> >
> > With more than 1, you have to define what each entry is. IOW, use
> > 'items'.
> >
> > > +
> > > +  clock-names:
> > > +    description: |
> > > +      Specify clock names for the "clocks" property. The first clock
> > > name +      doesn't matter, the second has to be "ts_clk". Timestamping
> > > frequency +      is then obtained from the "ts_clk" clock. This takes
> > > precedence over +      the ts-frequency property.
> > > +      You can omit this property if you don't need timestamps.
> > > +    maxItems: 2
> >
> > You must define what the names are as a schema.
> >
> > > +
> > > +  ts-used-bits:
> > > +    description: width of the timestamping counter
> > > +    maxItems: 1
> > > +    items:
> >
> > Not an array, so you don't need maxItems nor items.
> >
> > > +      minimum: 8
> > > +      maximum: 64
> > > +
> > > +  ts-frequency:
> >
> > Use a standard unit suffix.
> >
> > > +    description: |
> > > +      Frequency of the timestamping counter. Set this if you want to
> > > get +      timestamps, but you didn't set the timestamping clock in
> > > clocks property. maxItems: 1
> > > +    items:
> >
> > Not an array.
> >
> >
> > Is timestamping a common feature for CAN or is this specific to this
> > controller? In the latter case, you need vendor prefixes on these
> > properties. In the former case, you need to define them in a common
> > schema.
>
> This property describes the usable with of the free running timer and
> the timestamps generated by it. This is similar to the free running
> timer and time stamps as found on PTP capable Ethernet NICs. But the
> ctucanfd comes in a hardware description language that can be
> parametrized and synthesized into your own FPGA.
>
> To answer your question, timestamping is common in newer CAN cores, but
> the width of the timestamping register is usually fixed and thus hard
> coded in the driver.
>
> regards,
> Marc

