Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B216D3C622A
	for <lists+netdev@lfdr.de>; Mon, 12 Jul 2021 19:46:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235770AbhGLRtb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Jul 2021 13:49:31 -0400
Received: from mail-io1-f53.google.com ([209.85.166.53]:40603 "EHLO
        mail-io1-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232979AbhGLRt1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Jul 2021 13:49:27 -0400
Received: by mail-io1-f53.google.com with SMTP id l5so23694153iok.7;
        Mon, 12 Jul 2021 10:46:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=kypqM6y1X5Uap1Yv9eo3AY26jWp58MtC35uqeVy+D/s=;
        b=jgAcPzG8Pfk96sQoJIA47dROj8Ii09I36kZbD/xyPmHCnjolWCvLiKF7l8zjvWu2wQ
         oXVXgdS72DlV38t+uGVdytvj+O4NzeMbA+s9r9f8I/I9ND+QLKGN6ZTBk3qd05IP1HuI
         cZ1OZIoNOgJs3neEyyEwxLzru5TzPB0KDnJzLU+/nJ/eezmCHAcv3cPMaM9c1jBAzAnK
         mUGFuHQYvMzaFxZ6bw2NMH8idxJAA2ukcaSh9Aesvl4pvO92zvS3bevPqPvEEYkrHc7d
         ALzsCtHGdHH1YcI2WziDy80YLgNafkQk7uM2lag1Tx6qU5rjajKDEQgjZL3MGvmBM4FD
         QuUg==
X-Gm-Message-State: AOAM532Wn3q1jCLvGu57p8Y8IBnE2ivUF9iGNrl2gDzhxK2ScOmqBMCE
        6oS4X4j6xEv7YbV5hbFWwg==
X-Google-Smtp-Source: ABdhPJxxmnJl24dnArleMtbmuSzlu+wFSZfgs9MLtXLeofedAdnLogZXPQzDxVZDnRWKYHlZECdGFA==
X-Received: by 2002:a5d:8996:: with SMTP id m22mr106500iol.6.1626111997867;
        Mon, 12 Jul 2021 10:46:37 -0700 (PDT)
Received: from robh.at.kernel.org ([64.188.179.248])
        by smtp.gmail.com with ESMTPSA id y13sm7878335ioa.51.2021.07.12.10.46.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Jul 2021 10:46:37 -0700 (PDT)
Received: (nullmailer pid 2180397 invoked by uid 1000);
        Mon, 12 Jul 2021 17:46:35 -0000
Date:   Mon, 12 Jul 2021 11:46:35 -0600
From:   Rob Herring <robh@kernel.org>
To:     alexandru.tachici@analog.com
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux@armlinux.org.uk, hkallweit1@gmail.com,
        linux-kernel@vger.kernel.org, kuba@kernel.org, andrew@lunn.ch,
        davem@davemloft.net
Subject: Re: [PATCH v2 7/7] dt-bindings: adin1100: Add binding for ADIN1100
 Ethernet PHY
Message-ID: <20210712174635.GA2178411@robh.at.kernel.org>
References: <20210712130631.38153-1-alexandru.tachici@analog.com>
 <20210712130631.38153-8-alexandru.tachici@analog.com>
 <1626099173.624231.1850544.nullmailer@robh.at.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1626099173.624231.1850544.nullmailer@robh.at.kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 12, 2021 at 08:12:53AM -0600, Rob Herring wrote:
> On Mon, 12 Jul 2021 16:06:31 +0300, alexandru.tachici@analog.com wrote:
> > From: Alexandru Tachici <alexandru.tachici@analog.com>
> > 
> > DT bindings for the ADIN1100 10BASE-T1L Ethernet PHY.
> > 
> > Signed-off-by: Alexandru Tachici <alexandru.tachici@analog.com>
> > ---
> >  .../devicetree/bindings/net/adi,adin1100.yaml | 45 +++++++++++++++++++
> >  1 file changed, 45 insertions(+)
> >  create mode 100644 Documentation/devicetree/bindings/net/adi,adin1100.yaml
> > 
> 
> My bot found errors running 'make DT_CHECKER_FLAGS=-m dt_binding_check'
> on your patch (DT_CHECKER_FLAGS is new in v5.13):
> 
> yamllint warnings/errors:
> 
> dtschema/dtc warnings/errors:
> Documentation/devicetree/bindings/net/adi,adin1100.example.dt.yaml:0:0: /example-0/ethernet@e000c000: failed to match any schema with compatible: ['cdns,zynq-gem', 'cdns,gem']
> Documentation/devicetree/bindings/net/adi,adin1100.example.dt.yaml:0:0: /example-0/ethernet@e000c000: failed to match any schema with compatible: ['cdns,zynq-gem', 'cdns,gem']

Please either convert the above binding or use something that already 
has a schema.

Rob
