Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8ECE51940DB
	for <lists+netdev@lfdr.de>; Thu, 26 Mar 2020 15:04:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728345AbgCZOEB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Mar 2020 10:04:01 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:44132 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728304AbgCZOD4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Mar 2020 10:03:56 -0400
Received: by mail-pg1-f193.google.com with SMTP id 142so2904706pgf.11;
        Thu, 26 Mar 2020 07:03:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=17tMX3H9Sdcq+0ONAuGblCc3JhNQf2xB0k0+J4gQv5w=;
        b=vCtMDfHQ5Cvsc6sUODmXa4WM9QXhZZJsWuKwaH0pkh9ZkNZeQw/5z3AlMs6vGFwHyk
         +855UUdV5Rr7orSl0aK6F10moKt3nwlL9kJCDqMH7zEn3Sh5R5Oc3gFWZ71nHHIzuNKc
         yj9puVwQYwsJDVv40DcfzGl8K/s2n8Zj2/xhK/AJndlIr1XSqTQIy7VDvnGRaXfueq0N
         nX0+5nAqmThDz2w4LrDZwqO+cUVCZDFlNFqaxDY1rzRQIDlB5d10Z+YpyxDyG75uy5So
         AeyaKePMzJu/myLvJElrCPgdElk+8/1ZNV0eQUc2Q3QShNrelHWxNWgvJVA+itxQMUV+
         ln9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=17tMX3H9Sdcq+0ONAuGblCc3JhNQf2xB0k0+J4gQv5w=;
        b=TXgZKcGnmGvq6fqvM0mdhbNGVnStjmrjE7JwmziMElqQOiw6ILJfp/LVrs0Rs/7F4D
         Ks1UADnP/shhU3QaUyOI5N8Y2GxwP/8vJx/K8Rg6zuhsN7EPDjoePl8V9MslHg5yZX3K
         lwjWfAigk5pqb3WwPnpvMqadxiSWwhiHf5aB9UHSLSGTfx+Z79KNRMsY8TkKIhoeUCxB
         DHOEpkPQfaNuhE5bEiNRzQoywfNrDTrSibyc6bkZ8AfXPRmfdBKKToxjQOSTpUt3q+8R
         pIWCysqv90lF4d19OzHLh4H8BwziOk9qipcC4/H6ssD7OLozcGanKKuLIBufeb7u95rd
         Wodw==
X-Gm-Message-State: ANhLgQ35oGszXrXnGK6aYklKOUPxYl1BcOT8qQp4divCj7zzY4hJc49a
        6Xmjk6VAiX/Rxx0dH6r2lZ8=
X-Google-Smtp-Source: ADFU+vtdRRGcpFSi9InB6187asoRCJ2tCcZCL55pt1JZiXLIagZ/Fpb5kuHhPGJAztT5ef5nj0jxhw==
X-Received: by 2002:a62:2b8a:: with SMTP id r132mr9650099pfr.56.1585231435769;
        Thu, 26 Mar 2020 07:03:55 -0700 (PDT)
Received: from localhost (c-73-241-114-122.hsd1.ca.comcast.net. [73.241.114.122])
        by smtp.gmail.com with ESMTPSA id q123sm1853036pfb.54.2020.03.26.07.03.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Mar 2020 07:03:55 -0700 (PDT)
Date:   Thu, 26 Mar 2020 07:03:53 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     Grygorii Strashko <grygorii.strashko@ti.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Lokesh Vutla <lokeshvutla@ti.com>,
        Tony Lindgren <tony@atomide.com>, Sekhar Nori <nsekhar@ti.com>,
        Murali Karicheri <m-karicheri2@ti.com>,
        netdev <netdev@vger.kernel.org>, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v3 01/11] net: ethernet: ti: cpts: use dev_yy()
 api for logs
Message-ID: <20200326140353.GB20841@localhost>
References: <20200320194244.4703-1-grygorii.strashko@ti.com>
 <20200320194244.4703-2-grygorii.strashko@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200320194244.4703-2-grygorii.strashko@ti.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 20, 2020 at 09:42:34PM +0200, Grygorii Strashko wrote:
> @@ -150,7 +150,7 @@ static int cpts_fifo_read(struct cpts *cpts, int match)
>  			break;
>  
>  		if (list_empty(&cpts->pool) && cpts_purge_events(cpts)) {
> -			pr_err("cpts: event pool empty\n");
> +			dev_info(cpts->dev, "cpts: event pool empty\n");

You changed err into info.  Was that on purpose?

The size of the pool is hard coded, but it should be large enough for
any use case.  If the pool size turns out to be too small at run time,
then I think the message deserves at least the level of warning.

Thanks,
Richard
