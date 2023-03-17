Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 35C246BF3A0
	for <lists+netdev@lfdr.de>; Fri, 17 Mar 2023 22:13:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230060AbjCQVNF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Mar 2023 17:13:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229680AbjCQVNE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Mar 2023 17:13:04 -0400
Received: from mail-il1-f170.google.com (mail-il1-f170.google.com [209.85.166.170])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E4D6F951;
        Fri, 17 Mar 2023 14:13:03 -0700 (PDT)
Received: by mail-il1-f170.google.com with SMTP id h7so3423373ila.5;
        Fri, 17 Mar 2023 14:13:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679087583;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0cLT9nvbyGDO+rZS3qLUAHKtUfaXz4dTYvgAZ9mY5+E=;
        b=NpWMh+H/TD2usHQijYSLrbgfH08F/dXQAukjeJk8X3pFC3/OOoyaeJqDGolc4GsFdD
         sX3tFXazEBEGNvrksvkPxxrrE/YmQPhKdhI1rUiuX5QiqT1GMKBoLwPe74jLuI0Tgsgl
         mViVoGLWjhM1SJsAxotvIUK/bfmMQD4Jj1eJ5fquCfZMa93wqJxlQsv3Wv2agSu7Oiik
         D47JBbCZkF1QowdIAp5dm436H1wptG5fYqy8DS5ODZfzF+NtLRqzBVeDAHpGWt/T4gAk
         u4oqvFZ0mNY6YfkzCb3DgfFh0RGaMGlkdpMqEzjULOpQHzdZkz8R7Wmo/JsCH6CmOg/i
         JR2w==
X-Gm-Message-State: AO0yUKX/Gmnk2m+ztIn66dn4lTEmLbl9GNRBJ/eRMTE5aX7FFTV6IFjX
        /MG7dvcRZcBBshVSaXFR0A==
X-Google-Smtp-Source: AK7set+kHa11pPniVGqEyT+IX45l08nf/CPb3WXSyO/YNiwEYWD2EUMXyJV7HLcXyV4EPbUjxdWQlg==
X-Received: by 2002:a92:d40c:0:b0:317:93dc:10f5 with SMTP id q12-20020a92d40c000000b0031793dc10f5mr33737ilm.19.1679087582684;
        Fri, 17 Mar 2023 14:13:02 -0700 (PDT)
Received: from robh_at_kernel.org ([64.188.179.249])
        by smtp.gmail.com with ESMTPSA id i35-20020a056638382300b003a607dccd1bsm1009090jav.17.2023.03.17.14.13.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Mar 2023 14:13:02 -0700 (PDT)
Received: (nullmailer pid 2814507 invoked by uid 1000);
        Fri, 17 Mar 2023 21:13:00 -0000
Date:   Fri, 17 Mar 2023 16:13:00 -0500
From:   Rob Herring <robh@kernel.org>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Vladimir Oltean <olteanv@gmail.com>,
        Christian Marangi <ansuelsmth@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Gregory Clement <gregory.clement@bootlin.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Andy Gross <agross@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konrad.dybcio@linaro.org>,
        John Crispin <john@phrozen.org>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-arm-msm@vger.kernel.org, Lee Jones <lee@kernel.org>,
        linux-leds@vger.kernel.org
Subject: Re: [net-next PATCH v3 09/14] dt-bindings: net: dsa: dsa-port:
 Document support for LEDs node
Message-ID: <20230317211300.GA2811156-robh@kernel.org>
References: <20230314101516.20427-1-ansuelsmth@gmail.com>
 <20230314101516.20427-1-ansuelsmth@gmail.com>
 <20230314101516.20427-10-ansuelsmth@gmail.com>
 <20230314101516.20427-10-ansuelsmth@gmail.com>
 <20230315005000.co4in33amy3t3xbx@skbuf>
 <afd1f052-6bb6-4388-9620-1adb02e6d607@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <afd1f052-6bb6-4388-9620-1adb02e6d607@lunn.ch>
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,
        FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 15, 2023 at 02:58:23AM +0100, Andrew Lunn wrote:
> On Wed, Mar 15, 2023 at 02:50:00AM +0200, Vladimir Oltean wrote:
> > On Tue, Mar 14, 2023 at 11:15:11AM +0100, Christian Marangi wrote:
> > > Document support for LEDs node in dsa port.
> > > Switch may support different LEDs that can be configured for different
> > > operation like blinking on traffic event or port link.
> > > 
> > > Also add some Documentation to describe the difference of these nodes
> > > compared to PHY LEDs, since dsa-port LEDs are controllable by the switch
> > > regs and the possible intergated PHY doesn't have control on them.
> > > 
> > > Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
> > > ---
> > >  .../devicetree/bindings/net/dsa/dsa-port.yaml | 21 +++++++++++++++++++
> > >  1 file changed, 21 insertions(+)
> > 
> > Of all schemas, why did you choose dsa-port.yaml? Why not either something
> > hardware specific (qca8k.yaml) or more generic (ethernet-controller.yaml)?
> 
> The binding should be generic. So qca8k.yaml is way to specific. The
> Marvell switch should re-use it at some point.
> 
> Looking at the hierarchy, ethernet-controller.yaml would work since
> dsa-port includes ethernet-switch-port, which includes
> ethernet-controller.
> 
> These are MAC LEDs, and there is no reason why a standalone MAC in a
> NIC could not implement such LEDs. So yes,
> ethernet-controller.yaml.
> 
> Is there actually anything above ethernet-controller.yaml?

Yes, the one under review[1].

Rob
 
[1] https://lore.kernel.org/all/20230203-dt-bindings-network-class-v2-0-499686795073@jannau.net/
