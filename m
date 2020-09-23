Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF17E2762A4
	for <lists+netdev@lfdr.de>; Wed, 23 Sep 2020 22:58:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726668AbgIWU63 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Sep 2020 16:58:29 -0400
Received: from mail-io1-f66.google.com ([209.85.166.66]:33846 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726460AbgIWU61 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Sep 2020 16:58:27 -0400
Received: by mail-io1-f66.google.com with SMTP id m17so1042228ioo.1;
        Wed, 23 Sep 2020 13:58:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=DBI7yAxzhMeYdJxsj8BjmnEz5KxHDzBoWiYPr4XLc0w=;
        b=ABz2SOJH7/U8SbtaA7wiD4ncqTsIWpfDI+LkHLY2mAonVWTQPgtIe9UjVmR5rvlGuh
         hOyTfJB3QgJZCJQfKQhId7wvUw/2oz/UIdBn2kmmRgczITzIkbVG92Ydd06JlCEwV0HH
         p5TIl4q0Ha17gJ3+9oVIUrbWK2AGFn2l4tSEVkHQJwSFp1bPW/5xWLITqD7c8RPBhU3K
         oXqY5VAe1vpggtGZ4sv4tPmHeLpRVQB6l2KN3t/AS1DMa0TOU0PrESqBgnXqim8FY8Pi
         pX3H0nU9TX7wsudEX445JI23r+bHgkafXituGBbdjU0Nx157bAzFCRP0l36x5u53R+V6
         ahAQ==
X-Gm-Message-State: AOAM530pXv+/eP3iiPNy9hl902cHh3LbpkpR5F0rXY6NSdigh6PxqKWt
        jdX0T/kMeoBDocj0ZXynIA==
X-Google-Smtp-Source: ABdhPJy0JbRbialOqZQgmgY+YuO73Raga2r31TBjNVrQd2QbuB7XuHqV35G5uICkoCqoeC4Y+1hpww==
X-Received: by 2002:a02:a816:: with SMTP id f22mr1079416jaj.118.1600894706126;
        Wed, 23 Sep 2020 13:58:26 -0700 (PDT)
Received: from xps15 ([64.188.179.253])
        by smtp.gmail.com with ESMTPSA id v89sm435886ili.26.2020.09.23.13.58.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Sep 2020 13:58:25 -0700 (PDT)
Received: (nullmailer pid 1296317 invoked by uid 1000);
        Wed, 23 Sep 2020 20:58:24 -0000
Date:   Wed, 23 Sep 2020 14:58:24 -0600
From:   Rob Herring <robh@kernel.org>
To:     Ansuel Smith <ansuelsmth@gmail.com>
Cc:     Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        ath10k@lists.infradead.org
Subject: Re: [PATCH v2 2/2] dt: bindings: ath10k: Document
 qcom,ath10k-pre-calibration-data-mtd
Message-ID: <20200923205824.GA1290651@bogus>
References: <20200918181104.98-1-ansuelsmth@gmail.com>
 <20200918181104.98-2-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200918181104.98-2-ansuelsmth@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 18, 2020 at 08:11:03PM +0200, Ansuel Smith wrote:
> Document use of qcom,ath10k-pre-calibration-data-mtd bindings used to
> define from where the driver will load the pre-cal data in the defined
> mtd partition.
> 
> Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
> ---
>  .../devicetree/bindings/net/wireless/qcom,ath10k.txt | 12 +++++++++---
>  1 file changed, 9 insertions(+), 3 deletions(-)
> 
> diff --git a/Documentation/devicetree/bindings/net/wireless/qcom,ath10k.txt b/Documentation/devicetree/bindings/net/wireless/qcom,ath10k.txt
> index b61c2d5a0..568364243 100644
> --- a/Documentation/devicetree/bindings/net/wireless/qcom,ath10k.txt
> +++ b/Documentation/devicetree/bindings/net/wireless/qcom,ath10k.txt
> @@ -15,9 +15,9 @@ and also uses most of the properties defined in this doc (except
>  "qcom,ath10k-calibration-data"). It uses "qcom,ath10k-pre-calibration-data"
>  to carry pre calibration data.
>  
> -In general, entry "qcom,ath10k-pre-calibration-data" and
> -"qcom,ath10k-calibration-data" conflict with each other and only one
> -can be provided per device.
> +In general, entry "qcom,ath10k-pre-calibration-data",
> +"qcom,ath10k-calibration-data-mtd" and "qcom,ath10k-calibration-data" conflict with
> +each other and only one can be provided per device.
>  
>  SNOC based devices (i.e. wcn3990) uses compatible string "qcom,wcn3990-wifi".
>  
> @@ -63,6 +63,12 @@ Optional properties:
>  				 hw versions.
>  - qcom,ath10k-pre-calibration-data : pre calibration data as an array,
>  				     the length can vary between hw versions.
> +- qcom,ath10k-pre-calibration-data-mtd :

mtd is a Linuxism.

> +	Usage: optional
> +	Value type: <phandle offset size>
> +	Definition: pre calibration data read from mtd partition. Take 3 value, the
> +		    mtd to read data from, the offset in the mtd partition and the

The phandle is the mtd or partition?

Maybe you should be using nvmem binding here.

> +		    size of data to read.
>  - <supply-name>-supply: handle to the regulator device tree node
>  			   optional "supply-name" are "vdd-0.8-cx-mx",
>  			   "vdd-1.8-xo", "vdd-1.3-rfa", "vdd-3.3-ch0",
> -- 
> 2.27.0
> 
