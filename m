Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A65A357B107
	for <lists+netdev@lfdr.de>; Wed, 20 Jul 2022 08:25:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239797AbiGTGZM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jul 2022 02:25:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231855AbiGTGZL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Jul 2022 02:25:11 -0400
Received: from mx1.tq-group.com (mx1.tq-group.com [93.104.207.81])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2644A261B;
        Tue, 19 Jul 2022 23:25:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=tq-group.com; i=@tq-group.com; q=dns/txt; s=key1;
  t=1658298309; x=1689834309;
  h=subject:from:to:cc:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=9fMBUYBQ6Nrvmz4yHYqzLSOHfp4ZNWCyYFk+3uuzu2M=;
  b=lSD0UpT0+kNIQe8XGvwT7+OEGWEJJEwnEo0noZ+P84uYXnysUC2aPIDQ
   kYXBGXiyJu8bm6TfdECqJKv79UAIlYn4MSNnoXpVWziaQLTW8hj2e7fww
   wox0+Nk8zav1+QJj6eJgN6J4i2hyJfBp+Kwz/Z73E3Zxq0tfMOeoS74jv
   Da/ewZSsfgw+Ap/iSy0btjbIW2aw7exos7k6efC79qsiOnL1awNtlGgy1
   s5xD5x/9d5GsruwVue1QPeM5JIG/Ly56fTK+xLbNviprrksSdqWF3DM3x
   JQdFjci5A/i2mAp6GCYSy6Pxv+cf27dTBIV5u/qyHgQebEcjiR0hcN6xN
   A==;
X-IronPort-AV: E=Sophos;i="5.92,286,1650924000"; 
   d="scan'208";a="25147044"
Received: from unknown (HELO tq-pgp-pr1.tq-net.de) ([192.168.6.15])
  by mx1-pgp.tq-group.com with ESMTP; 20 Jul 2022 08:25:07 +0200
Received: from mx1.tq-group.com ([192.168.6.7])
  by tq-pgp-pr1.tq-net.de (PGP Universal service);
  Wed, 20 Jul 2022 08:25:07 +0200
X-PGP-Universal: processed;
        by tq-pgp-pr1.tq-net.de on Wed, 20 Jul 2022 08:25:07 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=tq-group.com; i=@tq-group.com; q=dns/txt; s=key1;
  t=1658298307; x=1689834307;
  h=from:to:cc:date:message-id:in-reply-to:references:
   mime-version:content-transfer-encoding:subject;
  bh=9fMBUYBQ6Nrvmz4yHYqzLSOHfp4ZNWCyYFk+3uuzu2M=;
  b=HWmvKm967HfTgH98QDXy5rLJsdrmDEG33OErpJluWqFtTDfr7j6WiATE
   y1DcVIN/Svn0GGSWyuXZaM+aDqaDIcjs0SmnydS40rs6tWoaEP+WTfoW4
   uKavOLamEdX0LqM/2axQzjdHt1d9/HLH72/F0YNounsm82ybDWTTHKxRH
   MeFnerljCB8Eo+rIgrIF1nTH7potW39typUMtCrKLTsxV7oBkiVEBSkEa
   aPEcwYaGbZa2rfGHZztlv7QXboiFya7AmJwX+XCZuEf9w9s8UUAb0fPmQ
   4k+HccAxMSq9TfmOSr3CvLxrWgrPKkNOTCvXg+kua4lI1B7h6DUl5fHO8
   w==;
X-IronPort-AV: E=Sophos;i="5.92,286,1650924000"; 
   d="scan'208";a="25147043"
Subject: Re: Re: [PATCH v2 1/1] dt-bindings: net: fsl,
 fec: Add nvmem-cells / nvmem-cell-names properties
Received: from vtuxmail01.tq-net.de ([10.115.0.20])
  by mx1.tq-group.com with ESMTP; 20 Jul 2022 08:25:06 +0200
Received: from steina-w.localnet (unknown [10.123.49.12])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by vtuxmail01.tq-net.de (Postfix) with ESMTPSA id C2B33280056;
        Wed, 20 Jul 2022 08:25:06 +0200 (CEST)
From:   Alexander Stein <alexander.stein@ew.tq-group.com>
To:     Rob Herring <robh@kernel.org>
Cc:     Joakim Zhang <qiangqing.zhang@nxp.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org
Date:   Wed, 20 Jul 2022 08:25:04 +0200
Message-ID: <1924174.PYKUYFuaPT@steina-w>
Organization: TQ-Systems GmbH
In-Reply-To: <20220718215016.GA3615606-robh@kernel.org>
References: <20220715080640.881316-1-alexander.stein@ew.tq-group.com> <20220718215016.GA3615606-robh@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Am Montag, 18. Juli 2022, 23:50:16 CEST schrieb Rob Herring:
> On Fri, Jul 15, 2022 at 10:06:40AM +0200, Alexander Stein wrote:
> > These properties are inherited from ethernet-controller.yaml.
> > This fixes the dt_binding_check warning:
> > imx8mm-tqma8mqml-mba8mx.dt.yaml: ethernet@30be0000: 'nvmem-cell-names',
> > 'nvmem-cells' do not match any of the regexes: 'pinctrl-[0-9]+'
> > 
> > Signed-off-by: Alexander Stein <alexander.stein@ew.tq-group.com>
> > ---
> > Changes in v2:
> > * Add amount and names of nvmem-cells (copied from
> > ethernet-controller.yaml)> 
> >  Documentation/devicetree/bindings/net/fsl,fec.yaml | 8 ++++++++
> >  1 file changed, 8 insertions(+)
> > 
> > diff --git a/Documentation/devicetree/bindings/net/fsl,fec.yaml
> > b/Documentation/devicetree/bindings/net/fsl,fec.yaml index
> > daa2f79a294f..b5b55dca08cb 100644
> > --- a/Documentation/devicetree/bindings/net/fsl,fec.yaml
> > +++ b/Documentation/devicetree/bindings/net/fsl,fec.yaml
> > 
> > @@ -121,6 +121,14 @@ properties:
> >    mac-address: true
> > 
> > +  nvmem-cells:
> > +    maxItems: 1
> > +    description:
> > +      Reference to an nvmem node for the MAC address
> > +
> > +  nvmem-cell-names:
> > +    const: mac-address
> 
> Sorry, steered you wrong on this. I didn't realize
> ethernet-controller.yaml already defined these. You just need
> 'unevaluatedProperties: false' instead additionalProperties.

Ok, will come up with a new version.

> I'm not sure what the FIXME for the additionalProperties is all about
> though.

I guess this is about the deprecated properties (phy-reset-gpios, phy-reset-
duration, phy-reset-active-high, phy-reset-post-delay), which you can see in 
the example. There is e.g. phy-reset-gpios and put to MAC node, but nowadays 
this should be reset-gpios property in PHY node (see ethernet-phy.yaml)
Unfortunately you can't get rid of it until a single, common MDIO bus is 
supported by multiple fec instances, see [1].

Best regards,
Alexander

[1] https://www.spinics.net/lists/kernel/msg4110563.html



