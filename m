Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B9BF76D9C30
	for <lists+netdev@lfdr.de>; Thu,  6 Apr 2023 17:25:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239064AbjDFPZS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Apr 2023 11:25:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237171AbjDFPZQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Apr 2023 11:25:16 -0400
Received: from mail-oo1-f41.google.com (mail-oo1-f41.google.com [209.85.161.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5949C93C1;
        Thu,  6 Apr 2023 08:25:13 -0700 (PDT)
Received: by mail-oo1-f41.google.com with SMTP id o15-20020a4ae58f000000b00538c0ec9567so6226689oov.1;
        Thu, 06 Apr 2023 08:25:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680794712;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RMkMXwMSZEr9FFGtDRkxvrTAlSRKSswIFRpR7VpqIQQ=;
        b=k3HBo2DBTUnwIvr1Zm4VJho13eiHdId0rZXgQZbQfYH2rRQhgZKyRUSIgEwUhRgYTw
         +5RhO7VXPeqFdrzTUMCG59ra+eojFNlvCyFcEQ/x/iS5P7RnNbN4PHe104TDVLKQirIu
         9kguFF1TJtw3qlWW5T33AhWsbJ4A0COFyXsNe2wenQ8EhvbkiCiM1omjpoygQFARtb1V
         zn62Nsn8hZtPHKr0L61iJXtjhEfiFvPqQhXsj5O7Ikabh4WlNSJ1AXgU4ItfVTDK6RYV
         d2mYO7ai82meWvuf2muhVLYTZc0u+Kbf3IWUHBMHDP6VUKEJ1xPr/AqDVzlRyI8LcrBx
         rgng==
X-Gm-Message-State: AAQBX9eQAsjh/ko3DurjzJb7UZpZluQIm5SaRH89c3waDJgs0x9EEZVv
        oKpAR3sbB89XXlwUrCntIg==
X-Google-Smtp-Source: AKy350aD8i61CSEMsXWO+ODXbKKtkeyWipy3Tnvjy0WnRBnCKMJ4XFPRDEIn9gvkDG7hvfRH5ebobg==
X-Received: by 2002:a4a:e753:0:b0:541:87fe:5b75 with SMTP id n19-20020a4ae753000000b0054187fe5b75mr1415607oov.1.1680794712637;
        Thu, 06 Apr 2023 08:25:12 -0700 (PDT)
Received: from robh_at_kernel.org (66-90-144-107.dyn.grandenetworks.net. [66.90.144.107])
        by smtp.gmail.com with ESMTPSA id j48-20020a4a9473000000b0053dfd96fa61sm646099ooi.39.2023.04.06.08.25.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Apr 2023 08:25:12 -0700 (PDT)
Received: (nullmailer pid 3124644 invoked by uid 1000);
        Thu, 06 Apr 2023 15:25:11 -0000
Date:   Thu, 6 Apr 2023 10:25:11 -0500
From:   Rob Herring <robh@kernel.org>
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
        pabeni@redhat.com, kuba@kernel.org, matthias.bgg@gmail.com,
        linux-mediatek@lists.infradead.org, nbd@nbd.name, john@phrozen.org,
        sean.wang@mediatek.com, Mark-MC.Lee@mediatek.com,
        lorenzo.bianconi@redhat.com, daniel@makrotopia.org,
        krzysztof.kozlowski+dt@linaro.org, devicetree@vger.kernel.org
Subject: Re: [PATCH v2 net-next 00/10] mtk: wed: move cpuboot, ilm and dlm in
 dedicated dts nodes
Message-ID: <20230406152511.GA3117403-robh@kernel.org>
References: <cover.1680268101.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1680268101.git.lorenzo@kernel.org>
X-Spam-Status: No, score=0.8 required=5.0 tests=FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 31, 2023 at 03:12:36PM +0200, Lorenzo Bianconi wrote:
> Since cpuboot, ilm and dlm memory region are not part of MT7986 SoC RAM,

That's not really a requirement. Is that the only "problem" here?

Certainly going from a standard binding to a custom phandle reference is 
not an improvement.

> move them in dedicated mt7986a syscon dts nodes.

What makes them a syscon? Are they memory or h/w registers? Can't be 
both...

Perhaps mmio-sram?

> At the same time we keep backward-compatibility with older dts version where
> cpuboot, ilm and dlm were defined as reserved-memory child nodes.

Doesn't really seem big enough issue to justify carrying this.

Rob
