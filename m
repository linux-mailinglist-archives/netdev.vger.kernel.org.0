Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A5B2282110
	for <lists+netdev@lfdr.de>; Sat,  3 Oct 2020 06:12:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725747AbgJCEMW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 3 Oct 2020 00:12:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725446AbgJCEMW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 3 Oct 2020 00:12:22 -0400
Received: from mail-qk1-x743.google.com (mail-qk1-x743.google.com [IPv6:2607:f8b0:4864:20::743])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45527C0613D0;
        Fri,  2 Oct 2020 21:12:22 -0700 (PDT)
Received: by mail-qk1-x743.google.com with SMTP id s131so5496903qke.0;
        Fri, 02 Oct 2020 21:12:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=hg04t68kHh/aDLKc4RiBl/UK4YGgsqcSESMyUaeK4ME=;
        b=StvhTCnWj9t49hM0DDOXzTzeTDl1Qu6vdomrdtL2tuzVRg2NavlODTkkJg99huKkUl
         p3AB9tDE7RWduREt5Rq+AEtUOOzjE2kSlxU7lAsk+IrHAMHEeHxFrBg+l5NN3bdwGZ8g
         70MchwS+zF8uIPFQ6hf/Amq2Af0NMI9QyTQGLXBgeWNjmIhxtH6lNpIAKzA8dWxdpdpo
         1c0enrT+UjDQS1Iq7eik3fMMxYOXyaSTVLBM0Efq5rinFW3XPr1GZAIjGtiX7YoDjfff
         I3ovKW72sOR+6mgcHhK9RKUtFE6TNMjSm0eCD6GbuDWvfLl5wtFvYRX+im6WVPEthzWZ
         6VWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=hg04t68kHh/aDLKc4RiBl/UK4YGgsqcSESMyUaeK4ME=;
        b=dJf1cWDOAH7BhZhvO8tvkxqnX4p+UqkONanXS9plD0CF4S/lec8YUZSJQucCx6L/Jn
         FkpPLHdWUxjdVDCgfmC5Uc+5lJst/y5/ewAQ1+RQIdxVzxqnu26++t4AGdmWv5nR2OjA
         uUbTLxUwPKHW6MBAudITmfmwiHTKl48iemTxXED7oDrm+zn3w/nuDHXvB9Kuex6xzozv
         jWCfVKY8NP2Pbwu8yF+6e/9Ixn272sNMvvSUr1Te9/+blgavTvXPZVfJs15iGUhN8NXW
         0syCzr4iZIhz3aeRqPLhEII97MDTzTk6lAflicvgQJ6wXzMKbEcHxNwg7lzqC7gu2kje
         TmTA==
X-Gm-Message-State: AOAM531YXWjTf/G+ldMQ0LKVCpzsVH1e8mg2WKZm2d5OS9ZnrqT/1xJC
        /ErIpWL8Ig0qN28qjGeo6sk=
X-Google-Smtp-Source: ABdhPJyAm/amwYVpjrS7vpOP4nbKrbWaYgoPlvCsZTlr7/mFZByk2TRmF0qKxnuEgfHXQxI2/3dMog==
X-Received: by 2002:a05:620a:650:: with SMTP id a16mr5152951qka.52.1601698341411;
        Fri, 02 Oct 2020 21:12:21 -0700 (PDT)
Received: from localhost.localdomain ([177.220.172.62])
        by smtp.gmail.com with ESMTPSA id w128sm2582863qkb.6.2020.10.02.21.12.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Oct 2020 21:12:20 -0700 (PDT)
Received: by localhost.localdomain (Postfix, from userid 1000)
        id 04534C6195; Sat,  3 Oct 2020 01:12:17 -0300 (-03)
Date:   Sat, 3 Oct 2020 01:12:17 -0300
From:   Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
To:     Xin Long <lucien.xin@gmail.com>
Cc:     network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org,
        Neil Horman <nhorman@tuxdriver.com>,
        Michael Tuexen <tuexen@fh-muenster.de>,
        Tom Herbert <therbert@google.com>, davem@davemloft.net
Subject: Re: [PATCH net-next 15/15] sctp: enable udp tunneling socks
Message-ID: <20201003041217.GI70998@localhost.localdomain>
References: <cover.1601387231.git.lucien.xin@gmail.com>
 <780b235b6b4446f77cfcf167ba797ce1ae507cf1.1601387231.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <780b235b6b4446f77cfcf167ba797ce1ae507cf1.1601387231.git.lucien.xin@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 29, 2020 at 09:49:07PM +0800, Xin Long wrote:
> This patch is to enable udp tunneling socks by calling
> sctp_udp_sock_start() in sctp_ctrlsock_init(), and
> sctp_udp_sock_stop() in sctp_ctrlsock_exit().
> 
> Also add sysctl udp_port to allow changing the listening
> sock's port by users.
> 
> Wit this patch, the whole sctp over udp feature can be
  With

> enabled and used.
...
> @@ -1466,6 +1466,10 @@ static int __net_init sctp_ctrlsock_init(struct net *net)
>  	if (status)
>  		pr_err("Failed to initialize the SCTP control sock\n");
>  
> +	status = sctp_udp_sock_start(net);

This can be masking the previous error.

> +	if (status)
> +		pr_err("Failed to initialize the SCTP udp tunneling sock\n");
                                                 SCTP UDP

> +
>  	return status;
>  }
>  

This is the last comment I had.
Thanks Xin! Nice patches.
