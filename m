Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6791A2A8469
	for <lists+netdev@lfdr.de>; Thu,  5 Nov 2020 18:05:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731587AbgKERFW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Nov 2020 12:05:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727275AbgKERFV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Nov 2020 12:05:21 -0500
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40239C0613CF;
        Thu,  5 Nov 2020 09:05:20 -0800 (PST)
Received: by mail-pj1-x1043.google.com with SMTP id gi3so389087pjb.3;
        Thu, 05 Nov 2020 09:05:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=DkfZLxJRcuWqF8h1C1wuDqCCoEllPC6R7DtXuNRHRGA=;
        b=CzjqoyZfeHBkSFZenYVadtTaZQijE6XMIft5FoyuutEWPNoLXZQiYzhGzi9AVykvEc
         tgSE46+lULNRRTPDC7rb/1rBs7HsUM1KXK/wPIe5yG37OdC1V3BsjnTH3p/hgl+KkxAo
         OOxGYiJGsO3lqXzKFO7GPf/ZCpd7qE07ePL34PFX8IzjU9kWkUDqjIZZICC6AmOahK+n
         To8bsQ0R5x9F2NUtkOL21+9vkbx276fGw/8xgXedTFPVur+RBlm3FbJ0sOMsqjSgay6p
         KvIl1cpzejh18O3b9hp7McXaHZLv8YDE9RT/ueQ7yEiMIWRgRoaIkjgXKUHwzexBzUe2
         9HKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=DkfZLxJRcuWqF8h1C1wuDqCCoEllPC6R7DtXuNRHRGA=;
        b=pATorwmiyriR5h8yfbKU+IYitMpFVR0h4ZdgQ/9dAnPZLXYIwDCGSuxmJucjs5TJD/
         OyIjakicqcEqK+b1tOD7odQ7VNZiKM6CrbRUaH9u5EuudEDaNcRoDLgcSeYLk7NAx9UU
         skEvd9XqTZV/6JAzz2vQknL2hR5dbAbk9RuSyNB3sCYico24KTCAbi96/C+N7aLb2V9b
         Us8CB8liWrOOG5+3Fgov6YyFwo6BRF1FznQUugVVAE1vvWco4EVKvpJrs7iuLyr7FxVd
         Oynhk2gofkvljBi2Ca/j7PVdF8dxu8LuLOj6THMQ9+esNCQ7WNfFDSCnFPwKDOf+/CFb
         ALOw==
X-Gm-Message-State: AOAM531fWlWcb4lbbt1whL5z/GmajZ463GuXHl4etjEP7DddAd9SS8db
        6462boP0TPvDWfCUXVXiq/8=
X-Google-Smtp-Source: ABdhPJz7z0IOLgroE/ZgLmOmWkS6TTbdkLBvsZpm22KuVB6Ig9ftl5zk61jccCtln4zD1uSQFuAs4g==
X-Received: by 2002:a17:90a:d590:: with SMTP id v16mr3398815pju.88.1604595919770;
        Thu, 05 Nov 2020 09:05:19 -0800 (PST)
Received: from hoboy.vegasvil.org (c-73-241-114-122.hsd1.ca.comcast.net. [73.241.114.122])
        by smtp.gmail.com with ESMTPSA id k4sm2570412pfg.130.2020.11.05.09.05.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Nov 2020 09:05:19 -0800 (PST)
Date:   Thu, 5 Nov 2020 09:05:16 -0800
From:   Richard Cochran <richardcochran@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     min.li.xe@renesas.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 net-next 1/3] ptp: idt82p33: add adjphase support
Message-ID: <20201105170516.GB5258@hoboy.vegasvil.org>
References: <1604531626-17644-1-git-send-email-min.li.xe@renesas.com>
 <20201104154508.557cc29b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201104154508.557cc29b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 04, 2020 at 03:45:08PM -0800, Jakub Kicinski wrote:
> Also are you sure the last patch is okay? Richard suggested it's not
> worth the risk AFAIU.

I took a look, and I can't find anything wrong with it.

Thanks,
Richard
