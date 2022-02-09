Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD2064AE7F8
	for <lists+netdev@lfdr.de>; Wed,  9 Feb 2022 05:07:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244085AbiBIEHW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Feb 2022 23:07:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347391AbiBIDrp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Feb 2022 22:47:45 -0500
Received: from mail-ot1-f51.google.com (mail-ot1-f51.google.com [209.85.210.51])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7946CC0613C9;
        Tue,  8 Feb 2022 19:47:44 -0800 (PST)
Received: by mail-ot1-f51.google.com with SMTP id x52-20020a05683040b400b0059ea92202daso682434ott.7;
        Tue, 08 Feb 2022 19:47:44 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Y/S59m4SqvekIlBklMvaBC073KyUpiz6Cf+mvt2eZDQ=;
        b=Kvq3eAkR1QL7WD7lC2CQ3BtGlrznTWoUiF7UBin9OJHJ/D0UZ4HGdyuJ6kt76MuA9s
         UPj0RinpoL1rIy4eFxhi5BCyKcZQz1+ZOQrjX9Tt2wihsIcy2RKZ+QYvfmbMKvNnj4Yv
         OvhvMkAob68QYmJthfwaQ+RPfbeg2+ijokHIToI6ulGPdOor7yj0Hw7YfXx6oF+SfZBZ
         +8hRrtThTlYqQpahAThjOfvRzmsGiru1K7BfHYwVjf0DrRy1MyNaToqGyupbJR8i5Tux
         gvdDHCig/FWqgHzo0DjzQhZOi9MlkBzgW6pNOe4KoSvOUzUuHKv0O1JftbtiD3swWFOI
         FQsg==
X-Gm-Message-State: AOAM5320Wy022hrjR/Na0wXvdeMqTxsa11439RRHR9mE/HnN/NhST0a3
        KGpZirO+WeHmD9t+9SktqA==
X-Google-Smtp-Source: ABdhPJxzSi7rOGQ+ufIvJGYHpLK1bHM3/A5fE+JnD2iGJS8mZHIGfvvmaY41ZsJPcSb1b/cz04OpDQ==
X-Received: by 2002:a9d:6c8b:: with SMTP id c11mr197538otr.92.1644378463701;
        Tue, 08 Feb 2022 19:47:43 -0800 (PST)
Received: from robh.at.kernel.org (66-90-148-213.dyn.grandenetworks.net. [66.90.148.213])
        by smtp.gmail.com with ESMTPSA id c29sm6054494otk.16.2022.02.08.19.47.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Feb 2022 19:47:42 -0800 (PST)
Received: (nullmailer pid 3608852 invoked by uid 1000);
        Wed, 09 Feb 2022 03:47:41 -0000
Date:   Tue, 8 Feb 2022 21:47:41 -0600
From:   Rob Herring <robh@kernel.org>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Oleksij Rempel <o.rempel@pengutronix.de>,
        Oliver Neukum <oneukum@suse.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org, devicetree@vger.kernel.org
Subject: Re: [PATCH net-next v1 2/4] dt-bindings: net: add schema for
 Microchip/SMSC LAN95xx USB Ethernet controllers
Message-ID: <YgM5XSwmiQi5XbW/@robh.at.kernel.org>
References: <20220127104905.899341-1-o.rempel@pengutronix.de>
 <20220127104905.899341-3-o.rempel@pengutronix.de>
 <YfJ6/xdacR59Jvq+@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YfJ6/xdacR59Jvq+@kroah.com>
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

On Thu, Jan 27, 2022 at 11:59:11AM +0100, Greg KH wrote:
> On Thu, Jan 27, 2022 at 11:49:03AM +0100, Oleksij Rempel wrote:
> > Create initial schema for Microchip/SMSC LAN95xx USB Ethernet controllers and
> > import all currently supported USB IDs form drivers/net/usb/smsc95xx.c
> 
> That is a loosing game to play.  There is a reason that kernel drivers
> only require a device id in 1 place, instead of multiple places like
> other operating systems.  Please do not go back and make the same
> mistakes others have.

This instance doesn't look so bad because SMSC devices are chips rather 
than random OEM rebranded devices all with the same underlying chip.

> Not to mention that I think overall this is a bad idea anyway.  USB
> devices are self-describing, don't add them to DT.

Until they are soldered down and the board maker cheaps out on having an 
eeprom to hold the MAC address...

Rob
