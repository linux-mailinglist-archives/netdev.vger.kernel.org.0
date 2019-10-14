Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 24387D5F65
	for <lists+netdev@lfdr.de>; Mon, 14 Oct 2019 11:52:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731183AbfJNJwJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Oct 2019 05:52:09 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:35475 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730740AbfJNJwJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Oct 2019 05:52:09 -0400
Received: by mail-wr1-f67.google.com with SMTP id v8so18924527wrt.2;
        Mon, 14 Oct 2019 02:52:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=TgbHwKMY+OVVpJwkvai2RZenJKOMFPjpVaxMPbCBN5c=;
        b=elRGhDdYM5z0fh+u2IZyo1JzQV3H7y+UrHsWM7o/96lM7+Ebs6p8gPbSvJ3AVhwJBj
         0NaTzI4MZEPEaXP6FqpGKddIbjjUo/h3yv+u1gRnlgcU8DFQDR0lPjDD1lxDWyHvLKqK
         3/O6c+NKmB9mGLM3ikw52QIHKw9zDHJjlz8o2NVxkvnT8MyK0RVkOfE41JxQgyBHuZS+
         sK0H63CzgAsyROvFwi1LQbLicVptacN6HMiQtFR/kYFrXLewZJEeKfjSGdD0taVpV33/
         +/SoMOlx52DP38EiUcth+pT1z/j4ZsVeUg8nXnPW8OG8OCvUVZICpLt6TxV0bJCsTH/i
         NRDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=TgbHwKMY+OVVpJwkvai2RZenJKOMFPjpVaxMPbCBN5c=;
        b=Ji+Zgwo1BSJnYe32mb3kSSurSzRHMQEQpvOt20XDBJjrg5ELwcN8+t6ddmmoe+O62e
         QoJOA3pLIuQ46KU+xg66XEvgI8KPKN07vwK56HNQuI7QTYBLcvUDA7T0oP7368HdVfza
         XWy7wGyTRK798KpsAQzxfpNV7P/4sN5aPxJ3f3b/rFK/X9UwAdUN9Yy7P1nR5AIi0K9l
         zRe0W+u2xZCKiC8yVq8yqbjM19/frpCWZRVv2fcqL7gj+MAqbCqtNeCTJg/3Y87UtK6+
         2Vt03JKSLWn/jrl+dE8vs7JlK6TBG2Df+I5o6ric4liH9EuDM+pMe0YIYQtUEz+akWuS
         RcVA==
X-Gm-Message-State: APjAAAVyuDdAjx9yOC6R3hs+0IRpee1YNhYd9aOvB5udUJiJh4qKUs9I
        8KdtlJkKB7oAccoTOhLWZi2P/B3RJu8=
X-Google-Smtp-Source: APXvYqz1DO5pTofEXIw0VuTnZxvGGS4XOx24scLh6dbp7EmJkpptvcoPoDUeJr/fbSXfHIkghsFIMw==
X-Received: by 2002:adf:e90d:: with SMTP id f13mr25249204wrm.104.1571046726846;
        Mon, 14 Oct 2019 02:52:06 -0700 (PDT)
Received: from andrea.guest.corp.microsoft.com ([2a01:110:8012:1012:484d:bbc3:12dc:348b])
        by smtp.gmail.com with ESMTPSA id r6sm19715339wmh.38.2019.10.14.02.52.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Oct 2019 02:52:06 -0700 (PDT)
Date:   Mon, 14 Oct 2019 11:52:00 +0200
From:   Andrea Parri <parri.andrea@gmail.com>
To:     Michael Kelley <mikelley@microsoft.com>
Cc:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        KY Srinivasan <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Sasha Levin <sashal@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        vkuznets <vkuznets@redhat.com>, Dexuan Cui <decui@microsoft.com>
Subject: Re: [PATCH v2 1/3] Drivers: hv: vmbus: Introduce table of VMBus
 protocol versions
Message-ID: <20191014095200.GA11206@andrea.guest.corp.microsoft.com>
References: <20191010154600.23875-1-parri.andrea@gmail.com>
 <20191010154600.23875-2-parri.andrea@gmail.com>
 <DM5PR21MB013798776480FFA5DCD22442D7960@DM5PR21MB0137.namprd21.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DM5PR21MB013798776480FFA5DCD22442D7960@DM5PR21MB0137.namprd21.prod.outlook.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > @@ -244,20 +232,18 @@ int vmbus_connect(void)
> >  	 * version.
> >  	 */
> > 
> > -	version = VERSION_CURRENT;
> > +	for (i = 0; i < ARRAY_SIZE(vmbus_versions); i++) {
> > +		version = vmbus_versions[i];
> > 
> > -	do {
> >  		ret = vmbus_negotiate_version(msginfo, version);
> >  		if (ret == -ETIMEDOUT)
> >  			goto cleanup;
> > 
> >  		if (vmbus_connection.conn_state == CONNECTED)
> >  			break;
> > +	}
> > 
> > -		version = vmbus_get_next_version(version);
> > -	} while (version != VERSION_INVAL);
> > -
> > -	if (version == VERSION_INVAL)
> > +	if (vmbus_connection.conn_state != CONNECTED)
> >  		goto cleanup;
> > 
> 
> This is a nit, but the loop exit path bugs me.  When a connection
> is established, the loop is exited by the "break", and then
> conn_state has to be tested again to decide whether the loop
> exited due to getting a connection vs. hitting the end of the list.
> Slightly cleaner in my mind would be:
> 
> 	for (i=0; ; i++) {
> 		if (i == ARRAY_SIZE(vmbus_versions))
> 			goto cleanup;
> 
> 		version  = vmbus_versions[i];
> 		ret = vmbus_negotiate_version(msginfo, version);
> 		if (ret == -ETIMEDOUT)
> 			goto cleanup;
> 
> 		if (vmbus_connection.conn_state == CONNECTED)
> 			break;
> 	}

Indeed.  I applied this locally, for the next iteration.  Thank you for
the review, Michael.

  Andrea
