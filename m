Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4BE9B28F778
	for <lists+netdev@lfdr.de>; Thu, 15 Oct 2020 19:11:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390063AbgJORLh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Oct 2020 13:11:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389725AbgJORLh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Oct 2020 13:11:37 -0400
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E16BEC061755
        for <netdev@vger.kernel.org>; Thu, 15 Oct 2020 10:11:36 -0700 (PDT)
Received: by mail-wm1-x32b.google.com with SMTP id d3so4595274wma.4
        for <netdev@vger.kernel.org>; Thu, 15 Oct 2020 10:11:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=c+MYicf1lpHfDiQSi/dXFm1nzutLYSpEdMcc55loHok=;
        b=p2vhTNBLUUV96D0e0VtWoDjQqbjoEEEO015ZKi1d43RTqSLTun4aKeyglr/+cSaV04
         0DG0QEk/AXS0YKH8lj1RTEkrDihXiKNLLVfvY1m/Rse0Z6c0nI5vJrpkHJLG5ZU4pX1y
         8R8M206sP8oeqOLE3lMJJ+qXZoRXHlVHYnnxIDKUqBW21kq9NfjFE7Qf4Yae3+vRMiSz
         w32eF9QEpgCqk40lGZa1vYvpMOxDDre19DQk28nbToR8Jv4QJLJmdgexeL47MO8GsZaJ
         czW0F8wAkm1rwdi9H/tjjc681a0pFIE/uh37gubi8XFq9aCKPvnEceTvWK5SgOlXZ9Oj
         fIOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=c+MYicf1lpHfDiQSi/dXFm1nzutLYSpEdMcc55loHok=;
        b=PMnWdcVtG2tYyjiUinVuZjSZJHgifem9ZJpKyRx6VpCE231PxP2hc82obKiT4RvZMk
         Ecda8E2iyjpaR0O7xwn4OXt2i32E1W6OkJHblTNbDW7NIP2SHzcfP1wV26Uthl4nLyq+
         9xLawPZE6Xn3k4LjXPeqAHA492pqDSRbx8e3MLLIhGN3r8YskECnuBc5hYS0SiBYSUfd
         eIixLxd01UAEyrmMFY6OKWmuMZYA9g30ey7VOiSPj5a0rXPDLkL8qvXdnUa48uLn/9zP
         wBemqFrJIKG80jY/p9D+KHzIfwaj4f6niYTeIP9nD5MsboOLFKyr62ossWiTZiFH1edS
         eEnQ==
X-Gm-Message-State: AOAM5310QkFTbs3+MHLp2HQeWy7eAVXuJW2WIuw2e2Xu7KXHGfuHlrfe
        QySHX0HdQZsh2YU660eIdC77q7JRYjmchinN
X-Google-Smtp-Source: ABdhPJzZC5wM2jj7Y5n8PcPRKOgbGNMzCkKLp6YNMYPxMZvN26VaN/d28YCML5/nIC0hGccEzuArgQ==
X-Received: by 2002:a1c:770e:: with SMTP id t14mr5004018wmi.34.1602781895396;
        Thu, 15 Oct 2020 10:11:35 -0700 (PDT)
Received: from localhost ([86.61.181.4])
        by smtp.gmail.com with ESMTPSA id 30sm5887738wrr.35.2020.10.15.10.11.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Oct 2020 10:11:34 -0700 (PDT)
Date:   Thu, 15 Oct 2020 19:11:33 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Jacob Keller <jacob.e.keller@intel.com>
Cc:     netdev@vger.kernel.org, Shannon Nelson <snelson@pensando.io>,
        David Ahern <dsahern@gmail.com>
Subject: Re: [iproute2-next v3] devlink: display elapsed time during flash
 update
Message-ID: <20201015171133.GA46013@nanopsycho.orion>
References: <20201014223104.3494850-1-jacob.e.keller@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201014223104.3494850-1-jacob.e.keller@intel.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thu, Oct 15, 2020 at 12:31:04AM CEST, jacob.e.keller@intel.com wrote:
>For some devices, updating the flash can take significant time during
>operations where no status can meaningfully be reported. This can be
>somewhat confusing to a user who sees devlink appear to hang on the
>terminal waiting for the device to update.
>
>Recent changes to the kernel interface allow such long running commands
>to provide a timeout value indicating some upper bound on how long the
>relevant action could take.
>
>Provide a ticking counter of the time elapsed since the previous status
>message in order to make it clear that the program is not simply stuck.
>
>Display this message whenever the status message from the kernel
>indicates a timeout value. Additionally also display the message if
>we've received no status for more than couple of seconds. If we elapse
>more than the timeout provided by the status message, replace the
>timeout display with "timeout reached".
>
>Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>

Reviewed-by: Jiri Pirko <jiri@nvidia.com>
