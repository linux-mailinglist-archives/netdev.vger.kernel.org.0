Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DCF4444696
	for <lists+netdev@lfdr.de>; Thu, 13 Jun 2019 18:53:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389389AbfFMQwt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Jun 2019 12:52:49 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:40623 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730103AbfFMDHd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Jun 2019 23:07:33 -0400
Received: by mail-pf1-f195.google.com with SMTP id p184so7553187pfp.7
        for <netdev@vger.kernel.org>; Wed, 12 Jun 2019 20:07:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=7ubb/3xIFo4hdvzIstCkG1DXHANL+nvtWX801y7iEAo=;
        b=kfjSRwn2PnGQxNeVTk/GGeOk9WJLQ91uz9hcEEsgD4w4LpWb1E59aPS6XDENBN6vSu
         CzM7w5nwifPBibL9nRtGqFzIwp0c7jXSEtjG4aHnxqP93uI9+4hpjK76bLWHnKvfiHxd
         FBCyHM5biFuNqv423gvlzuhc04KcWWoh/3+dhMThP2w7BTQthtJTJVVppATZQRfIwj8K
         WgLWo5P2LMs+kzqp7j8VrLk8dHH5JD9019GhUNiMBBaCLOgDt/99KfTNJP5IELlSlvsU
         eotiVjJWsBljGESFmKrUZc7sGt7ny8+jbh2T1ykq9+PrbEXlx5ecaLSLimfER/fFWVoV
         bO/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=7ubb/3xIFo4hdvzIstCkG1DXHANL+nvtWX801y7iEAo=;
        b=jvOkzumTmi3JFq3+Z62Rok46/BRfXsg2LLVFozPMGF2ST50jubsqizEH1enUi2LfL5
         E3GfYgugEM2qPI+Zs/Z7F5GcJWAJ9tseyuBBo3wPQxWeHk+7ikLWY6NxdK2kBwvEiDSW
         3eyrr0uaRuNaiUhuQPNhU3AEBvRPSbXFFS+BLCNWFKY+CW0J8KvWVmscL7B7OfDoZU5A
         gMkIMW+fJmTpNibU1gM+Zc+YAsrRgBghlpA71vHVaJg3SvznkSzEiGJ+AeJD/yYdGcNa
         r8ysFVTK65hWtzSI/s3pcaP3nJH8ppNf6uXDvng2dOYvuka7lYCmYtIQqOI7ubs/Smtn
         DZbA==
X-Gm-Message-State: APjAAAXASMBcWMDbHly4l0bFDhzHeTkC6w6YeVCJEGaSwOXO1bVXhd+1
        FXG3ENvvr1XxrX1F42AHHb4=
X-Google-Smtp-Source: APXvYqzpX5w6030JhtNuOEsizY8oAdFqVfGQNes99scd4ZJPV7/v32SvU7AdY49C/XmCpo/YVRR37g==
X-Received: by 2002:a63:dd53:: with SMTP id g19mr18432483pgj.3.1560395252453;
        Wed, 12 Jun 2019 20:07:32 -0700 (PDT)
Received: from dhcp-12-139.nay.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id f21sm724315pjq.2.2019.06.12.20.07.30
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Wed, 12 Jun 2019 20:07:31 -0700 (PDT)
Date:   Thu, 13 Jun 2019 11:07:22 +0800
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     Roman Mashak <mrv@mojatatu.com>
Cc:     netdev@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Phil Sutter <phil@nwl.cc>
Subject: Re: [iproute2 net-next PATCH] ip: add a new parameter -Numeric
Message-ID: <20190613030722.GD18865@dhcp-12-139.nay.redhat.com>
References: <20190612092115.30043-1-liuhangbin@gmail.com>
 <85imtaiyi7.fsf@mojatatu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <85imtaiyi7.fsf@mojatatu.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Roman,
On Wed, Jun 12, 2019 at 12:01:20PM -0400, Roman Mashak wrote:
> Hangbin Liu <liuhangbin@gmail.com> writes:
> 
> > Add a new parameter '-Numeric' to show the number of protocol, scope,
> > dsfield, etc directly instead of converting it to human readable name.
> > Do the same on tc and ss.
> >
> > This patch is based on David Ahern's previous patch.
> >
> 
> [...]
> 
> It would be good idea to specify the numerical format, e.g. hex or dec,
> very often hex is more conveninet representation (for example, when
> skbmark is encoded of IP address or such).

Some functions use hex and some functions use integer. It's looks hard to
unit all functions.

I tried to make all the functions use itself printf to keep the compatibility.
Only changed function nl_proto_n2a as it was only called by ss, and we
removed function nl_proto_n2a.

Thanks
Hangbin
> 
> Could you think of extending it '-Numeric' to have an optional argument
> hex, and use decimal as default.
