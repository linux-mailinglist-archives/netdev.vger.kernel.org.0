Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55E891C0CB2
	for <lists+netdev@lfdr.de>; Fri,  1 May 2020 05:39:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728188AbgEADi5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Apr 2020 23:38:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728071AbgEADi4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Apr 2020 23:38:56 -0400
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D9C7C035494;
        Thu, 30 Apr 2020 20:38:56 -0700 (PDT)
Received: by mail-pf1-x442.google.com with SMTP id y25so1060763pfn.5;
        Thu, 30 Apr 2020 20:38:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=bdbqu8VLEnZw0JRGNu45bF7rlrWBblq37f2ZHgjd84k=;
        b=jyRPImphjgw+EWoLOSKPgkozZrrEzFccwTsDFPIUEhQO/Ikk7zG40Fh7JXSnW0vSd7
         lW1EjbVl11kflPMyilQknOSl4m8QQCitXM7jDLNq63ulffhgy/ep83qZi45i8GOn0b6Y
         XaM3x57dzybJ/iJLougFckHsVKrRY2auXdVfAsdqPQ9vZci7GSraQzg8GvG6m236SEnr
         FRqaNZQl2+rhv5tDkJ0urpRoRKYohcJ0IvMGIVqxFOaDH6FT839jICfpQfX8Z1oSmWRC
         d5aQOieAHqzu8Qtr1nnZBXFpjCVEMqyE7WKMC6J7bhdVOi+oZo6sGuTkubwC3BWMPgos
         lkzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=bdbqu8VLEnZw0JRGNu45bF7rlrWBblq37f2ZHgjd84k=;
        b=t+SFKPfuXb+EW8DEuzyyTArrmvSUzqt0o7RTCY3K3VVCvCoIiq34eUiWgFlf7WqQDw
         ZynEhXu6cnvKVKPnoadld8SxAZHbiha4ArmVbgWH/ZdxgZZIuEEC22RhgEIVW/KNB3Va
         SBwFE+TobYsdNxQvc7mRxbsCXBzy+L5Wxs9c7ey/GC7bgn528hjE+eEuaoeo1SZwqyho
         HmVCH60Li0Bq/rQyTD+Rff8gg+H+U/1V6wYVfy4qIGuIA5sakg1z+S5ZL/vueGptITLq
         HjUmUogsKyCwLkGthGOvk495fgYl5ieJsD5iSSfxA+RUekLeufirK6ZpcJqrMWrGUoYB
         yNIA==
X-Gm-Message-State: AGi0PuYijzU0Dc6au85EnaCtPpoITr4JmW08J+IAHbdvSnVL0XcYzhwL
        +Fxd3DTOSE9m426cCbvAj+32bjeb
X-Google-Smtp-Source: APiQypJPgAPOsmspI6oCc5B+2ULsFHj9PsqbYNere5DKgz4n7Jj50iHAnbcsujZTeTwYPj3zt7VG+w==
X-Received: by 2002:aa7:8a9a:: with SMTP id a26mr1157580pfc.77.1588304335544;
        Thu, 30 Apr 2020 20:38:55 -0700 (PDT)
Received: from localhost (c-73-241-114-122.hsd1.ca.comcast.net. [73.241.114.122])
        by smtp.gmail.com with ESMTPSA id n16sm1027809pfq.61.2020.04.30.20.38.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Apr 2020 20:38:54 -0700 (PDT)
Date:   Thu, 30 Apr 2020 20:38:53 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     vincent.cheng.xh@renesas.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-kselftest@vger.kernel.org
Subject: Re: [PATCH net-next 2/3] ptp: Add adjust_phase to ptp_clock_caps
 capability.
Message-ID: <20200501033853.GB31749@localhost>
References: <1588206505-21773-1-git-send-email-vincent.cheng.xh@renesas.com>
 <1588206505-21773-3-git-send-email-vincent.cheng.xh@renesas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1588206505-21773-3-git-send-email-vincent.cheng.xh@renesas.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 29, 2020 at 08:28:24PM -0400, vincent.cheng.xh@renesas.com wrote:
> From: Vincent Cheng <vincent.cheng.xh@renesas.com>
> 
> Add adjust_phase to ptp_clock_caps capability to allow
> user to query if a PHC driver supports adjust phase with
> ioctl PTP_CLOCK_GETCAPS command.
> 
> Signed-off-by: Vincent Cheng <vincent.cheng.xh@renesas.com>

Reviewed-by: Richard Cochran <richardcochran@gmail.com>
