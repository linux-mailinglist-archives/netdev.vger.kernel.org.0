Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6C32ED3614
	for <lists+netdev@lfdr.de>; Fri, 11 Oct 2019 02:34:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727556AbfJKAeG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Oct 2019 20:34:06 -0400
Received: from mail-qt1-f195.google.com ([209.85.160.195]:42862 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726096AbfJKAeG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Oct 2019 20:34:06 -0400
Received: by mail-qt1-f195.google.com with SMTP id w14so11422041qto.9
        for <netdev@vger.kernel.org>; Thu, 10 Oct 2019 17:34:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=Ir1jRSeCWH2x6xvXc8uL8ybXkWpvILfmaQVgM2wRfvA=;
        b=N/NiHW61NL9pl0vSynqNPKg+47CTftTAZJrCeaKJfjBsZQsGZbA8sq8jZPvlPRspj3
         +y9R41RMgNMVvFxYKy26KTQCe+od85PboWA8bWr0RfnsIQlkyjqx/wGvHDhEMCqamHsU
         9G7vXzxRBYHTZmgJTnxOXLA+plvbFYf/p9ieYG2s/k9OecB/ezF4A96KHhDM8hQxvtbp
         kKWhlMutOrHtnnOgwcfyPDt4hTz8osq0GKXPY+qrRPVY8Cc0t5lRHnNm0T9Axq6qYljB
         RfHHcJvZC1XMehq73B8DwGn8FKLMblhE99UM5nhqImqrx+5YVYUVEUc8Wcw8mRLGPWN7
         a1JA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=Ir1jRSeCWH2x6xvXc8uL8ybXkWpvILfmaQVgM2wRfvA=;
        b=ryngVxNzQtARWx3pxWn1m8/+KK06V+xecZYD+kEYF6wui8M4bkH4/CRgKRQ7DlSBFv
         D2Jrpx5dOtcZ8927Tq5EU6Mye1vzUgE8x7jDMxY4Ot+fYRGxXefTYrwyviNKSTy8V7JW
         UiUu//0gj96Q9ih630hKfMJhTSlli0C71OMKdUrGlkKtyRAGA4H5CodS7pWbPHi2FBct
         5G2cnU0RVn6KGhWgsodWG+esnQ6wENrChyohgrCT5kWcxIkSN5h84JhSqasSOcDUc4Sv
         zlcgdBqo+IlkhweUqeak7CGNxu9znOYRtER3+njI5K6okCVnaL+Yo9VCr5xb3+G+EG4k
         OUgw==
X-Gm-Message-State: APjAAAXaKqx+feho7loPosBd56pISdOA0XWtbSoeinPPkfLtsnrpxd8u
        w8CpOQWhV/HIVol5A9rQzyvN+w==
X-Google-Smtp-Source: APXvYqxLt8bpwBFRHaQ/ptEWq7ZJhKNvIocjzEh92WCjqtn0q+SHst81ezrPpSRnVrvXXCwdTmZgLg==
X-Received: by 2002:ac8:71d7:: with SMTP id i23mr13728484qtp.195.1570754045532;
        Thu, 10 Oct 2019 17:34:05 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id m186sm3151805qkd.119.2019.10.10.17.34.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Oct 2019 17:34:05 -0700 (PDT)
Date:   Thu, 10 Oct 2019 17:33:48 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Randy Dunlap <rdunlap@infradead.org>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        Tal Gilboa <talgi@mellanox.com>,
        David Miller <davem@davemloft.net>, linux-doc@vger.kernel.org,
        Jacob Keller <jacob.e.keller@intel.com>
Subject: Re: [PATCH] Documentation: networking: add a chapter for the DIM
 library
Message-ID: <20191010173348.1836f23f@cakuba.netronome.com>
In-Reply-To: <c3eab338-f3a9-bff3-4c24-edeb3f80b7cd@infradead.org>
References: <e9345b39-352e-cfc6-7359-9b681cb760e8@infradead.org>
        <20191010162003.4f36a820@cakuba.netronome.com>
        <4c7f5563-2ca1-d37b-7639-f3df99a0219b@infradead.org>
        <20191010165828.0540d18d@cakuba.netronome.com>
        <c3eab338-f3a9-bff3-4c24-edeb3f80b7cd@infradead.org>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 10 Oct 2019 17:01:02 -0700, Randy Dunlap wrote:
> > Will you try to convert and integrate the existing file instead, or do
> > you think the kdoc file should be separate?  
> 
> I'll take a look at doing that.

Thanks!
