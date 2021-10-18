Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 203F043267F
	for <lists+netdev@lfdr.de>; Mon, 18 Oct 2021 20:34:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232968AbhJRShC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Oct 2021 14:37:02 -0400
Received: from mail-oi1-f172.google.com ([209.85.167.172]:40493 "EHLO
        mail-oi1-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232871AbhJRShB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Oct 2021 14:37:01 -0400
Received: by mail-oi1-f172.google.com with SMTP id n63so1029236oif.7;
        Mon, 18 Oct 2021 11:34:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=BXwNrG4eTVKzZpIRCarHGGXmlKSomOiTra/AD02w75c=;
        b=7VlNV8FWPkUjBb0oU0/UKu0j+6nH945hLFFhwK0pJYMh/0EBKobvyoJnTk7mDoV2y9
         Lags/V2LT1yogHoqyWPNGUKdjruMlr8zyZ1LKF2MTnkceGWjy7m5NtdqlqkcfKl/npqL
         qZY3bgbfEI1L+kmQ14CA/Ucdth6QKziW8X5NSJ8rrP5fHpAzPwEn6qlGgVcYxy7fENqq
         Ary2i1yOOo/UOu2SQjfCfH9Xkq6lMUG1+8m5L3fLs4G+Zy2tSiY9oPTaPVOkSQ5IvQLz
         7/Hm5TjX46vPzlWj7QXSIwgvfzmjBd4YL8D1AhBUjB7d3w/CjQFNf7LuFiYwGsLZjYpT
         1mDA==
X-Gm-Message-State: AOAM532T8hrPTXUxMXWJjUNxWCpy/3SExM3UK3zYnXreYAIPbT5dDY9c
        nx9QkmeMXeLp/6HR7RNLWA==
X-Google-Smtp-Source: ABdhPJzytjS8WufNOS6c5DnQSwiC9AtiJ0xXtCDkJKcuKA4GJ0hB8mYCuU118OYBmfgq1xUbUP7g1A==
X-Received: by 2002:a05:6808:10cc:: with SMTP id s12mr453511ois.164.1634582089247;
        Mon, 18 Oct 2021 11:34:49 -0700 (PDT)
Received: from robh.at.kernel.org (66-90-148-213.dyn.grandenetworks.net. [66.90.148.213])
        by smtp.gmail.com with ESMTPSA id r14sm1276825oiw.44.2021.10.18.11.34.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Oct 2021 11:34:48 -0700 (PDT)
Received: (nullmailer pid 2717501 invoked by uid 1000);
        Mon, 18 Oct 2021 18:34:47 -0000
Date:   Mon, 18 Oct 2021 13:34:47 -0500
From:   Rob Herring <robh@kernel.org>
To:     David Heidelberg <david@ixit.cz>
Cc:     linux-kernel@vger.kernel.org,
        Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        ~okias/devicetree@lists.sr.ht, devicetree@vger.kernel.org
Subject: Re: [PATCH v4] dt-bindings: net: nfc: nxp,pn544: Convert txt
 bindings to yaml
Message-ID: <YW2+R4drCwcmzKMK@robh.at.kernel.org>
References: <20211017160210.85543-1-david@ixit.cz>
 <1634559233.484644.2074240.nullmailer@robh.at.kernel.org>
 <RAC61R.YOBPB57076K71@ixit.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <RAC61R.YOBPB57076K71@ixit.cz>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 18, 2021 at 03:04:03PM +0200, David Heidelberg wrote:
> 
> 
> 
> On Mon, Oct 18 2021 at 07:13:53 -0500, Rob Herring <robh@kernel.org> wrote:
> > On Sun, 17 Oct 2021 18:02:10 +0200, David Heidelberg wrote:
> > >  Convert bindings for NXP PN544 NFC driver to YAML syntax.
> > > 
> > >  Signed-off-by: David Heidelberg <david@ixit.cz>
> > >  ---
> > >  v2
> > >   - Krzysztof is a maintainer
> > >   - pintctrl dropped
> > >   - 4 space indent for example
> > >   - nfc node name
> > >  v3
> > >   - remove whole pinctrl
> > >  v4
> > >   - drop clock-frequency, which is inherited by i2c bus
> > > 
> > >   .../bindings/net/nfc/nxp,pn544.yaml           | 56
> > > +++++++++++++++++++
> > >   .../devicetree/bindings/net/nfc/pn544.txt     | 33 -----------
> > >   2 files changed, 56 insertions(+), 33 deletions(-)
> > >   create mode 100644
> > > Documentation/devicetree/bindings/net/nfc/nxp,pn544.yaml
> > >   delete mode 100644
> > > Documentation/devicetree/bindings/net/nfc/pn544.txt
> > > 
> Full log is available here: https://patchwork.ozlabs.org/patch/1542257
> > 
> > Running 'make dtbs_check' with the schema in this patch gives the
> > following warnings. Consider if they are expected or the schema is
> > incorrect. These may not be new warnings.
> > 
> > Note that it is not yet a requirement to have 0 warnings for dtbs_check.
> > This will change in the future.
> > 
> > 
> > 
> > nfc@28: 'clock-frequency' does not match any of the regexes:
> > 'pinctrl-[0-9]+'
> > 	arch/arm/boot/dts/tegra30-asus-nexus7-grouper-E1565.dt.yaml
> > 	arch/arm/boot/dts/tegra30-asus-nexus7-grouper-PM269.dt.yaml
> > 
> > nfc@2a: 'clock-frequency' does not match any of the regexes:
> > 'pinctrl-[0-9]+'
> > 	arch/arm/boot/dts/tegra30-asus-nexus7-tilapia-E1565.dt.yaml
> > 
> 
> Patches for this are already in grate repository and will be sent to
> mainline soon! :)

Okay. I was under the impression 'clock-frequency' was removed thinking 
it is in the i2c bus schema already. It is, but unfortunately you need 
it here too if used because all properties for a node have to be listed 
in the schema for the node. 'unevaluatedProperties' can't evaluate 
properties in the child nodes of the parent schema with the properties 
of the child schema.

Rob
