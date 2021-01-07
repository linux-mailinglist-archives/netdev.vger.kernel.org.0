Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F2BF2EE7B3
	for <lists+netdev@lfdr.de>; Thu,  7 Jan 2021 22:39:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727897AbhAGViZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jan 2021 16:38:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727858AbhAGViX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Jan 2021 16:38:23 -0500
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75A91C0612F4
        for <netdev@vger.kernel.org>; Thu,  7 Jan 2021 13:37:43 -0800 (PST)
Received: by mail-ed1-x52f.google.com with SMTP id p22so9096696edu.11
        for <netdev@vger.kernel.org>; Thu, 07 Jan 2021 13:37:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=L2TJkmktnxiGdUN2mxXGmatDDtiJRacj1YtOYPqc9IA=;
        b=hJMcWdYMdiQaxH4y25Hwn5jz5c7T1mRiNfb+y9n2yAMWSZBmpX0GuQIRRjTcWUhJLd
         S9oPZELOEJb/G1eDcRqD7MHjTKWHq0+a7w3++zlgrsH4nh5MgCmsrcBzqxPPhXNq6Iuj
         lu8JRUeQgbdcfIdLigE8ahoJakaL0elqsbhSSaiDQSIOKuueGEKOI39W0u8N+GigLHGS
         C8H0ON/h9kCUf0F6xMdxlECu1Y4zo1DHpb0UFb0Cy7iqzee89zPUsPKIXl56E4mTGNC7
         4RNSzwxHp0degv2sPEesJ6i8YeUp5srRqYKhaD6djArgZ45bif5nUOi0AFLOl62n9Eys
         lgyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=L2TJkmktnxiGdUN2mxXGmatDDtiJRacj1YtOYPqc9IA=;
        b=cctHbDlWQ30DuB18f1edl0ITDRLgBDbfP2WPcm+6xv9I+6hYna7M/i8fBh1q0G/owX
         os4OzmznJfQB91ZQ4ZPHTU7h0xvKC3j755GLaXMMejoKn6y8fQ8JiQjVAg4ZrVtb4KBh
         Z5cCYu9kotcfd+oEfwmD0WfutImYZaBIHSzm1QKXYB4wr/zroGIR6Yb1sBaGaVBMAm/m
         xhp6SS2ADQbXuZtCw/LM6o4qO/j5T02P49vW+cH2P+ljHEkCw+4oWfWrJtlPRGSiFTO8
         XPnykMhHQS1oStlyD4Je6kx7w4IpCtkQpS2l0s9pYCNWZph4/B+44lqAzJZkYRCX52TE
         N8SQ==
X-Gm-Message-State: AOAM531FS8JB+MMPBzFfh9qXz5jIxZq6YPZyU/Mj3vojYex/MMIeRYhn
        IzVGYv4HgD/7FGI4wHg21Gc=
X-Google-Smtp-Source: ABdhPJy+tJe6jMH89tDYGWK6Y64wvh4plwGZyEbRDLF3H6uEIUdN8AXTGMbH/VdeB8BqH5UYFuMIVg==
X-Received: by 2002:a50:8387:: with SMTP id 7mr2937683edi.131.1610055462249;
        Thu, 07 Jan 2021 13:37:42 -0800 (PST)
Received: from skbuf (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id n16sm3065826edq.62.2021.01.07.13.37.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Jan 2021 13:37:41 -0800 (PST)
From:   Ioana Ciornei <ciorneiioana@gmail.com>
X-Google-Original-From: Ioana Ciornei <ciornei.ioana@gmail.com>
Date:   Thu, 7 Jan 2021 23:37:40 +0200
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Ioana Ciornei <ciorneiioana@gmail.com>, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org, laurentiu.tudor@nxp.com,
        Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: Re: [PATCH 6/6] dpaa2-mac: remove a comment regarding pause settings
Message-ID: <20210107213740.ze22xyqsplkogasq@skbuf>
References: <20210107153638.753942-1-ciorneiioana@gmail.com>
 <20210107153638.753942-7-ciorneiioana@gmail.com>
 <X/d8hEpW4dHWUDem@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <X/d8hEpW4dHWUDem@lunn.ch>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 07, 2021 at 10:26:28PM +0100, Andrew Lunn wrote:
> On Thu, Jan 07, 2021 at 05:36:38PM +0200, Ioana Ciornei wrote:
> > From: Ioana Ciornei <ioana.ciornei@nxp.com>
> > 
> > The pause settings are not actually lossy since the MC firmware was does
> > is
> 
> was does is?
> 

It was supposed to be 'what does is'...

Even so, I'll reword it.
