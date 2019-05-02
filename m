Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 13DCB1205E
	for <lists+netdev@lfdr.de>; Thu,  2 May 2019 18:38:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726482AbfEBQig (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 May 2019 12:38:36 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:44077 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726338AbfEBQig (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 May 2019 12:38:36 -0400
Received: by mail-wr1-f65.google.com with SMTP id c5so4255660wrs.11;
        Thu, 02 May 2019 09:38:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=WCg55UBvofcQY30vp8bMKEAotS2TiPrUJ6KwYRg11YI=;
        b=lNHVBPlAVsb+yxpdWN5v/UhJVOtaNgJFPQb2sQSuiYfFLlL2CrW5ZDWAQ9KiMpdF0K
         nDjQNufIYiyVlwikLnJiauBUAeae84SvldowG/xD9BUW5UA2GjCEaQ5myb9AdvnZODFw
         oY1q96dW8qRCBcHYb9Q/qGSlorHE+N4cVdBc26ooXCamWDGQVUc7QP3z/vuT8UEsiTYY
         UqxpuUWz+hYCOI4c7pdsK7Iwhbaac0Oi1MJj3ddun33u7ROsbegX8W7I7A1nmzdEKBFv
         lqnmGGhaXJMoMN17uv48NVzE9uOiChHXUhFVLG02nYoYlNwwz+BcLKbQOzgW5hnYO83A
         Mnqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=WCg55UBvofcQY30vp8bMKEAotS2TiPrUJ6KwYRg11YI=;
        b=eyTdecZoLpaVQXfPOT/24bHYQ/F2En3SuN39BJfN3uuXtlCAZngcETyX8WsvvDGvpg
         aXe7d3aDXPXavEOoYaqeaC2NxFq1gbSGqjpzoKpxn6eUASJKvWjM4OdjjAcBmTt/qwxj
         qJN2lOlvY/zzeryr199Jnilq9zXjLlSfTs3b090xMne4LaXu+ro7HZ/yWqWHWEdUv89K
         jIy4paoqMCF/pZzWpq4bQHNNNVNlLIsAmmDY3o9FYqrbU3RiZtmjsYut7gzfyPYhsEv0
         D17buyUndBp7ZpUSqLvNFQxYVJoLnFbVCmYKLnfrk1OMPWOD5QNv8UYltpMvIpeWQPAd
         +tiw==
X-Gm-Message-State: APjAAAWNSPA3Y8qHtSZ8hNWi337XaU3ZPIHFMPbRU6rIAMRcPTfACCuR
        Qr/y9ikOlp2PgbjNaHNWnYu6go+z
X-Google-Smtp-Source: APXvYqxgguvaBA/sLmAZwJGt4LrBldv5la5wkWpKEvQwNY1Z/EXq01oe4B3DJzXGTQ0gN+7LJNy+rw==
X-Received: by 2002:adf:dd46:: with SMTP id u6mr3355658wrm.228.1556815113954;
        Thu, 02 May 2019 09:38:33 -0700 (PDT)
Received: from Red ([2a01:cb1d:147:7200:2e56:dcff:fed2:c6d6])
        by smtp.googlemail.com with ESMTPSA id u64sm1122347wmg.23.2019.05.02.09.38.22
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 02 May 2019 09:38:23 -0700 (PDT)
Date:   Thu, 2 May 2019 18:38:21 +0200
From:   Corentin Labbe <clabbe.montjoie@gmail.com>
To:     Kalyani Akula <kalyania@xilinx.com>
Cc:     "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "kstewart@linuxfoundation.org" <kstewart@linuxfoundation.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "pombredanne@nexb.com" <pombredanne@nexb.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Sarat Chand Savitala <saratcha@xilinx.com>
Subject: Re: [RFC PATCH V3 0/4] Add Xilinx's ZynqMP SHA3 driver support
Message-ID: <20190502163821.GA22561@Red>
References: <1556793282-17346-1-git-send-email-kalyani.akula@xilinx.com>
 <20190502120012.GA19008@Red>
 <BN7PR02MB512413C534A8EFA925105441AF340@BN7PR02MB5124.namprd02.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BN7PR02MB512413C534A8EFA925105441AF340@BN7PR02MB5124.namprd02.prod.outlook.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 02, 2019 at 03:12:55PM +0000, Kalyani Akula wrote:
> Hi Corentin,
> 
> Please find my response inline.
> 
> > -----Original Message-----
> > From: Corentin Labbe <clabbe.montjoie@gmail.com>
> > Sent: Thursday, May 2, 2019 5:30 PM
> > To: Kalyani Akula <kalyania@xilinx.com>
> > Cc: herbert@gondor.apana.org.au; kstewart@linuxfoundation.org;
> > gregkh@linuxfoundation.org; tglx@linutronix.de; pombredanne@nexb.com;
> > linux-crypto@vger.kernel.org; linux-kernel@vger.kernel.org;
> > netdev@vger.kernel.org; Sarat Chand Savitala <saratcha@xilinx.com>; Kalyani
> > Akula <kalyania@xilinx.com>
> > Subject: Re: [RFC PATCH V3 0/4] Add Xilinx's ZynqMP SHA3 driver support
> > 
> > On Thu, May 02, 2019 at 04:04:38PM +0530, Kalyani Akula wrote:
> > > This patch set adds support for
> > > - dt-binding docs for Xilinx ZynqMP SHA3 driver
> > > - Adds communication layer support for sha_hash in zynqmp.c
> > > - Adds Xilinx ZynqMP driver for SHA3 Algorithm
> > > - Adds device tree node for ZynqMP SHA3 driver
> > >
> > > V3 Changes :
> > > - Removed zynqmp_sha_import and export APIs.The reason as follows The
> > > user space code does an accept on an already accepted FD when we
> > > create AF_ALG socket and call accept on it, it calls af_alg_accept and
> > > not hash_accept.
> > > import and export APIs are called from hash_accept.
> > > The flow is as below
> > > accept--> af_alg_accept-->hash_accept_parent-->hash_accept_parent_noke
> > > accept--> y
> > > for hash salg_type.
> > > - Resolved comments from
> > >         https://patchwork.kernel.org/patch/10753719/
> > >
> > 
> > 
> > Your driver still doesnt handle the case where two hash are done in parallel.
> > 
> 
> Our Firmware uses IPI protocol to send this SHA3 requests to SHA3 HW engine, which doesn't support parallel processing of 2 hash requests.
> The flow is 
> SHA3 request from App -> SHA3 driver-> ZynqMp driver-> Firmware (which doesn't support parallel processing of 2 requests) -> SHA3 HW Engine
> 
> 

So your driver will just send bad result in that case.

You need to export and store the intermediate result in a request context.

> > Furthermore, you miss the export/import functions.
> > 
> 
> When user space code does an accept on an already accepted FD as below
> sockfd = socket(AF_ALG, SOCK_SEQPACKET, 0);
> bind(sockfd, (struct sockaddr *)&sa, sizeof(sa));
> fd = accept(sockfd, NULL, 0);
> 
> where my sockaddr is 
> struct sockaddr_alg sa = {
>         .salg_family = AF_ALG,
>         .salg_type = "hash",
>         .salg_name = "xilinx-sha3-384"
>  };
> 
> Upon calling accept the flow in the kernel is as mentioned
> accept--> af_alg_accept-->hash_accept_parent-->hash_accept_parent_nokey
> for hash salg_type.
> 
> And where import and export functions are called from hash_accept. hence, these functions never be called from the application.
> So, I removed those from the driver.
> 
> Regards
> Kalyani.
> 

Handling your own worflow is not enough.

You need to support two client doing multiple update in parallel.
It seems that your driver is bugged in that case.

Furthermore, i am pretty sure that export and import are mandatory, and without them self-test should fail.
Do you have self test enabled and tryed to load the tcrypt module ?

Regards
