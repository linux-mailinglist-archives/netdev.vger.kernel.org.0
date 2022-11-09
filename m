Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BA3A9623641
	for <lists+netdev@lfdr.de>; Wed,  9 Nov 2022 23:00:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232045AbiKIWAJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Nov 2022 17:00:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229657AbiKIWAG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Nov 2022 17:00:06 -0500
Received: from mail-oa1-f54.google.com (mail-oa1-f54.google.com [209.85.160.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FCBE15824;
        Wed,  9 Nov 2022 14:00:05 -0800 (PST)
Received: by mail-oa1-f54.google.com with SMTP id 586e51a60fabf-13bef14ea06so323653fac.3;
        Wed, 09 Nov 2022 14:00:05 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MBKBlPlYHH+d23qoAhQOq2lKx+b+s6DjJqW2E+tnx78=;
        b=vF1Ae9NzXfI6JISwGKGv8JwLRALwEyCqkoDFVQAGy+3LcBSoCBU+7VXyx5S8QyPtwR
         1srm2pvBJ1DEBcM62BB5SfO27jYfmn/biwp0CNuPPo0OmobUJOX2oQZWbLGeFsHTGEDa
         wBpKXEFQU6B5PKyZFz2Jcs40T0oRcGw+VlLkasZZT7Mcxy3TyQPeQgO7mPQ+KN7HO1qg
         I1VY56c064WJLyVPhp114NImk9KkZb8oZzKRUFtZqycjCov3z64WWQ2JF0vc8ut4z/L4
         rC5i4aB7OHpr39YsRcZmPk/q6tW4q/T5EFtY0xAhV4uG459nZIrCl+6emUO3KIlL3PDp
         TRtg==
X-Gm-Message-State: ACrzQf0y7tgNg9mFaaIP1cwh8qDSQnoQBkj+VVq0ctazDHhYRwrXUfax
        fElWXxQx4W8TgNnoqodLeQ==
X-Google-Smtp-Source: AMsMyM6RtkRPsY/21k9tRFMpIeKt38HsQlzu9nAZrPUmyHUaj27aNg7tYDMULJ1nSDY2kux7Z8WMjg==
X-Received: by 2002:a05:6870:a2ce:b0:131:a8bc:54db with SMTP id w14-20020a056870a2ce00b00131a8bc54dbmr38331247oak.187.1668031204238;
        Wed, 09 Nov 2022 14:00:04 -0800 (PST)
Received: from robh_at_kernel.org (66-90-144-107.dyn.grandenetworks.net. [66.90.144.107])
        by smtp.gmail.com with ESMTPSA id er33-20020a056870c8a100b00131c3d4d38fsm6666398oab.39.2022.11.09.14.00.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Nov 2022 14:00:03 -0800 (PST)
Received: (nullmailer pid 2946725 invoked by uid 1000);
        Wed, 09 Nov 2022 22:00:05 -0000
Date:   Wed, 9 Nov 2022 16:00:05 -0600
From:   Rob Herring <robh@kernel.org>
To:     Dominique Martinet <dominique.martinet@atmark-techno.com>
Cc:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Marcel Holtmann <marcel@holtmann.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, linux-bluetooth@vger.kernel.org,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S . Miller" <davem@davemloft.net>, mizo@atmark-techno.com
Subject: Re: [RFC PATCH 1/2] dt-bindings: net: h4-bluetooth: add new bindings
 for hci_h4
Message-ID: <20221109220005.GA2930253-robh@kernel.org>
References: <CAL_JsqKCb2ZA+CLTVnGBMjp6zu0yw-rSFjWRg2S3hA7S6h-XEA@mail.gmail.com>
 <6a4f7104-8b6f-7dcd-a7ac-f866956e31d6@linaro.org>
 <Y2rsQowbtvOdmQO9@atmark-techno.com>
 <Y2tW8EMmhTpCwitM@atmark-techno.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y2tW8EMmhTpCwitM@atmark-techno.com>
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,
        FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 09, 2022 at 04:29:52PM +0900, Dominique Martinet wrote:
> Dominique Martinet wrote on Wed, Nov 09, 2022 at 08:54:42AM +0900:
> > This is a pretty terrible design, as the Bluetooth side cannot actually
> > know when the device is ready as the initialization takes place, but
> > that means there really aren't any property to give here
> > 
> > (I haven't reproduced during normal boot, but in particular if I run
> > bluetoothd before loading the wifi driver, I need to unbind/bind the
> > serial device from the hci_uart_h4 driver to recover bluetooth...
> > With that in mind it might actually be best to try to coordinate this
> > from userspace with btattach after all, and I'd be happy with that if I
> > didn't have to fight our init system so much, but as things stand having
> > it autoloaded by the kernel is more convenient for us... Which is
> > admitedly a weak reason for you all, feel free to tell me this isn't
> > viable)

Punting the issue to userspace is not a great solution...


> This actually hasn't taken long to bite us: while the driver does work,
> we get error messages early on before the firmware is loaded.
> (In hindsight, I probably should have waited a few days before sending
> this...)
> 
> 
> My current workaround is to return EPROBE_DEFER until we can find a
> netdev with a known name in the init namespace, but that isn't really
> something I'd consider upstreamable for obvious reasons (interfaces can
> be renamed or moved to different namespaces so this is inherently racy
> and it's just out of place in BT code)

Can't you just try to access the BT h/w in some way and defer when that 
fails?

Or perhaps use fw_devlink to create a dependency on the wifi node. I'm 
not sure offhand how exactly you do that with a custom property.

Rob
