Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B1A946E175
	for <lists+netdev@lfdr.de>; Thu,  9 Dec 2021 05:31:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231815AbhLIEfN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Dec 2021 23:35:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231753AbhLIEfM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Dec 2021 23:35:12 -0500
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E35FC061746
        for <netdev@vger.kernel.org>; Wed,  8 Dec 2021 20:31:40 -0800 (PST)
Received: by mail-pl1-x633.google.com with SMTP id u11so2991908plf.3
        for <netdev@vger.kernel.org>; Wed, 08 Dec 2021 20:31:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=aDBOUx9mV9wfzPgcbhrNbD98eZLutwtGL3Xc4hN44f8=;
        b=KqNfAtz6cIT28+tNwqSt3QgcHaBK8YO3RsCDyt2KGMrh5tM1sCj1d8fWcHhd8TlH2Q
         87MOfdEKKugSOPeZaqmYkgBp8RiGlVC5RSow+p4oHTFHKsOMIQh/oCqKTZeBDR8Jjgdr
         RvJBNfVfhPiFvBf2p8LjK5jpM6t31BsNfBd3d4HyZrS4pxDRjsFBkF0ywUe/g9kXZ+wa
         YxaBaVOfecSg6TnTbnlYov3JJiqoUxp4PgCbpsik/KyVf47e6OddHcmAXEXwfopeUTfT
         +IQ5dRn5ZuX0BEZZML57++ZhQnVPqqEppf1PvZIlA+LpfRqVWNw9KYzwfTMs51XowoPn
         mIZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=aDBOUx9mV9wfzPgcbhrNbD98eZLutwtGL3Xc4hN44f8=;
        b=JfOYJ588mM1hezR1nF9RpHqXjPajhFbhfq7ydEAStCBzlBM3iVvTWm/OzzjYSAffhM
         wMTLKJ5WVpHJyiwHxJmDWfEZpA0N4p1krSySKEaoqjQc7ALodnNcDmH4o0J6vKfT886+
         q7nzJsO0lfufNcaQSbit2esVCsFYTU/b9qxchlPLOmxx+JHl0Bat3yOSsPmz4k0bx39o
         1ajIDyV9NsjQsMDRa43DcJ13YjvFh1nx704VQOkFjYUT7Uk2VTNK9XGSibONoDn/OPho
         7UuozdXPFh5I5q6B8c/IwQOhEfEs9gAU0r0rorjeVnu46Xp+EGojhv/+gbn6QBIcbl15
         6ibA==
X-Gm-Message-State: AOAM532nnec7JoYrABsZ5PgsSDkrCgx8WXqAdpjJ1Xue2KS92NOUiJ1l
        8WmWXMsR9Ogui02qWIyihesMAYhx+Pw=
X-Google-Smtp-Source: ABdhPJxXkPXZyq0FHkYYAuQrBtEv/7+U2UDyAKOSdDO3KIAGBPx6B5W9JSvtAwteYHd1hTw+kjBUfg==
X-Received: by 2002:a17:90a:ac0b:: with SMTP id o11mr12290443pjq.143.1639024299699;
        Wed, 08 Dec 2021 20:31:39 -0800 (PST)
Received: from Laptop-X1 ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id n16sm5038294pfv.123.2021.12.08.20.31.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Dec 2021 20:31:39 -0800 (PST)
Date:   Thu, 9 Dec 2021 12:31:30 +0800
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     Richard Cochran <richardcochran@gmail.com>
Cc:     netdev@vger.kernel.org, Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: [PATCH net-next 1/2] net_tstamp: add new flag
 HWTSTAMP_FLAGS_UNSTABLE_PHC
Message-ID: <YbGGosXXCvBAJEx4@Laptop-X1>
References: <20211208044224.1950323-1-liuhangbin@gmail.com>
 <20211208044224.1950323-2-liuhangbin@gmail.com>
 <20211208152022.GB18344@hoboy.vegasvil.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211208152022.GB18344@hoboy.vegasvil.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 08, 2021 at 07:20:22AM -0800, Richard Cochran wrote:
> > +/* possible values for hwtstamp_config->flags */
> > +enum hwtstamp_flags {
> > +	/*
> > +	 * With this flag the user should aware that the PHC index
> > +	 * get/set by syscall is not stable. e.g. the phc index of
> > +	 * bond active interface may changed after failover.
> > +	 */
> > +	HWTSTAMP_FLAGS_UNSTABLE_PHC = (1<<0),
> 
> Can we please find a different name?  I see this, and I think,
> "unstable ptp hw clock".  Nobody would want to use such a clock.
> 
> How about HWTSTAMP_FLAG_BONDED_PHC_INDEX ?

Thanks, this one looks better.

> 
> > +	/* add new constants above here */
> > +	__HWTSTAMP_FLAGS_CNT
> > +};
> 
> I guess that the original intent of hwtstamp_config.flags was for user
> space to SET flags that it wanted. 
> Now this has become a place for drivers to return values back.

I think it's a flag that when uses want phc index of bond.
There is no affect for other drivers. It only affect bond interfaces.
When this flag set, it means users want to get the info from bond.

Do I missed something?

> Please make the input/output distinction clear in the comments.

Yes, with the flag name changed to HWTSTAMP_FLAG_BONDED_PHC_INDEX.
The comments also need update.

Thanks
Hangbin
