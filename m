Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 650D636146F
	for <lists+netdev@lfdr.de>; Fri, 16 Apr 2021 00:00:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236366AbhDOWAX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Apr 2021 18:00:23 -0400
Received: from mail-oo1-f52.google.com ([209.85.161.52]:38871 "EHLO
        mail-oo1-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234777AbhDOWAX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Apr 2021 18:00:23 -0400
Received: by mail-oo1-f52.google.com with SMTP id y23-20020a4ade170000b02901e6250b3be6so3239084oot.5;
        Thu, 15 Apr 2021 14:59:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=K0IEGA8eoD3PpHTJOZ22bAJrHX64vU8Ut2xJcmWS2Ug=;
        b=NTWE2QtDhwd+oly0djXSilcT5xrVJCMDavgRndE5Qgs7IqxqE3x3DdbGAn/a9x35P2
         5BASHxQKpLFbPBYtLZcEshr06f1oZaf6x6SUIpgcP280s/orhnec20Vhl6RZRoWcaw+u
         fvKYEwcdlsq8BBKXkOFmbyqqQTdXJNIlzBxoGHWC7I2/Y6ZQTT5TQD5WV15sMN9o+SPY
         ARutKqV1skt57dvUUimFKInTsUxvd8TU76LjrpkxoKN5gTAvUUO1Yw4wNvEeV7yvZtdP
         wTd1080LIsTF78ucwGEecDwW9y8Ol77giuYJ18+shVSTIK2N86hadh9MX0Qjvv5GcoF5
         Ltyg==
X-Gm-Message-State: AOAM531Jb2pq8F4A962lg8sZfAbIz+rw4SzsAdxTmuw5k0A4efCtIzE9
        6Vb439xy8M2Go1s9ERt3uw==
X-Google-Smtp-Source: ABdhPJwb8QFOkLwSA3dsX/gssqbMFOSOZQ6boTRotK4OAm3cItOk6lFBlYf/9shany+8Kd223SSOmw==
X-Received: by 2002:a4a:d781:: with SMTP id c1mr937783oou.44.1618523999149;
        Thu, 15 Apr 2021 14:59:59 -0700 (PDT)
Received: from robh.at.kernel.org (24-155-109-49.dyn.grandenetworks.net. [24.155.109.49])
        by smtp.gmail.com with ESMTPSA id s84sm913666oie.39.2021.04.15.14.59.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Apr 2021 14:59:57 -0700 (PDT)
Received: (nullmailer pid 1954142 invoked by uid 1000);
        Thu, 15 Apr 2021 21:59:55 -0000
Date:   Thu, 15 Apr 2021 16:59:55 -0500
From:   Rob Herring <robh@kernel.org>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Michael Walle <michael@walle.cc>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Frank Rowand <frowand.list@gmail.com>
Subject: Re: [PATCH net-next 1/3] dt-bindings: net: add
 nvmem-mac-address-offset property
Message-ID: <20210415215955.GA1937954@robh.at.kernel.org>
References: <20210414152657.12097-1-michael@walle.cc>
 <20210414152657.12097-2-michael@walle.cc>
 <YHcNtdq+oIYcB08+@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YHcNtdq+oIYcB08+@lunn.ch>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 14, 2021 at 05:43:49PM +0200, Andrew Lunn wrote:
> On Wed, Apr 14, 2021 at 05:26:55PM +0200, Michael Walle wrote:
> > It is already possible to read the MAC address via a NVMEM provider. But
> > there are boards, esp. with many ports, which only have a base MAC
> > address stored. Thus we need to have a way to provide an offset per
> > network device.
> 
> We need to see what Rob thinks of this. There was recently a patchset
> to support swapping the byte order of the MAC address in a NVMEM. Rob
> said the NVMEM provider should have the property, not the MAC driver.
> This does seems more ethernet specific, so maybe it should be an
> Ethernet property?

There was also this one[1]. I'm not totally opposed, but don't want to 
see a never ending addition of properties to try to describe any 
possible transformation.

Rob

[1] https://patchwork.ozlabs.org/project/devicetree-bindings/patch/20200920095724.8251-4-ansuelsmth@gmail.com/
