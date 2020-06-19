Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 80D521FFFAB
	for <lists+netdev@lfdr.de>; Fri, 19 Jun 2020 03:31:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730277AbgFSBal (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Jun 2020 21:30:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727045AbgFSBaj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Jun 2020 21:30:39 -0400
Received: from mail-io1-xd30.google.com (mail-io1-xd30.google.com [IPv6:2607:f8b0:4864:20::d30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0EC42C06174E
        for <netdev@vger.kernel.org>; Thu, 18 Jun 2020 18:30:37 -0700 (PDT)
Received: by mail-io1-xd30.google.com with SMTP id t9so9440672ioj.13
        for <netdev@vger.kernel.org>; Thu, 18 Jun 2020 18:30:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=IldwTwJCpq4wCvITuBrNOaV5+KoKVBhlQjwPCBSqlvo=;
        b=Kg5pQ/LmvicG/ph00qE7TStfSMGtKQSe2UjeZV7RUM277ypJBSG02LumD2Y7IR34o0
         7aEMv1wScPT8YRw5P5aaXwLksI9MF5KnP2ABOglJ4j2/TYmcinBQRSK+DOXQD+ReIIU+
         8aiiKVooxSc5WbOLCZd6aHNkRM/0HKNxWUVQBjv8WmiCQ5OiUwY6hocFi4OE0QEfQK+0
         7pOZ4BWn7Tao3EQBvvH1yEss7wHL7qpjr7Ry2zCgEZmcWK1rHi0N9eIqQ3LfhQD6Jqp0
         0MFZtMQJEENbo8KUp5Pj21sKeIFgDMjHSjDynHPlyyw5hsWfmLhaxYr+WOZ9RS4hWrmG
         WcTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=IldwTwJCpq4wCvITuBrNOaV5+KoKVBhlQjwPCBSqlvo=;
        b=rzD6ygC8BVLfUOHf6DGbgPiAgYi0lotpnU8yL1i2ji3S+dCdntH7CD+PP8VsAHs8FR
         0c3/yIcrJEMSJxYOHXlX/YcvTmXQqQDFIfYrmv8DDkt093yVv3RQwO81nQKujbj3iKQb
         EPRcarMTSxR9W+BHILaTD2da1s+6YZm2pq0PqxsblIxvzN7nHUdDSeUGqRr0oWSBpcQ1
         fPyYuupUO8cn7wSJRBT9ixKd7epukn1gYewXvRJPutDVZh7jP00f2LyPD9asL4eS+9p+
         FPY9lxaM8x/jr1muVS8rVZZE0qGJEvJ3U6cU+tkWA+a5UojHiWAq3+RlhIqe0ebDIwTZ
         LJyw==
X-Gm-Message-State: AOAM5322eF67Mz5WU7cVRZLSuOFPnttX16/BghOtV8VdJfahc3SXLVaf
        W8+K+QzAwZfOwc+ugp1inZ7dXvLQo94WSE97LrvN71vZ
X-Google-Smtp-Source: ABdhPJx7AYnnbYgnQZwXrjezclv3ddly+Az5CXAx7xkK3sSmU2PoHd5Fg3Tas1XOwR8tr5vSd+GpbjyJSOuqSRzid7w=
X-Received: by 2002:a5e:a705:: with SMTP id b5mr1772762iod.12.1592530234185;
 Thu, 18 Jun 2020 18:30:34 -0700 (PDT)
MIME-Version: 1.0
References: <d33998c7-f529-e1d1-31a5-626aa8dd44da@ibw.com.ni>
In-Reply-To: <d33998c7-f529-e1d1-31a5-626aa8dd44da@ibw.com.ni>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Thu, 18 Jun 2020 18:30:22 -0700
Message-ID: <CAM_iQpWa6KmiWv72YmB3ufR8Rw9RD9=PwLMamjOS6fSCM+zXbA@mail.gmail.com>
Subject: Re: RATE not being printed on tc -s class show dev XXXX
To:     "Roberto J. Blandino Cisneros" <roberto.blandino@ibw.com.ni>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 16, 2020 at 7:06 AM Roberto J. Blandino Cisneros
<roberto.blandino@ibw.com.ni> wrote:
> I am seing "rate 0bit".
>
> But installing from debian package iproute2 i got nothing so i decide to
> compile iproute2 using version 5.7.0
>
> But my output is the same as below:

You either need to enable /sys/module/sch_htb/parameters/htb_rate_est
or specify a rate estimator when you create your HTB class.

Thanks.
