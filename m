Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E066966197F
	for <lists+netdev@lfdr.de>; Sun,  8 Jan 2023 21:48:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230396AbjAHUsK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 8 Jan 2023 15:48:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234698AbjAHUsH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 8 Jan 2023 15:48:07 -0500
Received: from mail-il1-f175.google.com (mail-il1-f175.google.com [209.85.166.175])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8E0A10567;
        Sun,  8 Jan 2023 12:48:06 -0800 (PST)
Received: by mail-il1-f175.google.com with SMTP id u8so4011650ilg.0;
        Sun, 08 Jan 2023 12:48:06 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vHxr5mLuFxmWvfavlVBIREuSSqKhQ3d2Z/8DjGXmg6Y=;
        b=xdgq2C2q7b3nsX9KRPvxFQAU2c93BsE6cJRGVyG2ICnH/cRQUKbO3e8O/y7uMUwLW+
         NQwab2qrqPWykXHvioJaxge3w4rw7zWr17nKZ6rB/pA5aMd2Cn3/0GUrHhcXbFIDRmk7
         UqQHRZkBQJkxL5tze1LOb/A2j7u3HegfviYEttsIdiS4SKDUL+mdbF+ntGTTxLbeQ1xV
         Kot8HH9+ZDlg9Cc1hqkh5sTFRk/fUoEitkSOGd69v9AdJZ/nAgmRXgWEohxVw72IcYpk
         LrqMq7C7q9aYHvRfU1RKYAkvQTb/G1WDneYw/dvxoY4ubXOOj55X/EEmaPq2Xfc55L0j
         vpIA==
X-Gm-Message-State: AFqh2kpVzXNqD7qFXmb4Eto3tKU6jBbuQgBVER+3zDVRF8pZdHxWsl+F
        HdacEhmS6l5NI/RWqNdjqQ==
X-Google-Smtp-Source: AMrXdXuKPepv4kuDDCDpddQUERh7QcI/R4QfMSI3MATnClFZ8929Mwc47cRjT8t6wT+NiTY1wwqFAg==
X-Received: by 2002:a92:d7c3:0:b0:30b:f88a:b507 with SMTP id g3-20020a92d7c3000000b0030bf88ab507mr41981963ilq.17.1673210886151;
        Sun, 08 Jan 2023 12:48:06 -0800 (PST)
Received: from robh_at_kernel.org ([2605:ef80:8069:516a:f2b0:691e:4315:7c0f])
        by smtp.gmail.com with ESMTPSA id g28-20020a02271c000000b003757ab96c08sm2243925jaa.67.2023.01.08.12.48.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 08 Jan 2023 12:48:05 -0800 (PST)
Received: (nullmailer pid 254609 invoked by uid 1000);
        Sun, 08 Jan 2023 20:48:02 -0000
Date:   Sun, 8 Jan 2023 14:48:02 -0600
From:   Rob Herring <robh@kernel.org>
To:     Philipp Zabel <p.zabel@pengutronix.de>
Cc:     Paolo Abeni <pabeni@redhat.com>, linux-wireless@vger.kernel.org,
        Johannes Berg <johannes@sipsolutions.net>,
        devicetree@vger.kernel.org, netdev@vger.kernel.org,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>, kernel@pengutronix.de,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/2] dt-bindings: net: Add rfkill-gpio binding
Message-ID: <167321088153.254537.14539950692993362753.robh@kernel.org>
References: <20230102-rfkill-gpio-dt-v2-0-d1b83758c16d@pengutronix.de>
 <20230102-rfkill-gpio-dt-v2-1-d1b83758c16d@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230102-rfkill-gpio-dt-v2-1-d1b83758c16d@pengutronix.de>
X-Spam-Status: No, score=-1.3 required=5.0 tests=BAYES_00,
        FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On Mon, 02 Jan 2023 18:29:33 +0100, Philipp Zabel wrote:
> Add a device tree binding document for GPIO controlled rfkill switches.
> The label and radio-type properties correspond to the name and type
> properties used for ACPI, respectively. The shutdown-gpios property
> is the same as defined for ACPI.
> 
> Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
> ---
> Changes since v1:
> - Drop quotes from $id and $schema (Krzysztof)
> - Use generic label property (Rob, Krzysztof)
> - Rename type property to radio-type (Rob)
> - Reorder list of radio types alphabetically (Krzysztof)
> - Drop reset-gpios property (Rob, Krzysztof)
> - Use generic node name in example (Rob, Krzysztof)
> ---
>  .../devicetree/bindings/net/rfkill-gpio.yaml       | 51 ++++++++++++++++++++++
>  1 file changed, 51 insertions(+)
> 

Reviewed-by: Rob Herring <robh@kernel.org>
