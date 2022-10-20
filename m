Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2927F60630F
	for <lists+netdev@lfdr.de>; Thu, 20 Oct 2022 16:32:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229673AbiJTOcC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Oct 2022 10:32:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229535AbiJTOcB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Oct 2022 10:32:01 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89F04EAA;
        Thu, 20 Oct 2022 07:32:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=xFmjSHPX73AcikU1mQLkkvYG12kXurGPaydIf61YTSU=; b=Kvzple/+RYe96lGPBTm7RzQ99h
        GAe8YDfHWclKBh5uhFWtKaUhT+fZa+WWIBCP2UHljFkKUHJ6Gtb8wK1PV87bRwMUAmPDXPXsmeuek
        qQb9l0gJY8/Af6rPOkjPgEfOP7eAXegIkBMpsmsMcdEgqLtfQV4K0pJkgqK80RxdSsIEdwRByDkZz
        7+wzAT6ON4a+qiarNfThlutvYXhQ8apCAEWDyRWeTuBVw/ZX3LeEuZO+ScN24bf6C5uaiv7epRzwd
        G4m57ZEReynEqEiaUX6UHuPRpyMl2kPQzfL1vlPJiDy/Dd1fqs1nY3D3bY7Vaayf/5Ha09Ag5E2RN
        tR8T4VpQ==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:34824)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1olWaP-0007Jm-Bz; Thu, 20 Oct 2022 15:31:53 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1olWaN-0003EJ-I6; Thu, 20 Oct 2022 15:31:51 +0100
Date:   Thu, 20 Oct 2022 15:31:51 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Rob Herring <robh@kernel.org>
Cc:     Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH net-next 1/7] dt-bindings: net: sff,sfp: update binding
Message-ID: <Y1Fb14s5pTcQa53V@shell.armlinux.org.uk>
References: <Y0/7dAB8OU3jrbz6@shell.armlinux.org.uk>
 <E1ol97m-00EDSR-46@rmk-PC.armlinux.org.uk>
 <166622204824.13053.10147527260423850821.robh@kernel.org>
 <Y1EGqR6IEhPfx7gd@shell.armlinux.org.uk>
 <20221020141923.GA1252205-robh@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221020141923.GA1252205-robh@kernel.org>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 20, 2022 at 09:19:23AM -0500, Rob Herring wrote:
> On Thu, Oct 20, 2022 at 09:28:25AM +0100, Russell King (Oracle) wrote:
> > On Wed, Oct 19, 2022 at 06:31:53PM -0500, Rob Herring wrote:
> > > On Wed, 19 Oct 2022 14:28:46 +0100, Russell King (Oracle) wrote:
> > > > Add a minimum and default for the maximum-power-milliwatt option;
> > > > module power levels were originally up to 1W, so this is the default
> > > > and the minimum power level we can have for a functional SFP cage.
> > > > 
> > > > Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
> > > > ---
> > > >  Documentation/devicetree/bindings/net/sff,sfp.yaml | 2 ++
> > > >  1 file changed, 2 insertions(+)
> > > > 
> > > 
> > > My bot found errors running 'make DT_CHECKER_FLAGS=-m dt_binding_check'
> > > on your patch (DT_CHECKER_FLAGS is new in v5.13):
> > > 
> > > yamllint warnings/errors:
> > > 
> > > dtschema/dtc warnings/errors:
> > > /builds/robherring/dt-review-ci/linux/Documentation/devicetree/bindings/net/sff,sfp.yaml: properties:maximum-power-milliwatt: 'minimum' should not be valid under {'enum': ['const', 'enum', 'exclusiveMaximum', 'exclusiveMinimum', 'minimum', 'maximum', 'multipleOf', 'pattern']}
> > > 	hint: Scalar and array keywords cannot be mixed
> > > 	from schema $id: http://devicetree.org/meta-schemas/keywords.yaml#
> > 
> > I'm reading that error message and it means absolutely nothing to me.
> > Please can you explain it (and also re-word it to be clearer)?
> 
> 'maxItems' is a constraint for arrays. 'maximum' is a constraint for 
> scalar values. Mixing them does not make sense.
> 
> I have little control over the 1st line as that comes from jsonschema 
> package. 'hint' is what I've added to explain things a bit more.

Given that maximum-power-milliwatt is a single value and has never been
an array, it seems then that the original conversion to yaml was wrong.
What should it have been?

(I'm clueless what the difference is between an array and scalar in
this yaml stuff.)

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
