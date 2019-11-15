Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 64EDFFD307
	for <lists+netdev@lfdr.de>; Fri, 15 Nov 2019 03:41:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726949AbfKOClR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Nov 2019 21:41:17 -0500
Received: from mail-pf1-f195.google.com ([209.85.210.195]:45866 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726674AbfKOClR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Nov 2019 21:41:17 -0500
Received: by mail-pf1-f195.google.com with SMTP id z4so5593577pfn.12
        for <netdev@vger.kernel.org>; Thu, 14 Nov 2019 18:41:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=HYmOQANnCkSlFcDihAh5eb6bIR/vh6vlincHQyiM8Qg=;
        b=YWHMrD41EmZKoZkdzSvRVU+bl9dLUW2DLnRRxbTRtF0feLvU1Tz90CT4qo0uynCvNO
         fzNQ28SYD/Ej4oeJHET3Q2NVISOj28EZCJ64jawxacxMNKcSkxXIp8YHbOBVsatrA2y/
         L6AuN8vbR0yZ4FMsZ4ytnII7OLqr2Uq8tgYfHhs2uCGYPGykG8FtXcLRcwcq+jl2MIYC
         mYqXSZD361ABu8s1Dm8mVbA5JsRlBtHQXyfM9v/dW+MzJQmVzJmrb7xzJ1WiyvkzRDUH
         w4WVwjXGBqN8Q4o/zRIYSCw0NzCBECiF8PTcqoV1f8zsifPejuSToyN9WWJvKlo9MsF4
         1s9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=HYmOQANnCkSlFcDihAh5eb6bIR/vh6vlincHQyiM8Qg=;
        b=hSBbOyN6/i3fGuQveTqcWz5S3XThzf68qbkwYQUFsD7GkBjDdE1tSb2gUed+IVU51a
         KSxAJ9Xn39IkYE+B7sfD3s0DmNZaylKcQUzeWPUta7rtmw2jiFOc8sCbuGnWFm5K6dsi
         b+EbGU/sbXk+ZeyJ3/VDFZXujRox6a60wpX1DG2W73nZsWQr18h45vOXs+SKQwlUM0H+
         YfHZ4Y+o7xq+9TmP9NHxL+vWg4ALf5BWlphBiBlQa6NsRZtG1BH6tpsihgL4zqes7KJ7
         zC5WGdJCeeWornZr+d7vZnjJtlJ4PYA/bkjP5iD/q9pHbkxXt7/+SOk05z1dGyRSQPrj
         BJXA==
X-Gm-Message-State: APjAAAVCYJwrSrMVePKcxJPKHe9Ml1gAGvPyF/jo2ZVLf4s6c5vWenQN
        pvNT+VYqIetNDs4jqtLjpu4e+NalowurWQ==
X-Google-Smtp-Source: APXvYqz9AFJ5xRgtU/8yy5wLnJKI3mvq2kAxPSiwNC8iilKW/iZCsqlju7qenzoyNpXQ2D9AAEYi0g==
X-Received: by 2002:a63:1703:: with SMTP id x3mr2607092pgl.263.1573785676727;
        Thu, 14 Nov 2019 18:41:16 -0800 (PST)
Received: from dhcp-12-139.nay.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id r184sm10403867pfc.106.2019.11.14.18.41.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Nov 2019 18:41:16 -0800 (PST)
Date:   Fri, 15 Nov 2019 10:41:06 +0800
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     netdev@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jiri Benc <jbenc@redhat.com>
Subject: Re: [PATCH net] tcp: switch snprintf to scnprintf
Message-ID: <20191115024106.GB18865@dhcp-12-139.nay.redhat.com>
References: <20191114102831.23753-1-liuhangbin@gmail.com>
 <557b2545-3b3c-63a9-580c-270a0a103b2e@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <557b2545-3b3c-63a9-580c-270a0a103b2e@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Eric,
On Thu, Nov 14, 2019 at 06:28:35AM -0800, Eric Dumazet wrote:
> 
> 
> On 11/14/19 2:28 AM, Hangbin Liu wrote:
> > snprintf returns the number of chars that would be written, not number
> > of chars that were actually written. As such, 'offs' may get larger than
> > 'tbl.maxlen', causing the 'tbl.maxlen - offs' being < 0, and since the
> > parameter is size_t, it would overflow.
> > 
> > Currently, the buffer is still enough, but for future design, use scnprintf
> > would be safer.
> >
> 
> Why is it targeting net tree ?

I though this is a small fixup. Maybe my though is not rigor enough. I don't
have much intend to net or net-next.
> 
> How have you checked that it was actually safer ?

No, this patch just from code review. I only did a test in user space
that snprintf could cause overflow. But I found some similar fixes
in kernel.

63350bdb3845 staging: vhciq_core: replace snprintf with scnprintf
37e444c8296c usb: Replace snprintf with scnprintf in gether_get_ifname
bd17cc5a20ae test_firmware: Use correct snprintf() limit
e7f7b6f38a44 scsi: lpfc: change snprintf to scnprintf for possible overflow

> 
> This looks unnecessary code churn to me, and it might hide an error in the future.

Not sure if I understand correctly, do you mean we may rely scnprintf
to much, and not set size correctly and got truncated message?
> 
> We need to properly size the output buffers before using them,
> we can not afford truncating silently the output.
> 

Yes, I agree. Just as I said, the buffer is still enough, while scnprintf
is just a safer usage compired with snprintf.

Thanks
Hangbin
