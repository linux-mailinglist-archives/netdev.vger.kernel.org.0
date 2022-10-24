Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CE28860B571
	for <lists+netdev@lfdr.de>; Mon, 24 Oct 2022 20:27:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231516AbiJXS1L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Oct 2022 14:27:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231145AbiJXS0t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Oct 2022 14:26:49 -0400
Received: from mail-oi1-f170.google.com (mail-oi1-f170.google.com [209.85.167.170])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 918963FD5D;
        Mon, 24 Oct 2022 10:08:32 -0700 (PDT)
Received: by mail-oi1-f170.google.com with SMTP id g130so11443567oia.13;
        Mon, 24 Oct 2022 10:08:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=n0kYhDrwp/vsj/k7RAVnqojHJWY5hdYOtypPscTgAEQ=;
        b=DwDqcaLUjlKm7E5s8DJZyXUyZaSBAMWNXLUzAyrcxzjB3przrq1c74OI6SlfvS3Mcz
         yGfKomMWRO4069iP+8AJOGq5yZRMF+241Txa1IIdH9O48j6Xy77IFDgc1s2wY3pFV9HO
         FfS4vpgESV6cc4h8bjSxVv3VQ+cacXMZ7s7n9aTi0BeUg4Y71PZy8qPtuKiSu1VfqZyr
         a12s391voFSoVlIs60IjyRixTaaQXgmaL93tBPIEI7rqLEuplvWQ5MGgPMu7qSsEQUOI
         47mmEq3WrO4d87l7iU4EBCIm1RKtbfAJqQ5z3dSlI4Yq3kCiuf6QkbWEfaILrpy75LrJ
         /BHw==
X-Gm-Message-State: ACrzQf0G00+APGfYx8Smv3h1mSM+n9GFXZv+R+BxA8yOELHNGtJUwWAW
        OlOiYZuewINK0QlKawNDLTnnFIrrWA==
X-Google-Smtp-Source: AMsMyM7ySHS3c7QNqcTH2KM3ZosPwpTwRr1KeMwtVTHphnl5pxNgztELYV4t/OP92+FpjfMwsXAQCw==
X-Received: by 2002:a05:6870:89a3:b0:12b:45b6:80de with SMTP id f35-20020a05687089a300b0012b45b680demr22216102oaq.263.1666630643114;
        Mon, 24 Oct 2022 09:57:23 -0700 (PDT)
Received: from robh_at_kernel.org (66-90-144-107.dyn.grandenetworks.net. [66.90.144.107])
        by smtp.gmail.com with ESMTPSA id c2-20020a544e82000000b00354b0850fb6sm41612oiy.33.2022.10.24.09.57.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Oct 2022 09:57:22 -0700 (PDT)
Received: (nullmailer pid 1911533 invoked by uid 1000);
        Mon, 24 Oct 2022 16:57:23 -0000
Date:   Mon, 24 Oct 2022 11:57:23 -0500
From:   Rob Herring <robh@kernel.org>
To:     Sarath Babu Naidu Gaddam <sarath.babu.naidu.gaddam@amd.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, richardcochran@gmail.com,
        krzysztof.kozlowski+dt@linaro.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        yangbo.lu@nxp.com, radhey.shyam.pandey@amd.com,
        anirudha.sarangi@amd.com, harini.katakam@amd.com, git@amd.com
Subject: Re: [PATCH net-next V2] dt-bindings: net: ethernet-controller: Add
 ptp-hardware-clock
Message-ID: <20221024165723.GA1896281-robh@kernel.org>
References: <20221021054111.25852-1-sarath.babu.naidu.gaddam@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221021054111.25852-1-sarath.babu.naidu.gaddam@amd.com>
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 20, 2022 at 11:41:10PM -0600, Sarath Babu Naidu Gaddam wrote:
> There is currently no standard property to pass PTP device index
> information to ethernet driver when they are independent.
> 
> ptp-hardware-clock property will contain phandle to PTP clock node.
> 
> Freescale driver currently has this implementation but it will be
> good to agree on a generic (optional) property name to link to PTP
> phandle to Ethernet node. In future or any current ethernet driver
> wants to use this method of reading the PHC index,they can simply use
> this generic name and point their own PTP clock node, instead of
> creating separate property names in each ethernet driver DT node.

Seems like this does the same thing as 
Documentation/devicetree/bindings/ptp/timestamper.txt.

Or perhaps what we have in bindings/timestamp/ which unfortunately does 
about the same thing.

The latter one is more flexible and follows standard provider/consumer 
patterns. So timestamper.txt should probably be deprecated.

> 
> axiethernet driver uses this method when PTP support is integrated.
> 
> Example:
> 	fman0: fman@1a00000 {
> 		ptp-hardware-clock = <&ptp_timer0>;
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

If you want a common binding, I want to see multiple users and 
preferrably ones that have some differing requirements. It can be 
something existing with a 'this is what it would look like if we had 
used this new common binding'.

Rob
