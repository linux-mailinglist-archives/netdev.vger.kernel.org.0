Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F037A27FA05
	for <lists+netdev@lfdr.de>; Thu,  1 Oct 2020 09:17:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730695AbgJAHRE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Oct 2020 03:17:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725878AbgJAHRE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Oct 2020 03:17:04 -0400
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58722C0613D0
        for <netdev@vger.kernel.org>; Thu,  1 Oct 2020 00:17:04 -0700 (PDT)
Received: by mail-wm1-x331.google.com with SMTP id j136so553882wmj.2
        for <netdev@vger.kernel.org>; Thu, 01 Oct 2020 00:17:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=m8FTjHxJ27KJOivH9JRU27ges1fzk013+SWgDAUmfZ4=;
        b=VpqwyOgQwn8jJ6WzzGtczH/FNfHzLRQ+FNgNm7WgMVR5MoyGe9KWvvcSw5HvDIud4P
         om4kJVKqFXEuAMPCj68GCszUAvD3MilsjnYSWEroKUPvUpONggAMBZMAI+HPobbBMQH3
         48vGcwUPbyLwEQLyYzni1sfuZVWXIWy9BU0ztUP86oW/S3HG4g3ab0r6nZ1TKh5anFaT
         Io+E3dnShcdEO4zWldccu/3ZOk7Se1z1awR2J+EdAH+cnYBvKHjgiAjYlUfuzbYwohnn
         OX8mgOJ7K8lBnT77n9a3ASEkc6FWSGiKHGviuFU19vD+VvOeMyMT9qW7VgWi6yJ2/toL
         95cQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=m8FTjHxJ27KJOivH9JRU27ges1fzk013+SWgDAUmfZ4=;
        b=KjCxtI/WBojK07bMMmlGO2wkszZD5LCahg5rH2RkIGOg2YgoXcT3MxHLBQkKjRtd05
         nkL4+P7xoaN6688NtMKsOPDHozYcPhHgA6nuPVvOMzV3lfbclH5Hq0AxPF0yu1PgjvsH
         OjnrOC4gQDaaVMvJuEwOaxQVgVtcxzz3exB2Jo8OmlQ2zjXZoEhEaZRu5bb5lCB2BsA3
         gwKw44pSD931enJCGvXx/33VBcgG7mr8ie6e3c89s1mEgN4Y5TO7LQP+l7EvPP0pvYwP
         IYx5WaWZawYO3PUoGmW7yaKE6h6nW1v2aBB6Vfwb6+1Ql6GipFx8gkwdMrQronUGupN2
         NZqQ==
X-Gm-Message-State: AOAM531DMTyWtyrzce5iVaAMd6B+OWWNk31Jrdp1jQ7ix8v6xLdJheFL
        scfqJ+WtOge5FX6eYTByCemV9A==
X-Google-Smtp-Source: ABdhPJyWrpBZVI+PsJl6mZMDtCBhSOKxlAhK/uvu7IwOChT+TlSVuHwILs5orNA/OvmYW8X0nufRSQ==
X-Received: by 2002:a1c:7302:: with SMTP id d2mr7235973wmb.133.1601536623012;
        Thu, 01 Oct 2020 00:17:03 -0700 (PDT)
Received: from localhost ([86.61.181.4])
        by smtp.gmail.com with ESMTPSA id i26sm7539648wmb.17.2020.10.01.00.17.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Oct 2020 00:17:02 -0700 (PDT)
Date:   Thu, 1 Oct 2020 09:17:01 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Jacob Keller <jacob.e.keller@intel.com>
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        Shannon Nelson <snelson@pensando.io>
Subject: Re: [iproute2-next v2 1/1] devlink: display elapsed time during
 flash update
Message-ID: <20201001071701.GK8264@nanopsycho>
References: <20200930234012.137020-1-jacob.e.keller@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200930234012.137020-1-jacob.e.keller@intel.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thu, Oct 01, 2020 at 01:40:12AM CEST, jacob.e.keller@intel.com wrote:
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

Looks nice. Thanks!

Reviewed-by: Jiri Pirko <jiri@nvidia.com>
