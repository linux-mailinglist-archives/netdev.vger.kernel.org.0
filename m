Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A038D1684B6
	for <lists+netdev@lfdr.de>; Fri, 21 Feb 2020 18:19:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728144AbgBURTP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Feb 2020 12:19:15 -0500
Received: from mail-pf1-f193.google.com ([209.85.210.193]:40519 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725957AbgBURTP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Feb 2020 12:19:15 -0500
Received: by mail-pf1-f193.google.com with SMTP id b185so1557292pfb.7;
        Fri, 21 Feb 2020 09:19:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=yx5cvOCD+sFEjUGtVe6ZzZuJSF9/cKxMq4KSKO5fnIc=;
        b=RHnwH3vkrMasjLmsq/dFiAdjxc6psmxNHJk3QKr6tv8FnI94mqT9vQQ+pbRgeI7PuY
         r2kB2Vemr72V+pxeykUsAPf3F8QoVv/hNhWQ5wRiUWru9z16vqYArknEKotJfqJb3H9b
         22K1gUh5i1ntFJ2hChsfPdOZhnLOFZbP8I9uM41Vmv1TgSHcCSiEFgZ2O8fyJ50LxtOz
         w1NU3eDRKGRz3+x77yV9mAvK033yRVuLXMz+5LW5MySs8tzjnHzZ3Uonad4lyEfDYaCj
         wI/opOoq1bv4ZJSzzyvVzMf73q2FTi5RlJ/LSpxsf4kdhealESL1NEO3ElAZJJzxNid/
         LMLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=yx5cvOCD+sFEjUGtVe6ZzZuJSF9/cKxMq4KSKO5fnIc=;
        b=bM1C86zEzmzBMdssVVdTQNVCNW+RSM1K5TC0Zrp0VVq1TImTqUNdjRGuWsNlRyjCC+
         7fiVq1tHvAQBMH/Tqg5AaqMub19UYSz2bm4Ym0GF/6KjbXF2EEA8NEyYKaVz8w9HI51k
         P9qwDngmhs6oa0fLSJZzR9wCQarp5fQNSplGjgGBdNARRryeELq5ZCWQCtZ3GvsrKrM+
         /q2MFFABPjFzPe+takxs8MwhSxhFKFzUJ8rDBUiDFp9OBxA1aJtJJBU4hosrqciFp9Ho
         E/6dS5DnLpbKTSnM2W8CJaUs+HSo3UZwsZVnjLOABniIndH8Ezj/GpCCarUlimAz6Gaq
         BrOA==
X-Gm-Message-State: APjAAAWKQcfL5aHeFNT9bOPgwt1bneWbVk+VlOSo0cGR38XJXfG6oVbM
        bTnGyKw5iqyEuWRnZ237cSk=
X-Google-Smtp-Source: APXvYqxFSjsosSs8k94a9qesHL+3OUA3U+e/rBGoGglmXK80/N939pWZP6PhhL7SlGzEoJIbXdqUug==
X-Received: by 2002:a63:2541:: with SMTP id l62mr10409153pgl.98.1582305554920;
        Fri, 21 Feb 2020 09:19:14 -0800 (PST)
Received: from localhost (c-73-241-114-122.hsd1.ca.comcast.net. [73.241.114.122])
        by smtp.gmail.com with ESMTPSA id w18sm3087417pge.4.2020.02.21.09.19.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Feb 2020 09:19:14 -0800 (PST)
Date:   Fri, 21 Feb 2020 09:19:12 -0800
From:   Richard Cochran <richardcochran@gmail.com>
To:     min.li.xe@renesas.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v3 2/2] ptp: Add a ptp clock driver for IDT
 82P33 SMU.
Message-ID: <20200221171912.GA5673@localhost>
References: <1582234109-6296-1-git-send-email-min.li.xe@renesas.com>
 <20200221115128.GA1692@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200221115128.GA1692@localhost>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 21, 2020 at 03:51:28AM -0800, Richard Cochran wrote:
> > +	channel->ptp_clock = ptp_clock_register(&channel->caps, NULL);
> > +
> > +	if (IS_ERR(channel->ptp_clock)) {
> > +		err = PTR_ERR(channel->ptp_clock);
> > +		channel->ptp_clock = NULL;
> > +		return err;
> > +	}
> 
> The function, ptp_clock_register(), can also return NULL.  Please
> handle that case as well.
> 
> > +
> > +	if (!channel->ptp_clock)
> > +		return -ENOTSUPP;

Duh!  Never mind that last comment!

Thanks,
Richard
