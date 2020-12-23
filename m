Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A2B12E1DED
	for <lists+netdev@lfdr.de>; Wed, 23 Dec 2020 16:35:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727641AbgLWPco (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Dec 2020 10:32:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727039AbgLWPcj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Dec 2020 10:32:39 -0500
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD394C0617A6;
        Wed, 23 Dec 2020 07:31:58 -0800 (PST)
Received: by mail-ed1-x534.google.com with SMTP id g24so16561301edw.9;
        Wed, 23 Dec 2020 07:31:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=4ZX/oY/UMh+zpGx1mdoH5h4IbrR1t26jLXfuR6PIHus=;
        b=gUfgl9ha7ZaX82C1DhmTvyl5Reu1sMt8IXJeECjnH1nCWXv+b8NtbsVWmnxpR45HBK
         u4bxL2Hjrv5ljk9QLG6kceFL2lSiJvzcHUANFwblBUWT3clOX5X2Su9S1fZnyLkmLosE
         Xevz3BMSemRImdclS/xbZ5gEmC5fPuPPT1ZeBICtF3oZlQ5KDWllYrJGuLkdF2BUZtEk
         qMZ0/j/o8wazvDsNdoOJpbAYEdSNwIagHJyIuLvxsaFdyMjeKEmStVf0EgviLykkrxZ8
         A6g1OUvG1USwp+UOqpjl1FZ9Fispt91vi8gJeoImli3s9th4KwMk7bEqMrPNjgflgAWU
         WCtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=4ZX/oY/UMh+zpGx1mdoH5h4IbrR1t26jLXfuR6PIHus=;
        b=RBn3gr1e0YHaMmVr7P5iJSCciof4XxtU9ej6uSn/RTwDfe/6UO8I1vIoCLalCzsqKN
         eHW3i+HkGP84Jb3EMorYMDgW/t1GXWr93dLtj1VIvXmAQkc0CVqmSUBzKojY3nScAufs
         1XfGzR42rvtwueJ7Pdue69sIpry0U2InsM5C7hrcyYv5Pt4k4qRan8XLI1URYy+Ebr9E
         meqqXdYdd1cW4f2++n1Fm/HZnBchLlrItIXdccCnktClQyyhtRisCOk8gZp3wLpdiNqi
         i8AI9kVnrpKVfAXbFFGeymRsq4wZAGVU7FMxgIOo+BKFUMJjw+FskebEG7QYgJULsr1A
         KlRw==
X-Gm-Message-State: AOAM5301V1eXr18yXSQB9/9cuZ2dt/5p4sdA0kd3Psc3nYgV48/jKulU
        d/bdc+BNQk73kzUubmj2gCc=
X-Google-Smtp-Source: ABdhPJz7qunYCzByIufCe9LefmAJBHO+dxaqq5T6ePnJaklV7S98rLzR9x5Ul5EUKOKyQwge3EVtjA==
X-Received: by 2002:a05:6402:171a:: with SMTP id y26mr25771935edu.371.1608737517461;
        Wed, 23 Dec 2020 07:31:57 -0800 (PST)
Received: from skbuf ([188.25.2.120])
        by smtp.gmail.com with ESMTPSA id d3sm27554041edt.32.2020.12.23.07.31.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Dec 2020 07:31:56 -0800 (PST)
Date:   Wed, 23 Dec 2020 17:31:52 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Danielle Ratson <danieller@nvidia.com>,
        Petr Machata <petrm@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Ido Schimmel <idosch@nvidia.com>,
        Ivan Vecera <ivecera@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        bridge@lists.linux-foundation.org
Subject: Re: [PATCH AUTOSEL 4.14 48/66] bridge: switchdev: Notify about VLAN
 protocol changes
Message-ID: <20201223153152.zbzgs63dykehwk5x@skbuf>
References: <20201223022253.2793452-1-sashal@kernel.org>
 <20201223022253.2793452-48-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201223022253.2793452-48-sashal@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 22, 2020 at 09:22:34PM -0500, Sasha Levin wrote:
> From: Danielle Ratson <danieller@nvidia.com>
> 
> [ Upstream commit 22ec19f3aee327806c37c9fa1188741574bc6445 ]
> 
> Drivers that support bridge offload need to be notified about changes to
> the bridge's VLAN protocol so that they could react accordingly and
> potentially veto the change.
> 
> Add a new switchdev attribute to communicate the change to drivers.
> 
> Signed-off-by: Danielle Ratson <danieller@nvidia.com>
> Reviewed-by: Petr Machata <petrm@nvidia.com>
> Acked-by: Nikolay Aleksandrov <nikolay@nvidia.com>
> Signed-off-by: Ido Schimmel <idosch@nvidia.com>
> Reviewed-by: Ivan Vecera <ivecera@redhat.com>
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---

This looks like a bit of an odd patch to backport?
Are we also going to backport driver changes that make use of this new
switchdev notifier?
