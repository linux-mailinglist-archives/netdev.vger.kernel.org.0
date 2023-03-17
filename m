Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 21C656BF33D
	for <lists+netdev@lfdr.de>; Fri, 17 Mar 2023 21:57:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229581AbjCQU5Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Mar 2023 16:57:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229499AbjCQU5O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Mar 2023 16:57:14 -0400
Received: from mail-io1-f51.google.com (mail-io1-f51.google.com [209.85.166.51])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42B1060435;
        Fri, 17 Mar 2023 13:57:04 -0700 (PDT)
Received: by mail-io1-f51.google.com with SMTP id v10so2855950iol.9;
        Fri, 17 Mar 2023 13:57:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679086623;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uLFg5SJlhums3IhrKCKFmTnC2PnKge+4XwzniRuOanQ=;
        b=yEn7k7fFrpuKCdYONc7AwpuurbC7Qhxr2qWuGC1Z2OnAES8hJK4wv986cCQ/NDrjZE
         XMd1iQpo3Bwa2uXRdfpFfZ0JZKk/WkAo27r24zNc8+RoOaaeymgSxeAc6k3EpiEYc2zh
         PNwWAmPg76vowijWvHXYrTYDSf5hDaoWC1qMBOqYVL1X0hHBqfiuNQTcmj12DfCVnfm0
         NFebcNTj1fLizzhwnZTMkW6SAao+QaZlGeSt047obIPixUDjsNA0lKDSB4CaVStUmUkv
         +F87TJ6EFbEWlYcVlyUocSQ53KQcODfseGv4qCy5MgQdRanek++WDbMLh5OGPZ491D1C
         uRDw==
X-Gm-Message-State: AO0yUKVMlHRxRYfAj/gGPrVBnnNWMJKox7bqKwYXRD9XPvvfKj/HZuWS
        4eD0gn98kA3O8DyJNygCBA==
X-Google-Smtp-Source: AK7set/Rej6w9mB2VDRi5FHjVEC3hMKbesjJ9soHth3jWZgIRADTjBlxR2RmJUvd0fxae8dMdcK3qw==
X-Received: by 2002:a5e:a918:0:b0:753:568:358e with SMTP id c24-20020a5ea918000000b007530568358emr472070iod.20.1679086623499;
        Fri, 17 Mar 2023 13:57:03 -0700 (PDT)
Received: from robh_at_kernel.org ([64.188.179.249])
        by smtp.gmail.com with ESMTPSA id n17-20020a02a191000000b003a958069dbfsm1009918jah.8.2023.03.17.13.57.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Mar 2023 13:57:02 -0700 (PDT)
Received: (nullmailer pid 2788499 invoked by uid 1000);
        Fri, 17 Mar 2023 20:57:00 -0000
Date:   Fri, 17 Mar 2023 15:57:00 -0500
From:   Rob Herring <robh@kernel.org>
To:     Serge Semin <Sergey.Semin@baikalelectronics.ru>
Cc:     Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        linux-arm-kernel@lists.infradead.org,
        Pavel Parkhomenko <Pavel.Parkhomenko@baikalelectronics.ru>,
        Christian Marangi <ansuelsmth@gmail.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Richard Cochran <richardcochran@gmail.com>,
        Serge Semin <fancer.lancer@gmail.com>,
        linux-kernel@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Yang Yingliang <yangyingliang@huawei.com>,
        linux-stm32@st-md-mailman.stormreply.com,
        Biao Huang <biao.huang@mediatek.com>, netdev@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>,
        Alexey Malahov <Alexey.Malahov@baikalelectronics.ru>,
        devicetree@vger.kernel.org
Subject: Re: [PATCH net-next 16/16] dt-bindings: net: dwmac: Add MTL Tx queue
 CBS-algo props dependencies
Message-ID: <167908661916.2788441.13598395924571888568.robh@kernel.org>
References: <20230313225103.30512-1-Sergey.Semin@baikalelectronics.ru>
 <20230313225103.30512-17-Sergey.Semin@baikalelectronics.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230313225103.30512-17-Sergey.Semin@baikalelectronics.ru>
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,
        FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On Tue, 14 Mar 2023 01:51:03 +0300, Serge Semin wrote:
> Currently the CBS algorithm specific properties could be used
> unconditionally in the MTL Tx queue sub-nodes. It's definitely wrong from
> the correct Tx queue description point of view. Let's fix that in a way so
> the "snps,send_slope", "snps,idle_slope", "snps,high_credit" and
> "snps,low_credit" properties would be allowed only if the CBS TC algorithm
> is enabled for the MTL Tx queue.
> 
> Signed-off-by: Serge Semin <Sergey.Semin@baikalelectronics.ru>
> ---
>  Documentation/devicetree/bindings/net/snps,dwmac.yaml | 5 +++++
>  1 file changed, 5 insertions(+)
> 

Reviewed-by: Rob Herring <robh@kernel.org>

