Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 487181C6297
	for <lists+netdev@lfdr.de>; Tue,  5 May 2020 23:04:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728737AbgEEVEZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 May 2020 17:04:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726350AbgEEVEY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 May 2020 17:04:24 -0400
Received: from mail-il1-x12b.google.com (mail-il1-x12b.google.com [IPv6:2607:f8b0:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF9E8C061A0F;
        Tue,  5 May 2020 14:04:24 -0700 (PDT)
Received: by mail-il1-x12b.google.com with SMTP id i16so3641717ils.12;
        Tue, 05 May 2020 14:04:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=qiuUzqE2/f03i/K+IuMMf4ZJk9FsxvsEXkqwsChJdM0=;
        b=oeqrtzGY0YOPRKIAVa1B8AjQyMjtQwkElMLhenAmG5dxGK5XQYzevAN5wq/Ah0CYic
         G7MtwSdM4HgTfj9Go1JUlCmlMQI4FCV2b3FIf4UnAbY63/m8w1Z+h3gRztGyayZl0ddR
         606LfWLu75BoUB6w8mp02mAySD7dyA5AeqIA/wPAj2/I0FWqeeEf1E/wrP6kss9T/mRo
         VaXt7v0+cKgBAY3bT1KX0mpHfnmAhU/7yHc34bV5ZVaYLlCd0/M1wtCJ7a3gdbsaxW4z
         BV/avLfdvAmnbdhZlyEYVSr2Iapw5Ee/EeBGVXRR419h8Qb6LOxNfq4CfQa4XRq1a28m
         px+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=qiuUzqE2/f03i/K+IuMMf4ZJk9FsxvsEXkqwsChJdM0=;
        b=s8yVaFKXa6JXc/AIOolZwTmtL6v/CoS7INrQcYmH9IeheX40ymDh7D5XdIfZOQ4rJR
         afPIyeQng3hCb1fzmEZ3d02raHTRLNuLY3TZtULAwRBndrhHaaSu0f5Ij0AJ748prowl
         jpcuvpU/NDHhcChIxMGgmyEG7+7WadTQHuxNcC+mnMbmkKN9NukmJ+utK3hvvldqjHig
         xPism0u7lB0SvYjl+wi+H4dda7CFt3nTC5IljqHrlaf6nxKlvMKFdA7CizN/4IqsiElI
         EB/U5UaK7tsasWQ0oqLk4foTaXuLhGUvsiVjA2TqSnGdxX8gfgbzcMxtZMmleXPV/WRB
         eBgQ==
X-Gm-Message-State: AGi0PuYfs+9pwACWDikMLwPKJdo+vkm7w1zp+lqfvgchh9KjssdTkxPy
        YqbrnJPdTZTflEvhbA+n6e4=
X-Google-Smtp-Source: APiQypIG7D2i88sHlf04V5FJ/cLLW1eMZ/wNFw3JWarzwT1flwFVlZv2KmfPJVqYDMELesMnjht8eA==
X-Received: by 2002:a92:5b90:: with SMTP id c16mr5631224ilg.276.1588712664288;
        Tue, 05 May 2020 14:04:24 -0700 (PDT)
Received: from localhost ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id n138sm3136iod.21.2020.05.05.14.04.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 May 2020 14:04:23 -0700 (PDT)
Date:   Tue, 05 May 2020 14:04:15 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     John Fastabend <john.fastabend@gmail.com>, lmb@cloudflare.com,
        jakub@cloudflare.com, daniel@iogearbox.net
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        john.fastabend@gmail.com, ast@kernel.org
Message-ID: <5eb1d4cfefaa2_1f842ae2d2df25c094@john-XPS-13-9370.notmuch>
In-Reply-To: <158871160668.7537.2576154513696580062.stgit@john-Precision-5820-Tower>
References: <158871160668.7537.2576154513696580062.stgit@john-Precision-5820-Tower>
Subject: RE: [bpf-next PATCH 00/10] bpf: selftests, test_sockmap improvements
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

John Fastabend wrote:
> Update test_sockmap to add ktls tests and in the process make output
> easier to understand and reduce overall runtime significantly. Before
> this series test_sockmap did a poor job of tracking sent bytes causing
> the recv thread to wait for a timeout even though all expected bytes
> had been received. Doing this many times causes significant delays.
> Further, we did many redundant tests because the send/recv test we used
> was not specific to the parameters we were testing. For example testing
> a failure case that always fails many times with different send sizes
> is mostly useless. If the test condition catches 10B in the kernel code
> testing 100B, 1kB, 4kB, and so on is just noise.
> 
> The main motivation for this is to add ktls tests, the last patch. Until
> now I have been running these locally but we haven't had them checked in
> to selftests. And finally I'm hoping to get these pushed into the libbpf
> test infrastructure so we can get more testing. For that to work we need
> ability to white and blacklist tests based on kernel features so we add
> that here as well.
> 

I forgot to note this series needs to be merged after the series here,

 https://patchwork.ozlabs.org/project/netdev/list/?series=174562

Otherwise we may hit the error from that series in selftests. It should
be no problem to let the series sit on the list for a few days while
the above series gets into bpf-next but if you would prefer I can resubmit
later.

Thanks,
John
