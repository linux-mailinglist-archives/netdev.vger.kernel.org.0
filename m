Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 69F532B4600
	for <lists+netdev@lfdr.de>; Mon, 16 Nov 2020 15:38:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730264AbgKPOhY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Nov 2020 09:37:24 -0500
Received: from mail-ot1-f67.google.com ([209.85.210.67]:43726 "EHLO
        mail-ot1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729845AbgKPOhX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Nov 2020 09:37:23 -0500
Received: by mail-ot1-f67.google.com with SMTP id y22so16198057oti.10;
        Mon, 16 Nov 2020 06:37:23 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=U0dn7aZtjbLlMoxw+EC4gwPZPIaLXL0z9WswT9nNc04=;
        b=d696/cVm13gDEL4kQzqTLpNpMNZ4WqXGDdoHGkElB1SJE3RzVbWHGRg6Fgz0/bAZ30
         xN86bIhrffi2T6Vof5HOC8aW6/Uf/flRfWzfy4wHwOXOVyLr70Z2NQeptkH11dJT8Bis
         TEde+ZkydV+aCd5LC+OAZMdqyKhbT5RMUrvD2ur6GsCup7ILBpSBxnYhMaGQhFzjilHQ
         H7UEONJtonzAujsMVhbLmikvYyeiB8WHxBQJRKCrMyMKm08FDSHErDFnb4Fj4zSBDIej
         +Bo9GBOvxuxSkCeI1vUVeqC+IgOpRxn2TIA/uDhBZ3UqynApz1KKoOgRcKEZ9XdHgp5X
         Ft5Q==
X-Gm-Message-State: AOAM533Ggg7qo2eoAezbnZ23TNTLbW8yKqRk7V0gAMOeHp3cgbFNGX2n
        1V77Fz9Is3LD68UqASNWmQ==
X-Google-Smtp-Source: ABdhPJwIV5z+0rmaYuqN6NtU5Zk/X3SZnVZP20sR6OiEeqF705htu2HuRjIcnYyA8eBoDaWRcC4wVg==
X-Received: by 2002:a05:6830:18d5:: with SMTP id v21mr10045958ote.136.1605537442742;
        Mon, 16 Nov 2020 06:37:22 -0800 (PST)
Received: from xps15 (24-155-109-49.dyn.grandenetworks.net. [24.155.109.49])
        by smtp.gmail.com with ESMTPSA id q7sm4738104oig.42.2020.11.16.06.37.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Nov 2020 06:37:21 -0800 (PST)
Received: (nullmailer pid 1612218 invoked by uid 1000);
        Mon, 16 Nov 2020 14:37:20 -0000
Date:   Mon, 16 Nov 2020 08:37:20 -0600
From:   Rob Herring <robh@kernel.org>
To:     Christian Eggers <ceggers@arri.de>
Cc:     Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Tristram Ha <Tristram.Ha@microchip.com>,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Woojung Huh <woojung.huh@microchip.com>,
        Codrin Ciubotariu <codrin.ciubotariu@microchip.com>,
        netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Richard Cochran <richardcochran@gmail.com>,
        George McCollister <george.mccollister@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Helmut Grohne <helmut.grohne@intenta.de>,
        Marek Vasut <marex@denx.de>,
        Kurt Kanzenbach <kurt.kanzenbach@linutronix.de>,
        Paul Barker <pbarker@konsulko.com>,
        Vladimir Oltean <olteanv@gmail.com>
Subject: Re: [PATCH net-next v2 01/11] dt-bindings: net: dsa: convert ksz
 bindings document to yaml
Message-ID: <20201116143720.GA1611573@bogus>
References: <20201112153537.22383-1-ceggers@arri.de>
 <20201112153537.22383-2-ceggers@arri.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201112153537.22383-2-ceggers@arri.de>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 12 Nov 2020 16:35:27 +0100, Christian Eggers wrote:
> Convert the bindings document for Microchip KSZ Series Ethernet switches
> from txt to yaml.
> 
> Signed-off-by: Christian Eggers <ceggers@arri.de>
> ---
>  .../devicetree/bindings/net/dsa/ksz.txt       | 125 ---------------
>  .../bindings/net/dsa/microchip,ksz.yaml       | 150 ++++++++++++++++++
>  MAINTAINERS                                   |   2 +-
>  3 files changed, 151 insertions(+), 126 deletions(-)
>  delete mode 100644 Documentation/devicetree/bindings/net/dsa/ksz.txt
>  create mode 100644 Documentation/devicetree/bindings/net/dsa/microchip,ksz.yaml
> 


My bot found errors running 'make dt_binding_check' on your patch:

yamllint warnings/errors:

dtschema/dtc warnings/errors:
/builds/robherring/linux-dt-review/Documentation/devicetree/bindings/net/dsa/microchip,ksz.yaml: 'oneOf' conditional failed, one must be fixed:
	'unevaluatedProperties' is a required property
	'additionalProperties' is a required property
/builds/robherring/linux-dt-review/Documentation/devicetree/bindings/net/dsa/microchip,ksz.yaml: ignoring, error in schema: 
warning: no schema found in file: ./Documentation/devicetree/bindings/net/dsa/microchip,ksz.yaml


See https://patchwork.ozlabs.org/patch/1399036

The base for the patch is generally the last rc1. Any dependencies
should be noted.

If you already ran 'make dt_binding_check' and didn't see the above
error(s), then make sure 'yamllint' is installed and dt-schema is up to
date:

pip3 install dtschema --upgrade

Please check and re-submit.

