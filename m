Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2FE744E4235
	for <lists+netdev@lfdr.de>; Tue, 22 Mar 2022 15:46:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238137AbiCVOrl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Mar 2022 10:47:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236277AbiCVOrj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Mar 2022 10:47:39 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BEE176FA09;
        Tue, 22 Mar 2022 07:46:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1647960369; x=1679496369;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=zP725tvXUiO7zKOyNAbjmJfwuMlzSbKo9AwbYYlFB/U=;
  b=gxmJV7osb3tq9BvThiJENUb79TnL85WN3ES3AP6N44fswtIu+F8UVDkZ
   2FlqtICeHbmk70FIa3kjvDZ0BrLDIEDiKlLoiS/N8wtwys4LlNLKiqkzt
   cslAjMA4p4yWehXQjcdxZqO5G0H5TucFXoVXc3WnC1o5ivCzspMw7fOhE
   fhSi4bQUvQh37+pgVeHQX6/PGJHfmzdBAouZWNQ7mUmzsa8z1QuSgILC3
   O0JshWB2D83DIL6oJYWfFA6bCO6FNANVA76zUmZavqLZMJA0lg8YA3x+k
   kmoddcWSRCUEguCLDTVLdFz1tRrKOmPAv4Ph2I2+8FXHz8jPlpN4so+eg
   Q==;
X-IronPort-AV: E=Sophos;i="5.90,201,1643698800"; 
   d="scan'208";a="152834847"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 22 Mar 2022 07:46:08 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.87.72) by
 chn-vm-ex02.mchp-main.com (10.10.87.72) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Tue, 22 Mar 2022 07:46:08 -0700
Received: from CHE-LT-I21427LX.microchip.com (10.10.115.15) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server id
 15.1.2375.17 via Frontend Transport; Tue, 22 Mar 2022 07:46:02 -0700
Message-ID: <7526eff194e4dcfec1b8d88fc30b22aeb83e3100.camel@microchip.com>
Subject: Re: [PATCH v9 net-next 02/11] dt-bindings: net: add mdio property
From:   Prasanna Vengateshan <prasanna.vengateshan@microchip.com>
To:     Rob Herring <robh@kernel.org>
CC:     <andrew@lunn.ch>, <netdev@vger.kernel.org>, <olteanv@gmail.com>,
        <UNGLinuxDriver@microchip.com>, <woojung.huh@microchip.com>,
        <hkallweit1@gmail.com>, <linux@armlinux.org.uk>,
        <davem@davemloft.net>, <kuba@kernel.org>,
        <linux-kernel@vger.kernel.org>, <vivien.didelot@gmail.com>,
        <f.fainelli@gmail.com>, <devicetree@vger.kernel.org>
Date:   Tue, 22 Mar 2022 20:16:00 +0530
In-Reply-To: <YjkJxykT2dQxe3d/@robh.at.kernel.org>
References: <20220318085540.281721-1-prasanna.vengateshan@microchip.com>
         <20220318085540.281721-3-prasanna.vengateshan@microchip.com>
         <YjkJxykT2dQxe3d/@robh.at.kernel.org>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.40.0-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 2022-03-21 at 18:27 -0500, Rob Herring wrote:
> EXTERNAL EMAIL: Do not click links or open attachments unless you know the
> content is safe
> 
> On Fri, Mar 18, 2022 at 02:25:31PM +0530, Prasanna Vengateshan wrote:
> > mdio bus is applicable to any switch hence it is added as per the below
> > request,
> > https://lore.kernel.org/netdev/1300f84832ef1c43ecb9edb311fb817e3aab5420.camel@microchip.com/
> 
> Quoting that thread:
> 
> > Yes indeed, since this is a common property of all DSA switches, it can
> > be defined or not depending on whether the switch does have an internal
> > MDIO bus controller or not.
> 
> Whether or not a switch has an MDIO controller or not is a property of
> that switch and therefore 'mdio' needs to be documented in those switch
> bindings.
> 
> > 
> > Signed-off-by: Prasanna Vengateshan <prasanna.vengateshan@microchip.com>
> > ---
> >  Documentation/devicetree/bindings/net/dsa/dsa.yaml | 4 ++++
> >  1 file changed, 4 insertions(+)
> > 
> > diff --git a/Documentation/devicetree/bindings/net/dsa/dsa.yaml
> > b/Documentation/devicetree/bindings/net/dsa/dsa.yaml
> > index b9d48e357e77..0f8426e219eb 100644
> > --- a/Documentation/devicetree/bindings/net/dsa/dsa.yaml
> > +++ b/Documentation/devicetree/bindings/net/dsa/dsa.yaml
> > @@ -31,6 +31,10 @@ properties:
> >        switch 1. <1 0> is cluster 1, switch 0. A switch not part of any
> > cluster
> >        (single device hanging off a CPU port) must not specify this property
> >      $ref: /schemas/types.yaml#/definitions/uint32-array
> > +
> > +  mdio:
> > +    $ref: /schemas/net/mdio.yaml#
> > +    unevaluatedProperties: false
> 
> From a schema standpoint, this bans every switch from adding additional
> properties under an mdio node. Not likely what you want.
> 
> Rob

Thanks for the feedback. Do you mean that the 'unevaluatedProperties: false' to
be removed, so that the additional properties can be added? or mdio is not
supposed to be defined in the dsa.yaml ?


