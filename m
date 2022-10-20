Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 74C77606568
	for <lists+netdev@lfdr.de>; Thu, 20 Oct 2022 18:08:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230247AbiJTQId (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Oct 2022 12:08:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230045AbiJTQIb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Oct 2022 12:08:31 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E54C1213EE;
        Thu, 20 Oct 2022 09:08:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=Tu4U+lQnvDeK4WfdirToag/wlMxNrMbWVorqMwlhqtM=; b=u+iIlvdsFZyNWyaK+vQJhzNpjX
        FautNPth7Z3euRWWBWFNtE+M0OyfS5TUvl893+xNaNLdVX09ZVuItxXOG8EreDsTJBHOJnKEsNUqP
        JJRGR+1QQGjAr5H1vu9plxC1pXF/B7wQ+nTIHZbtNSNy0Atz+OWW2Ch7Rf51OXKFa8x/gCVOuEnjR
        WoRLGaW+Im5ltPflzVOrrrmQi3Xwk5YUxhZSjm/MeCXdXxPWH499MUyIUq1UrgP381wIHM6eE1tyC
        sd0MsAEuD93vdvcbHnAD/shcK3KU6+cst0VZsEZLik8HVK5kanhVklGh2IqbHVezDkNu/RSBALAHK
        QHZIfqvw==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:34826)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1olY5n-0007T4-05; Thu, 20 Oct 2022 17:08:23 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1olY5l-0003HR-7b; Thu, 20 Oct 2022 17:08:21 +0100
Date:   Thu, 20 Oct 2022 17:08:21 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Rob Herring <robh@kernel.org>
Cc:     Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH net-next 1/7] dt-bindings: net: sff,sfp: update binding
Message-ID: <Y1FydexHzzOKS1V+@shell.armlinux.org.uk>
References: <Y0/7dAB8OU3jrbz6@shell.armlinux.org.uk>
 <E1ol97m-00EDSR-46@rmk-PC.armlinux.org.uk>
 <166622204824.13053.10147527260423850821.robh@kernel.org>
 <Y1EGqR6IEhPfx7gd@shell.armlinux.org.uk>
 <20221020141923.GA1252205-robh@kernel.org>
 <CAL_JsqKn0bn4nnzXXyZEVv9ZsFA6UXpV2SDHW7nkncH3Z3tsKA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAL_JsqKn0bn4nnzXXyZEVv9ZsFA6UXpV2SDHW7nkncH3Z3tsKA@mail.gmail.com>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 20, 2022 at 09:27:44AM -0500, Rob Herring wrote:
> On Thu, Oct 20, 2022 at 9:19 AM Rob Herring <robh@kernel.org> wrote:
> >
> > On Thu, Oct 20, 2022 at 09:28:25AM +0100, Russell King (Oracle) wrote:
> > > On Wed, Oct 19, 2022 at 06:31:53PM -0500, Rob Herring wrote:
> > > > On Wed, 19 Oct 2022 14:28:46 +0100, Russell King (Oracle) wrote:
> > > > > Add a minimum and default for the maximum-power-milliwatt option;
> > > > > module power levels were originally up to 1W, so this is the default
> > > > > and the minimum power level we can have for a functional SFP cage.
> > > > >
> > > > > Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
> > > > > ---
> > > > >  Documentation/devicetree/bindings/net/sff,sfp.yaml | 2 ++
> > > > >  1 file changed, 2 insertions(+)
> > > > >
> > > >
> > > > My bot found errors running 'make DT_CHECKER_FLAGS=-m dt_binding_check'
> > > > on your patch (DT_CHECKER_FLAGS is new in v5.13):
> > > >
> > > > yamllint warnings/errors:
> > > >
> > > > dtschema/dtc warnings/errors:
> > > > /builds/robherring/dt-review-ci/linux/Documentation/devicetree/bindings/net/sff,sfp.yaml: properties:maximum-power-milliwatt: 'minimum' should not be valid under {'enum': ['const', 'enum', 'exclusiveMaximum', 'exclusiveMinimum', 'minimum', 'maximum', 'multipleOf', 'pattern']}
> > > >     hint: Scalar and array keywords cannot be mixed
> > > >     from schema $id: http://devicetree.org/meta-schemas/keywords.yaml#
> > >
> > > I'm reading that error message and it means absolutely nothing to me.
> > > Please can you explain it (and also re-word it to be clearer)?
> >
> > 'maxItems' is a constraint for arrays. 'maximum' is a constraint for
> > scalar values. Mixing them does not make sense.
> 
> TBC, dropping 'maxItems' is what is needed here.

So how does this work?

maxItems: 1

tells it that there should be an array of one property, which is at the
DT level fundamentally the same as a scalar property.

minimum:
default:
maximum:

tells it that this is a scalar property, so there should be exactly one
item or the property should not be mentioned?

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
