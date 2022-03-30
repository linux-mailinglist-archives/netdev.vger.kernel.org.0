Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1C6964EC9C2
	for <lists+netdev@lfdr.de>; Wed, 30 Mar 2022 18:36:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348856AbiC3QiJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Mar 2022 12:38:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244806AbiC3Qhx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Mar 2022 12:37:53 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E407C144B60;
        Wed, 30 Mar 2022 09:36:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=ALx8ARvWqSkByuqgzD/rMzGpI9BdpJ6pBXa8AsrOFxA=; b=CPOWA5ININhL05ojuoEkeHuNuU
        cEYdETw3a70DK4U5wPGl/VU6HrTn5oSnArEajcgUdD95uZocLCIH7GoST3wO003+MKkteqnbbt8yV
        M8YICMTPZVMA9KycIEPLqaex+E5KTmCB9jRVFaLKWcz0FU0vnlxdz5gKMdRm1k6+wXR0+L4ZLyMXj
        Xuy+Whmv1WAfdIs6LPV90DtIUPjGfMfMoV1slspt9E1vU47LKB0frosFMy+4Ojos9b2JMLbvhe864
        H64Amy5UHljCpMHv8oCGdWZrlDzydn8ViTS4pE8LCx6IjDDUCNfADHrRWrprz7aJuNuSeMj3sxueK
        M7IQo0GA==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:58022)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1nZbId-0003Su-LW; Wed, 30 Mar 2022 17:35:59 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1nZbIc-0006m8-9u; Wed, 30 Mar 2022 17:35:58 +0100
Date:   Wed, 30 Mar 2022 17:35:58 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Rob Herring <robh+dt@kernel.org>
Cc:     Ioana Ciornei <ioana.ciornei@nxp.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Krzysztof Kozlowski <krzk@kernel.org>
Subject: Re: [PATCH net-next] dt-bindings: net: convert sff,sfp to dtschema
Message-ID: <YkSG7oBcDe6lTCOO@shell.armlinux.org.uk>
References: <20220315123315.233963-1-ioana.ciornei@nxp.com>
 <6f4f2e6f-3aee-3424-43bc-c60ef7c0218c@canonical.com>
 <20220315190733.lal7c2xkaez6fz2v@skbuf>
 <deed2e82-0d93-38d9-f7a2-4137fa0180e6@canonical.com>
 <20220316101854.imevzoqk6oashrgg@skbuf>
 <YkR8tTWabfTRLarB@shell.armlinux.org.uk>
 <CAL_JsqKFbU6VyLu+as_bZxWsfHRf5mJGeExjZ2ZJQqOcJchC+g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAL_JsqKFbU6VyLu+as_bZxWsfHRf5mJGeExjZ2ZJQqOcJchC+g@mail.gmail.com>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 30, 2022 at 11:09:42AM -0500, Rob Herring wrote:
> On Wed, Mar 30, 2022 at 10:52 AM Russell King (Oracle)
> <linux@armlinux.org.uk> wrote:
> >
> > On Wed, Mar 16, 2022 at 10:18:55AM +0000, Ioana Ciornei wrote:
> > > On Wed, Mar 16, 2022 at 09:23:45AM +0100, Krzysztof Kozlowski wrote:
> > > > On 15/03/2022 20:07, Ioana Ciornei wrote:
> > > > > On Tue, Mar 15, 2022 at 07:21:59PM +0100, Krzysztof Kozlowski wrote:
> > > > >> On 15/03/2022 13:33, Ioana Ciornei wrote:
> > > > >>> Convert the sff,sfp.txt bindings to the DT schema format.
> > > > >>>
> > > > >>> Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
> > > > >>> ---
> > > > >
> > > > > (..)
> > > > >
> > > > >>> +maintainers:
> > > > >>> +  - Russell King <linux@armlinux.org.uk>
> > > > >>> +
> > > > >>> +properties:
> > > > >>> +  compatible:
> > > > >>> +    enum:
> > > > >>> +      - sff,sfp  # for SFP modules
> > > > >>> +      - sff,sff  # for soldered down SFF modules
> > > > >>> +
> > > > >>> +  i2c-bus:
> > > > >>
> > > > >> Thanks for the conversion.
> > > > >>
> > > > >> You need here a type because this does not look like standard property.
> > > > >
> > > > > Ok.
> > > > >
> > > > >>
> > > > >>> +    description:
> > > > >>> +      phandle of an I2C bus controller for the SFP two wire serial
> > > > >>> +
> > > > >>> +  maximum-power-milliwatt:
> > > > >>> +    maxItems: 1
> > > > >>> +    description:
> > > > >>> +      Maximum module power consumption Specifies the maximum power consumption
> > > > >>> +      allowable by a module in the slot, in milli-Watts. Presently, modules can
> > > > >>> +      be up to 1W, 1.5W or 2W.
> > > > >>> +
> > > > >>> +patternProperties:
> > > > >>> +  "mod-def0-gpio(s)?":
> > > > >>
> > > > >> This should be just "mod-def0-gpios", no need for pattern. The same in
> > > > >> all other places.
> > > > >>
> > > > >
> > > > > The GPIO subsystem accepts both suffixes: "gpio" and "gpios", see
> > > > > gpio_suffixes[]. If I just use "mod-def0-gpios" multiple DT files will
> > > > > fail the check because they are using the "gpio" suffix.
> > > > >
> > > > > Why isn't this pattern acceptable?
> > > >
> > > > Because original bindings required gpios, so DTS are wrong, and the
> > > > pattern makes it difficult to grep and read such simple property.
> > > >
> > > > The DTSes which do not follow bindings should be corrected.
> > > >
> > >
> > > Russell, do you have any thoughts on this?
> > > I am asking this because you were the one that added the "-gpios" suffix
> > > in the dtbinding and the "-gpio" usage in the DT files so I wouldn't
> > > want this to diverge from your thinking.
> > >
> > > Do you have a preference?
> >
> > SFP support predated (in my tree) the deprecation of the -gpio suffix,
> > and despite the SFP binding doc being sent for review, it didn't get
> > reviewed so the issue was never picked up.
> 
> Really?
> 
> https://lore.kernel.org/all/CAL_JsqL_7gG8FSEJDXu=37DFpHjfLhQuUhPFRKcScYTzM4cNyg@mail.gmail.com/

Yes. I said "in my tree" not "in Linus' tree". It dates from shortly
after the first SolidRun Clearfog arrived here, first set of patches
were based on v4.3-rc2.

Remember, when development eventually gets submitted as patches, even
if there are no changes, if the patches are then applied, they get the
date of the _email_ not of their creation, and there can be several
years between creation and submission.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
