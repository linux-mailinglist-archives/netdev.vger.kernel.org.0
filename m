Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 863C82B0279
	for <lists+netdev@lfdr.de>; Thu, 12 Nov 2020 11:04:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727706AbgKLKEw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Nov 2020 05:04:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725979AbgKLKEv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Nov 2020 05:04:51 -0500
Received: from mail-wm1-x344.google.com (mail-wm1-x344.google.com [IPv6:2a00:1450:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CF9CC0613D1
        for <netdev@vger.kernel.org>; Thu, 12 Nov 2020 02:04:50 -0800 (PST)
Received: by mail-wm1-x344.google.com with SMTP id c9so4706851wml.5
        for <netdev@vger.kernel.org>; Thu, 12 Nov 2020 02:04:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=s2E/u0F0tDTSTx1gOaW8/01mbFoO3jqY6Xy2l3NiEcc=;
        b=SFPo3T82awxcVg1iIQDEy5AlrYpZshcgxcoAGVod6am7Qiuuj9zhSfSnEb7ITxPuus
         k5ZFlFYXwlYfEYcLTpzwqpALEbLyAdA1iNkcv4i7EhCjaoMPYqaFt2hXgx4XtzKffuJr
         PFZYxlEde3+LV4vm56BRa853d+QM/5oS4ZCcd0V56LgDi/G/DUn/jsfU3FdXEXmjBK7i
         6+QE10iIu40TnRb723vR64MXBaATc5lav2i2zuQjK0iMHaw8c+V8sQVSsDF6KtzQ+wSS
         c6+u6UtRZqfLio2JQiUWx0gkvwqhDK+1STEtv4sWiL2Zelb70nyVl2ZyhqlWf/8QNMyW
         gpBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=s2E/u0F0tDTSTx1gOaW8/01mbFoO3jqY6Xy2l3NiEcc=;
        b=DJhPcuIlNWDXVUgtWEYaulr/CUhbQ1GNPuO016UEh0XS527mwReQRkvAiVDLhmLsm4
         kuzSIpXVZsKGXWxb4b5fMQE9A3PuTCArhRWRBoK1Dk764q4+AUju5SGhL6k5rncmGzgJ
         Jz8uQ/Fi/ABFAoufzXmCP/bEm4IzW99hPYPmyzn1e3p9JtjJoFS4faTMV0gxMsjBuf/N
         Per6I9Kfif/8KVgEy9MANsDmsNaZ9nhUFtiveJ09hY36wOIZTEg9zBSnEW2UuMaWpnhk
         WVZqL1avKj5G66fb3s7i4kEmxNlrHy/IiUC2QcnsaoPbh+kc4DXOttXTYH8Apsic6wIX
         Wd7Q==
X-Gm-Message-State: AOAM531Nol+FJQyZpUwc8P/ml6HOhuRjgz3h06H/w0gc8SQwT8t6uUdq
        jt0Qzh7q6blTBXzJRC3orrS0RQ==
X-Google-Smtp-Source: ABdhPJxvJ4GQvSG28P3t1X8RkWLKjtZ+YGZvUroc9iQsjffTBV22c9C7wkul5mnE6ePLTeD+kDlIHw==
X-Received: by 2002:a1c:3803:: with SMTP id f3mr8563107wma.14.1605175488913;
        Thu, 12 Nov 2020 02:04:48 -0800 (PST)
Received: from dell ([91.110.221.159])
        by smtp.gmail.com with ESMTPSA id r9sm6310917wrg.59.2020.11.12.02.04.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Nov 2020 02:04:48 -0800 (PST)
Date:   Thu, 12 Nov 2020 10:04:45 +0000
From:   Lee Jones <lee.jones@linaro.org>
To:     davem@davemloft.net, gregkh@linuxfoundation.org
Cc:     Inaky Perez-Gonzalez <inaky.perez-gonzalez@intel.com>,
        linux-wimax@intel.com, Jakub Kicinski <kuba@kernel.org>,
        netdev@vger.kernel.org
Subject: Re: [PATCH 04/30] net: wimax: i2400m: control: Fix some misspellings
 in i2400m_set_init_config()'s docs
Message-ID: <20201112100445.GA1997862@dell>
References: <20201102114512.1062724-1-lee.jones@linaro.org>
 <20201102114512.1062724-5-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20201102114512.1062724-5-lee.jones@linaro.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 02 Nov 2020, Lee Jones wrote:

> Fixes the following W=1 kernel build warning(s):
> 
>  drivers/net/wimax/i2400m/control.c:1195: warning: Function parameter or member 'arg' not described in 'i2400m_set_init_config'
>  drivers/net/wimax/i2400m/control.c:1195: warning: Excess function parameter 'arg_size' description in 'i2400m_set_init_config'
> 
> Cc: Inaky Perez-Gonzalez <inaky.perez-gonzalez@intel.com>
> Cc: linux-wimax@intel.com
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: netdev@vger.kernel.org
> Signed-off-by: Lee Jones <lee.jones@linaro.org>
> ---
>  drivers/staging/wimax/i2400m/control.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)

Any news on these i2400 patches?

Looks like the driver has been moved to Staging since submission.

Greg, shall I re-submit?

-- 
Lee Jones [李琼斯]
Senior Technical Lead - Developer Services
Linaro.org │ Open source software for Arm SoCs
Follow Linaro: Facebook | Twitter | Blog
