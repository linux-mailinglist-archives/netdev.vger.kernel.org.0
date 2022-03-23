Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 07A7F4E5873
	for <lists+netdev@lfdr.de>; Wed, 23 Mar 2022 19:34:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240135AbiCWSgC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Mar 2022 14:36:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230296AbiCWSgB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Mar 2022 14:36:01 -0400
Received: from mail-oi1-f177.google.com (mail-oi1-f177.google.com [209.85.167.177])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 712E462A20;
        Wed, 23 Mar 2022 11:34:25 -0700 (PDT)
Received: by mail-oi1-f177.google.com with SMTP id v75so2544219oie.1;
        Wed, 23 Mar 2022 11:34:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=41lt9wO4XOxtae4ixgjybXOjCGsLCMvP6pxSnzHlc2U=;
        b=gKrSccSMjlQahHEhAJQyLxCSddSS9QtxoJ8D/ODeXScYU4ya3IZg31WbOJIm93LkGR
         CR8B+VwE3UHDENCYoUzM6In+nzjnzMObDRbchxmSnXeXou8efvbK56xD33UG4awkBmJi
         UIurc+mzuaJhV4b7bV2TLpr/Bs4H1bdOLgqrV6NvtdmrIEI6tFu7FbUpWEDXVdB7dObu
         jek5jpZLq0HvPoDxex8hp9Lw5HGN//3PlQ11O+ItSLHwe1+vii97jc01ANkjj5K4tg9H
         BCIhyivR/DanNCApVyRultoSqy+uwiUmBad5nIdO8xPNbV3i5xUpKcZ8b9aIsYWWZVe7
         zT1A==
X-Gm-Message-State: AOAM533HPxIxE6OjzgpOpWDYWMzxai7Dpw6R3bIAfuvCnfb6XvnsLGvN
        oJl9zraN/BLTIcZD4PPmew==
X-Google-Smtp-Source: ABdhPJzEHUUE48Om5qA2PfSnOF4hpP7NVTqs6dal5024vnutRjT370DO2aHoDKzq8MOGAbO5mihgeQ==
X-Received: by 2002:a05:6808:118d:b0:2cc:ef90:3812 with SMTP id j13-20020a056808118d00b002ccef903812mr5383988oil.48.1648060464775;
        Wed, 23 Mar 2022 11:34:24 -0700 (PDT)
Received: from robh.at.kernel.org (66-90-144-107.dyn.grandenetworks.net. [66.90.144.107])
        by smtp.gmail.com with ESMTPSA id s82-20020acadb55000000b002d9ce64bea0sm263151oig.48.2022.03.23.11.34.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Mar 2022 11:34:23 -0700 (PDT)
Received: (nullmailer pid 221555 invoked by uid 1000);
        Wed, 23 Mar 2022 18:34:22 -0000
Date:   Wed, 23 Mar 2022 13:34:22 -0500
From:   Rob Herring <robh@kernel.org>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Chris Packham <Chris.Packham@alliedtelesis.co.nz>,
        "huziji@marvell.com" <huziji@marvell.com>,
        "ulf.hansson@linaro.org" <ulf.hansson@linaro.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "linus.walleij@linaro.org" <linus.walleij@linaro.org>,
        "catalin.marinas@arm.com" <catalin.marinas@arm.com>,
        "will@kernel.org" <will@kernel.org>,
        "gregory.clement@bootlin.com" <gregory.clement@bootlin.com>,
        "sebastian.hesselbarth@gmail.com" <sebastian.hesselbarth@gmail.com>,
        "adrian.hunter@intel.com" <adrian.hunter@intel.com>,
        "thomas.petazzoni@bootlin.com" <thomas.petazzoni@bootlin.com>,
        "kostap@marvell.com" <kostap@marvell.com>,
        "robert.marko@sartura.hr" <robert.marko@sartura.hr>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v2 1/8] dt-bindings: pinctrl: mvebu: Document bindings
 for AC5
Message-ID: <YjtoLkeyYsT6Fih5@robh.at.kernel.org>
References: <20220314213143.2404162-1-chris.packham@alliedtelesis.co.nz>
 <20220314213143.2404162-2-chris.packham@alliedtelesis.co.nz>
 <Yi/Y0iynQbIOo8C0@lunn.ch>
 <16fa529e-b1ca-11d0-f068-628c7f25a7fa@alliedtelesis.co.nz>
 <Yi/dhK0NXg9g6J9T@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yi/dhK0NXg9g6J9T@lunn.ch>
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,
        FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 15, 2022 at 01:27:48AM +0100, Andrew Lunn wrote:
> > I think it can. I vaguely remember seeing conditional clauses based on 
> > compatible strings in other yaml bindings.
> > 
> > I started a new binding document because I expected adding significant 
> > additions to the existing .txt files would be rejected. If I get some 
> > cycles I could look at converting the existing docs from txt to yaml.
> > 
> > I'm not sure that there will be much in the way of a common 
> > mvebu-pinctrl.yaml as you'd end up repeating most of the common stuff to 
> > make things conditional anyway.
> 
> We should wait for Rob to comment. But is suspect you are right, there
> will not be much savings.

It's always a judgement call of amount of if/then schema vs. duplicating 
the common parts. If it's the function/pin parts that vary, then that's 
probably best as separate schema for each case. Otherwise, I'm not sure 
without seeing something.

Rob
