Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DA73F4B2B09
	for <lists+netdev@lfdr.de>; Fri, 11 Feb 2022 17:54:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345685AbiBKQwP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Feb 2022 11:52:15 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:51968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231825AbiBKQwN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Feb 2022 11:52:13 -0500
Received: from mail-qv1-f49.google.com (mail-qv1-f49.google.com [209.85.219.49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B14F1FD;
        Fri, 11 Feb 2022 08:52:12 -0800 (PST)
Received: by mail-qv1-f49.google.com with SMTP id p7so8991925qvk.11;
        Fri, 11 Feb 2022 08:52:12 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=atvNZwIQCcyeotnR4MVlumAm6zVSdFMZVQqvJ2jf9G8=;
        b=V9dXeeaElbWza+WOilx4ZARYeiTz2g0Xn5lmyCWOO4CMMahSSFRHaKzbOco36JOIFu
         pkq4u66D81ktUyNa3uX0Y38aRn87Y4HJCiMTwJnkoWkTRSLFH4IKvt1Fw22U+Be/awax
         CvETsGRWr2gkEGYU81pwpT29K4D4UhbXsjjC4Ruk0PT/oJJCB/x5vNOyGw5lrnECX/dv
         ebtXFRq6mCVexFVKwIq5qQ5dXwSzL6mA9z3dxigGto6WNcsD26Q0n4raUqYgc/c1cirl
         bvvZI8T5Xy9+oPNwPwXzSx7lVW0YB7oeYIgUKPKTzXZPx3Zh4IMP7eaf0a+nvRQG47hW
         5Otw==
X-Gm-Message-State: AOAM533WQCs7k1Sxh7E3NNH3PIo/GbrqePJZj0gzy1t8ZwcUzJvFI4UF
        215Gace+k1j0a12u+MuFfg==
X-Google-Smtp-Source: ABdhPJwzNwIX3jrsW/qzdAI57QC+AEVsdKCKvRbKpNjMkItzuUkspsIaa/83KsPN1yyzXm9Pf+6xVw==
X-Received: by 2002:ad4:5ba6:: with SMTP id 6mr1735942qvq.112.1644598331877;
        Fri, 11 Feb 2022 08:52:11 -0800 (PST)
Received: from robh.at.kernel.org ([2607:fb90:5fee:dfce:b6df:c3e1:b1e5:d6d8])
        by smtp.gmail.com with ESMTPSA id c14sm13003698qtc.31.2022.02.11.08.52.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Feb 2022 08:52:11 -0800 (PST)
Received: (nullmailer pid 507445 invoked by uid 1000);
        Fri, 11 Feb 2022 16:52:09 -0000
Date:   Fri, 11 Feb 2022 10:52:09 -0600
From:   Rob Herring <robh@kernel.org>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        kernel@pengutronix.de, "David S. Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>
Subject: Re: [PATCH net-next v1] dt-bindings: net: ethernet-controller:
 document label property
Message-ID: <YgaUORqDhoUoOJe8@robh.at.kernel.org>
References: <20220209082820.2210753-1-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220209082820.2210753-1-o.rempel@pengutronix.de>
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

On Wed, 09 Feb 2022 09:28:20 +0100, Oleksij Rempel wrote:
> "label" provides human readable name used on a box, board or schematic
> to identify Ethernet port.
> 
> Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
> ---
>  .../devicetree/bindings/net/ethernet-controller.yaml          | 4 ++++
>  1 file changed, 4 insertions(+)
> 

Applied, thanks!
