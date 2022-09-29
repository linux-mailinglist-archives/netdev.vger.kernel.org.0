Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E4D095EF967
	for <lists+netdev@lfdr.de>; Thu, 29 Sep 2022 17:47:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235756AbiI2PrX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Sep 2022 11:47:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235960AbiI2PrC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Sep 2022 11:47:02 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D45381869BC;
        Thu, 29 Sep 2022 08:45:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=ippxXlxAfdtPBqTbEjxB/QrdTYKNAml5gfgFwaIrYTI=; b=LNXrWcob64fBJ7qiE+e8Ej4BFv
        bQhBHul/x8UkaxKQzgzq8L56pvKMgBK8WIWV45c5A+chAnT8ZV0YG3m5mQvtI45FlwvPmhTEU6cdu
        bsITMMmhjRRSAZ7a5o5MiSFoe0DctlZNKtWlYiXj6ngMZGwY2kLMGOzEY9X1+um9xcOU=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1odvjR-000d8c-IO; Thu, 29 Sep 2022 17:45:49 +0200
Date:   Thu, 29 Sep 2022 17:45:49 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Sarath Babu Naidu Gaddam <sarath.babu.naidu.gaddam@amd.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        yangbo.lu@nxp.com, radhey.shyam.pandey@amd.com,
        anirudha.sarangi@amd.com, harini.katakam@amd.com
Subject: Re: [RFC PATCH] dt-bindings: net: ethernet-controller: Add
 ptimer_handle
Message-ID: <YzW9radTFVwciqvQ@lunn.ch>
References: <20220929121249.18504-1-sarath.babu.naidu.gaddam@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220929121249.18504-1-sarath.babu.naidu.gaddam@amd.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 29, 2022 at 06:12:49AM -0600, Sarath Babu Naidu Gaddam wrote:
> There is currently no standard property to pass PTP device index
> information to ethernet driver when they are independent.

You should Cc: the PTP maintainer....

    Andrew
