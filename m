Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 993BE22894B
	for <lists+netdev@lfdr.de>; Tue, 21 Jul 2020 21:37:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730954AbgGUThj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jul 2020 15:37:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729928AbgGUThj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jul 2020 15:37:39 -0400
Received: from mail-lf1-x141.google.com (mail-lf1-x141.google.com [IPv6:2a00:1450:4864:20::141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37843C061794;
        Tue, 21 Jul 2020 12:37:39 -0700 (PDT)
Received: by mail-lf1-x141.google.com with SMTP id j21so12339115lfe.6;
        Tue, 21 Jul 2020 12:37:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=YFe/cnF6IWymsJvaBr7Rz532BIQMr/Guh/gr0Ej7rFA=;
        b=EiWwl/ZJVJSw5uJP+hlz/84wyq6p5lHDpXjtUf8HdH4VVqqvUp380SUhUkBEasYn8f
         Sv5bzKq1DFddMaA3y3t4AdxS9JgUv+q3tv0u93oA9Tx89TLaiP96DdaqWaxLg8HsImjm
         ZKP335LlIDGWRbu+4VpWHfEv6UrntLtGf7KdEwwyf9V/VxM1xWSUF2C12cHzorgdCHFU
         uNrPmpEOWl9d/kUVSLzkhiEGfDh2HVSLwT2l12i1AmNjdSno0FUXQfSRBZeHXxAJvd2y
         6EE34lHsy9sny0XYQETflSrGgVrFV394iWfhMNR74qoXcDeHIFHolo9BSmtziujiFR/P
         yy2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=YFe/cnF6IWymsJvaBr7Rz532BIQMr/Guh/gr0Ej7rFA=;
        b=SmYEuqGsKK5mAH9vwRKamM65cSkcdNpFZYqpMbhQ1nwCOxkipJEXblxKn3j0eof2wC
         A3Xrt9sB9xrLo3HhMQmuleKqGUa3fgTLEbjbSqUQ7qxmgi9xlC8N4R2DwNRZjaKQardj
         Xl+PgySY8NMoSwYnL8hDfH6d5pZFf7SSSShfbkilupcyi3DrlUZ5mIW9jXDOkra8Xxr4
         mqWaVX45wyWh48am17VkJ57mFdq3S9znQRYS6lBTGMhnsCp/zErxxLLxBt13r5pNeh65
         w7iN8LyBlnjek7qUlsaAeDLwi36XyLgXiFEGCbpLw6fnhwjx+N4DZpA71PRZ8kbXoiL3
         ffZA==
X-Gm-Message-State: AOAM5301k2uWYLFdFL3cJdhjXP0PX9IvW9mtgEUg1cxySidsHm3ta3eq
        O9Ie4oNwvOG179CENNlm5LcVkh2Pw8iyZGH7UtI=
X-Google-Smtp-Source: ABdhPJx4ivdP5Wajkfg46Hiy3ATK3fqQBPvLzqy4CcAfp69aSM0zDy6XeMm/2mCcL340EFjK3FfL1sarfW3/jdD0Ifg=
X-Received: by 2002:ac2:5f48:: with SMTP id 8mr816590lfz.157.1595360257682;
 Tue, 21 Jul 2020 12:37:37 -0700 (PDT)
MIME-Version: 1.0
References: <20200718004122.37775-1-cneirabustos@gmail.com> <20200718004940.GA38154@bpf-dev>
In-Reply-To: <20200718004940.GA38154@bpf-dev>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Tue, 21 Jul 2020 12:37:26 -0700
Message-ID: <CAADnVQLysBYX=zR_kHJgjL6LzKKsb8moYyyRuTAKmYc4rargaA@mail.gmail.com>
Subject: Re: [PATCH v3] folds tests from test_current_pid_tgid_new_ns into test_progs.
To:     Carlos Antonio Neira Bustos <cneirabustos@gmail.com>
Cc:     Network Development <netdev@vger.kernel.org>,
        Yonghong Song <yhs@fb.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 17, 2020 at 5:50 PM Carlos Antonio Neira Bustos
<cneirabustos@gmail.com> wrote:
>
> My last email was missing what changed from V2.
> Changes from V2:
>  - Test that does not create a new namespace has been included in test_progs
>  - Test creating a new pid namespace is a standalone test.
>  - Skeleton is used in both tests.
>
> On Fri, Jul 17, 2020 at 08:41:22PM -0400, Carlos Neira wrote:
> > Signed-off-by: Carlos Neira <cneirabustos@gmail.com>

Please resubmit with proper subject and proper commit log.
