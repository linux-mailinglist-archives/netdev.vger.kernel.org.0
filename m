Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B234F30CEDE
	for <lists+netdev@lfdr.de>; Tue,  2 Feb 2021 23:29:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235361AbhBBW3N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Feb 2021 17:29:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235260AbhBBW1H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Feb 2021 17:27:07 -0500
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90CB5C0613D6
        for <netdev@vger.kernel.org>; Tue,  2 Feb 2021 14:26:26 -0800 (PST)
Received: by mail-pf1-x42b.google.com with SMTP id o20so15347161pfu.0
        for <netdev@vger.kernel.org>; Tue, 02 Feb 2021 14:26:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=EeK93bGpIq4Geok6cBmsuwStcHiOYNgVRGOztKWPaME=;
        b=j39s186XOcXhxOEDq5ouRufUVvlE4SaAsG+CMFnV+ayx3AZ5upInilijQlpZu272mR
         4caWf8Xr9C2juwyeR+6ghM0Ab7oUXNPMsGF6iromA/wrFa3zUuGsBWcijEAlXpEXYrgV
         Zs8eTXTP/gmtiYp7FcqsCVnZkMZpqTwVDIHACuvqxq6+M1zjFE84KapJIv67RLqncxLA
         z/6PtpKiQNVb/zWJg7yo9erCJFPVrBWF0+sDScbJ4gTCVCv1jdsieG8GVB3Oe24WfCPY
         kRU3pBYF+KIapWaUmibqZW9qS73WibrH9yKIoDbCO2tRyHeitMC7xh6b4m79e69OxSRa
         IdgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=EeK93bGpIq4Geok6cBmsuwStcHiOYNgVRGOztKWPaME=;
        b=L1y16xS8VH56ngSDkUgeAkIVQsX5CthwsG620ztyHuGMahuSclwev+aEZ9LnpoVTAd
         QA+ul9poIVDb0nCH8QG5qUYR1LwEjRhaMCtB+KJew9Dap4TEJzeasqFFprl0QVgWwLYt
         tGv1tX/77uf1Bef5JkuWBXmcSg+kZn1HjIgrACiXmL8U2uIAej5/cEcuz7wLtpfAp953
         LL8+kDKEw8VbkO2VJoxvzYfzcBpyoMUPBMPI1xyklgSRKJpIpQby7zkAGa+JITOyShSq
         Ybg8Fygl/FlVuvwCbQF3KxCY3IYAIKcgDV2Zj9W8YwlzMgHIYpk0bZIp1RFskzVp8cQ9
         Hytw==
X-Gm-Message-State: AOAM531YzSGg0TOHV47/thaQUHvhCg58Tr+6mnbPhkv86/N/6eHFSWAK
        82HPoNu+E+L1fcnW5DvoY/92dA==
X-Google-Smtp-Source: ABdhPJxIExY/c+P6nuIPxin+FHt9Gf7j2fMD2xd/zXW6AcgAmqK+zE/3uAX6SDZvY6E0Zfety2b9mg==
X-Received: by 2002:a63:2009:: with SMTP id g9mr250534pgg.219.1612304786161;
        Tue, 02 Feb 2021 14:26:26 -0800 (PST)
Received: from hermes.local (76-14-222-244.or.wavecable.com. [76.14.222.244])
        by smtp.gmail.com with ESMTPSA id f71sm19601pfa.138.2021.02.02.14.26.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Feb 2021 14:26:25 -0800 (PST)
Date:   Tue, 2 Feb 2021 14:25:08 -0800
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Thayne McCombs <astrothayne@gmail.com>
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH] Add documentation of ss filter to man page
Message-ID: <20210202142508.3d0aca91@hermes.local>
In-Reply-To: <20210128081018.9394-1-astrothayne@gmail.com>
References: <20210128081018.9394-1-astrothayne@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 28 Jan 2021 01:10:18 -0700
Thayne McCombs <astrothayne@gmail.com> wrote:

> This adds some documentation of the syntax for the FILTER argument to
> the ss command to the ss (8) man page.
> 
> Signed-off-by: Thayne McCombs <astrothayne@gmail.com>

Applied, but I had to fix several spelling errors.
