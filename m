Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4092D175462
	for <lists+netdev@lfdr.de>; Mon,  2 Mar 2020 08:22:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726780AbgCBHWc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Mar 2020 02:22:32 -0500
Received: from mail-pf1-f196.google.com ([209.85.210.196]:40291 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726426AbgCBHWc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Mar 2020 02:22:32 -0500
Received: by mail-pf1-f196.google.com with SMTP id l184so2526934pfl.7
        for <netdev@vger.kernel.org>; Sun, 01 Mar 2020 23:22:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=SkdVCR8OiXs5diTTG/Q7TJWCRWx/fIVDFp919zgH5+M=;
        b=Y+EqUsy+LkjIUDiUnyhNNMy9ar4EI2a3fdhvJoazp2B3nQGBk+koNmNdBTUw46KbfZ
         O6RTvHYBrM1lGTi5sQB4ia2VkJCyZdCmGk4DhYewS0yJjv8i2Eh1Q/hTts59+/mYqigA
         DfPMePTJIBwdrddWk07M6CkAP4tDakBDax+frBdzQC3B8K5MG6d3N46jO03gBuJe2nvi
         ff17otHto7qmDs2flWrroieBqcH6Z4TBl5yuLFSFlPMYG1RTdp5zuCvovFrdSnExll78
         8aDmroMx3UDuWgi9OpviCg5rP5WPD1mTviA1sHKvnSaNg4pmuZ33lOx8z3LGlyJG39CB
         KLVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=SkdVCR8OiXs5diTTG/Q7TJWCRWx/fIVDFp919zgH5+M=;
        b=fl6Wc4JJJXQmreLGSUqm0DJtPA/82QjNlQMHt+CfvTTrsAU8kBN40xQYAhobmxevuA
         xXsvkWyq2t4REWBeY9s/qFABzXFcXk2LJHZIGk9wXIR0Sfh0LH00ZJ3opYh3X6kWNjK5
         UCMlKT7r620SAsMSUlg/HIxQ7Q5jn8+Oh/k7z4rOk8K5iYlK6NS1YcuarTNuzr511fX3
         tFSKC6eodht5QkqnfYlJd5NISnkV/s2P5CB1VAJ/KWhBGZBcVh6OF1EW5MHsC4HvTStS
         EAPqPXJ+vgcXbrvdM2SNFaALhPFnhtcz0O1XuJX5S7DBe/Lj+WxCsS1WgwPTwH/w41hb
         oXew==
X-Gm-Message-State: ANhLgQ04Jy3iL37GigXZ84RnVmJ2umUJG5DiQtVyuy/bqm7F6EIMoAOr
        bP6oicPuE6zuLyZIImbaznqxi+BiYQ==
X-Google-Smtp-Source: ADFU+vubOlMSnHZJjju8vH6TP0cbiCd0JSbXY6EVeJWzF3TEaoPKBdFtBapF8cYeFDiMvrCOOkys1A==
X-Received: by 2002:aa7:97ac:: with SMTP id d12mr10653029pfq.209.1583133750946;
        Sun, 01 Mar 2020 23:22:30 -0800 (PST)
Received: from Mani-XPS-13-9360 ([2409:4072:683:b69c:15d:29bf:12ee:d853])
        by smtp.gmail.com with ESMTPSA id 129sm15490943pgf.10.2020.03.01.23.22.26
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Sun, 01 Mar 2020 23:22:30 -0800 (PST)
Date:   Mon, 2 Mar 2020 12:52:23 +0530
From:   Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
To:     Bjorn Andersson <bjorn.andersson@linaro.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org
Subject: Re: [PATCH 1/2] net: qrtr: Respond to HELLO message
Message-ID: <20200302072223.GC23607@Mani-XPS-13-9360>
References: <20200302032527.552916-1-bjorn.andersson@linaro.org>
 <20200302032527.552916-2-bjorn.andersson@linaro.org>
 <20200302055025.GA23607@Mani-XPS-13-9360>
 <20200302065502.GG210720@yoga>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200302065502.GG210720@yoga>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Mar 01, 2020 at 10:55:02PM -0800, Bjorn Andersson wrote:
> On Sun 01 Mar 21:50 PST 2020, Manivannan Sadhasivam wrote:
> 
> > Hi Bjorn,
> > 
> > Thanks for the fix. I have tested this and it works perfectly!
> > 
> > On Sun, Mar 01, 2020 at 07:25:26PM -0800, Bjorn Andersson wrote:
> > > Lost in the translation from the user space implementation was the
> > > detail that HELLO mesages must be exchanged between each node pair.  As
> > > such the incoming HELLO must be replied to.
> > > 
> > 
> > Err. I thought the say_hello() part in ctrl_cmd_hello() was redundant, so
> > removed it :P
> > 
> > Sorry for that.
> > 
> 
> No worries.
> 
> > > Similar to the previous implementation no effort is made to prevent two
> > > Linux boxes from continuously sending HELLO messages back and forth,
> > > this is left to a follow up patch.
> > > 
> > > say_hello() is moved, to facilitate the new call site.
> > > 
> > > Fixes: 0c2204a4ad71 ("net: qrtr: Migrate nameservice to kernel from userspace")
> > > Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
> > > ---
> > >  net/qrtr/ns.c | 54 ++++++++++++++++++++++++++++-----------------------
> > >  1 file changed, 30 insertions(+), 24 deletions(-)
> > > 
> > > diff --git a/net/qrtr/ns.c b/net/qrtr/ns.c
> > > index 7bfde01f4e8a..e3f11052b5f6 100644
> > > --- a/net/qrtr/ns.c
> > > +++ b/net/qrtr/ns.c
> > > @@ -286,9 +286,38 @@ static int server_del(struct qrtr_node *node, unsigned int port)
> > >  	return 0;
> > >  }
> > >  
> > > +static int say_hello(struct sockaddr_qrtr *dest)
> > > +{
> > > +	struct qrtr_ctrl_pkt pkt;
> > > +	struct msghdr msg = { };
> > > +	struct kvec iv;
> > > +	int ret;
> > > +
> > > +	iv.iov_base = &pkt;
> > > +	iv.iov_len = sizeof(pkt);
> > > +
> > > +	memset(&pkt, 0, sizeof(pkt));
> > > +	pkt.cmd = cpu_to_le32(QRTR_TYPE_HELLO);
> > > +
> > > +	msg.msg_name = (struct sockaddr *)dest;
> > > +	msg.msg_namelen = sizeof(*dest);
> > > +
> > > +	ret = kernel_sendmsg(qrtr_ns.sock, &msg, &iv, 1, sizeof(pkt));
> > > +	if (ret < 0)
> > > +		pr_err("failed to send hello msg\n");
> > > +
> > > +	return ret;
> > > +}
> > > +
> > >  /* Announce the list of servers registered on the local node */
> > >  static int ctrl_cmd_hello(struct sockaddr_qrtr *sq)
> > >  {
> > > +	int ret;
> > > +
> > > +	ret = say_hello(sq); > > +	if (ret < 0)
> > > +		return ret;
> > > +
> > >  	return announce_servers(sq);
> > >  }
> > >  
> > > @@ -566,29 +595,6 @@ static void ctrl_cmd_del_lookup(struct sockaddr_qrtr *from,
> > >  	}
> > >  }
> > >  
> > > -static int say_hello(void)
> > > -{
> > > -	struct qrtr_ctrl_pkt pkt;
> > > -	struct msghdr msg = { };
> > > -	struct kvec iv;
> > > -	int ret;
> > > -
> > > -	iv.iov_base = &pkt;
> > > -	iv.iov_len = sizeof(pkt);
> > > -
> > > -	memset(&pkt, 0, sizeof(pkt));
> > > -	pkt.cmd = cpu_to_le32(QRTR_TYPE_HELLO);
> > > -
> > > -	msg.msg_name = (struct sockaddr *)&qrtr_ns.bcast_sq;
> > > -	msg.msg_namelen = sizeof(qrtr_ns.bcast_sq);
> > > -
> > > -	ret = kernel_sendmsg(qrtr_ns.sock, &msg, &iv, 1, sizeof(pkt));
> > > -	if (ret < 0)
> > > -		pr_err("failed to send hello msg\n");
> > > -
> > > -	return ret;
> > > -}
> > > -
> > >  static void qrtr_ns_worker(struct work_struct *work)
> > >  {
> > >  	const struct qrtr_ctrl_pkt *pkt;
> > > @@ -725,7 +731,7 @@ void qrtr_ns_init(struct work_struct *work)
> > >  	if (!qrtr_ns.workqueue)
> > >  		goto err_sock;
> > >  
> > > -	ret = say_hello();
> > > +	ret = say_hello(&qrtr_ns.bcast_sq);
> > 
> > Why do you want to pass a global variable here? Why can't it be used directly
> > in say_hello() as done before?
> > 
> 
> Because I changed the prototype of say_hello() so that we pass the
> destination address; here that's the broadcast address, in
> ctrl_cmd_hello() it's the specific sender of the incoming hello that we
> want to respond to.
> 

Ah, yes. I missed that. Sounds good to me.

Thanks,
Mani

> Regards,
> Bjorn
> 
> > Other than that,
> > 
> > Reviewed-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
> > Tested-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
> > 
> > Thanks,
> > Mani
> > 
> > >  	if (ret < 0)
> > >  		goto err_wq;
> > >  
> > > -- 
> > > 2.24.0
> > > 
