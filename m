Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 101DD1EEDAD
	for <lists+netdev@lfdr.de>; Fri,  5 Jun 2020 00:23:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727793AbgFDWXP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Jun 2020 18:23:15 -0400
Received: from mail-io1-f66.google.com ([209.85.166.66]:40712 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726090AbgFDWXO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Jun 2020 18:23:14 -0400
Received: by mail-io1-f66.google.com with SMTP id q8so8154411iow.7;
        Thu, 04 Jun 2020 15:23:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=8n1ml5PEUVdbXeAwFS38cbuqEwnnmmDCmubjqkKfwRU=;
        b=KRG/+sQCaE+2ygYN4lBL5jMqeGiw1kOQR6QPK1xFk+Z1nytTLBk3iGgtwoQLxxCeK1
         tC/IihOgRB7NDD+FxWuyH5rKR0JGxNmp+Md1vMiJg8kQspW1HgHoEXZTz8Qbr4gnQg4A
         cSlx+nMPsphxH8l0FuyWIhbEiBh4tPrE6Kya7pfoEhOb/EB3XkB7c3myE87SzEFSrSyK
         dd9bP2591OXoBIr07n6EM6GLj5S27Nv4/DHmx8FheHrW6IS6VUp1gInTnRr0pTmBgk6L
         +bndm2Jm7HRIYQOlMqwO2gSB018I201Qw+8/m82DvzMDqeNTPLY+YgqM2H6OrPF/7E+U
         fmSA==
X-Gm-Message-State: AOAM530lLZkCFMT2BCLozgRJNrxHrHeb6VzgvYQAK3y7AvZf1eK16DkZ
        mQDY2pEfmciOTksrBJcDXQ==
X-Google-Smtp-Source: ABdhPJzKPNv71wCvaiJlPwIdg9InlDA/KS8LEZRO8xjpPMq3wbHc7c9Gx/NeNCcR4s81LqHK05++Rg==
X-Received: by 2002:a05:6602:1204:: with SMTP id y4mr6033750iot.44.1591309393781;
        Thu, 04 Jun 2020 15:23:13 -0700 (PDT)
Received: from xps15 ([64.188.179.251])
        by smtp.gmail.com with ESMTPSA id c20sm431897iot.33.2020.06.04.15.23.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Jun 2020 15:23:12 -0700 (PDT)
Received: (nullmailer pid 4151873 invoked by uid 1000);
        Thu, 04 Jun 2020 22:23:11 -0000
Date:   Thu, 4 Jun 2020 16:23:11 -0600
From:   Rob Herring <robh@kernel.org>
To:     "Ooi, Joyce" <joyce.ooi@intel.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Thor Thayer <thor.thayer@linux.intel.com>,
        netdev@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
        See Chin Liang <chin.liang.see@intel.com>,
        linux-kernel@vger.kernel.org, Dinh Nguyen <dinh.nguyen@intel.com>,
        Dalon Westergreen <dalon.westergreen@intel.com>,
        devicetree@vger.kernel.org,
        Dalon Westergreen <dalon.westergreen@linux.intel.com>,
        Tan Ley Foon <ley.foon.tan@intel.com>
Subject: Re: [PATCH v3 10/10] net: eth: altera: update devicetree bindings
 documentation
Message-ID: <20200604222311.GA4151468@bogus>
References: <20200604073256.25702-1-joyce.ooi@intel.com>
 <20200604073256.25702-11-joyce.ooi@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200604073256.25702-11-joyce.ooi@intel.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 04 Jun 2020 15:32:56 +0800, Ooi, Joyce wrote:
> From: Dalon Westergreen <dalon.westergreen@intel.com>
> 
> Update devicetree bindings documentation to include msgdma
> prefetcher and ptp bindings.
> 
> Cc: Rob Herring <robh+dt@kernel.org>
> Cc: devicetree@vger.kernel.org
> Signed-off-by: Dalon Westergreen <dalon.westergreen@intel.com>
> Signed-off-by: Joyce Ooi <joyce.ooi@intel.com>
> ---
> v2: no change
> v3: no change
> ---
>  .../devicetree/bindings/net/altera_tse.txt         | 103 +++++++++++++++++----
>  1 file changed, 84 insertions(+), 19 deletions(-)
> 


Please add Acked-by/Reviewed-by tags when posting new versions. However,
there's no need to repost patches *only* to add the tags. The upstream
maintainer will do that for acks received on the version they apply.

If a tag was not added on purpose, please state why and what changed.

