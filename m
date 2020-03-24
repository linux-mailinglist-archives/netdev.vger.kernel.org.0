Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6F28B191146
	for <lists+netdev@lfdr.de>; Tue, 24 Mar 2020 14:40:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727509AbgCXNip (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Mar 2020 09:38:45 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:36623 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726190AbgCXNip (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Mar 2020 09:38:45 -0400
Received: by mail-pg1-f194.google.com with SMTP id j29so2154943pgl.3;
        Tue, 24 Mar 2020 06:38:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=VBUiQeQGfbe8m2l40UxLUa/kv9A6NhKT5KCGe27ow+8=;
        b=WYsgIh1n5JIAK81ordTHdR/AxVf/kv+FGkkNkouvpEK4dg+KJDc6LSzJv7opLcQjjr
         TAAFU84ryji0ojTaNkoHl++YY2F7es7YZkFMYsqb1amYVN0pWRVM+9uXzpGgF82f+57Z
         LLXV6lza0hs2+s4SLpULbRNTHxVu24mOYBIVrKwr+7LkZzn6fvJ3bar0gjBNpxkxa7Y+
         b6DXeeCYZm4tBzZF2cQCVtP6iaTsV6muP1qpez3Z7W5q97xuRTQA8Gi3UNhLGifqDj6F
         dj+QXv7ZsafkI7pKv803Wk0A5tbCYQ7NO+ipgy/7sqrx3DCYyfujyUqhz73yFJJzShT7
         AKvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=VBUiQeQGfbe8m2l40UxLUa/kv9A6NhKT5KCGe27ow+8=;
        b=IGNBFwcJrLpV5YUGKa8vEOJ77G3I8F3q9kqEANnWX8iffXqSbPuwYTdlxnqOz2LBKN
         IsioW0+92VwU0dskZawImnRfjW/eu99wiXCrRw6Tapdz4lEQY2BrWLlvK1Mi7ZAPMUvL
         rGXJM/Uolg3wPffseNL9YK4xCpxzncFZqCvEfNg2U5Rc19HaZ2CfqC9phPDIKraqgmx/
         xxWIcWJQMOrkGUmZKhE3LvBAbeEs9n4nsZN7kuDfg0Uy9CGfxw1ScMvbbBgrSWB3tb0X
         tZV8x6LakiMIjNBa8csOxDJQgZEBdgiD7lggK4lCo9EMrv9wVtpXF0CTg5//WkjQvYpk
         kVew==
X-Gm-Message-State: ANhLgQ3gs8oiqMt2lqvUdqf7A90/DJRGT+4SKzHwl+U2HeD7trQ+yWta
        clrA0ZTmKwz1UkA4zlXCm5lDM1WY
X-Google-Smtp-Source: ADFU+vsIe4Fpzy8sKjAqkFakHApgf5NUUwRM9dTOixpmaJ2WbWd/cY0pU0nHKo8mn0YepHQmGpsmdg==
X-Received: by 2002:a62:1dd3:: with SMTP id d202mr29893622pfd.47.1585057123911;
        Tue, 24 Mar 2020 06:38:43 -0700 (PDT)
Received: from localhost (c-73-241-114-122.hsd1.ca.comcast.net. [73.241.114.122])
        by smtp.gmail.com with ESMTPSA id e14sm15849294pfn.196.2020.03.24.06.38.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Mar 2020 06:38:43 -0700 (PDT)
Date:   Tue, 24 Mar 2020 06:38:41 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     Grygorii Strashko <grygorii.strashko@ti.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Lokesh Vutla <lokeshvutla@ti.com>,
        Tony Lindgren <tony@atomide.com>, Sekhar Nori <nsekhar@ti.com>,
        Murali Karicheri <m-karicheri2@ti.com>,
        netdev <netdev@vger.kernel.org>, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v3 00/11] net: ethernet: ti: cpts: add irq and
 HW_TS_PUSH events
Message-ID: <20200324133841.GC18149@localhost>
References: <20200320194244.4703-1-grygorii.strashko@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200320194244.4703-1-grygorii.strashko@ti.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 20, 2020 at 09:42:33PM +0200, Grygorii Strashko wrote:
> Main changes comparing to initial submission:
> - both RX/TX timestamp processing deferred to ptp worker

I can't see any benefit in delaying Rx time stamps.
What is the reason for this change?

Thanks,
Richard
