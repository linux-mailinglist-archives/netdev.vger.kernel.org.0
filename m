Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 478D11C9904
	for <lists+netdev@lfdr.de>; Thu,  7 May 2020 20:12:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727825AbgEGSMT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 May 2020 14:12:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726367AbgEGSMT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 May 2020 14:12:19 -0400
Received: from mail-io1-xd44.google.com (mail-io1-xd44.google.com [IPv6:2607:f8b0:4864:20::d44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62FCAC05BD43;
        Thu,  7 May 2020 11:12:19 -0700 (PDT)
Received: by mail-io1-xd44.google.com with SMTP id 19so1469027ioz.10;
        Thu, 07 May 2020 11:12:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=bsfvRwYLZovAO0bUruxlGM77X2KCUAX81TV3jzfWFqE=;
        b=tBiB1iUj9gBySiYjAPn/Xp8wZi4+y130ES32MX5ZWOTfR5P1iG17HBo8gvKSecGxnC
         5BdPpHNdMR9v0+Eqk4R4IdVDdvFisSMCuLwV8W7F8H6VRlgXMS8x0uzbS9NWIXkXex7v
         2/9h0rkTzOhZHdh5rnqLfwyibhis4YaHz2+rGrPA3Z3spJsibUm4llhNDS0bxdz5iGqK
         8M1AQBIc5gB/px1/I/RALzYt6sWtOGfdOM7GPz+bJRLu8HzF93mQ/dyuKepYFO9SQBIh
         V1lKCcRMJLrm+VwTmYDnAfzgghgzFnZFY/v2BQZ+vH71JlzDn70DoeUK6A0F8qgDcDu1
         1qqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=bsfvRwYLZovAO0bUruxlGM77X2KCUAX81TV3jzfWFqE=;
        b=kBhZGYpaecDl9OGiYcMGaGixIiInDyv7woQkEp3CRzXJyHdg+o9aFdxyjs9AKFSuOw
         bKrhbVN2VxkIU0/h2XgMLCxCuwTK/WVKW4U+vqeRYbo4haqhV8//S782h2cZkJIfprIt
         4NwPhfi5ubiweBWc0Skn6/oOOnEGpNC2TsKOxvuMCyUuoOqBV1wtcetwYQ0Eq2rSnDSK
         Lrv6xHznaW1ttUFDiarwvDT17umMbn6zEnHyDXIqSCtUyaXEtEcntE+9v618KDLivWyW
         6dYIczoXFD0PzibukZHkst5NC0pk6gxYuD+krPOWgLnoRY8W2LqsoI/ytiA51Zeq3fJi
         df0Q==
X-Gm-Message-State: AGi0PubIQIfvJnRYZbEeVhaa5b9Qxydz5Nnbi65T77mj4bFFKp9WsiWy
        JTeF86W7/rC/rOnnXpG2NSA=
X-Google-Smtp-Source: APiQypKhCZlcqvrVRNBjm2QqQ8/03Xn8oIj0eLu3hCc6Co0ToPrz2JR+AEydWqvmmv6PvXtsgzJ0nA==
X-Received: by 2002:a6b:8dc2:: with SMTP id p185mr15441359iod.138.1588875138752;
        Thu, 07 May 2020 11:12:18 -0700 (PDT)
Received: from localhost ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id y70sm3053907ilk.47.2020.05.07.11.12.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 May 2020 11:12:17 -0700 (PDT)
Date:   Thu, 07 May 2020 11:12:10 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Jakub Sitnicki <jakub@cloudflare.com>,
        John Fastabend <john.fastabend@gmail.com>
Cc:     lmb@cloudflare.com, daniel@iogearbox.net, netdev@vger.kernel.org,
        bpf@vger.kernel.org, ast@kernel.org
Message-ID: <5eb44f7a39c81_22a22b23544285b8a@john-XPS-13-9370.notmuch>
In-Reply-To: <20200507123707.4b4a0fe1@toad>
References: <158871160668.7537.2576154513696580062.stgit@john-Precision-5820-Tower>
 <20200507123707.4b4a0fe1@toad>
Subject: Re: [bpf-next PATCH 00/10] bpf: selftests, test_sockmap improvements
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jakub Sitnicki wrote:
> On Tue, 05 May 2020 13:49:36 -0700
> John Fastabend <john.fastabend@gmail.com> wrote:
> 
> > Update test_sockmap to add ktls tests and in the process make output
> > easier to understand and reduce overall runtime significantly. Before
> > this series test_sockmap did a poor job of tracking sent bytes causing
> > the recv thread to wait for a timeout even though all expected bytes
> > had been received. Doing this many times causes significant delays.
> > Further, we did many redundant tests because the send/recv test we used
> > was not specific to the parameters we were testing. For example testing
> > a failure case that always fails many times with different send sizes
> > is mostly useless. If the test condition catches 10B in the kernel code
> > testing 100B, 1kB, 4kB, and so on is just noise.
> > 
> > The main motivation for this is to add ktls tests, the last patch. Until
> > now I have been running these locally but we haven't had them checked in
> > to selftests. And finally I'm hoping to get these pushed into the libbpf
> > test infrastructure so we can get more testing. For that to work we need
> > ability to white and blacklist tests based on kernel features so we add
> > that here as well.
> > 
> > The new output looks like this broken into test groups with subtest
> > counters,
> > 
> >  $ time sudo ./test_sockmap
> >  # 1/ 6  sockmap:txmsg test passthrough:OK
> >  # 2/ 6  sockmap:txmsg test redirect:OK
> >  ...
> >  #22/ 1 sockhash:txmsg test push/pop data:OK
> >  Pass: 22 Fail: 0
> > 
> >  real    0m9.790s
> >  user    0m0.093s
> >  sys     0m7.318s
> > 
> > The old output printed individual subtest and was rather noisy
> > 
> >  $ time sudo ./test_sockmap
> >  [TEST 0]: (1, 1, 1, sendmsg, pass,): PASS
> >  ...
> >  [TEST 823]: (16, 1, 100, sendpage, ... ,pop (1599,1609),): PASS
> >  Summary: 824 PASSED 0 FAILED 
> > 
> >  real    0m56.761s
> >  user    0m0.455s
> >  sys     0m31.757s
> > 
> > So we are able to reduce time from ~56s to ~10s. To recover older more
> > verbose output simply run with --verbose option. To whitelist and
> > blacklist tests use the new --whitelist and --blacklist flags added. For
> > example to run cork sockhash tests but only ones that don't have a receive
> > hang (used to test negative cases) we could do,
> > 
> >  $ ./test_sockmap --whitelist="cork" --blacklist="sockmap,hang"
> > 
> > ---
> 
> These are very nice improvements so thanks for putting time into it.
> 
> I run these whenever I touch sockmap, and they do currently take long to
> run, especially on 1 vCPU (which sometimes catches interesting bugs).
> 
> I've also ran before into the CLI quirks you've ironed out, like having
> to pass path to cgroup to get verbose output.
> 
> Feel free to add my:
> 
> Reviewed-by: Jakub Sitnicki <jakub@cloudflare.com>

Thanks will do. I'll push a v2 with the other comments addressed after bpf gets
synced into bpf-next.
