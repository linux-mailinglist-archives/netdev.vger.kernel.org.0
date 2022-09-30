Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6871A5F125B
	for <lists+netdev@lfdr.de>; Fri, 30 Sep 2022 21:22:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231834AbiI3TWE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Sep 2022 15:22:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231408AbiI3TWD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Sep 2022 15:22:03 -0400
Received: from mail-oo1-f43.google.com (mail-oo1-f43.google.com [209.85.161.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 116311A3ACF;
        Fri, 30 Sep 2022 12:22:03 -0700 (PDT)
Received: by mail-oo1-f43.google.com with SMTP id c22-20020a4a4f16000000b00474a44441c8so2883157oob.7;
        Fri, 30 Sep 2022 12:22:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=s8hYlxauR4HWzFPuDNAvjFsnutY8GEfDCZwsMSYjnTo=;
        b=EClq0hocxjbaKkeaaT/CNEfUhezq6HEyXHru79wHNGAeubZhP5xZt25PmKlNwgkNzC
         37iU8DhShzAwIbhk9bjZ4UudLcLfX+HvxgILjEDw+QyugwZE08n/sOgcJFv4JQ5PK1At
         bKcUVDzDFJMJNT0cJC2paC9J8UZ9VhfK7Arz2BgzRyvSmO8wRxNwtA5SIoWUEp3G+m3Y
         wg73OembAYAt/Kr6QdSyblDeBpisZcjCHPLzp606CeHTE7Uo7W45MePRCfU1nORpOEUt
         yen+RfIIHlHv7ZD1FBcAF0H4UoxUAohebmxBw9b8ZAoVxggycLk7PlN+/ZAieRDUMgqw
         g/yQ==
X-Gm-Message-State: ACrzQf1Qyfd2lXCVb9jA9J++O/yCNArBN5RFGzMeAoPGLwy0TQYskASU
        IAYKW64qH3YzZ9QPLQ3z1Q==
X-Google-Smtp-Source: AMsMyM5sBjDT6mVQDUBDup5iuG72k2RKEKu7xMS1jSPzzgHPWKqPcMBPivjnMtInGsAU+/w7aR5Fcg==
X-Received: by 2002:a4a:5e47:0:b0:476:2f9e:b30e with SMTP id h68-20020a4a5e47000000b004762f9eb30emr3930673oob.46.1664565722209;
        Fri, 30 Sep 2022 12:22:02 -0700 (PDT)
Received: from macbook.herring.priv (66-90-144-107.dyn.grandenetworks.net. [66.90.144.107])
        by smtp.gmail.com with ESMTPSA id b17-20020a056870d1d100b00127a6357bd5sm893417oac.49.2022.09.30.12.22.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Sep 2022 12:22:01 -0700 (PDT)
Received: (nullmailer pid 741200 invoked by uid 1000);
        Fri, 30 Sep 2022 19:22:00 -0000
Date:   Fri, 30 Sep 2022 14:22:00 -0500
From:   Rob Herring <robh@kernel.org>
To:     Sarath Babu Naidu Gaddam <sarath.babu.naidu.gaddam@amd.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, krzysztof.kozlowski+dt@linaro.org,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, yangbo.lu@nxp.com,
        radhey.shyam.pandey@amd.com, anirudha.sarangi@amd.com,
        harini.katakam@amd.com
Subject: Re: [RFC PATCH] dt-bindings: net: ethernet-controller: Add
 ptimer_handle
Message-ID: <20220930192200.GA693073-robh@kernel.org>
References: <20220929121249.18504-1-sarath.babu.naidu.gaddam@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220929121249.18504-1-sarath.babu.naidu.gaddam@amd.com>
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,
        FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 29, 2022 at 06:12:49AM -0600, Sarath Babu Naidu Gaddam wrote:
> There is currently no standard property to pass PTP device index
> information to ethernet driver when they are independent.
> 
> ptimer_handle property will contain phandle to PTP timer node.

ptimer_handle or ptimer-handle? One matches conventions.

However, 'handle' is redundant and 'ptimer' is vague. 'ptp-timer' 
instead? (Humm, looking at fsl-fman.txt after writing everything here, 
it's already using that name! So why are you making something new?)

However, for anything common, I'd like to see multiple examples and 
users. Do we have any custom bindings for this purpose already (besides 
FSL)? 

Could an ethernet device ever need more than 1 timer? Could a provider 
provide multiple timers? IOW, does this need to follow standard 
provider/consumer pattern of 'foos' and '#foo-cells'?

> Freescale driver currently has this implementation but it will be
> good to agree on a generic (optional) property name to link to PTP
> phandle to Ethernet node. In future or any current ethernet driver
> wants to use this method of reading the PHC index,they can simply use

What's PHC index?

> this generic name and point their own PTP timer node, instead of
> creating seperate property names in each ethernet driver DT node.
> 
> axiethernet driver uses this method when PTP support is integrated.
> 
> Example:
> 	fman0: fman@1a00000 {
> 		ptimer-handle = <&ptp_timer0>;
> 	}
> 
> 	ptp_timer0: ptp-timer@1afe000 {
> 		compatible = "fsl,fman-ptp-timer";
> 		reg = <0x0 0x1afe000 0x0 0x1000>;
> 	}
> 
> Signed-off-by: Sarath Babu Naidu Gaddam <sarath.babu.naidu.gaddam@amd.com>
> ---
> We want binding to be reviewed/accepted and then make changes in freescale
> binding documentation to use this generic binding.

You can't just change the binding you are using. That's an ABI break.

Rob
