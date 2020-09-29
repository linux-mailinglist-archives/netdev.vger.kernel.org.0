Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E237C27D1B3
	for <lists+netdev@lfdr.de>; Tue, 29 Sep 2020 16:46:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731216AbgI2OqN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Sep 2020 10:46:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728198AbgI2OqN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Sep 2020 10:46:13 -0400
Received: from mail-oi1-x242.google.com (mail-oi1-x242.google.com [IPv6:2607:f8b0:4864:20::242])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A395C061755
        for <netdev@vger.kernel.org>; Tue, 29 Sep 2020 07:46:13 -0700 (PDT)
Received: by mail-oi1-x242.google.com with SMTP id n2so5728138oij.1
        for <netdev@vger.kernel.org>; Tue, 29 Sep 2020 07:46:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=ToaKMfsZpv/NXqWEW4DPxSdQ0RqA1XE7R/QGRJ13ask=;
        b=c3kBSAtekI/IVTjai35R/eo23CQhe0UmA/ZoKSOsNj8InJHzf95C5qzBlOdbfRgdBb
         WpQF3AFh68Q2dPY8r8HSTPPPx0eTKT2ylsGLkr3aw2OSgg4Va49kXgsL9tZltdV6n4GH
         aoeyvvJZEjt1EzU1TMCFqCxii3HZWZyWsFWDtsLAfJTVUGjq+4emg+gvgOtb9le/XsYy
         3c+ZELiVQEmhQK/KWMdTi8/Ss5TEw9RsWF0Xk8av1JnfD2OrPV+wpMU6CgEXb5R36pbP
         3y7qzToTLlNRl1S4eEDlXMMPml//EkynGET/PZdFJJVgFkgM+7BQsog+hkVWnymfFD1Q
         gRwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ToaKMfsZpv/NXqWEW4DPxSdQ0RqA1XE7R/QGRJ13ask=;
        b=jG2jsjsQd0cWJ02TfQf9NljtdfXr7N7mIvvpWImNelYCzqwQzlcfIpKev75hLFEXIC
         Va2E0cx1Qs0v+YF6r6IvS6oec/sRFRqqTymTn6jP0HlRg1bzfRV0H3MRhownUXA5pes/
         tWgtnSx0/58/dqa4/CYZB7+ZCogk6AYfsVNb2tpXAWv/BDwhHyvetCooDXzJuHphg8DI
         IXRKlEKiH+BM9SQObPRniwA6PIsKigQUdLziQ8N0oh/tdgQpJvxyH8j5IUeUTA3CnNCT
         gxlfKY67wSRL//5xF8eL4mJu8NWYw1Vqe9feUPjKn+0/UOfTwGIA9uWxjAy7O81pdJPi
         Hmzg==
X-Gm-Message-State: AOAM530oGUAFc4Pq5UBzvHH0LFUoJh7GJDvlNd4Btq/cku8/DzHcPanc
        1z3p3PfcCoe6gfQHPISFbfvciA==
X-Google-Smtp-Source: ABdhPJyIAkJkPUHVSAwD3qPTZNG51gqnK6bf8qfBzhy6ghE0w98ab/g0Pdj5Ehyik8eAuY31kTlNjg==
X-Received: by 2002:a05:6808:ab5:: with SMTP id r21mr2917307oij.25.1601390772440;
        Tue, 29 Sep 2020 07:46:12 -0700 (PDT)
Received: from builder.lan (99-135-181-32.lightspeed.austtx.sbcglobal.net. [99.135.181.32])
        by smtp.gmail.com with ESMTPSA id o9sm2931961oop.1.2020.09.29.07.46.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Sep 2020 07:46:11 -0700 (PDT)
Date:   Tue, 29 Sep 2020 09:41:44 -0500
From:   Bjorn Andersson <bjorn.andersson@linaro.org>
To:     Loic Poulain <loic.poulain@linaro.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, clew@codeaurora.org,
        manivannan.sadhasivam@linaro.org
Subject: Re: [PATCH 2/2] net: qrtr: Allow non-immediate node routing
Message-ID: <20200929144144.GE71055@builder.lan>
References: <1601386397-21067-1-git-send-email-loic.poulain@linaro.org>
 <1601386397-21067-2-git-send-email-loic.poulain@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1601386397-21067-2-git-send-email-loic.poulain@linaro.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue 29 Sep 08:33 CDT 2020, Loic Poulain wrote:

> In order to reach non-immediate remote node services that are
> accessed through an intermediate node, the route to the remote
> node needs to be saved.
> 
> E.g for a [node1 <=> node2 <=> node3] network
> - node2 forwards node3 service to node1
> - node1 must save node2 as route for reaching node3
> 
> Signed-off-by: Loic Poulain <loic.poulain@linaro.org>

Reviewed-by: Bjorn Andersson <bjorn.andersson@linaro.org>

Regards,
Bjorn

> ---
>  net/qrtr/qrtr.c | 11 +++++++++--
>  1 file changed, 9 insertions(+), 2 deletions(-)
> 
> diff --git a/net/qrtr/qrtr.c b/net/qrtr/qrtr.c
> index e09154b..bd9bcea 100644
> --- a/net/qrtr/qrtr.c
> +++ b/net/qrtr/qrtr.c
> @@ -400,12 +400,13 @@ static void qrtr_node_assign(struct qrtr_node *node, unsigned int nid)
>  {
>  	unsigned long flags;
>  
> -	if (node->nid != QRTR_EP_NID_AUTO || nid == QRTR_EP_NID_AUTO)
> +	if (nid == QRTR_EP_NID_AUTO)
>  		return;
>  
>  	spin_lock_irqsave(&qrtr_nodes_lock, flags);
>  	radix_tree_insert(&qrtr_nodes, nid, node);
> -	node->nid = nid;
> +	if (node->nid == QRTR_EP_NID_AUTO)
> +		node->nid = nid;
>  	spin_unlock_irqrestore(&qrtr_nodes_lock, flags);
>  }
>  
> @@ -493,6 +494,12 @@ int qrtr_endpoint_post(struct qrtr_endpoint *ep, const void *data, size_t len)
>  
>  	qrtr_node_assign(node, cb->src_node);
>  
> +	if (cb->type == QRTR_TYPE_NEW_SERVER) {
> +		/* Remote node endpoint can bridge other distant nodes */
> +		const struct qrtr_ctrl_pkt *pkt = data + hdrlen;
> +		qrtr_node_assign(node, le32_to_cpu(pkt->server.node));
> +	}
> +
>  	if (cb->type == QRTR_TYPE_RESUME_TX) {
>  		qrtr_tx_resume(node, skb);
>  	} else {
> -- 
> 2.7.4
> 
