Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 181D71C98E6
	for <lists+netdev@lfdr.de>; Thu,  7 May 2020 20:11:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728372AbgEGSKe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 May 2020 14:10:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728261AbgEGSKc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 May 2020 14:10:32 -0400
Received: from mail-io1-xd44.google.com (mail-io1-xd44.google.com [IPv6:2607:f8b0:4864:20::d44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A67B9C05BD09;
        Thu,  7 May 2020 11:10:32 -0700 (PDT)
Received: by mail-io1-xd44.google.com with SMTP id y26so2313010ioj.2;
        Thu, 07 May 2020 11:10:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=Gd3RPRk/hJEPhKUzjU78kN4h+seKUcUFVx6IytlV+As=;
        b=VzoW3DZBILKoElYj2TEiHdQTkxBcm2wFCWzfQxfDcnHcGbLIuFDOP614l2Gr6xn8fB
         xz/EdTckE9mZZk/jvlAqKZ7D2htG042wmXkXnSROCKrcXo50BRDJ2UHoUkGTYiuGI96k
         wajd1ruNMW121S1UMTZS4eiGxpNZiGhBUizBufay+l1eb677FH8Z/3w9zAMzSOfga94F
         UcUiDZ5XTckeD9Ldbk1cEv24yNUKPz1huwYYWk9ghnfrIy/ON1bsy6nIONP/ipE6qTjY
         K+t2C1DEw/7uhDoTgxbNgs6GxGwEY7pSYUu/BJoXEZQIaAA2rzpD1sbzLpaAR6nnSMaf
         6Zeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=Gd3RPRk/hJEPhKUzjU78kN4h+seKUcUFVx6IytlV+As=;
        b=CmPeo3m/tU0TrfZDJzj/m5i/gGuZuqWVmlfFvYe/v8nOeHoV5TTyIk1YdWXS6Z9V0o
         MWT144zT6ypBiCFpnqVfKWJ++7sHqOo9Kui7Aep1HRAQDf/K2i+Q5m/Qyem/HsFOz2Rn
         QodMRxFuu2mhNg6nd9OyPMOSFvz7dT1fxGD9gu6A8T/Swo0XsWbvKz7553E9ohQIzt24
         iRwHvJl9h2i/YfG1M6Zpc30ywlD9RNYLcJNzfwogAfpxI+CblJJekPWfuLnJheakUm1L
         5Slf1No+mRWbKMZfJMt65/ld1A3kfbveFuY5mau09udAdeGeMBHttBqs+BzU0PwqjJOc
         1Pkg==
X-Gm-Message-State: AGi0PubxOj8nLj1noazA7Df6NNzyw49fL8kGG3NW8O13k5avPQyOhkwR
        glB2KhLKlflyAyY4pTFZy4o=
X-Google-Smtp-Source: APiQypLum2t/r+agPTzUNR0velxp46G4ahGjE1MBLJud7sWGcXmM1SsTWSh8zpljyqdp6297pWrQAg==
X-Received: by 2002:a02:6ccf:: with SMTP id w198mr14023160jab.8.1588875032098;
        Thu, 07 May 2020 11:10:32 -0700 (PDT)
Received: from localhost ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id s12sm3055951ill.82.2020.05.07.11.10.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 May 2020 11:10:31 -0700 (PDT)
Date:   Thu, 07 May 2020 11:10:25 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Jakub Sitnicki <jakub@cloudflare.com>,
        John Fastabend <john.fastabend@gmail.com>
Cc:     lmb@cloudflare.com, daniel@iogearbox.net, netdev@vger.kernel.org,
        bpf@vger.kernel.org, ast@kernel.org
Message-ID: <5eb44f11d1697_22a22b23544285b843@john-XPS-13-9370.notmuch>
In-Reply-To: <20200507102902.6b27705c@toad>
References: <158871160668.7537.2576154513696580062.stgit@john-Precision-5820-Tower>
 <158871183500.7537.4803419328947579658.stgit@john-Precision-5820-Tower>
 <20200507102902.6b27705c@toad>
Subject: Re: [bpf-next PATCH 03/10] bpf: selftests, sockmap test prog run
 without setting cgroup
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jakub Sitnicki wrote:
> On Tue, 05 May 2020 13:50:35 -0700
> John Fastabend <john.fastabend@gmail.com> wrote:
> 
> > Running test_sockmap with arguments to specify a test pattern requires
> > including a cgroup argument. Instead of requiring this if the option is
> > not provided create one
> > 
> > This is not used by selftest runs but I use it when I want to test a
> > specific test. Most useful when developing new code and/or tests.
> > 
> > Signed-off-by: John Fastabend <john.fastabend@gmail.com>
> > ---

[...]

> >  	if (!cg_fd) {
> > -		fprintf(stderr, "%s requires cgroup option: --cgroup <path>\n",
> > -			argv[0]);
> > -		return -1;
> > +		if (setup_cgroup_environment()) {
> > +			fprintf(stderr, "ERROR: cgroup env failed\n");
> > +			return -EINVAL;
> > +		}
> > +
> > +		cg_fd = create_and_get_cgroup(CG_PATH);
> > +		if (cg_fd < 0) {
> > +			fprintf(stderr,
> > +				"ERROR: (%i) open cg path failed: %s\n",
> > +				cg_fd, optarg);
> 
> Looks like you wanted to log strerror(errno) instead of optarg here.
> 
> > +			return cg_fd;
> > +		}

cut'n'paste error thanks.
