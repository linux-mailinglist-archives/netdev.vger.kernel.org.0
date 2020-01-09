Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CFA581361E0
	for <lists+netdev@lfdr.de>; Thu,  9 Jan 2020 21:36:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730034AbgAIUgs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jan 2020 15:36:48 -0500
Received: from mail-pf1-f196.google.com ([209.85.210.196]:42053 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729028AbgAIUgr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jan 2020 15:36:47 -0500
Received: by mail-pf1-f196.google.com with SMTP id 4so3903022pfz.9
        for <netdev@vger.kernel.org>; Thu, 09 Jan 2020 12:36:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=m/WmdaRUqp6N/K4Xz/YT8088+wZpLnybiT5kS+iIRpI=;
        b=HQRliT4dvgovJjDWgJKwj5H+gSg0p2MdSSCfxE0y4hthcbnDlcVDMWTTrQtWiolPgu
         EEK7FCHVqovb3xLpWHrJL8VRkaNurxYKV+YjYeaH3eVZFAph+QBh7GSDEVy7eLxoqgr+
         AWE1B6pevFOuXM54NzaFw8vMOdc0MsHmZ4ot49Nog9DSb8ncKqBU0imhipv0BI9yHHfS
         suWNE1wknBybFicBjymCqHYdWP4D6L6uaLnXHPTTOopgjxkvniIZhaBACFtENXqfcnbw
         QpQuSY9xL4buxG0ubMnMUA0NwuAnB0BVlLLr7u6B+OPMCnm0gtfCfjxOKSNyup3NJvcL
         IDgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=m/WmdaRUqp6N/K4Xz/YT8088+wZpLnybiT5kS+iIRpI=;
        b=G3gE5nkNJmO89rhPaySB7/NdBV3Zz6KhLG/5g4WLPU5kBf1Z0TE0ndBkPozMNn5Njh
         pXD09pCNe418WsbAM5kbVzKEqROXY0YTvtRT6ECXjz3WLG4JTvcqdeJAh6dUepymfYaN
         CQ4WbEmBQPrlbHgpgxXg78UGER7CsTFv6DSKBYek5wmgbChpt8zPNmUYCMrS6A+2gR7N
         oU2m4PAOlFCSgAG2oEmcjsHuV+JhbEDNp8w2dOGSnxpfADzgwF0xG93VEBZKqYV0DiF8
         mXgT5YLgCdn42PDRRt5+TcfpwhSEeUpL2R6045JauTFNfpN9kConc6GYSF4KjUFQ41pc
         bhwQ==
X-Gm-Message-State: APjAAAVGDEOQfGJTUZ+1HTZ680EMGeMwKHBYXX8ID8X21zZ+O+o0CfN8
        LM0RtqhwI0NYauZ6sQguFnjP/SniKSw=
X-Google-Smtp-Source: APXvYqzfQf8qGVvn5nxdN5JW8N3DPxHAHAtAcY0qAnX04xt1fTj8W6Ima/Pl1qbnyUkCyX+2LdEWuw==
X-Received: by 2002:a63:1e23:: with SMTP id e35mr13739258pge.219.1578602206903;
        Thu, 09 Jan 2020 12:36:46 -0800 (PST)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id i4sm8689875pgc.51.2020.01.09.12.36.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Jan 2020 12:36:46 -0800 (PST)
Date:   Thu, 9 Jan 2020 12:36:38 -0800
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Jacob Keller <jacob.e.keller@intel.com>
Cc:     netdev@vger.kernel.org, valex@mellanox.com, jiri@resnulli.us
Subject: Re: [PATCH 2/2] doc: fix typo of snapshot in documentation
Message-ID: <20200109123638.6dc0a155@hermes.lan>
In-Reply-To: <f1b34465-0bdc-e108-c887-5d04ec64e861@intel.com>
References: <20200109190821.1335579-1-jacob.e.keller@intel.com>
        <20200109190821.1335579-2-jacob.e.keller@intel.com>
        <20200109120021.66a46535@hermes.lan>
        <84ba1b73-aa0c-cce6-5284-6d4badb9bed4@intel.com>
        <f1b34465-0bdc-e108-c887-5d04ec64e861@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 9 Jan 2020 12:11:36 -0800
Jacob Keller <jacob.e.keller@intel.com> wrote:

> On 1/9/2020 12:06 PM, Jacob Keller wrote:
> > On 1/9/2020 12:00 PM, Stephen Hemminger wrote:  
> >> On Thu,  9 Jan 2020 11:08:21 -0800
> >> Jacob Keller <jacob.e.keller@intel.com> wrote:
> >>  
> >>> A couple of locations accidentally misspelled snapshot as shapshot.
> >>>
> >>> Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
> >>> ---
> >>>  Documentation/admin-guide/devices.txt    | 2 +-
> >>>  Documentation/media/v4l-drivers/meye.rst | 2 +-
> >>>  2 files changed, 2 insertions(+), 2 deletions(-)
> >>>
> >>> diff --git a/Documentation/admin-guide/devices.txt b/Documentation/admin-guide/devices.txt
> >>> index 1c5d2281efc9..2a97aaec8b12 100644
> >>> --- a/Documentation/admin-guide/devices.txt
> >>> +++ b/Documentation/admin-guide/devices.txt
> >>> @@ -319,7 +319,7 @@
> >>>  		182 = /dev/perfctr	Performance-monitoring counters
> >>>  		183 = /dev/hwrng	Generic random number generator
> >>>  		184 = /dev/cpu/microcode CPU microcode update interface
> >>> -		186 = /dev/atomicps	Atomic shapshot of process state data
> >>> +		186 = /dev/atomicps	Atomic snapshot of process state data
> >>>  		187 = /dev/irnet	IrNET device  
> >>
> >> Oops, irnet is part of irda which is no longer part of the kernel.
> >>  
> > 
> > This is probably based on the wrong tree. Will rebase and re-send.
> > 
> > Thanks,  
> > Jake>  
> 
> Well, I did rebase the patches locally but the contents are still the
> same so I'm not going to resend. I guess it's just because the
> devices.txt file hasn't been updated?
> 
> -Jake

Yes, it looks like references to irnet were never deleted.
