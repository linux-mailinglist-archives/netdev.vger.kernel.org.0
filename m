Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8CB76175425
	for <lists+netdev@lfdr.de>; Mon,  2 Mar 2020 07:55:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726621AbgCBGzH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Mar 2020 01:55:07 -0500
Received: from mail-pj1-f66.google.com ([209.85.216.66]:52903 "EHLO
        mail-pj1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726232AbgCBGzH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Mar 2020 01:55:07 -0500
Received: by mail-pj1-f66.google.com with SMTP id lt1so1291665pjb.2
        for <netdev@vger.kernel.org>; Sun, 01 Mar 2020 22:55:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=pWcYKlhLAnKGB3383nGwa1XGwMwc5bp9m4MPxMifptM=;
        b=nNDD/rubXmYKGH9BJT0e27lqeQsmccF/U5km0Dx0rn8qwQ3HpB6UDN8hyJWQr7Qi56
         GTi2hkxYOrvhaqLFEoHFPt+0Qr23+FJfaBiCc+zQll5nEkmnnTgvhHTUVZ8kmogW1ypd
         H/1bATv1m/pje1sWAlfQLACBnkOkSJEPgg/UCoSjQk8HncVFVF5zlZPWDqab0Vs10KB2
         chQ2tiO375iXhc9thpXCn2UQxY+PIOCaRlIpvI0cC5J2XmaCjAnFLZta7uAjMIQm/UH3
         pVNYtib47VbQcSam2au+f9Z1sF1TnQ+EZFvelzznopj3lUi716/ozqCbez6CKqx5S8O8
         vlPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=pWcYKlhLAnKGB3383nGwa1XGwMwc5bp9m4MPxMifptM=;
        b=jYqoK7OCYPLE+t5KjmPne1h9Dqzq8FMEV3kKtHPZm8E/YTZqj6n249Wz9QH5CN+VKI
         DX/hLgi20cZf35Oi4cEFdXqnA/ETzzcxLiZ0j7Bu44pQuaZ6TSNjEv6QeGBf2tRZnHCj
         fHRMa2F1eVDL2L5urC+eU/JQyLrkJIiVbSGRgt/yGaBZ6mDKl165zyQ+ofp7YswGq25N
         Lbl6bVYZheU7eV92whxgAZRdjLcgCB/kdC7O2JJIVg0P2UfoNApPt7Mm00qTZIZMWbtk
         V7EVL50dEb9NsaKZF2lXqljbXbnbtVP6+S00/75t8rlHN4rsxQ7qVU0dj3ZYP3bkJz9x
         nhBg==
X-Gm-Message-State: APjAAAUWPnQLFAvv5SOw/d+ixJ7BoAtJ0K8m/13GYX4j+1Kosj9fI2EH
        dS4qf3oZv/FO4M5U70dkRWnjFQ==
X-Google-Smtp-Source: APXvYqxAQJBrCZKpR7ZbY7wdYkROyZ6BhKS54PIo+Ig28iQj7F3OvFmQe2/r9GuyIz2jw/M+aKP79A==
X-Received: by 2002:a17:902:8545:: with SMTP id d5mr15883403plo.116.1583132105386;
        Sun, 01 Mar 2020 22:55:05 -0800 (PST)
Received: from yoga (104-188-17-28.lightspeed.sndgca.sbcglobal.net. [104.188.17.28])
        by smtp.gmail.com with ESMTPSA id w26sm20301383pfj.119.2020.03.01.22.55.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 01 Mar 2020 22:55:04 -0800 (PST)
Date:   Sun, 1 Mar 2020 22:55:02 -0800
From:   Bjorn Andersson <bjorn.andersson@linaro.org>
To:     Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org
Subject: Re: [PATCH 1/2] net: qrtr: Respond to HELLO message
Message-ID: <20200302065502.GG210720@yoga>
References: <20200302032527.552916-1-bjorn.andersson@linaro.org>
 <20200302032527.552916-2-bjorn.andersson@linaro.org>
 <20200302055025.GA23607@Mani-XPS-13-9360>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200302055025.GA23607@Mani-XPS-13-9360>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun 01 Mar 21:50 PST 2020, Manivannan Sadhasivam wrote:

> Hi Bjorn,
> 
> Thanks for the fix. I have tested this and it works perfectly!
> 
> On Sun, Mar 01, 2020 at 07:25:26PM -0800, Bjorn Andersson wrote:
> > Lost in the translation from the user space implementation was the
> > detail that HELLO mesages must be exchanged between each node pair.  As
> > such the incoming HELLO must be replied to.
> > 
> 
> Err. I thought the say_hello() part in ctrl_cmd_hello() was redundant, so
> removed it :P
> 
> Sorry for that.
> 

No worries.

> > Similar to the previous implementation no effort is made to prevent two
> > Linux boxes from continuously sending HELLO messages back and forth,
> > this is left to a follow up patch.
> > 
> > say_hello() is moved, to facilitate the new call site.
> > 
> > Fixes: 0c2204a4ad71 ("net: qrtr: Migrate nameservice to kernel from userspace")
> > Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
> > ---
> >  net/qrtr/ns.c | 54 ++++++++++++++++++++++++++++-----------------------
> >  1 file changed, 30 insertions(+), 24 deletions(-)
> > 
> > diff --git a/net/qrtr/ns.c b/net/qrtr/ns.c
> > index 7bfde01f4e8a..e3f11052b5f6 100644
> > --- a/net/qrtr/ns.c
> > +++ b/net/qrtr/ns.c
> > @@ -286,9 +286,38 @@ static int server_del(struct qrtr_node *node, unsigned int port)
> >  	return 0;
> >  }
> >  
> > +static int say_hello(struct sockaddr_qrtr *dest)
> > +{
> > +	struct qrtr_ctrl_pkt pkt;
> > +	struct msghdr msg = { };
> > +	struct kvec iv;
> > +	int ret;
> > +
> > +	iv.iov_base = &pkt;
> > +	iv.iov_len = sizeof(pkt);
> > +
> > +	memset(&pkt, 0, sizeof(pkt));
> > +	pkt.cmd = cpu_to_le32(QRTR_TYPE_HELLO);
> > +
> > +	msg.msg_name = (struct sockaddr *)dest;
> > +	msg.msg_namelen = sizeof(*dest);
> > +
> > +	ret = kernel_sendmsg(qrtr_ns.sock, &msg, &iv, 1, sizeof(pkt));
> > +	if (ret < 0)
> > +		pr_err("failed to send hello msg\n");
> > +
> > +	return ret;
> > +}
> > +
> >  /* Announce the list of servers registered on the local node */
> >  static int ctrl_cmd_hello(struct sockaddr_qrtr *sq)
> >  {
> > +	int ret;
> > +
> > +	ret = say_hello(sq); > > +	if (ret < 0)
> > +		return ret;
> > +
> >  	return announce_servers(sq);
> >  }
> >  
> > @@ -566,29 +595,6 @@ static void ctrl_cmd_del_lookup(struct sockaddr_qrtr *from,
> >  	}
> >  }
> >  
> > -static int say_hello(void)
> > -{
> > -	struct qrtr_ctrl_pkt pkt;
> > -	struct msghdr msg = { };
> > -	struct kvec iv;
> > -	int ret;
> > -
> > -	iv.iov_base = &pkt;
> > -	iv.iov_len = sizeof(pkt);
> > -
> > -	memset(&pkt, 0, sizeof(pkt));
> > -	pkt.cmd = cpu_to_le32(QRTR_TYPE_HELLO);
> > -
> > -	msg.msg_name = (struct sockaddr *)&qrtr_ns.bcast_sq;
> > -	msg.msg_namelen = sizeof(qrtr_ns.bcast_sq);
> > -
> > -	ret = kernel_sendmsg(qrtr_ns.sock, &msg, &iv, 1, sizeof(pkt));
> > -	if (ret < 0)
> > -		pr_err("failed to send hello msg\n");
> > -
> > -	return ret;
> > -}
> > -
> >  static void qrtr_ns_worker(struct work_struct *work)
> >  {
> >  	const struct qrtr_ctrl_pkt *pkt;
> > @@ -725,7 +731,7 @@ void qrtr_ns_init(struct work_struct *work)
> >  	if (!qrtr_ns.workqueue)
> >  		goto err_sock;
> >  
> > -	ret = say_hello();
> > +	ret = say_hello(&qrtr_ns.bcast_sq);
> 
> Why do you want to pass a global variable here? Why can't it be used directly
> in say_hello() as done before?
> 

Because I changed the prototype of say_hello() so that we pass the
destination address; here that's the broadcast address, in
ctrl_cmd_hello() it's the specific sender of the incoming hello that we
want to respond to.

Regards,
Bjorn

> Other than that,
> 
> Reviewed-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
> Tested-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
> 
> Thanks,
> Mani
> 
> >  	if (ret < 0)
> >  		goto err_wq;
> >  
> > -- 
> > 2.24.0
> > 
