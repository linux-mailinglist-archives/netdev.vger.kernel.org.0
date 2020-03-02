Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3F10B17537B
	for <lists+netdev@lfdr.de>; Mon,  2 Mar 2020 06:55:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726953AbgCBFzV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Mar 2020 00:55:21 -0500
Received: from mail-pf1-f194.google.com ([209.85.210.194]:45014 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725446AbgCBFzV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Mar 2020 00:55:21 -0500
Received: by mail-pf1-f194.google.com with SMTP id y5so5004643pfb.11
        for <netdev@vger.kernel.org>; Sun, 01 Mar 2020 21:55:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=/rugZxpdMgFuggpknIjg9upbTqeu96rVvKelMnBJ9UA=;
        b=AUKoQ2qIej++uMhL6Cg9bs9r0hCEdWT28c5rZpygXGbAUxGgH6pqibzWYMpM6cc7/T
         Hhu3Jn7w73pVCQZWpU0wBqzMfTezwvpaOvnbE/5bVsZoEml3Wo2JbYgkn3NaZB30zSqy
         fzoLCy4Beb8LUmmrcpVkPayAEYqs8zNb3ZMrimukA9XfsiZ9yiZU08Ww7Vl3w3yVuLse
         doj2aTd77l8pXdi6IXiROq+tghT/WVtVfz+M4+hqy9Ivwt8T8ry/cbrHfgSUOLkhA3i8
         lN/Wxw0A41YK7IkLkgnGBFmuH20k2rF+D0p5Ej/4MS5phnLcZKDYo/Nc1e8CzZhHe78w
         ifhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=/rugZxpdMgFuggpknIjg9upbTqeu96rVvKelMnBJ9UA=;
        b=nXDW0mWv5FMYFQ0X575pXhQrgSdnhtRk9NxQR+Nm3a/y+x4Oa53nyc0l9jE9kO9OVV
         0JDrVwe4p1Tu/DIi9fxv3d3diMOjTRnTrj9XmUbQDeCnq5hDCTn59RouuGS52fxTYGM1
         fQba8YNHfAiDyzF865KmREEZLBu6vsGQqQH14K5IgboCNDzj/FXsDZ+yHWxxetsVo/OG
         bUWK0ntz5DuKQXkQ6yMhNkVuZmkXPKaMM9P+zjCdBjCQgG2TmP3nKd6ZkW5/4W0CmVGu
         dg+dQdvmwgSVLcKsxlq7RJ8oybcGsFnHbqMQbIfh6SPmSZ2PgmXskGoy1pAZL+A/xX6R
         S3XQ==
X-Gm-Message-State: APjAAAVXIpZUs4obPRU6C4b0xyMi99x9uUoDetRtN1XPDakrppO1jEQz
        fBjrQ4EgFf7buDvLCnDT+H6g
X-Google-Smtp-Source: APXvYqxY0x55nq3fyRV03uQtfT196Q9JIOy5IBWGxH31mgiNHSafdj+D6Pob7Gp23ZUNY1EY8VbmHw==
X-Received: by 2002:a65:668c:: with SMTP id b12mr17983339pgw.14.1583128518463;
        Sun, 01 Mar 2020 21:55:18 -0800 (PST)
Received: from Mani-XPS-13-9360 ([2409:4072:683:b69c:15d:29bf:12ee:d853])
        by smtp.gmail.com with ESMTPSA id i15sm278975pfk.115.2020.03.01.21.55.14
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Sun, 01 Mar 2020 21:55:17 -0800 (PST)
Date:   Mon, 2 Mar 2020 11:25:10 +0530
From:   Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
To:     Bjorn Andersson <bjorn.andersson@linaro.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org
Subject: Re: [PATCH 2/2] net: qrtr: Fix FIXME related to qrtr_ns_init()
Message-ID: <20200302055510.GB23607@Mani-XPS-13-9360>
References: <20200302032527.552916-1-bjorn.andersson@linaro.org>
 <20200302032527.552916-3-bjorn.andersson@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200302032527.552916-3-bjorn.andersson@linaro.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Mar 01, 2020 at 07:25:27PM -0800, Bjorn Andersson wrote:
> The 2 second delay before calling qrtr_ns_init() meant that the remote
> processors would register as endpoints in qrtr and the say_hello() call
> would therefor broadcast the outgoing HELLO to them. With the HELLO
> handshake corrected this delay is no longer needed.
> 
> Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
> ---
>  net/qrtr/ns.c   | 2 +-
>  net/qrtr/qrtr.c | 6 +-----
>  net/qrtr/qrtr.h | 2 +-
>  3 files changed, 3 insertions(+), 7 deletions(-)
> 
> diff --git a/net/qrtr/ns.c b/net/qrtr/ns.c
> index e3f11052b5f6..cfd4bd07a62b 100644
> --- a/net/qrtr/ns.c
> +++ b/net/qrtr/ns.c
> @@ -693,7 +693,7 @@ static void qrtr_ns_data_ready(struct sock *sk)
>  	queue_work(qrtr_ns.workqueue, &qrtr_ns.work);
>  }
>  
> -void qrtr_ns_init(struct work_struct *work)
> +void qrtr_ns_init(void)
>  {
>  	struct sockaddr_qrtr sq;
>  	int ret;
> diff --git a/net/qrtr/qrtr.c b/net/qrtr/qrtr.c
> index 423310896285..313d3194018a 100644
> --- a/net/qrtr/qrtr.c
> +++ b/net/qrtr/qrtr.c
> @@ -1263,11 +1263,7 @@ static int __init qrtr_proto_init(void)
>  		return rc;
>  	}
>  
> -	/* FIXME: Currently, this 2s delay is required to catch the NEW_SERVER
> -	 * messages from routers. But the fix could be somewhere else.
> -	 */
> -	INIT_DELAYED_WORK(&qrtr_ns_work, qrtr_ns_init);
> -	schedule_delayed_work(&qrtr_ns_work, msecs_to_jiffies(2000));
> +	qrtr_ns_init();
>  

You forgot to remove the below instances of delayed_work:

#include <linux/workqueue.h>
struct delayed_work qrtr_ns_work;
cancel_delayed_work_sync(&qrtr_ns_work);

Other than that,

Reviewed-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Tested-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>

Thanks,
Mani

>  	return rc;
>  }
> diff --git a/net/qrtr/qrtr.h b/net/qrtr/qrtr.h
> index 53a237a28971..dc2b67f17927 100644
> --- a/net/qrtr/qrtr.h
> +++ b/net/qrtr/qrtr.h
> @@ -29,7 +29,7 @@ void qrtr_endpoint_unregister(struct qrtr_endpoint *ep);
>  
>  int qrtr_endpoint_post(struct qrtr_endpoint *ep, const void *data, size_t len);
>  
> -void qrtr_ns_init(struct work_struct *work);
> +void qrtr_ns_init(void);
>  
>  void qrtr_ns_remove(void);
>  
> -- 
> 2.24.0
> 
