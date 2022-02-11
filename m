Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4464A4B271F
	for <lists+netdev@lfdr.de>; Fri, 11 Feb 2022 14:30:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350540AbiBKN31 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Feb 2022 08:29:27 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:52900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350530AbiBKN3Z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Feb 2022 08:29:25 -0500
Received: from ssl.serverraum.org (ssl.serverraum.org [IPv6:2a01:4f8:151:8464::1:2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F6A01DE
        for <netdev@vger.kernel.org>; Fri, 11 Feb 2022 05:29:24 -0800 (PST)
Received: from ssl.serverraum.org (web.serverraum.org [172.16.0.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ssl.serverraum.org (Postfix) with ESMTPSA id 05B0022205;
        Fri, 11 Feb 2022 14:29:17 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2016061301;
        t=1644586157;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=B1DHqIx/PoUhbF5fk42oLmFGP6Vh8dVHYXp+pkQoscQ=;
        b=gqFHQI0TPC8WodkMpqhzMovyZKmVi4yi2/Qofet6fkiVFf9IuegvES07re9HbDe9x7kEfI
        BqZJhb7gs2n0oxaODw0en9N4mJxGNGyzps1DSajVyfmIMHDBjlyVmMo73BtMOpO/lF2mBi
        ufRyary5yw9RhZf4RInocaf4tkOE7QI=
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Fri, 11 Feb 2022 14:29:16 +0100
From:   Michael Walle <michael@walle.cc>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     Rob Herring <robh@kernel.org>, Shawn Guo <shawnguo@kernel.org>,
        Lee Jones <lee.jones@linaro.org>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Leo Li <leoyang.li@nxp.com>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 2/3] dt-bindings: mfd: add "fsl,ls1028a-qds-qixis-i2c"
 compatible to sl28cpld
In-Reply-To: <20220211132410.3qldvlpznlrxsgzg@skbuf>
References: <20220127172105.4085950-1-vladimir.oltean@nxp.com>
 <20220127172105.4085950-3-vladimir.oltean@nxp.com>
 <YgZeNqAbdisyeT+s@robh.at.kernel.org>
 <20220211132410.3qldvlpznlrxsgzg@skbuf>
User-Agent: Roundcube Webmail/1.4.12
Message-ID: <7444c54c0214552f1a565a8bd0c48850@walle.cc>
X-Sender: michael@walle.cc
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Am 2022-02-11 14:24, schrieb Vladimir Oltean:
> On Fri, Feb 11, 2022 at 07:01:42AM -0600, Rob Herring wrote:
>> On Thu, Jan 27, 2022 at 07:21:04PM +0200, Vladimir Oltean wrote:
>> > The LS1028A-QDS QIXIS FPGA has no problem working with the
>> > simple-mfd-i2c.c driver, so extend the list of compatible strings to
>> > include that part.
>> >
>> > Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
>> > ---
>> >  Documentation/devicetree/bindings/mfd/kontron,sl28cpld.yaml | 4 +++-
>> >  1 file changed, 3 insertions(+), 1 deletion(-)
>> >
>> > diff --git a/Documentation/devicetree/bindings/mfd/kontron,sl28cpld.yaml b/Documentation/devicetree/bindings/mfd/kontron,sl28cpld.yaml
>> > index eb3b43547cb6..8c1216eb36ee 100644
>> > --- a/Documentation/devicetree/bindings/mfd/kontron,sl28cpld.yaml
>> > +++ b/Documentation/devicetree/bindings/mfd/kontron,sl28cpld.yaml
>> > @@ -16,7 +16,9 @@ description: |
>> >
>> >  properties:
>> >    compatible:
>> > -    const: kontron,sl28cpld
>> > +    enum:
>> > +      - fsl,ls1028a-qds-qixis-i2c
>> > +      - kontron,sl28cpld
>> 
>> Is there some relationship between these besides happening to use the
>> same driver? Sharing a generic driver is not a reason to have the same
>> binding doc.

Ahh didn't notice this. Yes that should probably go into an own binding.

>> Your DT has a mux-controller which is undocuemnted in this binding.
>> 
>> Rob
> 
> I'd guess they are both programmable FPGA's/CPLD's that are used for
> board control. What I don't know is whether the sources for the Kontron
> bit stream are derived in any way from the QIXIS.

I can 100% guarantee that is not the case ;)

> I can look into adding a separate binding doc for the QIXIS anyway.

-michael
