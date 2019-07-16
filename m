Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3C8B96ACF3
	for <lists+netdev@lfdr.de>; Tue, 16 Jul 2019 18:42:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387782AbfGPQl1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Jul 2019 12:41:27 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:38460 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726722AbfGPQl0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Jul 2019 12:41:26 -0400
Received: by mail-pg1-f196.google.com with SMTP id f5so881772pgu.5;
        Tue, 16 Jul 2019 09:41:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=k81iFqdeZm4Oz+WY2E6pPuUPc3zBMN3KKPiuWR1MJ9o=;
        b=sBB66Ifd/s/2oRZNno9OSfzuYtZ93G/xGkhk5u459QHCjAw/R8KwjNuqYCEZ6QfWMb
         zyp78upwG+HzDrOrHACtGhECAgd3gIqdZUxUukC4buAMArOAyYvqiHoloKlzm3/8urwH
         6Qu06cNmrnSc/fGxhvmVNj7pDLn2J7/2oEkhwMtwzYW+s4FTALWVtaJNkUEEMDZGPjl2
         +89GcfrS96OHd+dwpjhKIOjN1upK+TEfaxi8GXZZt83G2AgcTxCVXZCEas/WNnUKat9T
         PoSJzmye5lOrLiKxjAWKpEnrQesVl2xlFU5VKvarjLyAQOJMkSgxIvoIcerBTiBxUNW6
         pBKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=k81iFqdeZm4Oz+WY2E6pPuUPc3zBMN3KKPiuWR1MJ9o=;
        b=WyTkQAFtnYKv2fGTFYc73eXPc7gM819YHbuU0WDZG8DvII7k83P5lcI93h3V53ypNp
         C4a7JYUpxhT6YYdsMdGkwFrLx8j2Xd2CFDYiI8hrXFsQlIdpc/uRUTNYf+STYqYpyIXm
         iFEAzr0bhDek3ZHdOGh5HtP78MBXWRvRTWzk0Zg84W5OEnlsu4cqrvR0tgUwEtY+7hU5
         X2yeOA0MR4DQgGncNdjsUuQcGBLPDziM5eoJSm6zgbeziWSXOygrjGf1JZ2u/8HN7/zj
         IxM0YZX3a+aGLJXnZaFwRlsxsnMHtHIqbNhvsnWiRn2U8tqhH5xh4SYD14m3/FyMh2ox
         KK+g==
X-Gm-Message-State: APjAAAX6rwfMM0dV7oDECbJq3XH2xIZi8ycVDqWNR1uP1aKys/2753J/
        OG+sBkhVogEfVUKDuDcwirs=
X-Google-Smtp-Source: APXvYqzg2QyqXbFeIfcwR4DcuzKJ0QZaYuFyr9wBW3SrTs9ty3dpPFm5UU0hLqb3Mt3X8TzoJa1SaA==
X-Received: by 2002:a63:7b4d:: with SMTP id k13mr34417480pgn.182.1563295286068;
        Tue, 16 Jul 2019 09:41:26 -0700 (PDT)
Received: from localhost (c-73-222-71-142.hsd1.ca.comcast.net. [73.222.71.142])
        by smtp.gmail.com with ESMTPSA id b190sm7312039pga.37.2019.07.16.09.41.24
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 16 Jul 2019 09:41:25 -0700 (PDT)
Date:   Tue, 16 Jul 2019 09:41:23 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     Felipe Balbi <felipe.balbi@linux.intel.com>
Cc:     netdev@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H . Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org,
        "Christopher S . Hall" <christopher.s.hall@intel.com>
Subject: Re: [RFC PATCH 0/5] PTP: add support for Intel's TGPIO controller
Message-ID: <20190716164123.GB2125@localhost>
References: <20190716072038.8408-1-felipe.balbi@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190716072038.8408-1-felipe.balbi@linux.intel.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 16, 2019 at 10:20:33AM +0300, Felipe Balbi wrote:
> TGPIO is a new IP which allows for time synchronization between systems
> without any other means of synchronization such as PTP or NTP. The
> driver is implemented as part of the PTP framework since its features
> covered most of what this controller can do.

Can you provide some background on this new HW?  Is the interface
copper wires between chips?  Or is it perhaps coax between hosts?

Thanks,
Richard
