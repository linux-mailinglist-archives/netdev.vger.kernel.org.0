Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 22AFF1D4309
	for <lists+netdev@lfdr.de>; Fri, 15 May 2020 03:40:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728244AbgEOBkC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 May 2020 21:40:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726165AbgEOBkB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 May 2020 21:40:01 -0400
Received: from mail-lf1-x144.google.com (mail-lf1-x144.google.com [IPv6:2a00:1450:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1800CC061A0C;
        Thu, 14 May 2020 18:40:00 -0700 (PDT)
Received: by mail-lf1-x144.google.com with SMTP id z22so465093lfd.0;
        Thu, 14 May 2020 18:40:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=PneD4aJFPrSl/OSnIoySuM5BCf1r2D8FY19KBbwv6Wk=;
        b=IC9oqa2Xf8ErT83/4dcjBWdk4IiEwxc7JJPpFbNUUx8DERvxqdGNXadY31LvkcW3hc
         q2MnGMyJ+hvpT2UNv0+u7kkfZg2mGnucsh8omXUIqdqw4GduwYILQs/1NCgnEBEdMqVQ
         baUhwdqPx7gZfhKKkniqDhIE7j31UwJBtRiERng2psfEqm4MfgrWEW0oO7iVuUPUxFZC
         kdd0UPMw/OTOznNKlDjoB6O0qqIcFXTwBHZdg0UCdeWjD9ut9b6eTbMJ6btzhSrJp2mp
         g+1WwpVhMHSWyCwcYeU4V9C8BOG3yMB8QebCm5AUjbsohTN7Wv8bntgqhQER3zMFmPEL
         qrpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=PneD4aJFPrSl/OSnIoySuM5BCf1r2D8FY19KBbwv6Wk=;
        b=Q4sSyfZnZ2JHjQc2RyhPB43V+olqVCQ8pEkXraYrnU1tByeCXHmElFqjqsPvsJ6Ro+
         c2LJNxXpI+/y8cw7pTQTIW0a5dJ3lmtX2FQCMMZ5RZh6ajPh5NEOpEtH+Aa3s8muk3mf
         mt+kI63fUq9ZgWS6b8a7xpBUh9zLCKgdHhbo74u6ghxBtk7/SCgzPgvT7k+RbXeJXVp4
         2ZAY15BptQ2I3XyZJ8MM6ke/ljFVxYj8PCWzE2zrN2ljGTI4VWUEWZWVqSlnNVmY0Cqb
         9E5a+gvpK9XcWIIcD2dC3N9a9tSCz+kBWO8oukuzKCYIu/VhiNWV4hjIE62Pb6mGSJaG
         sZxQ==
X-Gm-Message-State: AOAM530Q77k7ap6hgzwJMUXpsX7q3cQ+XRUJQEZr1/sQZlVoH1R4jljC
        KC8BTDYFAU+uzmMfT431UxYf2OY5ww4ojVqPqHg=
X-Google-Smtp-Source: ABdhPJyjQHz0At8Ad0VCzJBUw9YeB3JR/fowM/LM40iYsBEA5mDyczMgxfvv1c1eIwOj5gsuxVT/lzNl29WZiqPDNZk=
X-Received: by 2002:a19:987:: with SMTP id 129mr667488lfj.8.1589506798456;
 Thu, 14 May 2020 18:39:58 -0700 (PDT)
MIME-Version: 1.0
References: <20200514121529.259668-1-colin.king@canonical.com> <bae961e3-a3ae-2652-6f4e-df97f501db0e@fb.com>
In-Reply-To: <bae961e3-a3ae-2652-6f4e-df97f501db0e@fb.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Thu, 14 May 2020 18:39:47 -0700
Message-ID: <CAADnVQKeM7-H0HCLHfQdY4U=898uxUSMHNV04tE2ZMtG8oSByQ@mail.gmail.com>
Subject: Re: [PATCH][next] selftest/bpf: fix spelling mistake "SIGALARM" -> "SIGALRM"
To:     Yonghong Song <yhs@fb.com>
Cc:     Colin King <colin.king@canonical.com>,
        Shuah Khan <shuah@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, kernel-janitors@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 14, 2020 at 8:01 AM Yonghong Song <yhs@fb.com> wrote:
>
>
>
> On 5/14/20 5:15 AM, Colin King wrote:
> > From: Colin Ian King <colin.king@canonical.com>
> >
> > There is a spelling mistake in an error message, fix it.
> >
> > Signed-off-by: Colin Ian King <colin.king@canonical.com>
> Acked-by: Yonghong Song <yhs@fb.com>

Applied. Thanks
