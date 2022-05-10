Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0366A520A55
	for <lists+netdev@lfdr.de>; Tue, 10 May 2022 02:44:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233771AbiEJAsA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 May 2022 20:48:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230517AbiEJAr6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 May 2022 20:47:58 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B30B16A248;
        Mon,  9 May 2022 17:44:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 22FC0B818E1;
        Tue, 10 May 2022 00:44:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E70DC385C5;
        Tue, 10 May 2022 00:43:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652143438;
        bh=xvMnKGsMcMqPfbFLid+FMJPhYTuxpDEVpEnVK4EkZVQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=YKWENu/wjT1mmbPQjtKBOEdnkqZJ50knPw/iQGEbojJ19WtDyKXc1+Q+hQU9yXmOm
         GFPlAFX0p/wtlXL2l+onAjder1KXVcYhO45swnslQxDmToouGEprIo2tcNQ/6vi4b3
         mPlzPq62KwCWin7prdhYoa8QTrOk8q8oPn2B1aOfxFyTt088O7g6MQqoHjX2TuFqFT
         j91JFZmKWDkmvh4+hbbQtzMzhwi3BcopxLVmI4wWV1NF6ISSTa4yZzvhfgcMhSIaYy
         5EzRPDCacuh0p+6TTtAAl9XleeTaPTH7sx+KTWIwMaXn4NVhw56+t8oANnCS0WRQp5
         RbSxvHZYYuJPw==
Date:   Mon, 9 May 2022 17:43:57 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Chris Packham <chris.packham@alliedtelesis.co.nz>,
        davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
        robh+dt@kernel.org, krzysztof.kozlowski+dt@linaro.org,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] dt-bindings: net: orion-mdio: Convert to JSON schema
Message-ID: <20220509174357.7ea67d37@kernel.org>
In-Reply-To: <Ynm0tm7/05ye9z6v@lunn.ch>
References: <20220505210621.3637268-1-chris.packham@alliedtelesis.co.nz>
        <20220509172814.31f83802@kernel.org>
        <Ynm0tm7/05ye9z6v@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 10 May 2022 02:41:26 +0200 Andrew Lunn wrote:
> On Mon, May 09, 2022 at 05:28:14PM -0700, Jakub Kicinski wrote:
> > On Fri,  6 May 2022 09:06:20 +1200 Chris Packham wrote:  
> > > Subject: [PATCH v2] dt-bindings: net: orion-mdio: Convert to JSON schema  
> > 
> > JSON or YAML?  
> 
> JAML is a superset of JSON. So it is not completely wrong. I've no
> idea if this particular binding sticks to the subset which is JSON.

I hope you mean s/JAML/YAML/ otherwise I'm completely confused :)
