Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A5381528CB3
	for <lists+netdev@lfdr.de>; Mon, 16 May 2022 20:15:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344618AbiEPSOr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 May 2022 14:14:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233662AbiEPSOn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 May 2022 14:14:43 -0400
Received: from mail-oa1-f45.google.com (mail-oa1-f45.google.com [209.85.160.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4F853DA44;
        Mon, 16 May 2022 11:14:42 -0700 (PDT)
Received: by mail-oa1-f45.google.com with SMTP id 586e51a60fabf-edeb6c3642so21251615fac.3;
        Mon, 16 May 2022 11:14:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=YTOcTjcksUgxwLMxNgyCUp09mpYRGThv4GSjr4Scpnw=;
        b=dZCa7TbdhqmYXDq2In631fB8O/kuG7YvczQwrlX3yvrhZsPJdgalQIOVOT0u53W8a5
         KCaCF1giN+geCu/5P3rIMe33NKscsBXn1poVZnZg+QxFsFuFua4/FEE5fWlil5a9g2fd
         fIUhp01xxoHy8B+eklV6R7psySBwoXbgQr1hxNBBYbi/PcQQLP1Ga236hjxqC0mFQxON
         y5xkcWqvZGI7Q0uom1OUCFld25AMVnx0X5D8OUgw/7KYZpPxc5YRA7YFAXARoQhRNsAu
         Q45LHT0v6Uj1falYER+p9+r440CITWIY4UEjnYF0HPPZnV9ME/iDItW9hLsfkWkpu/Xs
         1dKg==
X-Gm-Message-State: AOAM530sq41BBOmQNMS3z4Y3M4UQIyC7XRTopSr69uTjYTE5+OzfxOGX
        zpDtHicW4i7HCEsP0JcgWYIKQhjz0w==
X-Google-Smtp-Source: ABdhPJzlOJrAN8CAQ9e/lTg+Ojp5fI0TuUGrAMTn2J+1X3epWoZSVbV8q+U9o6p8305YV+hyTsa7pg==
X-Received: by 2002:a05:6870:6490:b0:f1:8489:e5f5 with SMTP id cz16-20020a056870649000b000f18489e5f5mr6373315oab.235.1652724882135;
        Mon, 16 May 2022 11:14:42 -0700 (PDT)
Received: from robh.at.kernel.org (66-90-144-107.dyn.grandenetworks.net. [66.90.144.107])
        by smtp.gmail.com with ESMTPSA id j9-20020aca3c09000000b00326bab99fe5sm4072675oia.40.2022.05.16.11.14.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 May 2022 11:14:41 -0700 (PDT)
Received: (nullmailer pid 3011567 invoked by uid 1000);
        Mon, 16 May 2022 18:14:40 -0000
Date:   Mon, 16 May 2022 13:14:40 -0500
From:   Rob Herring <robh@kernel.org>
To:     Andrew Lunn <andrew@lunn.ch>, Jakub Kicinski <kuba@kernel.org>,
        Chris Packham <chris.packham@alliedtelesis.co.nz>
Cc:     davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
        krzysztof.kozlowski+dt@linaro.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] dt-bindings: net: orion-mdio: Convert to JSON schema
Message-ID: <20220516181440.GA2997786-robh@kernel.org>
References: <20220505210621.3637268-1-chris.packham@alliedtelesis.co.nz>
 <20220509172814.31f83802@kernel.org>
 <Ynm0tm7/05ye9z6v@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Ynm0tm7/05ye9z6v@lunn.ch>
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,
        FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 10, 2022 at 02:41:26AM +0200, Andrew Lunn wrote:
> On Mon, May 09, 2022 at 05:28:14PM -0700, Jakub Kicinski wrote:
> > On Fri,  6 May 2022 09:06:20 +1200 Chris Packham wrote:
> > > Subject: [PATCH v2] dt-bindings: net: orion-mdio: Convert to JSON schema
> > 
> > JSON or YAML?

I actually prefer 'DT schema format' which implicitly means json-schema 
vocabulary in YAML formatted files (among other constraints we place on 
them).

> 
> JAML is a superset of JSON. So it is not completely wrong. I've no
> idea if this particular binding sticks to the subset which is JSON.

I think you just invented a new term for 'JSON compatible YAML subset'.

Rob
