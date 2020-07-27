Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A3DEA22FA57
	for <lists+netdev@lfdr.de>; Mon, 27 Jul 2020 22:49:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727095AbgG0Us5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jul 2020 16:48:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726877AbgG0Usz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jul 2020 16:48:55 -0400
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E703C0619D4
        for <netdev@vger.kernel.org>; Mon, 27 Jul 2020 13:48:55 -0700 (PDT)
Received: by mail-pg1-x542.google.com with SMTP id t6so10629126pgq.1
        for <netdev@vger.kernel.org>; Mon, 27 Jul 2020 13:48:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=cl8j7GopTyZRJUUXdEXAzgEZa0nsCpMSIg/iqYNRNJI=;
        b=iLaBtnq6xWHbjfS9QuQUioSxC170WYAeutNLBQNmsMY9Y5mX4ojCA5wgEOGVS8YKK9
         Zhnmc63uw2QgH+kTs90etqDqnzopdR3s57ppLc/b3RXAl9YxGF4x5P9vW410qZyxeU2i
         R+g6Sc76SziFatI+tH9MDVVyPtjHG+78wlE+8NCVMYjAnwkxd/aKj7o6Rt6VqK1KCHgF
         At2PEyVi6sodJmb7NuOz8V4OBbZeHTxo5y6EW6OMyaRfqm0t3Oi722HGRLk2BkUdLW61
         EQixGImDS8VRcz0HoTaUwecOxP0DX793COr0JYu0+mJVUGI+Lczxa3N7Ck35M4FfNScp
         +kbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=cl8j7GopTyZRJUUXdEXAzgEZa0nsCpMSIg/iqYNRNJI=;
        b=I7kQStsr3QaDZziPdf3G0GtTRnxV+U7hFBjMMYw0qIVKCC4wCyXFn0z93gqt+NEqkJ
         7qwzeuOrmaBOh3TEDT4elayX0m7+BpKK1reZP9EXXWPHDFTHmpZr5wQPonWg9eaQDPtI
         nigW8eu9pwZobqtdMxxdy1acRZHyWkMdy6kot2RCv7NXV9VP0ulEMhnns2AAJwqlw4PD
         GmRczq+vAciwF9+GuN5WTx7rbXfEIlqnVEp0+OESBl+km1SbSm/YYIa6suqCnC7MEXMn
         Sh4svgkf8CTgaY5djTDCu/P6yvr/CE0m+XT6945m3Eaby2XXD9MUTqSyiyoNr9LLkon7
         4dng==
X-Gm-Message-State: AOAM531Gu4NnXT80CXCMepF7QEwfOdVTc8cClXP/gSs+7VRRj2dqTqVI
        iC4vOmwoLGWdonxMSJuj8QlRZw==
X-Google-Smtp-Source: ABdhPJzCJt3/kFYjKdCkjcIMaqcvuRRHbskkoYcAp1VnT157e73YyUuEdxYzSE508CB7pOpy9v5aTQ==
X-Received: by 2002:aa7:9f46:: with SMTP id h6mr2443306pfr.321.1595882934807;
        Mon, 27 Jul 2020 13:48:54 -0700 (PDT)
Received: from builder.lan (104-188-17-28.lightspeed.sndgca.sbcglobal.net. [104.188.17.28])
        by smtp.gmail.com with ESMTPSA id n15sm535816pjf.12.2020.07.27.13.48.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Jul 2020 13:48:54 -0700 (PDT)
Date:   Mon, 27 Jul 2020 13:45:21 -0700
From:   Bjorn Andersson <bjorn.andersson@linaro.org>
To:     ????????? <wenhu.wang@vivo.com>
Cc:     elder@kernel.org, davem@davemloft.net, kuba@kernel.org,
        kvalo@codeaurora.org, agross@kernel.org, ohad@wizery.com,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-remoteproc@vger.kernel.org, alsa-devel@alsa-project.org,
        ath11k@lists.infradead.org, netdev@vger.kernel.org,
        ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        srinivas.kandagatla@linaro.org, sibis@codeaurora.org
