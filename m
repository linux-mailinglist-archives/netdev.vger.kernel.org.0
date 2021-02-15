Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F1AC31B7EF
	for <lists+netdev@lfdr.de>; Mon, 15 Feb 2021 12:23:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230021AbhBOLW5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Feb 2021 06:22:57 -0500
Received: from mail-wr1-f54.google.com ([209.85.221.54]:34843 "EHLO
        mail-wr1-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229779AbhBOLWw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Feb 2021 06:22:52 -0500
Received: by mail-wr1-f54.google.com with SMTP id l12so8452523wry.2;
        Mon, 15 Feb 2021 03:22:35 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=H/HSQcMjtFGIvIu1oJqCB+ca0ygjk6QUeyq3U3IQtxk=;
        b=CeOAZKJsNN2IoHWTQw5YyeKe2msfvoVBNR60OHpRea1YnrYZU1QF/XunqUbWwHxmRn
         0KGQdJ85xPaciK7CW8IbDjJmR3/93ezDfqKMIbBK9s6GcR7lHlxMhD+grWkTH0TYTcQW
         u4TDPtUIpYrzgorzdxBzEMrcUHQqi6JROHOpayy+Fja/hYWuJhu0+EFdLI8XGSgdGlMp
         Kwi1dMCPg+pDs6G18xozyLKYIEtUW1H5uSisevautJk0+6Xpbl9WqifptyaX1GOkLJ+c
         5CGXd0F5OWZT1sgs9T3M62eqxbs6FcSqWNlkRaidVuawL4TUxN3b4PZYNnqPYtM3z2sC
         pToA==
X-Gm-Message-State: AOAM533LOOStorUfaW0/yfI+hZ4jZ+zgrfXJ9bD1iszs9rFITa4rgz6/
        k9gy2KkY4UGqOsMpJhlQsKbhkTTh1bo=
X-Google-Smtp-Source: ABdhPJyRupVeBoZBpt65+nI7oNINndMhPBKC/Ci5iSqTNaW0cIXpnFEG8TXNObG8U6+9JByW508T+w==
X-Received: by 2002:a5d:4051:: with SMTP id w17mr18060071wrp.186.1613388130320;
        Mon, 15 Feb 2021 03:22:10 -0800 (PST)
Received: from liuwe-devbox-debian-v2 ([51.145.34.42])
        by smtp.gmail.com with ESMTPSA id v6sm14735523wrw.49.2021.02.15.03.22.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Feb 2021 03:22:09 -0800 (PST)
Date:   Mon, 15 Feb 2021 11:22:08 +0000
From:   Wei Liu <wei.liu@kernel.org>
To:     Andrea Parri <parri.andrea@gmail.com>
Cc:     linux-kernel@vger.kernel.org, kys@microsoft.com,
        haiyangz@microsoft.com, sthemmin@microsoft.com, wei.liu@kernel.org,
        mikelley@microsoft.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com, davem@davemloft.net, kuba@kernel.org,
        linux-hyperv@vger.kernel.org, linux-scsi@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: Regressions with VMBus/VSCs hardening changes
Message-ID: <20210215112208.jjzhtvzhemlgpvfa@liuwe-devbox-debian-v2>
References: <20210212165050.GA11906@anparri>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210212165050.GA11906@anparri>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 12, 2021 at 05:50:50PM +0100, Andrea Parri wrote:
> Hi all,
[...]
> 2) IIUC a8c3209998afb5 could be dropped (after rebase) without further modi-
>    fications to hyperv-next.

I've reverted the said patch from hyperv-next.

Wei.
