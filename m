Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0151C2797AB
	for <lists+netdev@lfdr.de>; Sat, 26 Sep 2020 09:57:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728736AbgIZH5E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Sep 2020 03:57:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726210AbgIZH5D (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 26 Sep 2020 03:57:03 -0400
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96736C0613CE
        for <netdev@vger.kernel.org>; Sat, 26 Sep 2020 00:57:03 -0700 (PDT)
Received: by mail-pl1-x641.google.com with SMTP id s19so526833plp.3
        for <netdev@vger.kernel.org>; Sat, 26 Sep 2020 00:57:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=rtFXkRfgZbEQcfpdeuiy3DzD4aySSj2Q6F3pQx5z5GU=;
        b=uufmRRKwAdo9BkQf+3mIFDizTkh9NuB4GlBMpOdCuWczQrzyQAD/FK5atBw6s54bcV
         BZsoU6GjagogIZ89z3YvlZhq1EPAY9dAe8499fYZIuwUihFOjpE/Yi1QbaAQK+7J7vrJ
         Y9N91NvDhnuyaqqzYN3NEmO+Yz8cSfWuB1yEybXoCpbkOr+bC461wrDNuZKZcWjIEiwU
         5zKgOk7IyxFVET7+z5wljLaFUK7L2oDVoGFJ+J1Gu/406GSH7fFC2OotjNdu5sc94708
         MLNm4qvxLhLKzgAkAWN6WgVwoNlZY5ctOGDJHCyrq2wurYk6gjSIp30+JEAHNVwfq0kW
         ffZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=rtFXkRfgZbEQcfpdeuiy3DzD4aySSj2Q6F3pQx5z5GU=;
        b=Qk8sCsQVA02GhhglyplsAUhL8S8CndJs22aNcznAq2BUMtWk4wppMj42Z6ymJmBTB1
         bHtREu1abBE3E0dNN/RVLsOVPDJBIRAt+6es4agMhsx9GsZmctd3XqECaPc/psj63pfA
         98WV+imkOxRWxkmWpFVTWzpld5t8iTaA2gZ6MwHz46GdePGE+fsAmDZwBh5IlQNfdT+k
         uQCsmjL3YEEWcy41pWsFU8z6vYIG5VTVSP8kGjbZ895EsOFFbxl0R0VKAN3NDi0pwDGX
         VBkFRLmvkdrG8OHziaN6YY3E94yaUAcUibCXAutt2l9+suUrYV3fNBOLltFQpKrGWCZl
         /jiQ==
X-Gm-Message-State: AOAM532+Nrj7jKbMTmLV3l6GTMPzLwtet30MvDejKeHL1kTgUN/CeTH9
        PcEk7NntHMx8sHuA+GAJfEx+
X-Google-Smtp-Source: ABdhPJwX1Kf654Q2Pko7pZA4nEWKlT1e+Qf7WrdGtwjQBnD4W5BWZUSG4DwBX7ToZ1FfULBt/D0ZUA==
X-Received: by 2002:a17:90a:ca09:: with SMTP id x9mr1170437pjt.89.1601107023117;
        Sat, 26 Sep 2020 00:57:03 -0700 (PDT)
Received: from linux ([103.59.133.81])
        by smtp.gmail.com with ESMTPSA id q18sm4873241pfg.158.2020.09.26.00.57.00
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Sat, 26 Sep 2020 00:57:02 -0700 (PDT)
Date:   Sat, 26 Sep 2020 13:26:56 +0530
From:   Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
To:     Loic Poulain <loic.poulain@linaro.org>
Cc:     hemantk@codeaurora.org, davem@davemloft.net,
        netdev@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        bjorn.andersson@linaro.org
Subject: Re: [PATCH v2 2/2] net: qrtr: Start MHI channels during init
Message-ID: <20200926075656.GE9302@linux>
References: <1600674184-3537-1-git-send-email-loic.poulain@linaro.org>
 <1600674184-3537-2-git-send-email-loic.poulain@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1600674184-3537-2-git-send-email-loic.poulain@linaro.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 21, 2020 at 09:43:04AM +0200, Loic Poulain wrote:
> Start MHI device channels so that transfers can be performed.
> The MHI stack does not auto-start channels anymore.
> 
> Signed-off-by: Loic Poulain <loic.poulain@linaro.org>

Reviewed-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>

Dave: I'd like to queue this patch through MHI tree because there is a dependent
change in MHI bus. So, can you please provide your Ack?

Thanks,
Mani

> ---
>  v2: split MHI and qrtr changes in dedicated commits
> 
>  net/qrtr/mhi.c | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/net/qrtr/mhi.c b/net/qrtr/mhi.c
> index ff0c414..7100f0b 100644
> --- a/net/qrtr/mhi.c
> +++ b/net/qrtr/mhi.c
> @@ -76,6 +76,11 @@ static int qcom_mhi_qrtr_probe(struct mhi_device *mhi_dev,
>  	struct qrtr_mhi_dev *qdev;
>  	int rc;
>  
> +	/* start channels */
> +	rc = mhi_prepare_for_transfer(mhi_dev);
> +	if (rc)
> +		return rc;
> +
>  	qdev = devm_kzalloc(&mhi_dev->dev, sizeof(*qdev), GFP_KERNEL);
>  	if (!qdev)
>  		return -ENOMEM;
> -- 
> 2.7.4
> 
