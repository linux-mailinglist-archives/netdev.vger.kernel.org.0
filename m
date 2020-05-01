Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE4501C0CAE
	for <lists+netdev@lfdr.de>; Fri,  1 May 2020 05:38:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728163AbgEADhi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Apr 2020 23:37:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727889AbgEADhi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Apr 2020 23:37:38 -0400
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08316C035494;
        Thu, 30 Apr 2020 20:37:38 -0700 (PDT)
Received: by mail-pl1-x641.google.com with SMTP id t7so3242916plr.0;
        Thu, 30 Apr 2020 20:37:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=GS0U8SUSILHCjq5eNMqOXcV1RkW3JRNv0r6fRdIwZvU=;
        b=Y0yZWp2ByAvWs+hOwbpnNcu3m+4h9A7k/sgRhFZthd29pQdZtkcqrvJd2PbZ7lDv2t
         oxNiQsfu3XM7dleNdFMjUvusZAlo9ZIRbmMAy3yn/evZtXzHcO3Ai857h7TS3dkYJS75
         6rq3BO4WtMdAsjyy+lwbxDxdCJYB2GfqK+xc46a0Y1O6rsSK1xIRFXX6zqKDQEocrBsg
         h2JSuVDUYFSawQaekW5PjwGDKOXCXi4qJ6WFs86AuN/STwA1kK/MMIGUh/KOxSiDPUbS
         LrGaToygyrP/7q/YENKVkl35MSKD85ZEz2C828Zal/dyOmnGKWw/khR5AOWpVn3RHl1z
         euzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=GS0U8SUSILHCjq5eNMqOXcV1RkW3JRNv0r6fRdIwZvU=;
        b=ix7dASpOR2MN39TFBnfZgzXK0WahxJl3I/VuA1lnidqLNJdNgTf1UZ+XKsDwi3Mp8q
         5dRn1bwhL/VR3zJ+aJ8pYJGHKpFuAhdRGdfe5gay6jUy0O0/Nvho+1qaVqBIEeT4TK8u
         ad6YGLe7JGvb25w0bYecMDqsYzZDh2Ce71X8MYg5om6QdBtQ9Y9COzcuDD7FCuFw69CJ
         AKG43UDfrGOpbn8fv41sC5i4H2bWKOB63ljK3QqRq3JDh8YTUIds5+kaPxHw2X6GN/LW
         FCGj/L3w4QGWXBu9nwe70NoQ4opykXD9VpKhsgoL14em+C9TY6eiVjifMiHJXCjn++OI
         euTQ==
X-Gm-Message-State: AGi0Pubn5FEmod6gS3gcusBsCEr8A3TXyX9Waes3EIcrJ6ssvd0dbaxO
        tLteD1fC+xkL5dHBjcNnpaL1KA9n
X-Google-Smtp-Source: APiQypL72KBQOOq8iZbi8rVhj7DDLjwrhumRgxyU9FhI6FqdeW999kfmvhKXR+eyF0PkZlrucqjA0g==
X-Received: by 2002:a17:90a:fe06:: with SMTP id ck6mr2387664pjb.4.1588304257419;
        Thu, 30 Apr 2020 20:37:37 -0700 (PDT)
Received: from localhost (c-73-241-114-122.hsd1.ca.comcast.net. [73.241.114.122])
        by smtp.gmail.com with ESMTPSA id b3sm929068pga.48.2020.04.30.20.37.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Apr 2020 20:37:36 -0700 (PDT)
Date:   Thu, 30 Apr 2020 20:37:34 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     vincent.cheng.xh@renesas.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-kselftest@vger.kernel.org
Subject: Re: [PATCH net-next 1/3] ptp: Add adjphase function to support phase
 offset control.
Message-ID: <20200501033734.GA31749@localhost>
References: <1588206505-21773-1-git-send-email-vincent.cheng.xh@renesas.com>
 <1588206505-21773-2-git-send-email-vincent.cheng.xh@renesas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1588206505-21773-2-git-send-email-vincent.cheng.xh@renesas.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 29, 2020 at 08:28:23PM -0400, vincent.cheng.xh@renesas.com wrote:
> diff --git a/drivers/ptp/ptp_clock.c b/drivers/ptp/ptp_clock.c
> index acabbe7..c46ff98 100644
> --- a/drivers/ptp/ptp_clock.c
> +++ b/drivers/ptp/ptp_clock.c
> @@ -146,6 +146,8 @@ static int ptp_clock_adjtime(struct posix_clock *pc, struct __kernel_timex *tx)
>  		else
>  			err = ops->adjfreq(ops, ppb);
>  		ptp->dialed_frequency = tx->freq;
> +	} else if (tx->modes & ADJ_OFFSET) {
> +		err = ops->adjphase(ops, tx->offset);

This is a new method, and no drivers have it, so there must be a check
that the function pointer is non-null.

Thanks,
Richard
