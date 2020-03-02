Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9E415175373
	for <lists+netdev@lfdr.de>; Mon,  2 Mar 2020 06:51:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726758AbgCBFug (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Mar 2020 00:50:36 -0500
Received: from mail-pl1-f196.google.com ([209.85.214.196]:38204 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726052AbgCBFug (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Mar 2020 00:50:36 -0500
Received: by mail-pl1-f196.google.com with SMTP id p7so3758209pli.5
        for <netdev@vger.kernel.org>; Sun, 01 Mar 2020 21:50:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=Fz5Kp2VdKawxBoU+hLFXNYu1dVA8dYreDgpbY7UrLKU=;
        b=GprpfjrSdJhCqLS8OT2NzuXi3BUcWXA15xKQGZWWf3YBBrmEtOfkB4VEjsKmem7ym3
         LLvS0HCmO+ZEdOzOFWgZiVBeBx4fRFeO/d6+MyybU/aWj7k6UoeG+/2w1nbl+6W/f/hY
         TomsHDeKCmY79m/MlbtQJy0LRRWOj+LHkkmRKkcemXRhES/3Bf/Dwmll/mu0WoxcbxCa
         gaCZNaxYJcToEnXFIXhe35fZ46yTfJMWcWIG6qEu4Zl1H1IeC7JPNgAV6myBvICL/3Sv
         jsMprZqkePz0L0voDSWOS9M7YIn9Tt4nourI+tjistiQuxTr+nMw7Id1fnpXoZlroaKW
         8vKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=Fz5Kp2VdKawxBoU+hLFXNYu1dVA8dYreDgpbY7UrLKU=;
        b=iczxrPgAZa3R06ZVMkUoIhq7skQEoLqzXpGixlNLzMT9B4jlKz15u2yt6Og887fvI0
         IDw67bhIiF3oqxXZteBLMduvrr7XYopOiHuSDmEPEGIV2gUS71GWbSg8ZRIW9xFUL22p
         V4CFDpR5g7ImmGRpsZNIKBT4G+W5Ny84PsnUr5sfsUsJq5BeX/fGqJy8w4tvxbEsa/Ju
         x/Ivevd66ySwpPC32KHggOA8T5jTC21nBfuzVx6vWz0KSH88Vm/TCFVdfbtTR+gAAW8Y
         O7T6C8mY8ClMVcVD6QTOwSMUgM6jJ3eVlGMWsfqE6+wUHZO0KdMZM2WJ356b8o1TJp5E
         6yNA==
X-Gm-Message-State: APjAAAU9JWr+hvH95GL3tCe3iTHrHFRxo6bOUXHmnYquXqdzwYowSPBh
        o3rOTH712W5g/TU2jhsvdXpM
X-Google-Smtp-Source: APXvYqwf0p2Ihc98F61cK6cnafM3qoNT3H/Dan2meJyAD3Tp1BSClvBwEBDewnQQ/ew1M66WYi9faQ==
X-Received: by 2002:a17:902:b28a:: with SMTP id u10mr16846102plr.1.1583128233500;
        Sun, 01 Mar 2020 21:50:33 -0800 (PST)
Received: from Mani-XPS-13-9360 ([2409:4072:683:b69c:15d:29bf:12ee:d853])
        by smtp.gmail.com with ESMTPSA id w81sm5179222pff.22.2020.03.01.21.50.28
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Sun, 01 Mar 2020 21:50:32 -0800 (PST)
Date:   Mon, 2 Mar 2020 11:20:25 +0530
From:   Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
To:     Bjorn Andersson <bjorn.andersson@linaro.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org
Subject: Re: [PATCH 1/2] net: qrtr: Respond to HELLO message
Message-ID: <20200302055025.GA23607@Mani-XPS-13-9360>
References: <20200302032527.552916-1-bjorn.andersson@linaro.org>
 <20200302032527.552916-2-bjorn.andersson@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200302032527.552916-2-bjorn.andersson@linaro.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Bjorn,

Thanks for the fix. I have tested this and it works perfectly!

On Sun, Mar 01, 2020 at 07:25:26PM -0800, Bjorn Andersson wrote:
> Lost in the translation from the user space implementation was the
> detail that HELLO mesages must be exchanged between each node pair.  As
> such the incoming HELLO must be replied to.
> 

Err. I thought the say_hello() part in ctrl_cmd_hello() was redundant, so
removed it :P

Sorry for that.

> Similar to the previous implementation no effort is made to prevent two
> Linux boxes from continuously sending HELLO messages back and forth,
> this is left to a follow up patch.
> 
> say_hello() is moved, to facilitate the new call site.
> 
> Fixes: 0c2204a4ad71 ("net: qrtr: Migrate nameservice to kernel from userspace")
> Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
> ---
>  net/qrtr/ns.c | 54 ++++++++++++++++++++++++++++-----------------------
>  1 file changed, 30 insertions(+), 24 deletions(-)
> 
> diff --git a/net/qrtr/ns.c b/net/qrtr/ns.c
> index 7bfde01f4e8a..e3f11052b5f6 100644
> --- a/net/qrtr/ns.c
> +++ b/net/qrtr/ns.c
> @@ -286,9 +286,38 @@ static int server_del(struct qrtr_node *node, unsigned int port)
>  	return 0;
>  }
>  
> +static int say_hello(struct sockaddr_qrtr *dest)
> +{
> +	struct qrtr_ctrl_pkt pkt;
> +	struct msghdr msg = { };
> +	struct kvec iv;
> +	int ret;
> +
> +	iv.iov_base = &pkt;
> +	iv.iov_len = sizeof(pkt);
> +
> +	memset(&pkt, 0, sizeof(pkt));
> +	pkt.cmd = cpu_to_le32(QRTR_TYPE_HELLO);
> +
> +	msg.msg_name = (struct sockaddr *)dest;
> +	msg.msg_namelen = sizeof(*dest);
> +
> +	ret = kernel_sendmsg(qrtr_ns.sock, &msg, &iv, 1, sizeof(pkt));
> +	if (ret < 0)
> +		pr_err("failed to send hello msg\n");
> +
> +	return ret;
> +}
> +
>  /* Announce the list of servers registered on the local node */
>  static int ctrl_cmd_hello(struct sockaddr_qrtr *sq)
>  {
> +	int ret;
> +
> +	ret = say_hello(sq);
> +	if (ret < 0)
> +		return ret;
> +
>  	return announce_servers(sq);
>  }
>  
> @@ -566,29 +595,6 @@ static void ctrl_cmd_del_lookup(struct sockaddr_qrtr *from,
>  	}
>  }
>  
> -static int say_hello(void)
> -{
> -	struct qrtr_ctrl_pkt pkt;
> -	struct msghdr msg = { };
> -	struct kvec iv;
> -	int ret;
> -
> -	iv.iov_base = &pkt;
> -	iv.iov_len = sizeof(pkt);
> -
> -	memset(&pkt, 0, sizeof(pkt));
> -	pkt.cmd = cpu_to_le32(QRTR_TYPE_HELLO);
> -
> -	msg.msg_name = (struct sockaddr *)&qrtr_ns.bcast_sq;
> -	msg.msg_namelen = sizeof(qrtr_ns.bcast_sq);
> -
> -	ret = kernel_sendmsg(qrtr_ns.sock, &msg, &iv, 1, sizeof(pkt));
> -	if (ret < 0)
> -		pr_err("failed to send hello msg\n");
> -
> -	return ret;
> -}
> -
>  static void qrtr_ns_worker(struct work_struct *work)
>  {
>  	const struct qrtr_ctrl_pkt *pkt;
> @@ -725,7 +731,7 @@ void qrtr_ns_init(struct work_struct *work)
>  	if (!qrtr_ns.workqueue)
>  		goto err_sock;
>  
> -	ret = say_hello();
> +	ret = say_hello(&qrtr_ns.bcast_sq);

Why do you want to pass a global variable here? Why can't it be used directly
in say_hello() as done before?

Other than that,

Reviewed-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Tested-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>

Thanks,
Mani

>  	if (ret < 0)
>  		goto err_wq;
>  
> -- 
> 2.24.0
> 
