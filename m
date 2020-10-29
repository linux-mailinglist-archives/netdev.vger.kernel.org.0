Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3680229F012
	for <lists+netdev@lfdr.de>; Thu, 29 Oct 2020 16:35:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728329AbgJ2P3I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Oct 2020 11:29:08 -0400
Received: from mail-oi1-f194.google.com ([209.85.167.194]:36755 "EHLO
        mail-oi1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728189AbgJ2P05 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Oct 2020 11:26:57 -0400
Received: by mail-oi1-f194.google.com with SMTP id y186so3584520oia.3;
        Thu, 29 Oct 2020 08:26:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=4OFBgFX8nLewiGm0jPfaiHisoQ+37/JFIGxKrAiCiQ0=;
        b=LXfpRCb82FBJtaOftXsJGLwN3cs0ooQ6JJzWyaWWZA70CAPZF6hJ+IY94Dzv08dTp5
         B/o363Lu3CqggkUwN5z48VBxCuDz57dEUQ7fRCr+F/54vkH6lRuHe1NCTuzVAQDYPs1f
         nSSwnRznZwadZSYcHbg0NUHLlpeZ4RzPLmnj9t+lDvC0K3uCVswL/BKKsTbtst3beRDB
         l8Q4I8AcKHWCMq8PK6iw9uVd7cV0KngdF4ZTS+tyEuRxMQL5KcQP3AtDoTY9lQSkFN5B
         TmSnN/oBw83vYo3EAwzgkj4C+Y3XD7G0Ki/LVwMYQgs1nYmvbkjOuihYv/ZMn116Jlgo
         Djmw==
X-Gm-Message-State: AOAM532WQVQWBwjss1zVW87xWYVvXLQ19hu1dVAFu9Luw00zv7DRtn33
        iCf+Ulyxw5NINCgPWtxCAA==
X-Google-Smtp-Source: ABdhPJw8CuiTPteZx2cGCfAEj/1GKhtCCfbr2/hiuI3d+cIboYSSNq6Ss3yQni+9Jc/GGf1rHNK0zQ==
X-Received: by 2002:aca:b854:: with SMTP id i81mr316628oif.6.1603985217102;
        Thu, 29 Oct 2020 08:26:57 -0700 (PDT)
Received: from xps15 (24-155-109-49.dyn.grandenetworks.net. [24.155.109.49])
        by smtp.gmail.com with ESMTPSA id c14sm667260otp.1.2020.10.29.08.26.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Oct 2020 08:26:55 -0700 (PDT)
Received: (nullmailer pid 1902350 invoked by uid 1000);
        Thu, 29 Oct 2020 15:26:54 -0000
Date:   Thu, 29 Oct 2020 10:26:54 -0500
From:   Rob Herring <robh@kernel.org>
To:     Kurt Kanzenbach <kurt@linutronix.de>
Cc:     Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        ilias.apalodimas@linaro.org, netdev@vger.kernel.org,
        Richard Cochran <richardcochran@gmail.com>,
        devicetree@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Rob Herring <robh+dt@kernel.org>,
        Kamil Alkhouri <kamil.alkhouri@hs-offenburg.de>,
        Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: [PATCH net-next v7 8/8] dt-bindings: net: dsa: Add documentation
 for Hellcreek switches
Message-ID: <20201029152654.GA1901783@bogus>
References: <20201028074221.29326-1-kurt@linutronix.de>
 <20201028074221.29326-9-kurt@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201028074221.29326-9-kurt@linutronix.de>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 28 Oct 2020 08:42:21 +0100, Kurt Kanzenbach wrote:
> Add basic documentation and example.
> 
> Signed-off-by: Kurt Kanzenbach <kurt@linutronix.de>
> Reviewed-by: Rob Herring <robh@kernel.org>
> Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
> ---
>  .../net/dsa/hirschmann,hellcreek.yaml         | 127 ++++++++++++++++++
>  1 file changed, 127 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/net/dsa/hirschmann,hellcreek.yaml
> 


My bot found errors running 'make dt_binding_check' on your patch:

yamllint warnings/errors:
./Documentation/devicetree/bindings/net/dsa/hirschmann,hellcreek.yaml:49:11: [warning] wrong indentation: expected 8 but found 10 (indentation)

dtschema/dtc warnings/errors:


See https://patchwork.ozlabs.org/patch/1389458

The base for the patch is generally the last rc1. Any dependencies
should be noted.

If you already ran 'make dt_binding_check' and didn't see the above
error(s), then make sure 'yamllint' is installed and dt-schema is up to
date:

pip3 install dtschema --upgrade

Please check and re-submit.

