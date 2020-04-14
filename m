Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F6BB1A8890
	for <lists+netdev@lfdr.de>; Tue, 14 Apr 2020 20:06:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2503351AbgDNSFb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Apr 2020 14:05:31 -0400
Received: from mail-ot1-f68.google.com ([209.85.210.68]:45057 "EHLO
        mail-ot1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2407784AbgDNSEd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Apr 2020 14:04:33 -0400
Received: by mail-ot1-f68.google.com with SMTP id i22so531888otp.12;
        Tue, 14 Apr 2020 11:04:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=X8HnP8qvwXULBtvNF32k/xLU2uHML1H+p2xHE6J9vac=;
        b=eyb775zagT+mwpFNkJJXurRNxjMbWnanvSb3K1/u2jtpoLhcxnZRI+qclBIJf14kp1
         5+S831a/q1KNeTIf9WyLMSr1yIjCfg5SpxNnhfmoZmxBaWECjcx5ikTJw4jOM8SWAOxB
         nS5+eJdjTopL8VYUfiAgeY0SbQhsDYN+peJEcVs+WDVNngEk+fhy0IRv65RDLYQD9P+T
         zE3HxPBfoUrxsvGZM+I0DMEPsIJlYGztg6fwKEf6IXZ+GsXU+xJbIQyHud2rw15bjq4K
         8Q84amchhLAEHgWkxtWJMMVmZL3t2rxMjVgc5MZd+T5oPoOC3Jt5w9c219KzJ58XxyxL
         DYqQ==
X-Gm-Message-State: AGi0Pua5iqBe5dn6ZaaXsYNG+ORnzK2QCeq+bW46DbN9hesz8hNf+PTh
        1ZckNTnX+zOmJ0a+btNgLQ==
X-Google-Smtp-Source: APiQypKU3vXmgT04leTbcZl+K+74cxsiUS9r32WTmebpcpqG/ivXWoMLBr8jyRZWS5laaRPbzqwoKA==
X-Received: by 2002:a4a:3ec1:: with SMTP id t184mr19168387oot.3.1586887472468;
        Tue, 14 Apr 2020 11:04:32 -0700 (PDT)
Received: from rob-hp-laptop (24-155-109-49.dyn.grandenetworks.net. [24.155.109.49])
        by smtp.gmail.com with ESMTPSA id g30sm6238585oof.39.2020.04.14.11.04.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Apr 2020 11:04:31 -0700 (PDT)
Received: (nullmailer pid 19544 invoked by uid 1000);
        Tue, 14 Apr 2020 18:04:30 -0000
Date:   Tue, 14 Apr 2020 13:04:30 -0500
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
Subject: Re: [PATCH V2 1/2] dt-bindings: net: dwmac: increase 'maxItems' for
 'clocks', 'clock-names' properties
Message-ID: <20200414180430.GA19162@bogus>
References: <20200403140415.29641-1-christophe.roullier@st.com>
 <20200403140415.29641-2-christophe.roullier@st.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200403140415.29641-2-christophe.roullier@st.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 3 Apr 2020 16:04:14 +0200, Christophe Roullier wrote:
> This change is needed for some soc based on snps,dwmac, which have
> more than 3 clocks.
> 
> Signed-off-by: Christophe Roullier <christophe.roullier@st.com>
> ---
>  Documentation/devicetree/bindings/net/snps,dwmac.yaml | 8 +++++++-
>  1 file changed, 7 insertions(+), 1 deletion(-)
> 

Applied, thanks.

Rob
