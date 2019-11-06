Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A79FBF0DD8
	for <lists+netdev@lfdr.de>; Wed,  6 Nov 2019 05:34:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731227AbfKFEd5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Nov 2019 23:33:57 -0500
Received: from mail-ot1-f66.google.com ([209.85.210.66]:34325 "EHLO
        mail-ot1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726368AbfKFEd4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Nov 2019 23:33:56 -0500
Received: by mail-ot1-f66.google.com with SMTP id t4so8250326otr.1;
        Tue, 05 Nov 2019 20:33:56 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=FcT3X6SewhnUxdf5PpBjzQ67V8xmr4mQJa2czEyvT2g=;
        b=iSuhSjqtCG2qfq5s7Z4Qg4XGOio8c5seno9tP6SqCAAh6kKcMe2YiA7cBVBbspdXrj
         L5fMf/JoiO+yt+NH98HoRsaOyDVvyQZU0tGTjypXPmEXc12qX9t9P4nW2C8eNLfv7o4Q
         LYHODVL+7qXnur0zTdEmD+MOrIlZAumHmqMu9kNHLRl4wc4gcLvHNG3o3iHtAjtGI0l9
         9L9QQ4E4Admxb4u3VvDLaS+dPpapg6VA07zywsCf9Esg09hVG+q5Ox0GlBFpWIfzNuu2
         IfUdrnaFMe1PsnZpb+mOdywg/XXkWZ150rk4D1ITms8+QWSwM6J6/Y4GuMEa4djKBD5+
         bDsw==
X-Gm-Message-State: APjAAAVHMC0X1PVdQOqbd5l5EbBAZ3UwASd8Ch9sz4txvoOtwNg/kwPB
        41+YOfT1HdmgDs7qX/gr3GVALew=
X-Google-Smtp-Source: APXvYqwCOMEzMdBqzxWu5qvCmo8ekEG/dMArnHbMg24m1XrIvAR2fjo0dYvF19jO5nQN6nOZZAZzqw==
X-Received: by 2002:a9d:4c15:: with SMTP id l21mr331639otf.204.1573014835602;
        Tue, 05 Nov 2019 20:33:55 -0800 (PST)
Received: from localhost (24-155-109-49.dyn.grandenetworks.net. [24.155.109.49])
        by smtp.gmail.com with ESMTPSA id m14sm6399297otl.26.2019.11.05.20.33.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Nov 2019 20:33:54 -0800 (PST)
Date:   Tue, 5 Nov 2019 22:33:54 -0600
From:   Rob Herring <robh@kernel.org>
To:     Grygorii Strashko <grygorii.strashko@ti.com>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org,
        Sekhar Nori <nsekhar@ti.com>, linux-kernel@vger.kernel.org,
        Grygorii Strashko <grygorii.strashko@ti.com>
Subject: Re: [PATCH] dt-bindings: net: davinci-mdio: convert bindings to
 json-schema
Message-ID: <20191106043354.GA17824@bogus>
References: <20191101164502.19089-1-grygorii.strashko@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191101164502.19089-1-grygorii.strashko@ti.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 1 Nov 2019 18:45:02 +0200, Grygorii Strashko wrote:
> Now that we have the DT validation in place, let's convert the device tree
> bindings for the TI SoC Davinci/OMAP/Keystone2 MDIO Controllerr over to a
> YAML schemas.
> 
> Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
> ---
> changes since rfc:
>  - removed old bindings
>  - bus_freq defined as "required" for davinci_mdio
> rfc: https://lkml.org/lkml/2019/10/24/300
> 
>  .../devicetree/bindings/net/davinci-mdio.txt  | 36 ----------
>  .../bindings/net/ti,davinci-mdio.yaml         | 71 +++++++++++++++++++
>  2 files changed, 71 insertions(+), 36 deletions(-)
>  delete mode 100644 Documentation/devicetree/bindings/net/davinci-mdio.txt
>  create mode 100644 Documentation/devicetree/bindings/net/ti,davinci-mdio.yaml
> 

Applied, thanks.

Rob
