Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 654DD1A8888
	for <lists+netdev@lfdr.de>; Tue, 14 Apr 2020 20:05:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2503341AbgDNSFT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Apr 2020 14:05:19 -0400
Received: from mail-ot1-f68.google.com ([209.85.210.68]:38889 "EHLO
        mail-ot1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2503320AbgDNSFM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Apr 2020 14:05:12 -0400
Received: by mail-ot1-f68.google.com with SMTP id k21so593738otl.5;
        Tue, 14 Apr 2020 11:05:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=zyyunDAx2uwMbONH8a30TAmLrXMLmxuwK8FL24ovkME=;
        b=JFxQUOQkSPavTwKxaFjhv/X3LDTpupPeFo0eKLKjS5poICwObiX7bA7UcKA1wRQuiu
         KJlvG/PpnEDRMiyV6LDM9WCniJWHA+BcX5aQNDKmVF3HZPvSWWCQSlZab5KNAAXOwuw0
         809MLwv5cW3O3PGGhUsDoU7swVQv/m8XrIPLTMZ+m2th6reXvqc5jp9aT9Lq90rZ0UYz
         TQPuvSDxxY6H9+AZSEGGqlXvywCb06mWNwErHyZPsGeDgZVjKHx95ro0poiPwcXSG8qv
         VHaAEditzZStcFuSQ9VPz+lE22Bx6spXVj+DJm/bPa7KJH0LJZXrL9BnpWDlB76v8yPJ
         8Abw==
X-Gm-Message-State: AGi0PuZu0IURcrgbcTftmzKk25SxkVgTPf7gG0r2hA0u0rmKIWFgl6y/
        9tDC7CE+3jTOfYgpIeJAD9ToBvI=
X-Google-Smtp-Source: APiQypLDJoJx7Di661s5byWD9ZVHoJghminhZPKnbjGm47MDfVVSc1w/i75wcXKy25C30Z1LkclSBg==
X-Received: by 2002:a9d:b8c:: with SMTP id 12mr19626038oth.205.1586887511542;
        Tue, 14 Apr 2020 11:05:11 -0700 (PDT)
Received: from rob-hp-laptop (24-155-109-49.dyn.grandenetworks.net. [24.155.109.49])
        by smtp.gmail.com with ESMTPSA id e21sm6180403ooh.31.2020.04.14.11.05.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Apr 2020 11:05:11 -0700 (PDT)
Received: (nullmailer pid 22106 invoked by uid 1000);
        Tue, 14 Apr 2020 18:05:10 -0000
Date:   Tue, 14 Apr 2020 13:05:09 -0500
From:   Rob Herring <robh@kernel.org>
To:     Christophe Roullier <christophe.roullier@st.com>
Cc:     davem@davemloft.net, robh+dt@kernel.org, mark.rutland@arm.com,
        mripard@kernel.org, martin.blumenstingl@googlemail.com,
        alexandru.ardelean@analog.com, narmstrong@baylibre.com,
        mcoquelin.stm32@gmail.com, alexandre.torgue@st.com,
        devicetree@vger.kernel.org, netdev@vger.kernel.org,
        christophe.roullier@st.com, linux-kernel@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH V2 2/2] dt-bindings: net: dwmac: Convert stm32 dwmac to
 DT schema
Message-ID: <20200414180509.GA21967@bogus>
References: <20200403140415.29641-1-christophe.roullier@st.com>
 <20200403140415.29641-3-christophe.roullier@st.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200403140415.29641-3-christophe.roullier@st.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 3 Apr 2020 16:04:15 +0200, Christophe Roullier wrote:
> Convert stm32 dwmac to DT schema.
> 
> Signed-off-by: Christophe Roullier <christophe.roullier@st.com>
> ---
>  .../devicetree/bindings/net/stm32-dwmac.txt   |  44 -----
>  .../devicetree/bindings/net/stm32-dwmac.yaml  | 150 ++++++++++++++++++
>  2 files changed, 150 insertions(+), 44 deletions(-)
>  delete mode 100644 Documentation/devicetree/bindings/net/stm32-dwmac.txt
>  create mode 100644 Documentation/devicetree/bindings/net/stm32-dwmac.yaml
> 

Applied, thanks.

Rob
