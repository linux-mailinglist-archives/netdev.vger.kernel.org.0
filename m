Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EF480150091
	for <lists+netdev@lfdr.de>; Mon,  3 Feb 2020 03:29:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727281AbgBCC2z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Feb 2020 21:28:55 -0500
Received: from mail-pl1-f193.google.com ([209.85.214.193]:41191 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726393AbgBCC2y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Feb 2020 21:28:54 -0500
Received: by mail-pl1-f193.google.com with SMTP id t14so5216674plr.8;
        Sun, 02 Feb 2020 18:28:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=/Lnmgxusi6/x//le30pI2bUgaub9a+/+5+73CaIB9g8=;
        b=LKIyz7KmBtrW9kHsHZQPL4N+oaIvvgh5PCAqNNQEfXZWk2LxMAvF06k06ZLCbNcKth
         hrX+If4cQEyWurJA6taUdMlAf7lLJIOqxFzhh/hTh+lsh2MRZtmxTC5ZPppwwycMtWti
         2emPrTqzKGoRRM5M+enOppuYMNUd3NM/mKrreNojZ2x4TCRAi8nlb3G3SUU7xXNYHzj7
         lqq+DARBcrrG+uBQ0dE3DMUzaCqkzsl105twCF+K4vFONwZD3sEYwkfwl3o2WgaaqQRR
         kLB3HTFG8zpK6zz5jGstXjxsmtJN/tLlWvQlrNbOxkzJBTFxH1s1KfaqiKg8mBB2SVx2
         JM0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=/Lnmgxusi6/x//le30pI2bUgaub9a+/+5+73CaIB9g8=;
        b=RJAK40/5fE61oLA4KpPDPHCh0rbgBtv4eu7q/RKSS8ukJQZ0vc8YGzQK+z5FUGTcak
         jmtuzIACwdR/nkq5slBOI2i78AH74oGpB7rzrIAxll+jblxwwjoFsFxn3sPM/3CnEjRi
         RS8ue26IIV6F0W764By4ai1p0xbe0ZdHwQMlFSDUpBf5M+/iinOoluaK4vAh4ABL7wfW
         eFOCbsjBj/2IPKbR1JzzZ97u0IBIHxkU1yKAOjF3Hwq2e2pUxSuwh5TTOJtjq/5+KCZ4
         0R0VSVFq1DHTvlVV8pr35VrTRW4BeISeKBlxuQqADgFptfZXYXu7kJhpApq5GOR9JtzS
         8WBQ==
X-Gm-Message-State: APjAAAVlJSf17lcNy99BWGS6tAFImNKUSSqVBuKVBy5M68vbS1WGUuTM
        7Vh+LYBpTkX08gF7NqPeD0CnVL9w
X-Google-Smtp-Source: APXvYqzQtvAPe4LfMH07GGznsQA3M6DN5rp77O1mGKiHhnt3BosSJgodP4AkIYfEJJHxYa+HwpUgDw==
X-Received: by 2002:a17:90a:3268:: with SMTP id k95mr27003561pjb.48.1580696934072;
        Sun, 02 Feb 2020 18:28:54 -0800 (PST)
Received: from localhost (c-73-241-114-122.hsd1.ca.comcast.net. [73.241.114.122])
        by smtp.gmail.com with ESMTPSA id cx18sm17748292pjb.26.2020.02.02.18.28.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 02 Feb 2020 18:28:53 -0800 (PST)
Date:   Sun, 2 Feb 2020 18:28:50 -0800
From:   Richard Cochran <richardcochran@gmail.com>
To:     christopher.s.hall@intel.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, hpa@zytor.com, mingo@redhat.com,
        x86@kernel.org, jacob.e.keller@intel.com, davem@davemloft.net,
        sean.v.kelley@intel.com
Subject: Re: [Intel PMC TGPIO Driver 3/5] drivers/ptp: Add user-space input
 polling interface
Message-ID: <20200203022850.GC3516@localhost>
References: <20191211214852.26317-1-christopher.s.hall@intel.com>
 <20191211214852.26317-4-christopher.s.hall@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191211214852.26317-4-christopher.s.hall@intel.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 11, 2019 at 01:48:50PM -0800, christopher.s.hall@intel.com wrote:
> From: Christopher Hall <christopher.s.hall@intel.com>
> 
> The Intel PMC Time-Aware GPIO controller doesn't implement interrupts to
> notify software that an input event has occurred. To solve this problem,
> implement a user-space polling interface allowing the application to check
> for input events. The API returns an event count and time. This interface
> (EVENT_COUNT_TSTAMP2) is *reused* from the output frequency adjustment API.
> The event count delta indicates that one or more events have occurred and
> how many events may have been missed.

So I think this interface is truly horrible.  

The ptp_pin_desc describes a pin's configuration WRT the PTP_PF_xxx
and the specific EXTTS/PEROUT_REQUEST channel.  I don't know exactly
what you are trying to accomplish, but there has got to be a better
way.  Re-using the ptp_pin_desc for a polling interface is surely not
the way forward.

Thanks,
Richard
