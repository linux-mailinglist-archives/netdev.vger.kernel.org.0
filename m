Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 108EA11BBFC
	for <lists+netdev@lfdr.de>; Wed, 11 Dec 2019 19:41:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729945AbfLKSlg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Dec 2019 13:41:36 -0500
Received: from mail-qv1-f67.google.com ([209.85.219.67]:44283 "EHLO
        mail-qv1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729809AbfLKSlg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Dec 2019 13:41:36 -0500
Received: by mail-qv1-f67.google.com with SMTP id n8so6162143qvg.11
        for <netdev@vger.kernel.org>; Wed, 11 Dec 2019 10:41:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:message-id:from:to:cc:subject:in-reply-to:references
         :mime-version:content-disposition:content-transfer-encoding;
        bh=QUS5BKSH61f4lKv1hrX3EZ1prXDNxY1nxacn7O67xGg=;
        b=KAxl3K1I5FzMh3XKViZcFfB9EeCf3AgNLlq9zOTdVMCwrHjKa7EWCjZJ+bBwcajfMA
         UIWclJQTkfpLMoXQjHaXmUIA51uhLaq4auOr/EDiJfvYUainah0ecJuFQ0t1S4UiKEDD
         n897e8jEBLwH2TvQcyyLL0fYeEYDI42XMcHJ3IDhsXrDiTFRf8g9LxE/i2Ffqgo9Lz30
         93gZJOPNJHOw01l40eSFt9OZVjLyAQmTZp1p23R4EVVvPkS7uJeNPlvoFly1SsRTv7sl
         CvhlaFCUXI7k5+6R4FeNWHIiGuye+9q0cx02WnxFAKmdQZG+BuMmsMxysutPykgIhTem
         BrbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:from:to:cc:subject:in-reply-to
         :references:mime-version:content-disposition
         :content-transfer-encoding;
        bh=QUS5BKSH61f4lKv1hrX3EZ1prXDNxY1nxacn7O67xGg=;
        b=pT+JRJIxR53WW6nGNZUZgNGk9YIutgEzIgUI22FmwuJYNWkxyxOlMHX96D2gxwWDMB
         YkXiXHkjpglXGE7pADeRXtp/BrEV2FTIUqb9o4CpVKC2mWTPFxBBZ1Asu7+gyvA6+Vzk
         jQLt7WahgJp4mTvN503h8IR8i2vWzmYtX51or5fIJMgr5EAnxNJB2yqZd/VSI/ft2/dc
         asIoF+izNAqVi2yFUF9zcMWh0617AcnSw0/Yx0WfgZNoO8Do5JqMiLJERqWGFKIAz6AN
         O+PpTlD1hxa93z5ZSsuPJse9AU6+5ZDTtesTww/sTJzLVdPneNv0c9VOvMUnVd0jYbpE
         BIWQ==
X-Gm-Message-State: APjAAAXc/7KdGUQd3UgHUz7ypgtCqx6m3rKyeRpmi+rIBKITqd4ggaRP
        SHmWplIClP6pTbBYf7c/KKOV6/p8lyc=
X-Google-Smtp-Source: APXvYqybAGoY76aTj5RQJd3vFH0dJvslULeQwYPRVEcNhEQaULWGWCYIBBUBNOdTHVLS66c/GN67Qg==
X-Received: by 2002:a0c:a145:: with SMTP id d63mr4608615qva.120.1576089695195;
        Wed, 11 Dec 2019 10:41:35 -0800 (PST)
Received: from localhost (modemcable249.105-163-184.mc.videotron.ca. [184.163.105.249])
        by smtp.gmail.com with ESMTPSA id o33sm1196818qta.27.2019.12.11.10.41.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Dec 2019 10:41:34 -0800 (PST)
Date:   Wed, 11 Dec 2019 13:41:33 -0500
Message-ID: <20191211134133.GB1587652@t480s.localdomain>
From:   Vivien Didelot <vivien.didelot@gmail.com>
To:     Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Cc:     David Ahern <dsahern@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Roopa Prabhu <roopa@cumulusnetworks.com>,
        netdev@vger.kernel.org, bridge@lists.linux-foundation.org,
        Stephen Hemminger <stephen@networkplumber.org>
Subject: Re: [PATCH net-next v2] net: bridge: add STP xstats
In-Reply-To: <9f978ee1-08ee-aa57-6e3d-9b68657eeb14@cumulusnetworks.com>
References: <20191210212050.1470909-1-vivien.didelot@gmail.com>
 <0e45fd22-c31b-a9c2-bf87-22c16a60aeb4@gmail.com>
 <9f978ee1-08ee-aa57-6e3d-9b68657eeb14@cumulusnetworks.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi David, Nikolay,

On Wed, 11 Dec 2019 17:42:33 +0200, Nikolay Aleksandrov <nikolay@cumulusnetworks.com> wrote:
> >>  /* Bridge multicast database attributes
> >>   * [MDBA_MDB] = {
> >>   *     [MDBA_MDB_ENTRY] = {
> >> @@ -261,6 +270,7 @@ enum {
> >>  	BRIDGE_XSTATS_UNSPEC,
> >>  	BRIDGE_XSTATS_VLAN,
> >>  	BRIDGE_XSTATS_MCAST,
> >> +	BRIDGE_XSTATS_STP,
> >>  	BRIDGE_XSTATS_PAD,
> >>  	__BRIDGE_XSTATS_MAX
> >>  };
> > 
> > Shouldn't the new entry be appended to the end - after BRIDGE_XSTATS_PAD
> > 
> 
> Oh yes, good catch. That has to be fixed, too.
> 

This I don't get. Why new attributes must come between BRIDGE_XSTATS_PAD
and __BRIDGE_XSTATS_MAX?


Thanks,

	Vivien
