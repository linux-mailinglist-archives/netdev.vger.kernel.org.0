Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 217076062D5
	for <lists+netdev@lfdr.de>; Thu, 20 Oct 2022 16:19:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230140AbiJTOTg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Oct 2022 10:19:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229915AbiJTOTc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Oct 2022 10:19:32 -0400
Received: from mail-oa1-f44.google.com (mail-oa1-f44.google.com [209.85.160.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6539C15729;
        Thu, 20 Oct 2022 07:19:23 -0700 (PDT)
Received: by mail-oa1-f44.google.com with SMTP id 586e51a60fabf-1322fa1cf6fso24738476fac.6;
        Thu, 20 Oct 2022 07:19:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZQA4zHCWOG6JtSjIux+oIJ8z02fbQmgoWttTrOvBmtE=;
        b=BHg/UIcuMUZhPsCOBLsh4vUylbKIpHHFjvk9M3Zqu2NSezLJoJJOGh9cC5hUgB4hdw
         zwRSUcED2fnI6HQqZbPAfFLVqteBbddQiSrb75iqHY+D/T8vfZiDQSlmu+K66NSipJZ6
         wHNNEkw3qT0Na4oHikeQ/GqFlAdKBTLn5cc7zxHY1A1EqYlY0M1u/vkcUZbR91eE/ndl
         kRJIbYPJ0KK+AYmuwf9irGEaff7NL0UjO10O9dMzxCG8Nh2yLYLeCjmj6LhqkU+J88qJ
         u5yeC3Y9cWcq1QuKu43K/eeO7Oe0/3alE3cqbDPATZi83hNY0mXovxMC5eNazHBnL/JL
         baow==
X-Gm-Message-State: ACrzQf3exMJqssL8pEB/O/q4KYevRA1hFN8TQhAomyO00YkuWXBfsYDg
        5cttZnf7RXmIM/Ku4NcaXC1Z2KDeHQ==
X-Google-Smtp-Source: AMsMyM7+OPQ2nhT7GF8f+yaKX/yIx6U1whQEd5yAAKfycoJMbVizk0ZgSSi1xHK1U7YIr6x/wqOVhQ==
X-Received: by 2002:a05:6870:a2d1:b0:131:a8bc:54db with SMTP id w17-20020a056870a2d100b00131a8bc54dbmr26030239oak.187.1666275562209;
        Thu, 20 Oct 2022 07:19:22 -0700 (PDT)
Received: from robh_at_kernel.org (66-90-144-107.dyn.grandenetworks.net. [66.90.144.107])
        by smtp.gmail.com with ESMTPSA id w192-20020acaadc9000000b00353f41440dasm7731677oie.56.2022.10.20.07.19.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Oct 2022 07:19:21 -0700 (PDT)
Received: (nullmailer pid 1258299 invoked by uid 1000);
        Thu, 20 Oct 2022 14:19:23 -0000
Date:   Thu, 20 Oct 2022 09:19:23 -0500
From:   Rob Herring <robh@kernel.org>
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH net-next 1/7] dt-bindings: net: sff,sfp: update binding
Message-ID: <20221020141923.GA1252205-robh@kernel.org>
References: <Y0/7dAB8OU3jrbz6@shell.armlinux.org.uk>
 <E1ol97m-00EDSR-46@rmk-PC.armlinux.org.uk>
 <166622204824.13053.10147527260423850821.robh@kernel.org>
 <Y1EGqR6IEhPfx7gd@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y1EGqR6IEhPfx7gd@shell.armlinux.org.uk>
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,
        FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 20, 2022 at 09:28:25AM +0100, Russell King (Oracle) wrote:
> On Wed, Oct 19, 2022 at 06:31:53PM -0500, Rob Herring wrote:
> > On Wed, 19 Oct 2022 14:28:46 +0100, Russell King (Oracle) wrote:
> > > Add a minimum and default for the maximum-power-milliwatt option;
> > > module power levels were originally up to 1W, so this is the default
> > > and the minimum power level we can have for a functional SFP cage.
> > > 
> > > Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
> > > ---
> > >  Documentation/devicetree/bindings/net/sff,sfp.yaml | 2 ++
> > >  1 file changed, 2 insertions(+)
> > > 
> > 
> > My bot found errors running 'make DT_CHECKER_FLAGS=-m dt_binding_check'
> > on your patch (DT_CHECKER_FLAGS is new in v5.13):
> > 
> > yamllint warnings/errors:
> > 
> > dtschema/dtc warnings/errors:
> > /builds/robherring/dt-review-ci/linux/Documentation/devicetree/bindings/net/sff,sfp.yaml: properties:maximum-power-milliwatt: 'minimum' should not be valid under {'enum': ['const', 'enum', 'exclusiveMaximum', 'exclusiveMinimum', 'minimum', 'maximum', 'multipleOf', 'pattern']}
> > 	hint: Scalar and array keywords cannot be mixed
> > 	from schema $id: http://devicetree.org/meta-schemas/keywords.yaml#
> 
> I'm reading that error message and it means absolutely nothing to me.
> Please can you explain it (and also re-word it to be clearer)?

'maxItems' is a constraint for arrays. 'maximum' is a constraint for 
scalar values. Mixing them does not make sense.

I have little control over the 1st line as that comes from jsonschema 
package. 'hint' is what I've added to explain things a bit more.

Rob
