Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F494220DF5
	for <lists+netdev@lfdr.de>; Wed, 15 Jul 2020 15:20:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731765AbgGONUc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jul 2020 09:20:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731457AbgGONUb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jul 2020 09:20:31 -0400
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A8D5C061755
        for <netdev@vger.kernel.org>; Wed, 15 Jul 2020 06:20:31 -0700 (PDT)
Received: by mail-pf1-x443.google.com with SMTP id 1so2082788pfn.9
        for <netdev@vger.kernel.org>; Wed, 15 Jul 2020 06:20:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=AEj+2PMvPQdYUCRcY/OgS/decXq8fZ27/dq14ngPR+8=;
        b=o1rBG16zvrlOA+i9kAO48FuZ36By75AGThvjxtRP9DE/sVWA6Cgmb2apiXbKv6ioGv
         s+mLeuL/uArZPDqojjJ5Fkx1LYspIZgNNKUYuTHG+lXqkkDno2pmtztKPmfiUTuPL79w
         fXi4s3pSUSavS8Rmh6pyKO954AFRLO7cj5NCcPs2XpwPSWma1N+gnv5lxyCofNlbPnUw
         VCE8uojzqvowz9Iw1OyLRPg4b1oICGqvjwsXgx5qHhMlbsX/PY+Mqxk0uv8Jq9pgxyvD
         WvPHWLQ5CnRUYZUr0ZgxbiKjHoI6oVDCmZuhuEngNNUgVlAX9J/Mx/QK6hsk2U4WONQ5
         Ejlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=AEj+2PMvPQdYUCRcY/OgS/decXq8fZ27/dq14ngPR+8=;
        b=aCAzc43/Uisvn6hqUzTQgCshSUqL2mAtP+lekDi35XPPu1VlFMGhNMY+2/IzMfAEJK
         CI8J9PC4efMjQTamvHWa+Ue2OVLJB8gywxnac7oGWhCMKh3MRbQiTVJiIe5e2UX4vWhJ
         silE57wv3IwRCpcV8NL7lx9vDync/vr7c7s/91kzVo73HKGZosnQaD3g+xC4cbgYzTKh
         XBvJTJJMeRMCxRnW8PpWaMagyKgO9xy9B43tJAdfXC6r/DFsh4MvSs70oyEiwwTiY0Ep
         6n7AA0Fu6+j7x+QiW55RQrkGen0PYX2E8Lr3HIYmKLEpicrfVmQnOtp/sIrxb78Zhsdy
         E7BQ==
X-Gm-Message-State: AOAM531gEulP/RvhQI5jgNIi4/kb8LtjR6RLDCqt8yy+22LUfrgSY/iz
        hNaSZUSlZzLMBYnsHT+BM4Q=
X-Google-Smtp-Source: ABdhPJySNtzuuVi4hy0KeXQWkl1gWde39riUe4EsuXUYlTUMBsylhsoCu7n+gx29WQ1DMPrp20RYiA==
X-Received: by 2002:a62:788d:: with SMTP id t135mr8274147pfc.315.1594819231152;
        Wed, 15 Jul 2020 06:20:31 -0700 (PDT)
Received: from hoboy (c-73-241-114-122.hsd1.ca.comcast.net. [73.241.114.122])
        by smtp.gmail.com with ESMTPSA id n2sm2246533pgv.37.2020.07.15.06.20.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Jul 2020 06:20:30 -0700 (PDT)
Date:   Wed, 15 Jul 2020 06:20:28 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     Subbaraya Sundeep <sbhatta@marvell.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        sgoutham@marvell.com
Subject: Re: [PATCH v4 net-next 0/3] Add PTP support for Octeontx2
Message-ID: <20200715132028.GA27070@hoboy>
References: <1594816689-5935-1-git-send-email-sbhatta@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1594816689-5935-1-git-send-email-sbhatta@marvell.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 15, 2020 at 06:08:06PM +0530, Subbaraya Sundeep wrote:
> Hi,
> 
> This patchset adds PTP support for Octeontx2 platform.
> PTP is an independent coprocessor block from which
> CGX block fetches timestamp and prepends it to the
> packet before sending to NIX block. Patches are as
> follows:
> 
> Patch 1: Patch to enable/disable packet timstamping
> 	 in CGX upon mailbox request. It also adjusts
> 	 packet parser (NPC) for the 8 bytes timestamp
> 	 appearing before the packet.
> 
> Patch 2: Patch adding PTP pci driver which configures
> 	 the PTP block and hooks up to RVU AF driver.
> 	 It also exposes a mailbox call to adjust PTP
> 	 hardware clock.
> 
> Patch 3: Patch adding PTP clock driver for PF netdev.
> 
> 
> Aleksey Makarov (2):
>   octeontx2-af: Add support for Marvell PTP coprocessor
>   octeontx2-pf: Add support for PTP clock
> 
> Zyta Szpak (1):
>   octeontx2-af: Support to enable/disable HW timestamping

Acked-by: Richard Cochran <richardcochran@gmail.com>
