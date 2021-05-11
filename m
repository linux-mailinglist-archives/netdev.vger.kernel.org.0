Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4293D37A85D
	for <lists+netdev@lfdr.de>; Tue, 11 May 2021 16:01:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231508AbhEKOCz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 May 2021 10:02:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231305AbhEKOCy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 May 2021 10:02:54 -0400
Received: from mail-qv1-xf31.google.com (mail-qv1-xf31.google.com [IPv6:2607:f8b0:4864:20::f31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22294C061574
        for <netdev@vger.kernel.org>; Tue, 11 May 2021 07:01:46 -0700 (PDT)
Received: by mail-qv1-xf31.google.com with SMTP id w9so10149821qvi.13
        for <netdev@vger.kernel.org>; Tue, 11 May 2021 07:01:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=coverfire.com; s=google;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=qQrmHIXjnXfQWJtbeZXpWntrZOfwSCQYMKOgToYP8RY=;
        b=T396vYFeyeH2mfE6IyQBYJ38lT3Ui2Zq67Smwbm/Z1g0PIbizMRKQ1uKlVX2eyxGTi
         JVwl3t6OTQP30yWJy0rQHZBNwfPOvOYo8uVeEMk03NAZ4L02t1ce6mTmSHMK9fRSI9ti
         F5bjVfWAV3jujBEdvaQ5MK63pNTlEEGAAqro2fyiOuCcpuVqHRVsq48T9ImHZ06kMAXB
         Bjhns7yE/acr5tu/08irFjl7qAzH8l+8+PmcX+Hg0NesEAV3ax/4sLSOjJMEDCctRwid
         2sNlTowaBrOp1DEuG+DXwJVfLK1WDvH7rHtx2/ghDjxVFM39MBOKGzdJcWsjLNFhJuAU
         QHiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=qQrmHIXjnXfQWJtbeZXpWntrZOfwSCQYMKOgToYP8RY=;
        b=ro9u6mGHnGBB+XXNvOfVArmneV81EC8fHdr1O0UGeC+j3enzAzdT7Ou+44KyhwUaf2
         FPlO/sJmGgE6CLA+FydPbz0MPPJs20z8RUNdcjUxjVRm5BQzzKjOWnl7N4x9tps/5+02
         Ur/EXSIwLzk05Mq7Z+x0DKFBzZrihquBmRkfipL7bSzQy2rPd1UHWGJCtmMLBgFAy1ig
         aWJEwtz7M/wPLmLSXOCXEvnUH3ATVNlSqlRb5Tj5rjtw79pYvbxIQ3mtxJJ3KYN3Fhbq
         DZ43VdCXszaMMsuOjSwiDeAr/Drx3IV/qGL0+nbKGwwam+5LR6nLVNEbK1NF/x3hzdoT
         aIqA==
X-Gm-Message-State: AOAM531xkx9yPwzXaXeMiSpQvhWE62S9AFcntRiiGhQgk4C8BrRE1P5V
        9vqJj5vn4gBtE0SLPx3jtkenWA==
X-Google-Smtp-Source: ABdhPJxytzBaKMGlPrwKBzJjDMzkAtcbYORowCXBnr0UKZ1P/EsTeNA7ml4BMiAqfrET7ORua2iQqQ==
X-Received: by 2002:a0c:a483:: with SMTP id x3mr10389262qvx.28.1620741705351;
        Tue, 11 May 2021 07:01:45 -0700 (PDT)
Received: from ?IPv6:2607:f2c0:e56e:28c:e4de:d9eb:cc0b:f46a? ([2607:f2c0:e56e:28c:e4de:d9eb:cc0b:f46a])
        by smtp.gmail.com with ESMTPSA id r5sm13794415qtp.75.2021.05.11.07.01.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 May 2021 07:01:44 -0700 (PDT)
Message-ID: <a52430d1e11c5cadcd08706bd6d8da3ea48e1c04.camel@coverfire.com>
Subject: Re: xsk_buff_pool.c trace
From:   Dan Siemon <dan@coverfire.com>
To:     Magnus Karlsson <magnus.karlsson@gmail.com>
Cc:     Network Development <netdev@vger.kernel.org>,
        =?ISO-8859-1?Q?Bj=F6rn_T=F6pel?= <bjorn@kernel.org>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>
Date:   Tue, 11 May 2021 10:01:43 -0400
In-Reply-To: <CAJ8uoz1qKnJw+StSfuCkXuoS5-qOQA89HKjLzedh7LySBDUp1g@mail.gmail.com>
References: <52fdf0e0d9d453379df2163f16bdf12f425ef456.camel@coverfire.com>
         <CAJ8uoz1qKnJw+StSfuCkXuoS5-qOQA89HKjLzedh7LySBDUp1g@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.40.1 (3.40.1-1.fc34) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 2021-05-10 at 08:15 +0200, Magnus Karlsson wrote:
> On Mon, May 10, 2021 at 3:59 AM Dan Siemon <dan@coverfire.com> wrote:
> > 
> > i40e NIC with 5.11.17-300.fc34.x86_64
> > 
> > Unfortunately, this does not consistently occur.
> > 
> > [ 2739.991807] ------------[ cut here ]------------
> > [ 2739.996428] Failed to disable zero-copy!
> 
> Could you please dump the error value that i40e_xsk_pool_disable
> returns? Just so I have something more to go on. There are three
> functions that can fail, xsk_get_pool_from_qid(),
> i40e_queue_pair_disable(), and i40e_queue_pair_enable(). If you can
> dig even deeper into what sub function of those functions that fail,
> even better. It would be ideal, if you could enable a function trace
> when you get into i40e_xsk_pool_disable so we would know exactly what
> function fails.

Thank you for taking a look. Unfortunately, I haven't been able to make
this happen consistently. If I can, I will try your suggestions.
> 

