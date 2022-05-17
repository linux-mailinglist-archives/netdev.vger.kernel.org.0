Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F014352A50B
	for <lists+netdev@lfdr.de>; Tue, 17 May 2022 16:37:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349168AbiEQOgv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 May 2022 10:36:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349160AbiEQOgs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 May 2022 10:36:48 -0400
Received: from mail-oi1-f173.google.com (mail-oi1-f173.google.com [209.85.167.173])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 967E840E6E;
        Tue, 17 May 2022 07:36:47 -0700 (PDT)
Received: by mail-oi1-f173.google.com with SMTP id i66so22462658oia.11;
        Tue, 17 May 2022 07:36:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Q5lBuzj7jrTo1bfrQUEvnoU3RNCjBwv86AZJ0JkzGd8=;
        b=iNhJkGORKDj395Y1+YKeTy6eUzfk/hngMFV/li8SzUN9jwvow0t6C63+VddzjWpOKK
         6MTitN79+LmWf5oIQgtPX5NU9SwJobc1knM5OwLljFMWO+v4JqhhgZe4AqEyPj5UE8r7
         cwy75RmKRNkdmeMR01+Ro+KTSXrYYhP8X/3FB21wGxS+37wtevMfAcK9U5UM3YRcFMHK
         7RcAobaaE4ZcBp2Ugw2cRPTHLwcjZR44hj2YAac2PSMpAF9BoxuAxvk7FHxkHtjeVyE6
         rLDAVpLxJPXNiMBR9xdOz36fmjdasBSuCA5uIvar8Z0pXkyYT8nrdY8HlSXe5nyORFkD
         gVDg==
X-Gm-Message-State: AOAM532J6ZWrWUkTDbOKMMjjgq1ODUOV7pcin6RfucjbveadeMv2g7hD
        Nd5nYeHFoQIJGJHhEhRY0A==
X-Google-Smtp-Source: ABdhPJzIcHczmuF3hxxob2E68B85dmbZb4/C/nUn+ACeqTvaX7o7FfPdMwzAISFHxfP0xQ77wLofQA==
X-Received: by 2002:a05:6808:218c:b0:326:955e:f39 with SMTP id be12-20020a056808218c00b00326955e0f39mr10911612oib.237.1652798206877;
        Tue, 17 May 2022 07:36:46 -0700 (PDT)
Received: from robh.at.kernel.org (66-90-144-107.dyn.grandenetworks.net. [66.90.144.107])
        by smtp.gmail.com with ESMTPSA id a18-20020a056870469200b000f18cae8c0esm4282088oap.30.2022.05.17.07.36.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 May 2022 07:36:46 -0700 (PDT)
Received: (nullmailer pid 988925 invoked by uid 1000);
        Tue, 17 May 2022 14:36:45 -0000
Date:   Tue, 17 May 2022 09:36:45 -0500
From:   Rob Herring <robh@kernel.org>
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     davem@davemloft.net, linux-mediatek@lists.infradead.org,
        Sam.Shih@mediatek.com, pabeni@redhat.com,
        lorenzo.bianconi@redhat.com, Mark-MC.Lee@mediatek.com,
        kuba@kernel.org, nbd@nbd.name, sean.wang@mediatek.com,
        edumazet@google.com, netdev@vger.kernel.org, john@phrozen.org,
        devicetree@vger.kernel.org
Subject: Re: [PATCH v2 net-next 02/15] dt-bindings: net: mediatek,net: add
 mt7986-eth binding
Message-ID: <20220517143645.GA986163-robh@kernel.org>
References: <cover.1652716741.git.lorenzo@kernel.org>
 <aa934c3185c9e04893d9c285ed655495a049fa4f.1652716741.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aa934c3185c9e04893d9c285ed655495a049fa4f.1652716741.git.lorenzo@kernel.org>
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,
        FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 16 May 2022 18:06:29 +0200, Lorenzo Bianconi wrote:
> Introduce dts bindings for mt7986 soc in mediatek,net.yaml.
> 
> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> ---
>  .../devicetree/bindings/net/mediatek,net.yaml | 141 +++++++++++++++++-
>  1 file changed, 139 insertions(+), 2 deletions(-)
> 

Doesn't apply for me, so not tested, but:

Reviewed-by: Rob Herring <robh@kernel.org>
