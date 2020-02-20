Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7114416687B
	for <lists+netdev@lfdr.de>; Thu, 20 Feb 2020 21:36:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729090AbgBTUgk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Feb 2020 15:36:40 -0500
Received: from mail-oi1-f194.google.com ([209.85.167.194]:36738 "EHLO
        mail-oi1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728582AbgBTUgj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Feb 2020 15:36:39 -0500
Received: by mail-oi1-f194.google.com with SMTP id c16so28956650oic.3;
        Thu, 20 Feb 2020 12:36:39 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=dTWnQ3lvBmB7ErgPURmWXOoQ/e5ybUtPY0ge36pNzVk=;
        b=ObtDcSwNnPoxbsU2S/HdnbRZjp4ejrkGrPdcYNIfPj2ghI6Oqf99H8WSK0FWCEYvJD
         x/g8CFsEEAccr0MF8eHrJXenKeKHOvSgsb3FilscNjmAhU0MsmwnaaIB8JrQwNZZn1Pn
         rgCos8WjHmiivlRgXLpZxC4+aUTtdslctEMrBe9PumqMP/q+2jLfD5xtYXbAgALavpey
         MVKTdpOQg+KkihgTffwYnL6Q21EflfEn9qem/t4S9m58eCw6SIKp11t+jDIXm6jQN+dR
         DJVadjn0bcRhOrPlfu/CrHHn4yvdsxJ7AE4zS4DurutPYnByNzVe12qUR/mtxgu2skIq
         w5Ww==
X-Gm-Message-State: APjAAAWBll/5KuzMcZjF3pDws2LDnTbrQw9zLgD5EKQruKO6Zg/3aSkw
        2QEvzr2uTlaQO+fspLBPNA==
X-Google-Smtp-Source: APXvYqxq6Fef/uB5nvq/j1hNavakwK21btDjib4pkIuE15IOqq9rtqlxMlELf9zdDMgdlOB20Qhzew==
X-Received: by 2002:aca:d502:: with SMTP id m2mr3358601oig.41.1582230999091;
        Thu, 20 Feb 2020 12:36:39 -0800 (PST)
Received: from rob-hp-laptop (24-155-109-49.dyn.grandenetworks.net. [24.155.109.49])
        by smtp.gmail.com with ESMTPSA id k18sm120714oiw.44.2020.02.20.12.36.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Feb 2020 12:36:38 -0800 (PST)
Received: (nullmailer pid 17428 invoked by uid 1000);
        Thu, 20 Feb 2020 20:36:37 -0000
Date:   Thu, 20 Feb 2020 14:36:37 -0600
From:   Rob Herring <robh@kernel.org>
To:     Ansuel Smith <ansuelsmth@gmail.com>
Cc:     Ansuel Smith <ansuelsmth@gmail.com>,
        Andy Gross <agross@kernel.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        "David S. Miller" <davem@davemloft.net>,
        Mark Rutland <mark.rutland@arm.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        linux-arm-msm@vger.kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/2] Documentation: devictree: Add ipq806x mdio
 bindings
Message-ID: <20200220203637.GA16998@bogus>
References: <20200220170732.12741-1-ansuelsmth@gmail.com>
 <20200220170732.12741-2-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200220170732.12741-2-ansuelsmth@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 20 Feb 2020 18:07:29 +0100, Ansuel Smith wrote:
> Add documentations for ipq806x mdio driver.
> 
> Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
> ---
>  .../bindings/net/qcom,ipq8064-mdio.yaml       | 52 +++++++++++++++++++
>  1 file changed, 52 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/net/qcom,ipq8064-mdio.yaml
> 

My bot found errors running 'make dt_binding_check' on your patch:

warning: no schema found in file: Documentation/devicetree/bindings/net/qcom,ipq8064-mdio.yaml
/builds/robherring/linux-dt-review/Documentation/devicetree/bindings/net/qcom,ipq8064-mdio.yaml: ignoring, error in schema: $id
Documentation/devicetree/bindings/display/simple-framebuffer.example.dts:21.16-37.11: Warning (chosen_node_is_root): /example-0/chosen: chosen node must be at root node
/builds/robherring/linux-dt-review/Documentation/devicetree/bindings/net/qcom,ipq8064-mdio.yaml: $id: 'http://devicetree.org/schemas/net/qcom,ipq8064-mdio.txt' does not match 'http://devicetree.org/schemas/.*\\.yaml#'
/builds/robherring/linux-dt-review/Documentation/devicetree/bindings/net/qcom,ipq8064-mdio.yaml: 'maintainers' is a required property
Documentation/devicetree/bindings/Makefile:12: recipe for target 'Documentation/devicetree/bindings/net/qcom,ipq8064-mdio.example.dts' failed
make[1]: *** [Documentation/devicetree/bindings/net/qcom,ipq8064-mdio.example.dts] Error 1
Makefile:1263: recipe for target 'dt_binding_check' failed
make: *** [dt_binding_check] Error 2

See https://patchwork.ozlabs.org/patch/1241574
Please check and re-submit.
