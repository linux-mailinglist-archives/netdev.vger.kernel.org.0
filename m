Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7684F2C2CBE
	for <lists+netdev@lfdr.de>; Tue, 24 Nov 2020 17:24:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390393AbgKXQW5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Nov 2020 11:22:57 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:42001 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390160AbgKXQW4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Nov 2020 11:22:56 -0500
Received: by mail-wr1-f65.google.com with SMTP id l1so22894871wrb.9;
        Tue, 24 Nov 2020 08:22:56 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=beptYMt7+eafD2ZEQSEovk9FzgjHfPs3g/lAfS8j9uM=;
        b=t/FNO/fvyKb5Pp9X5qeI/wK96CCsRhoEuWSjU5FNQGJeDNh/RIqckAR8R/30U8d/9i
         yY9l2zZhHfFVoqoms9HhW9BuxDgUeIBpvBVKsZ6nSrhiPoFpfeRearN7xTY9d8dIOjnU
         oGRXBBGh78QxEwAxziJFBHEiMTW4sbeOkwp9Pg6ADyu/bmifX1pWOCBAgaXGHWYP+kH5
         DAStr7Bac8O09h6tTVsL7C2Iyof8tjnrPp/fEqO4fW1L4fXdxsOyByzjeiuFR6PEHyKa
         GnFsnmeKpDwX4svHNbT76UIieBOvKOBNVr9uQMP9UH+nA4vWBrlV2gutUYX0sSq8JGgW
         cp8Q==
X-Gm-Message-State: AOAM533qVYbmYaxRPFvrGkzPxjg60SYW2T6G7pPLtwMc3nzuLTubemDO
        FgHYm5BgyOzaCwBBqG6ilDk=
X-Google-Smtp-Source: ABdhPJzNWJISAR6jpBemgnrfO4WfQurOZMlhDm6aMhArKWRtwu3b2mmXuZb+ypGKjS10uTSkrzVDfA==
X-Received: by 2002:adf:f441:: with SMTP id f1mr6141880wrp.225.1606234975722;
        Tue, 24 Nov 2020 08:22:55 -0800 (PST)
Received: from liuwe-devbox-debian-v2 ([51.145.34.42])
        by smtp.gmail.com with ESMTPSA id x9sm20773316wrt.70.2020.11.24.08.22.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Nov 2020 08:22:55 -0800 (PST)
Date:   Tue, 24 Nov 2020 16:22:53 +0000
From:   Wei Liu <wei.liu@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     "Andrea Parri (Microsoft)" <parri.andrea@gmail.com>,
        linux-kernel@vger.kernel.org,
        "K . Y . Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>, linux-hyperv@vger.kernel.org,
        Michael Kelley <mikelley@microsoft.com>,
        Juan Vazquez <juvazq@microsoft.com>,
        Saruhan Karademir <skarade@microsoft.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: Re: [PATCH] hv_netvsc: Validate number of allocated sub-channels
Message-ID: <20201124162253.3qpfgo7rtvut4nqn@liuwe-devbox-debian-v2>
References: <20201118153310.112404-1-parri.andrea@gmail.com>
 <20201118173715.60b5a8f2@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201118173715.60b5a8f2@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
User-Agent: NeoMutt/20180716
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 18, 2020 at 05:37:15PM -0800, Jakub Kicinski wrote:
> On Wed, 18 Nov 2020 16:33:10 +0100 Andrea Parri (Microsoft) wrote:
> > Lack of validation could lead to out-of-bound reads and information
> > leaks (cf. usage of nvdev->chan_table[]).  Check that the number of
> > allocated sub-channels fits into the expected range.
> > 
> > Suggested-by: Saruhan Karademir <skarade@microsoft.com>
> > Signed-off-by: Andrea Parri (Microsoft) <parri.andrea@gmail.com>
> > Cc: "David S. Miller" <davem@davemloft.net>
> > Cc: Jakub Kicinski <kuba@kernel.org>
> > Cc: netdev@vger.kernel.org
> 
> Acked-by: Jakub Kicinski <kuba@kernel.org>

Applied to hyperv-next.
