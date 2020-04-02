Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 68E3919BB69
	for <lists+netdev@lfdr.de>; Thu,  2 Apr 2020 07:49:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726743AbgDBFtX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Apr 2020 01:49:23 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:45971 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726453AbgDBFtX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Apr 2020 01:49:23 -0400
Received: by mail-pf1-f194.google.com with SMTP id r14so1222533pfl.12
        for <netdev@vger.kernel.org>; Wed, 01 Apr 2020 22:49:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Wc6NJb4p6MEXws3pGT/UQPzUAiBr55KOI2oc0zUByZE=;
        b=DFsGRPIa51D9kiMhfS9Y0TXDN4cpPQisgW3ovjshL3sgvvneedHSzsaZR7Tewo+I3j
         3ysfzSsCBc4VKJ1WATnbhouZIPYaAg4hFUw0KrSgAt+We6pSUCxCBCN+u4DxqVAdPy6J
         rn+9N3XJtsX5WbOxyffnBzFREj5gcIcOspHUe4clQ3rJcwWbx6VhMAcHLmhkG2WrTjw/
         2Um2csbnw6jcfwcYySPyWdgsdbFbhEhKLLfB5jgZiwOxDv/NAH0yAfZ85Gk6jsycc6D5
         lyQZqWVeYXSgmNtJweMqFKErKC9UAjvlFbzyzrzHKZQtXjLPDDntXdAVVBEI1lGv65Zv
         3EWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Wc6NJb4p6MEXws3pGT/UQPzUAiBr55KOI2oc0zUByZE=;
        b=RCRWzNVrs1kY+fIdbpysSDrsHOQlQ5/rKvgcobR+zGzqq1BJAyTnCutBY3w8W1IOAg
         IPB269E9OW5ihsONLGy1M2Y9Ia53xfQOlDNgP6husl0D3z5OF1RS6bHq3UjHDJfaxqZF
         3B/v01FUJGsyHiA8xDa5Qid3PtyFgzbIrUp6jXdUD9MmCWLdBX3X6dghPrmWVfnoD1gZ
         kFKbCqO5Xs7pc+ykHsM/F59Bt5YXVKwcN1Ew+FdTsV/E1lZG7AQQpObkPeOoPQaYkc+B
         LDdhctWKyTBqrWs22l5APNuKU4lHq1qOpWaWNd/RSt4/yR4ufa/K6cc9ULvstjVKOVDr
         8Z6A==
X-Gm-Message-State: AGi0PuZNlh47KY4Coczv3z93bUpTRD1CiENTbw0ZEscAFqt1G/1+imUv
        to+PnsgIWHxUSPZ1B/uwIJMUow==
X-Google-Smtp-Source: APiQypJAifa4s3GVx9lLF6JsRmWDp1RDEgGzUhXFfvE5W9LTztsNNjeZLxgI+/R4ywdUrj6cGWy+rA==
X-Received: by 2002:a62:7811:: with SMTP id t17mr1541854pfc.268.1585806562307;
        Wed, 01 Apr 2020 22:49:22 -0700 (PDT)
Received: from yoga (104-188-17-28.lightspeed.sndgca.sbcglobal.net. [104.188.17.28])
        by smtp.gmail.com with ESMTPSA id c11sm2874234pfc.216.2020.04.01.22.49.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Apr 2020 22:49:21 -0700 (PDT)
Date:   Wed, 1 Apr 2020 22:49:18 -0700
From:   Bjorn Andersson <bjorn.andersson@linaro.org>
To:     Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Cc:     gregkh@linuxfoundation.org, davem@davemloft.net,
        smohanad@codeaurora.org, jhugo@codeaurora.org,
        kvalo@codeaurora.org, hemantk@codeaurora.org,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        clew@codeaurora.org, netdev@vger.kernel.org
Subject: Re: [PATCH v2 2/3] net: qrtr: Add MHI transport layer
Message-ID: <20200402054918.GE663905@yoga>
References: <20200402053610.9345-1-manivannan.sadhasivam@linaro.org>
 <20200402053610.9345-3-manivannan.sadhasivam@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200402053610.9345-3-manivannan.sadhasivam@linaro.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed 01 Apr 22:36 PDT 2020, Manivannan Sadhasivam wrote:

> MHI is the transport layer used for communicating to the external modems.
> Hence, this commit adds MHI transport layer support to QRTR for
> transferring the QMI messages over IPC Router.
> 

Reviewed-by: Bjorn Andersson <bjorn.andersson@linaro.org>

Regards,
Bjorn

> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: netdev@vger.kernel.org
> Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
> ---
>  net/qrtr/Kconfig  |   7 +++
>  net/qrtr/Makefile |   2 +
>  net/qrtr/mhi.c    | 126 ++++++++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 135 insertions(+)
>  create mode 100644 net/qrtr/mhi.c
> 
> diff --git a/net/qrtr/Kconfig b/net/qrtr/Kconfig
> index 63f89cc6e82c..8eb876471564 100644
> --- a/net/qrtr/Kconfig
> +++ b/net/qrtr/Kconfig
> @@ -29,4 +29,11 @@ config QRTR_TUN
>  	  implement endpoints of QRTR, for purpose of tunneling data to other
>  	  hosts or testing purposes.
>  
> +config QRTR_MHI
> +	tristate "MHI IPC Router channels"
> +	depends on MHI_BUS
> +	help
> +	  Say Y here to support MHI based ipcrouter channels. MHI is the
> +	  transport used for communicating to external modems.
> +
>  endif # QRTR
> diff --git a/net/qrtr/Makefile b/net/qrtr/Makefile
> index 32d4e923925d..1b1411d158a7 100644
> --- a/net/qrtr/Makefile
> +++ b/net/qrtr/Makefile
> @@ -5,3 +5,5 @@ obj-$(CONFIG_QRTR_SMD) += qrtr-smd.o
>  qrtr-smd-y	:= smd.o
>  obj-$(CONFIG_QRTR_TUN) += qrtr-tun.o
>  qrtr-tun-y	:= tun.o
> +obj-$(CONFIG_QRTR_MHI) += qrtr-mhi.o
> +qrtr-mhi-y	:= mhi.o
> diff --git a/net/qrtr/mhi.c b/net/qrtr/mhi.c
> new file mode 100644
> index 000000000000..2f604dff93cd
> --- /dev/null
> +++ b/net/qrtr/mhi.c
> @@ -0,0 +1,126 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * Copyright (c) 2018-2020, The Linux Foundation. All rights reserved.
> + */
> +
> +#include <linux/mhi.h>
> +#include <linux/mod_devicetable.h>
> +#include <linux/module.h>
> +#include <linux/skbuff.h>
> +#include <net/sock.h>
> +
> +#include "qrtr.h"
> +
> +struct qrtr_mhi_dev {
> +	struct qrtr_endpoint ep;
> +	struct mhi_device *mhi_dev;
> +	struct device *dev;
> +};
> +
> +/* From MHI to QRTR */
> +static void qcom_mhi_qrtr_dl_callback(struct mhi_device *mhi_dev,
> +				      struct mhi_result *mhi_res)
> +{
> +	struct qrtr_mhi_dev *qdev = dev_get_drvdata(&mhi_dev->dev);
> +	int rc;
> +
> +	if (!qdev || mhi_res->transaction_status)
> +		return;
> +
> +	rc = qrtr_endpoint_post(&qdev->ep, mhi_res->buf_addr,
> +				mhi_res->bytes_xferd);
> +	if (rc == -EINVAL)
> +		dev_err(qdev->dev, "invalid ipcrouter packet\n");
> +}
> +
> +/* From QRTR to MHI */
> +static void qcom_mhi_qrtr_ul_callback(struct mhi_device *mhi_dev,
> +				      struct mhi_result *mhi_res)
> +{
> +	struct sk_buff *skb = (struct sk_buff *)mhi_res->buf_addr;
> +
> +	if (skb->sk)
> +		sock_put(skb->sk);
> +	consume_skb(skb);
> +}
> +
> +/* Send data over MHI */
> +static int qcom_mhi_qrtr_send(struct qrtr_endpoint *ep, struct sk_buff *skb)
> +{
> +	struct qrtr_mhi_dev *qdev = container_of(ep, struct qrtr_mhi_dev, ep);
> +	int rc;
> +
> +	rc = skb_linearize(skb);
> +	if (rc) {
> +		kfree_skb(skb);
> +		return rc;
> +	}
> +
> +	rc = mhi_queue_skb(qdev->mhi_dev, DMA_TO_DEVICE, skb, skb->len,
> +			   MHI_EOT);
> +	if (rc) {
> +		kfree_skb(skb);
> +		return rc;
> +	}
> +
> +	if (skb->sk)
> +		sock_hold(skb->sk);
> +
> +	return rc;
> +}
> +
> +static int qcom_mhi_qrtr_probe(struct mhi_device *mhi_dev,
> +			       const struct mhi_device_id *id)
> +{
> +	struct qrtr_mhi_dev *qdev;
> +	int rc;
> +
> +	qdev = devm_kzalloc(&mhi_dev->dev, sizeof(*qdev), GFP_KERNEL);
> +	if (!qdev)
> +		return -ENOMEM;
> +
> +	qdev->mhi_dev = mhi_dev;
> +	qdev->dev = &mhi_dev->dev;
> +	qdev->ep.xmit = qcom_mhi_qrtr_send;
> +
> +	dev_set_drvdata(&mhi_dev->dev, qdev);
> +	rc = qrtr_endpoint_register(&qdev->ep, QRTR_EP_NID_AUTO);
> +	if (rc)
> +		return rc;
> +
> +	dev_dbg(qdev->dev, "Qualcomm MHI QRTR driver probed\n");
> +
> +	return 0;
> +}
> +
> +static void qcom_mhi_qrtr_remove(struct mhi_device *mhi_dev)
> +{
> +	struct qrtr_mhi_dev *qdev = dev_get_drvdata(&mhi_dev->dev);
> +
> +	qrtr_endpoint_unregister(&qdev->ep);
> +	dev_set_drvdata(&mhi_dev->dev, NULL);
> +}
> +
> +static const struct mhi_device_id qcom_mhi_qrtr_id_table[] = {
> +	{ .chan = "IPCR" },
> +	{}
> +};
> +MODULE_DEVICE_TABLE(mhi, qcom_mhi_qrtr_id_table);
> +
> +static struct mhi_driver qcom_mhi_qrtr_driver = {
> +	.probe = qcom_mhi_qrtr_probe,
> +	.remove = qcom_mhi_qrtr_remove,
> +	.dl_xfer_cb = qcom_mhi_qrtr_dl_callback,
> +	.ul_xfer_cb = qcom_mhi_qrtr_ul_callback,
> +	.id_table = qcom_mhi_qrtr_id_table,
> +	.driver = {
> +		.name = "qcom_mhi_qrtr",
> +	},
> +};
> +
> +module_mhi_driver(qcom_mhi_qrtr_driver);
> +
> +MODULE_AUTHOR("Chris Lew <clew@codeaurora.org>");
> +MODULE_AUTHOR("Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>");
> +MODULE_DESCRIPTION("Qualcomm IPC-Router MHI interface driver");
> +MODULE_LICENSE("GPL v2");
> -- 
> 2.17.1
> 
