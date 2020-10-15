Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED68A28EC0E
	for <lists+netdev@lfdr.de>; Thu, 15 Oct 2020 06:24:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728055AbgJOEYo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Oct 2020 00:24:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725208AbgJOEYo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Oct 2020 00:24:44 -0400
Received: from mail-io1-xd42.google.com (mail-io1-xd42.google.com [IPv6:2607:f8b0:4864:20::d42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA0E5C061755;
        Wed, 14 Oct 2020 21:24:43 -0700 (PDT)
Received: by mail-io1-xd42.google.com with SMTP id k6so2693594ior.2;
        Wed, 14 Oct 2020 21:24:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=oNcEJhw55ywRjfZAJbg+/DFo+lApYdVywIBdG/1c8/0=;
        b=DJEVufa/6EoZwA8g2RuS3VgMyVWvJ0LZhY+WwDDL4LAAWeMSc8AExtZDUDLHiQyUE5
         RiU7ePVOud+yYiQGlmTA7U30/+przU8y2144JLOpCSAegshcVGoFys4G2mCp3D1bVoJJ
         JBb3JI0excZlHyBPUfiOkzlulp8+7XftnjgWKVodsBNQa65P0Vu4OxstuBVop5beImWo
         f0xXduJALXa5dl8NDhJd5Nyz/Z4qEqqeYRFXhCGFtv1jS3+H/FfL7VXPr74uO9Fg5+zR
         c/6svrn6hzDNS0PUSrUR4WUzQlcfCkljH8RUI82NilReWN6iqR7kvjneOtMc/oVTPow7
         djvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=oNcEJhw55ywRjfZAJbg+/DFo+lApYdVywIBdG/1c8/0=;
        b=nIgWsmSIzgn1Z42YN0e5raHM1x+/GD5AqZn4mJEJHoiWyPbKMOZ9sSSImgO7qeLM6n
         zIMp8xocVnfGNzGujyGVEzYPn5YEyVhyCRjIt13CPA1mrp1cClgdJ8hMkL4OoFKgPKWV
         9lmCkISOizcnFed2bUEuMDpHH8ssi537q37MFGZWrA3nVm29YRKs/VSjD6eIBVsezfEB
         IJYj8j1hfNerosYa53pLKMqgBk3gpEyAnUxMT5VttjcI5IpTcco3KeahGLcR/fyDvWWo
         LZSKzXJlrAJ6yymyG7oWJyENWrAJRSEZOzbab+Nrcgsa2HpKm3Qy0xT5FEMl1JNZwr+4
         V3LA==
X-Gm-Message-State: AOAM532w1O6bLHXVBnLYDICza4fdEGyuHKwQ3Zfa1SPwGkYehmyQ+kYv
        12rdBvN6FsbWFEfCjjm5NAM=
X-Google-Smtp-Source: ABdhPJzq7YtqBRFf1tmr6M3ouAl5ssjK0l3oYpdDF6PaJkAh/QIAu9g2gqSOxayeK3fZcFFictJJpw==
X-Received: by 2002:a05:6602:2a42:: with SMTP id k2mr1927530iov.82.1602735883204;
        Wed, 14 Oct 2020 21:24:43 -0700 (PDT)
Received: from localhost ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id z15sm1432763ilb.73.2020.10.14.21.24.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Oct 2020 21:24:42 -0700 (PDT)
Date:   Wed, 14 Oct 2020 21:24:26 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Song Liu <songliubraving@fb.com>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Jiri Olsa <jolsa@kernel.org>
Cc:     Kernel Team <Kernel-team@fb.com>,
        "ast@kernel.org" <ast@kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "john.fastabend@gmail.com" <john.fastabend@gmail.com>,
        "kpsingh@chromium.org" <kpsingh@chromium.org>
Message-ID: <5f87cefaa8401_b7602084e@john-XPS-13-9370.notmuch>
In-Reply-To: <96F50C6A-1A46-441D-AAEE-A67D7D5A903D@fb.com>
References: <20201014043638.3770558-1-songliubraving@fb.com>
 <96F50C6A-1A46-441D-AAEE-A67D7D5A903D@fb.com>
Subject: Re: [PATCH bpf-next] selftests/bpf: fix compilation error in
 progs/profiler.inc.h
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Song Liu wrote:
> 
> 
> > On Oct 13, 2020, at 9:36 PM, Song Liu <songliubraving@fb.com> wrote:
> > 
> > Fix the following error when compiling selftests/bpf
> > 
> > progs/profiler.inc.h:246:5: error: redefinition of 'pids_cgrp_id' as different kind of symbol
> > 
> > pids_cgrp_id is used in cgroup code, and included in vmlinux.h. Fix the
> > error by renaming pids_cgrp_id as pids_cgroup_id.
> > 
> > Fixes: 03d4d13fab3f ("selftests/bpf: Add profiler test")
> > Signed-off-by: Song Liu <songliubraving@fb.com>
> 
> I forgot to mention
> 
> Reported-by: Jiri Olsa <jolsa@kernel.org>

Acked-by: John Fastabend <john.fastabend@gmail.com>
