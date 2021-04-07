Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D60835778D
	for <lists+netdev@lfdr.de>; Thu,  8 Apr 2021 00:20:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231167AbhDGWUo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Apr 2021 18:20:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229600AbhDGWUj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Apr 2021 18:20:39 -0400
Received: from mail-qk1-x731.google.com (mail-qk1-x731.google.com [IPv6:2607:f8b0:4864:20::731])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4149EC061760;
        Wed,  7 Apr 2021 15:20:29 -0700 (PDT)
Received: by mail-qk1-x731.google.com with SMTP id g20so282069qkk.1;
        Wed, 07 Apr 2021 15:20:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ner43B1c7JahH39vGo3hPzauiEoC0Ok0VtKiG5WaEkY=;
        b=U16K0peTEaFDRZyiGqG5dTqKXCkKnJRPaNxJmbe3Q1Sg+u+XdBREmoPk9D4QGlPs5S
         eTTzVZabqfO+GDt9sCXNTUNN7zPqDYAwEn/+f1DLP5YiPjdgVRptDaBiPpYpOQLEQWeE
         t7lF2JbRy5iYwmiS/bJfdY9wv3rjHc1YWXsBlgjnAnXwVhZWzIfsGph7UJ6fQc4MSqkm
         v1pgLQlSm4eycU9hOmk4BInbijaFF+2qzoygqyipg1Ovqc4qsO3VU+eZKFmfHpWgy+yM
         cFlr/DFB9mOdGNdSs6D1jITwediB2I33I9gGyJAwfQTLgdHMu4BcSJ57rpvOpM6FRZsG
         1NYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ner43B1c7JahH39vGo3hPzauiEoC0Ok0VtKiG5WaEkY=;
        b=rr07hpEmqb+ycSn2B85K+8nn7P3PZ62+D1qRcsV5A/ct7b09ZHIKGNDxD+n/Hf+ddJ
         TXzDxaSvSlhCj4s0bR9TmEES4Q+prd4LnxgciPyc+sqxldhQp0M/7gMA7XxcSFlKCuuN
         q0hyUCPyE2pd5biNkE0fqJisYNrIvl1V2OeoemD3E3MJVCGMq41YcEEdpJdWfPdwqHvT
         D4Y2AEph0XKC5+goebxkHSqc7yUiEflWzxOr5NmF0X180lDMDWhSJuFacYviwYBQyQDE
         L0l6iwrTWNTmeWbroAw2D1y7+joTaxkWSeVOssNk8VQ+pER8VL5cQ5tcV2fvAh+4gA2Q
         cMVQ==
X-Gm-Message-State: AOAM530CBEC82hQzy/+fiRWoCCWEHr8N6s2ZKXdsZXiaJj+zJQCGa5SG
        BfpGwEB0yftlleIKkYJcWcK+9WvwsZu6cFUCecw=
X-Google-Smtp-Source: ABdhPJz5jXn36tzwk6U6Xoaraom6QWYRZFMN4zt+7Lp6WMX1nDkSss9M6Q8P/BhBfqfEksawLeaydMgAaq178wnCKMg=
X-Received: by 2002:a05:620a:527:: with SMTP id h7mr5602337qkh.108.1617834028553;
 Wed, 07 Apr 2021 15:20:28 -0700 (PDT)
MIME-Version: 1.0
References: <1617087773-7183-1-git-send-email-wangqing@vivo.com> <1617087773-7183-5-git-send-email-wangqing@vivo.com>
In-Reply-To: <1617087773-7183-5-git-send-email-wangqing@vivo.com>
From:   Richard Weinberger <richard.weinberger@gmail.com>
Date:   Thu, 8 Apr 2021 00:20:17 +0200
Message-ID: <CAFLxGvy7vKJHAms-QAyhcUiv58GYQy+zy3AZ3hP_g+tmh-X4xg@mail.gmail.com>
Subject: Re: [PATCH 4/6] fs/jffs2: Delete obsolete TODO file
To:     Wang Qing <wangqing@vivo.com>
Cc:     Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Adaptec OEM Raid Solutions <aacraid@microsemi.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Luis de Bethencourt <luisbg@kernel.org>,
        Salah Triki <salah.triki@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Richard Weinberger <richard@nod.at>,
        Ralf Baechle <ralf@linux-mips.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-mips@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org,
        linux-mtd@lists.infradead.org, linux-hams@vger.kernel.org,
        netdev@vger.kernel.org, linux-decnet-user@lists.sourceforge.net,
        Greg KH <gregkh@linuxfoundation.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 30, 2021 at 9:07 AM Wang Qing <wangqing@vivo.com> wrote:
>
> The TODO file here has not been updated for 14 years, and the function
> development described in the file have been implemented or abandoned.
>
> Its existence will mislead developers seeking to view outdated information.

Did you check whether all items in this list are really outdated?
Nobody shall ever blindly follow a TODO list without checking first which
points are still valid or not.
Removing that file does not magically solve the issues it describes.

-- 
Thanks,
//richard
