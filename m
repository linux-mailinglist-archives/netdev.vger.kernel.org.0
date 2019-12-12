Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1A9CD11D06B
	for <lists+netdev@lfdr.de>; Thu, 12 Dec 2019 16:02:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728641AbfLLPCF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Dec 2019 10:02:05 -0500
Received: from mail-yw1-f66.google.com ([209.85.161.66]:35319 "EHLO
        mail-yw1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728581AbfLLPCF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Dec 2019 10:02:05 -0500
Received: by mail-yw1-f66.google.com with SMTP id i190so878023ywc.2;
        Thu, 12 Dec 2019 07:02:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=88P7hGgy6VEyhnH2Wu8BZSOUx6up5jv+cSRDPvY4HZ0=;
        b=JakaJ6iM4KJXl2DlVFFGI4PE6etmpjeL2JZmewo+mrHW+fESI9UnGKRlaqUkMrV/+1
         5geYwMDMu26/0rbn+bfE/oR3NAVtgCPv31N7eGtBdDVaWP2KTnTUMS1iHRowj0XnmpfX
         4UX0f1MCIspncFDFSH/TI7ykgrnMZp6peglbRdfCR6kjwpiiuXC4Vzx4VJrOj63+s2qL
         YJQvCVNEhTa/LlMVvadM8/RUdS1RDgic90ch6eFKU9RLN3IVnXHbXZFFb0APsmEJ0t14
         s5A+LsUZkE1UQVcMxAHRvGVBamtdC40IdzM1+QeH/3H5heYyRs2Y0E9WBj7T/+8LrAxO
         k4eA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=88P7hGgy6VEyhnH2Wu8BZSOUx6up5jv+cSRDPvY4HZ0=;
        b=k+6JBMXo4JoiYIMYxbEUQn6+RD9P3aQfcWzW/GsKyCm0cJF7b4WfBls0z/YIpMac/k
         rstI13A5JQuJ/wNDHcxhgUWypQIdjOaZIUxYrewx3efWEdrdzbDgZiOtsQGLwXLiuuzK
         DyzSnJMoli3NuzclIt7Hujp54aWHF7XwgWaR/bB2g8uPyVvw/+05coENv8b2sjSphdZE
         0YrtoKBwlmV5Tt1VbF24sPBL0WyrwhWxTWFEekdIh9fLPCcKn3f3q2klpA/bIA/YDw2k
         QOxvebx95MPo1vraJSPU2SbIY9ztuDazV1ZvAwOpRKMtr/jpJXtK9ZvqW8BElD/KOHd7
         inyw==
X-Gm-Message-State: APjAAAVIHHQgVHGQKdr60NlUxWgmQ2RRKmGIc58layIXqnbgdMpk0O/j
        Oy9fzn6C6j/lZ/yS57NjpQkphjzhnArmmA==
X-Google-Smtp-Source: APXvYqydAxoN3yhF+zDxMfTh+NSSfxq/O43aghaQWXqunOVFNvk6+Q0tCC/c3s8uXvk9ThyuszIshQ==
X-Received: by 2002:a25:70c1:: with SMTP id l184mr4322144ybc.463.1576162924271;
        Thu, 12 Dec 2019 07:02:04 -0800 (PST)
Received: from karen ([2604:2d80:d68a:cf00:1549:e76:ca4c:6ce8])
        by smtp.gmail.com with ESMTPSA id s31sm2613870ywa.30.2019.12.12.07.02.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Dec 2019 07:02:03 -0800 (PST)
Date:   Thu, 12 Dec 2019 09:02:00 -0600
From:   Scott Schafer <schaferjscott@gmail.com>
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
        GR-Linux-NIC-Dev@marvell.com, Manish Chopra <manishc@marvell.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 11/23] staging: qlge: Fix CHECK: braces {} should be
 used on all arms of this statement
Message-ID: <20191212150200.GA8219@karen>
References: <cover.1576086080.git.schaferjscott@gmail.com>
 <0e1fc1a16725094676fdab63d3a24a986309a759.1576086080.git.schaferjscott@gmail.com>
 <20191212121206.GB1895@kadam>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191212121206.GB1895@kadam>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 12, 2019 at 03:12:06PM +0300, Dan Carpenter wrote:
> On Wed, Dec 11, 2019 at 12:12:40PM -0600, Scott Schafer wrote:
> > @@ -351,8 +352,9 @@ static int ql_aen_lost(struct ql_adapter *qdev, struct mbox_params *mbcp)
> >  	mbcp->out_count = 6;
> >  
> >  	status = ql_get_mb_sts(qdev, mbcp);
> > -	if (status)
> > +	if (status) {
> >  		netif_err(qdev, drv, qdev->ndev, "Lost AEN broken!\n");
> > +	}
> >  	else {
> 
> The close } should be on the same line as the else.
> 
> >  		int i;
> >  
> 
> regards,
> dan carpenter

this was fixed in patch 22
