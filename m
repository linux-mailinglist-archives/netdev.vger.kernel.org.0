Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE8231DDC97
	for <lists+netdev@lfdr.de>; Fri, 22 May 2020 03:23:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727050AbgEVBXd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 May 2020 21:23:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726335AbgEVBXc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 May 2020 21:23:32 -0400
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 950B1C061A0E;
        Thu, 21 May 2020 18:23:32 -0700 (PDT)
Received: by mail-pl1-x641.google.com with SMTP id f15so3757746plr.3;
        Thu, 21 May 2020 18:23:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=ogbg3vrGDJe0611dyqo8aJKJy+hyyzLlyQmUDoBczI4=;
        b=IgQ8Lvm6uoFkqaWjj/5uTQhkFd4Ay4eM61kvsD4Q9WaCiu12WVamQAWCEMN/PZCBu4
         BwvGPE44+OMWLl1ZgdDNkgWIEl66FtBgKwWzIQMsKHzXn0u2crLRtuy1yE4hxDG/SyOg
         k13PTXbmfd5YVHSNy43btFG4wMpT6g1Usx3/JcOmkFQ4QqJo9ZrfB6xpP5HJWH81vOB4
         XeyKMNF1vFf+GbPGhSr0hyEfykAIpu78msJ0lU10JzBusdZmMK6J8RNMxUfmQtTU3y7I
         YfzM262kIxnrPIFX+1BRydeRT02DWUkGXphEo4ePQhiJ9mkYZnN3HWam7FaM+d0UpzOw
         mjrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ogbg3vrGDJe0611dyqo8aJKJy+hyyzLlyQmUDoBczI4=;
        b=VsjowW3HOaCV1AZ/JuTsqsrwLokLThKQhyGA3OjR0Ni36tq4zsSk3WrILjCrC9l+KB
         ygt5AulrCJ0ZNMpEiVf5RfANiL8hg9FKILlhWeJIqzfEfVO961BRGMZjobGtYDOqp7H9
         VTdjsvlTBNYWvYiw8AWfNKjSDRZV02tUq6w54rPGoyN7lcOSrSJuAoCpxvBBhmbX/bfM
         5YTCdj441UxpyQJxisiFpY/bXy1MuVpci0qpZ8I5JT5V3S4HwEoDHkgQFtNt63LpnnJF
         SfHbMyM6Q/P+C1xs3ieI7//t05a/t6UYDP/8PObjp5nyNr/wacr79S2Pd60uZ5+xChDP
         1Jxg==
X-Gm-Message-State: AOAM532mOzfoVwDbOSo2qu9H2Bvjpkg3REHbdzltdhDjb9ptdNJWcM3E
        p3NykYdWbSnVm2P41mmDQdsUJ9Cl
X-Google-Smtp-Source: ABdhPJwaMxKrphz9D07FJ6rBzcGCtfeZ7zTzYCZB6fw3bLlEu/NZXP05iuVhDGKc67+Hat2YrUFsuw==
X-Received: by 2002:a17:90a:246d:: with SMTP id h100mr1407400pje.21.1590110611577;
        Thu, 21 May 2020 18:23:31 -0700 (PDT)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:400::5:e680])
        by smtp.gmail.com with ESMTPSA id 65sm5515340pfy.219.2020.05.21.18.23.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 May 2020 18:23:30 -0700 (PDT)
Date:   Thu, 21 May 2020 18:23:28 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Andrii Nakryiko <andriin@fb.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org, ast@fb.com,
        daniel@iogearbox.net, andrii.nakryiko@gmail.com,
        kernel-team@fb.com, "Paul E . McKenney" <paulmck@kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Stanislav Fomichev <sdf@google.com>
Subject: Re: [PATCH v2 bpf-next 7/7] docs/bpf: add BPF ring buffer design
 notes
Message-ID: <20200522012328.7vs44qhutdiukrog@ast-mbp.dhcp.thefacebook.com>
References: <20200517195727.279322-1-andriin@fb.com>
 <20200517195727.279322-8-andriin@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200517195727.279322-8-andriin@fb.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, May 17, 2020 at 12:57:27PM -0700, Andrii Nakryiko wrote:
> Add commit description from patch #1 as a stand-alone documentation under
> Documentation/bpf, as it might be more convenient format, in long term
> perspective.
> 
> Suggested-by: Stanislav Fomichev <sdf@google.com>
> Signed-off-by: Andrii Nakryiko <andriin@fb.com>
> ---
>  Documentation/bpf/ringbuf.txt | 191 ++++++++++++++++++++++++++++++++++

Thanks for the doc. Looks great, but could you make it .rst from the start?
otherwise soon after somebody will be converting it adding churn.
