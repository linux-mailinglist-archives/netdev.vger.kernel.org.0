Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3633E4B79CC
	for <lists+netdev@lfdr.de>; Tue, 15 Feb 2022 22:50:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244254AbiBOVB0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Feb 2022 16:01:26 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:59980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235440AbiBOVBY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Feb 2022 16:01:24 -0500
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FFC927FE3;
        Tue, 15 Feb 2022 13:01:14 -0800 (PST)
Received: by mail-pf1-x42c.google.com with SMTP id c4so282622pfl.7;
        Tue, 15 Feb 2022 13:01:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=wTa2P1MgBvk9m62qPWIOit490TSiIyPTgJSzWGel9bY=;
        b=Rs1oCdwMxQfYIGJWKXdRuZnB1Ma80VhEoTYeNZtsDwRds0jVEX5HUNouyWNpmnPRKb
         HrTm06k3tzmIkSplIDIRp684mUUaOheiW/2QtnudPz20P9C8zBxZYOByhkQ4IovjwnNm
         gHmN6sHkkNbAviSAEYQRkXI65xNnpBRvYb9v2CvjUk5LzL6CqNDk13QeIt9g9sdrQMO/
         B/bhfV5Cd2A4UTggseJf4bvZj70EpYruSXaUY9s1t+/VjpfyHxIpuR9qWDQvNJXHl2NT
         wKbWwhiOGuuRMHGLMGPAETmWCZpAijdKjM52I71SuZ9GXDQYgLSEykguUq2mYOQQClOn
         tfng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=wTa2P1MgBvk9m62qPWIOit490TSiIyPTgJSzWGel9bY=;
        b=gttvPXs0JJzkW2KEzGutEgF+BslUPfMQ794H4Q+zItntEQ5UYM3uEyryDtJWItXLWz
         U4tJrhiosY66N2NN8RNT3xcPWbTpIkB++gwCMXQqs2kkIJ1bYWAqA2qksmN3SFu/FevE
         8DJH5RB8BsIq50M5KdTyOcdOsXflEKn/8rUbUrrlR3O3zs7+9KUzj2IHMG5lpZ460epa
         avIBEm4XepWqL5eOLuIIJpr0eobfq5OgdfkA2cNf+1ORZolTkduW9keJGDFAo+AgSQNi
         L84RlZHie2adCSQx1u8D/lQUws9IFMCtDU23+jsSOkYpXniGustZzDMMfkpUnG9Nm2oP
         ucYA==
X-Gm-Message-State: AOAM5327KHvc+TjiEVXGHNTbezky5tkculQHv+y9MLAhHBpxq6YPwTok
        3g6z4Ia3BIInsauGWQ3x7ynOX1SRwYQ=
X-Google-Smtp-Source: ABdhPJxyQSAmCDE8WPMyCfUAI8JQM4Z7dyqZXvdtO7dYQTgEBuIQYkUh24QMtAyo8fvuDu2mO6aCAw==
X-Received: by 2002:a63:234d:: with SMTP id u13mr628141pgm.128.1644958873451;
        Tue, 15 Feb 2022 13:01:13 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id w12sm3306242pgl.64.2022.02.15.13.01.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 15 Feb 2022 13:01:12 -0800 (PST)
Subject: Re: [PATCH v3 4/8] ARM: dts: bcm283x: fix ethernet node name
To:     Oleksij Rempel <o.rempel@pengutronix.de>,
        =?UTF-8?Q?Beno=c3=aet_Cousson?= <bcousson@baylibre.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        Nicolas Saenz Julienne <nsaenz@kernel.org>,
        Ray Jui <rjui@broadcom.com>, Rob Herring <robh+dt@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Scott Branden <sbranden@broadcom.com>,
        Shawn Guo <shawnguo@kernel.org>,
        Tony Lindgren <tony@atomide.com>
Cc:     kernel@pengutronix.de, bcm-kernel-feedback-list@broadcom.com,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-rpi-kernel@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-tegra@vger.kernel.org
References: <20220215080937.2263111-1-o.rempel@pengutronix.de>
 <20220215080937.2263111-4-o.rempel@pengutronix.de>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <f5ea3375-0306-e37f-5847-e1472164d7b7@gmail.com>
Date:   Tue, 15 Feb 2022 13:01:06 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20220215080937.2263111-4-o.rempel@pengutronix.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/15/22 12:09 AM, Oleksij Rempel wrote:
> It should be "ethernet@x" instead of "usbether@x"
> 
> Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>

This looks like, a quick grep on the u-boot source code seems to suggest
that only one file is assuming that 'usbether@1' is to be used as a node
name and the error message does not even match the code it is patching:

board/liebherr/xea/xea.c:
  #ifdef CONFIG_OF_BOARD_SETUP
  static int fdt_fixup_l2switch(void *blob)
  {
          u8 ethaddr[6];
          int ret;

          if (eth_env_get_enetaddr("ethaddr", ethaddr)) {
                  ret = fdt_find_and_setprop(blob,

"/ahb@80080000/switch@800f0000",
                                             "local-mac-address",
ethaddr, 6, 1);
                  if (ret < 0)
                          printf("%s: can't find usbether@1 node: %d\n",
                                 __func__, ret);
          }

          return 0;
  }

I will wait for the other maintainers on the other patches to provide
some feedback, but if all is well, will apply this one soon.
-- 
Florian
