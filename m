Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C49D028C470
	for <lists+netdev@lfdr.de>; Tue, 13 Oct 2020 00:01:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731352AbgJLWBb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Oct 2020 18:01:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727778AbgJLWBb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Oct 2020 18:01:31 -0400
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0842C0613D0;
        Mon, 12 Oct 2020 15:01:29 -0700 (PDT)
Received: by mail-pg1-x541.google.com with SMTP id x16so15763598pgj.3;
        Mon, 12 Oct 2020 15:01:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=bfkpkKc5//vLPHmkF2yidzgAEep/vbh2udDMyO66d9I=;
        b=LxA2YTmXyfkffzXPRasT4DhLlVDwrppDBqS/hYVEa1ZSdEuAFT7jF3k8PnudIxlic+
         vci88/yKwtYtJGw5zKC31lHWOko9jk+qJQPSmuilYvW04CpvYb5duxTffBG+jmLa5gNq
         xLp2mfsU7UCJ2xywQLHvokdmwop5h1AsjIEvK5BucvqQiY5AEHURu8clCJtltLxTIg+/
         5XXDktjCbQtPSjWinQyiV2Fh3ggMqV0+su/i3HYBbSOvLi7mObVbvtD/PtaHW6Hy2n7p
         ywly2vTORbdlmitE2kK0Sb7n9bWXotmeo5+QYuHGB9xquid5zhi5soazgK/MmB8Yg8zm
         LRVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=bfkpkKc5//vLPHmkF2yidzgAEep/vbh2udDMyO66d9I=;
        b=J/oLQhtNwG6uSEt4M8k1M5g8OCHCfqEbfeg8kmDskC4ND9XTX+4zHO8QHIF2VgEmFJ
         az2HJWRDLj3dj4ayDLykczTeRYYbpOjd/pjaI9YteBwp622+XKi5xO7T/xSGq7ztDINM
         YzXFrDqIKqVrvs/IUN1434TKdZIIIQzTyTJwdXcfyvjcWLz0R+mtzkG0sO5lixt5eVvG
         dvlfN3gMIIpjw+ysiVpLOwRdCXwoQVbp35dt3D95uDrjohmhbkxL0iDzDRuxTtwGq3jL
         qdNuhTp0QDBtSdTQwzk1mMwbmHAIh7Bh3UmMeG98tEI3LbxQopNfDL4hSOcO6g2P/EHP
         AcSw==
X-Gm-Message-State: AOAM531vOGwuX9SeSYUXFQz+qBKbWHc1S/q1lVDyC6l3SYIrzXa1Y31D
        zQNDMA7NYxx5SBnlRYZTgKSemmACmq8=
X-Google-Smtp-Source: ABdhPJwLUvhoIqW41HExMySdxlZZViQPZ50hdtDgotqFyk1XoGTdXqSoNvzoyILOXnkJHyElqoVeGA==
X-Received: by 2002:a17:90a:e64f:: with SMTP id ep15mr8806928pjb.95.1602540089414;
        Mon, 12 Oct 2020 15:01:29 -0700 (PDT)
Received: from hoboy (c-73-241-114-122.hsd1.ca.comcast.net. [73.241.114.122])
        by smtp.gmail.com with ESMTPSA id d145sm22065668pfd.136.2020.10.12.15.01.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Oct 2020 15:01:28 -0700 (PDT)
Date:   Mon, 12 Oct 2020 15:01:26 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     trix@redhat.com
Cc:     natechancellor@gmail.com, ndesaulniers@google.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        clang-built-linux@googlegroups.com
Subject: Re: [PATCH] ptp: ptp_clockmatrix: initialize variables
Message-ID: <20201012220126.GB1310@hoboy>
References: <20201011200955.29992-1-trix@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201011200955.29992-1-trix@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Oct 11, 2020 at 01:09:55PM -0700, trix@redhat.com wrote:
> From: Tom Rix <trix@redhat.com>
> 
> Clang static analysis reports this representative problem
> 
> ptp_clockmatrix.c:1852:2: warning: 5th function call argument
>   is an uninitialized value
>         snprintf(idtcm->version, sizeof(idtcm->version), "%u.%u.%u",
>         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> 
> idtcm_display_version_info() calls several idtcm_read_*'s without
> checking a return status.

So why not check the return status?

Your patch papers over the issue.

Thanks,
Richard
