Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A3090D1E86
	for <lists+netdev@lfdr.de>; Thu, 10 Oct 2019 04:37:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732657AbfJJChk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Oct 2019 22:37:40 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:46954 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726197AbfJJChk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Oct 2019 22:37:40 -0400
Received: by mail-pf1-f193.google.com with SMTP id q5so2869952pfg.13
        for <netdev@vger.kernel.org>; Wed, 09 Oct 2019 19:37:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=jDj5V52U5xTiReCaQxdwl1Wy4Pgu3XL85Wr1xg/FK3o=;
        b=oS50rc6iHGi/Vwb3FeZHHicVb/Rnb1tGHLAO3ThEFqLc6xm/Ya8Xk9MJkkKaNXAo/d
         XcAbXLI4lTYVu1k5aSkI3bOyn/pE8gT9WRrIbb0E/oZW1J5ljZCa/hBZUIp+vcxpfjXc
         ovnKLZP4Dh7WRqfKRPzWiB5Yq6a/XCrYV60AW4Si1DEdv+CBNaYlNsuR6yOfXNaU59Pq
         haceGEbLu4afSSKQua8Q8AIYW1+Wx1BIwJA0VhIR0FEHsHHMlM67ye9Ir73kjHopjCJ+
         74w/ZuY+9rcWjZv1Qz3b9LJHILZUw+RCJlMOciqrcEtr632uPqTw8uA7JIYeLfYlIsrG
         Wj7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=jDj5V52U5xTiReCaQxdwl1Wy4Pgu3XL85Wr1xg/FK3o=;
        b=PngkdxvhNJabnpufzKyzK4Rx1pNWWuRKHMt9MWtMyg6ANt3zfjF6faFIFsc6lteETZ
         KgP3dBmSG35gDKWBHFGPjLfwq+hIL+hMRGLMkSw+2eOnkZtsppwcpuUjSmydq0IvVBrZ
         Ao9+pKC42pE48fTzhG2bm7QNk6D/G/f2nY0awSZyZCknxq+gI3/Q1o7PFfiKhZj8GyEO
         mGRX5znw/NkUZKzE5rf9S9WPxFtAFBN1+PGe2ycS7pOvdHrHLQ+q9IfF757buNDPZTLb
         3UBrbtNvrLIJKNItxLZtEZowc79h40k4B84X7osrtLKtLOhxfMaiC3nff2Zsj2dU7bXQ
         TYtg==
X-Gm-Message-State: APjAAAXkBmydXCgBd8cIIWtXBsbS4z9NdOu0Vg2PqqSKsrj8gd3bVTOn
        RZfCyeuP4HFFL2uwmSkhn0te8RiS8Rs=
X-Google-Smtp-Source: APXvYqyveXVAz9bIuwZtUAHK52ARF4ljhWlYEKMPMJprXOxzfsJrBKzLyspm+V+JLqlKkdhkIJnEYg==
X-Received: by 2002:a63:f810:: with SMTP id n16mr7909486pgh.176.1570675059958;
        Wed, 09 Oct 2019 19:37:39 -0700 (PDT)
Received: from cakuba.netronome.com (c-73-202-202-92.hsd1.ca.comcast.net. [73.202.202.92])
        by smtp.gmail.com with ESMTPSA id h26sm3266773pgh.7.2019.10.09.19.37.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Oct 2019 19:37:39 -0700 (PDT)
Date:   Wed, 9 Oct 2019 19:37:26 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Randy Dunlap <rdunlap@infradead.org>
Cc:     "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Yamin Friedman <yaminf@mellanox.com>,
        Tal Gilboa <talgi@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@mellanox.com>
Subject: Re: [PATCH] DIM: fix dim.h kernel-doc and headers
Message-ID: <20191009193726.098eb771@cakuba.netronome.com>
In-Reply-To: <6f8dd95f-dc58-88b9-1d20-1a620b964d86@infradead.org>
References: <6f8dd95f-dc58-88b9-1d20-1a620b964d86@infradead.org>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 8 Oct 2019 21:03:14 -0700, Randy Dunlap wrote:
> From: Randy Dunlap <rdunlap@infradead.org>
> 
> Lots of fixes to kernel-doc in structs, enums, and functions.
> Also add header files that are being used but not yet #included.
> 
> Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
> Cc: Yamin Friedman <yaminf@mellanox.com>
> Cc: Tal Gilboa <talgi@mellanox.com>
> Cc: Saeed Mahameed <saeedm@mellanox.com>
> Cc: Doug Ledford <dledford@redhat.com>
> Cc: Jason Gunthorpe <jgg@mellanox.com>
> Cc: linux-rdma@vger.kernel.org
> Cc: netdev@vger.kernel.org

I capitalized some of the descriptions looks like this file prefers that.

Otherwise seems reasonable, applied to net-next, thank you!