Subject: Re: [PATCH] soc: qmi: allow user to set handle wq to hiprio
Message-ID: <20200727204521.GB229995@builder.lan>
References: <AMoAtwB9DXJsyd-1khUpzqq9.1.1595862196133.Hmail.wenhu.wang@vivo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AMoAtwB9DXJsyd-1khUpzqq9.1.1595862196133.Hmail.wenhu.wang@vivo.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon 27 Jul 08:03 PDT 2020, ????????? wrote:

> Currently the qmi_handle is initialized single threaded and strictly
> ordered with the active set to 1. This is pretty simple and safe but
> sometimes ineffency. So it is better to allow user to decide whether
> a high priority workqueue should be used.

Can you please describe a scenario where this is needed/desired and
perhaps also comment on why this is not always desired?

Regards,
Bjorn

> 
> Signed-off-by: Wang Wenhu <wenhu.wang@vivo.com>
> ---
>  drivers/net/ipa/ipa_qmi.c             | 4 ++--
>  drivers/net/wireless/ath/ath10k/qmi.c | 2 +-
>  drivers/net/wireless/ath/ath11k/qmi.c | 2 +-
>  drivers/remoteproc/qcom_sysmon.c      | 2 +-
>  drivers/slimbus/qcom-ngd-ctrl.c       | 4 ++--
>  drivers/soc/qcom/pdr_interface.c      | 4 ++--
>  drivers/soc/qcom/qmi_interface.c      | 9 +++++++--
>  include/linux/soc/qcom/qmi.h          | 3 ++-
>  samples/qmi/qmi_sample_client.c       | 4 ++--
>  9 files changed, 20 insertions(+), 14 deletions(-)
> 
> diff --git a/drivers/net/ipa/ipa_qmi.c b/drivers/net/ipa/ipa_qmi.c
> index 5090f0f923ad..d78b0fe6bd83 100644
> --- a/drivers/net/ipa/ipa_qmi.c
> +++ b/drivers/net/ipa/ipa_qmi.c
> @@ -486,7 +486,7 @@ int ipa_qmi_setup(struct ipa *ipa)
>  	 */
>  	ret = qmi_handle_init(&ipa_qmi->server_handle,
>  			      IPA_QMI_SERVER_MAX_RCV_SZ, &ipa_server_ops,
> -			      ipa_server_msg_handlers);
> +			      ipa_server_msg_handlers, 0);
>  	if (ret)
>  		return ret;
>  
> @@ -500,7 +500,7 @@ int ipa_qmi_setup(struct ipa *ipa)
>  	 */
>  	ret = qmi_handle_init(&ipa_qmi->client_handle,
>  			      IPA_QMI_CLIENT_MAX_RCV_SZ, &ipa_client_ops,
> -			      ipa_client_msg_handlers);
> +			      ipa_client_msg_handlers, 0);
>  	if (ret)
>  		goto err_server_handle_release;
>  
> diff --git a/drivers/net/wireless/ath/ath10k/qmi.c b/drivers/net/wireless/ath/ath10k/qmi.c
> index 5468a41e928e..02881882b4d9 100644
> --- a/drivers/net/wireless/ath/ath10k/qmi.c
> +++ b/drivers/net/wireless/ath/ath10k/qmi.c
> @@ -1034,7 +1034,7 @@ int ath10k_qmi_init(struct ath10k *ar, u32 msa_size)
>  
>  	ret = qmi_handle_init(&qmi->qmi_hdl,
>  			      WLFW_BDF_DOWNLOAD_REQ_MSG_V01_MAX_MSG_LEN,
> -			      &ath10k_qmi_ops, qmi_msg_handler);
> +			      &ath10k_qmi_ops, qmi_msg_handler, 0);
>  	if (ret)
>  		goto err;
>  
> diff --git a/drivers/net/wireless/ath/ath11k/qmi.c b/drivers/net/wireless/ath/ath11k/qmi.c
> index c00a99ad8dbc..91394d58d36e 100644
> --- a/drivers/net/wireless/ath/ath11k/qmi.c
> +++ b/drivers/net/wireless/ath/ath11k/qmi.c
> @@ -2397,7 +2397,7 @@ int ath11k_qmi_init_service(struct ath11k_base *ab)
>  
>  	ab->qmi.target_mem_mode = ATH11K_QMI_TARGET_MEM_MODE_DEFAULT;
>  	ret = qmi_handle_init(&ab->qmi.handle, ATH11K_QMI_RESP_LEN_MAX,
> -			      &ath11k_qmi_ops, ath11k_qmi_msg_handlers);
> +			      &ath11k_qmi_ops, ath11k_qmi_msg_handlers, 0);
>  	if (ret < 0) {
>  		ath11k_warn(ab, "failed to initialize qmi handle\n");
>  		return ret;
> diff --git a/drivers/remoteproc/qcom_sysmon.c b/drivers/remoteproc/qcom_sysmon.c
> index 8d8996d714f0..4ec470e424ef 100644
> --- a/drivers/remoteproc/qcom_sysmon.c
> +++ b/drivers/remoteproc/qcom_sysmon.c
> @@ -614,7 +614,7 @@ struct qcom_sysmon *qcom_add_sysmon_subdev(struct rproc *rproc,
>  	}
>  
>  	ret = qmi_handle_init(&sysmon->qmi, SSCTL_MAX_MSG_LEN, &ssctl_ops,
> -			      qmi_indication_handler);
> +			      qmi_indication_handler, 0);
>  	if (ret < 0) {
>  		dev_err(sysmon->dev, "failed to initialize qmi handle\n");
>  		kfree(sysmon);
> diff --git a/drivers/slimbus/qcom-ngd-ctrl.c b/drivers/slimbus/qcom-ngd-ctrl.c
> index 743ee7b4e63f..ba76691fc5a5 100644
> --- a/drivers/slimbus/qcom-ngd-ctrl.c
> +++ b/drivers/slimbus/qcom-ngd-ctrl.c
> @@ -446,7 +446,7 @@ static int qcom_slim_qmi_init(struct qcom_slim_ngd_ctrl *ctrl,
>  		return -ENOMEM;
>  
>  	rc = qmi_handle_init(handle, SLIMBUS_QMI_POWER_REQ_MAX_MSG_LEN,
> -				NULL, qcom_slim_qmi_msg_handlers);
> +				NULL, qcom_slim_qmi_msg_handlers, 0);
>  	if (rc < 0) {
>  		dev_err(ctrl->dev, "QMI client init failed: %d\n", rc);
>  		goto qmi_handle_init_failed;
> @@ -1293,7 +1293,7 @@ static int qcom_slim_ngd_qmi_svc_event_init(struct qcom_slim_ngd_ctrl *ctrl)
>  	int ret;
>  
>  	ret = qmi_handle_init(&qmi->svc_event_hdl, 0,
> -				&qcom_slim_ngd_qmi_svc_event_ops, NULL);
> +				&qcom_slim_ngd_qmi_svc_event_ops, NULL, 0);
>  	if (ret < 0) {
>  		dev_err(ctrl->dev, "qmi_handle_init failed: %d\n", ret);
>  		return ret;
> diff --git a/drivers/soc/qcom/pdr_interface.c b/drivers/soc/qcom/pdr_interface.c
> index bdcf16f88a97..cc1cb90c1968 100644
> --- a/drivers/soc/qcom/pdr_interface.c
> +++ b/drivers/soc/qcom/pdr_interface.c
> @@ -685,7 +685,7 @@ struct pdr_handle *pdr_handle_alloc(void (*status)(int state,
>  
>  	ret = qmi_handle_init(&pdr->locator_hdl,
>  			      SERVREG_GET_DOMAIN_LIST_RESP_MAX_LEN,
> -			      &pdr_locator_ops, NULL);
> +			      &pdr_locator_ops, NULL, 0);
>  	if (ret < 0)
>  		goto destroy_indack;
>  
> @@ -696,7 +696,7 @@ struct pdr_handle *pdr_handle_alloc(void (*status)(int state,
>  	ret = qmi_handle_init(&pdr->notifier_hdl,
>  			      SERVREG_STATE_UPDATED_IND_MAX_LEN,
>  			      &pdr_notifier_ops,
> -			      qmi_indication_handler);
> +			      qmi_indication_handler, 0);
>  	if (ret < 0)
>  		goto release_qmi_handle;
>  
> diff --git a/drivers/soc/qcom/qmi_interface.c b/drivers/soc/qcom/qmi_interface.c
> index 1a03eaa38c46..01160dbfc4d0 100644
> --- a/drivers/soc/qcom/qmi_interface.c
> +++ b/drivers/soc/qcom/qmi_interface.c
> @@ -609,6 +609,7 @@ static struct socket *qmi_sock_create(struct qmi_handle *qmi,
>   * @recv_buf_size: maximum size of incoming message
>   * @ops:	reference to callbacks for QRTR notifications
>   * @handlers:	NULL-terminated list of QMI message handlers
> + * @hiprio:	whether high priority worker is used for workqueue
>   *
>   * This initializes the QMI client handle to allow sending and receiving QMI
>   * messages. As messages are received the appropriate handler will be invoked.
> @@ -617,9 +618,11 @@ static struct socket *qmi_sock_create(struct qmi_handle *qmi,
>   */
>  int qmi_handle_init(struct qmi_handle *qmi, size_t recv_buf_size,
>  		    const struct qmi_ops *ops,
> -		    const struct qmi_msg_handler *handlers)
> +		    const struct qmi_msg_handler *handlers,
> +		    unsigned int hiprio)
>  {
>  	int ret;
> +	unsigned int flags = WQ_UNBOUND;
>  
>  	mutex_init(&qmi->txn_lock);
>  	mutex_init(&qmi->sock_lock);
> @@ -647,7 +650,9 @@ int qmi_handle_init(struct qmi_handle *qmi, size_t recv_buf_size,
>  	if (!qmi->recv_buf)
>  		return -ENOMEM;
>  
> -	qmi->wq = alloc_workqueue("qmi_msg_handler", WQ_UNBOUND, 1);
> +	if (hiprio)
> +		flags |= WQ_HIGHPRI;
> +	qmi->wq = alloc_workqueue("qmi_msg_handler", flags, 1);
>  	if (!qmi->wq) {
>  		ret = -ENOMEM;
>  		goto err_free_recv_buf;
> diff --git a/include/linux/soc/qcom/qmi.h b/include/linux/soc/qcom/qmi.h
> index e712f94b89fc..24062fd7163d 100644
> --- a/include/linux/soc/qcom/qmi.h
> +++ b/include/linux/soc/qcom/qmi.h
> @@ -244,7 +244,8 @@ int qmi_add_server(struct qmi_handle *qmi, unsigned int service,
>  
>  int qmi_handle_init(struct qmi_handle *qmi, size_t max_msg_len,
>  		    const struct qmi_ops *ops,
> -		    const struct qmi_msg_handler *handlers);
> +		    const struct qmi_msg_handler *handlers,
> +		    unsigned int hiprio);
>  void qmi_handle_release(struct qmi_handle *qmi);
>  
>  ssize_t qmi_send_request(struct qmi_handle *qmi, struct sockaddr_qrtr *sq,
> diff --git a/samples/qmi/qmi_sample_client.c b/samples/qmi/qmi_sample_client.c
> index c9e7276c3d83..a91d1633ea38 100644
> --- a/samples/qmi/qmi_sample_client.c
> +++ b/samples/qmi/qmi_sample_client.c
> @@ -463,7 +463,7 @@ static int qmi_sample_probe(struct platform_device *pdev)
>  
>  	ret = qmi_handle_init(&sample->qmi, TEST_DATA_REQ_MAX_MSG_LEN_V01,
>  			      NULL,
> -			      qmi_sample_handlers);
> +			      qmi_sample_handlers, 0);
>  	if (ret < 0)
>  		return ret;
>  
> @@ -590,7 +590,7 @@ static int qmi_sample_init(void)
>  	if (ret)
>  		goto err_remove_debug_dir;
>  
> -	ret = qmi_handle_init(&lookup_client, 0, &lookup_ops, NULL);
> +	ret = qmi_handle_init(&lookup_client, 0, &lookup_ops, NULL, 0);
>  	if (ret < 0)
>  		goto err_unregister_driver;
>  
> -- 
> 2.17.1
> 
> 
> 
