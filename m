Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9144D2806A6
	for <lists+netdev@lfdr.de>; Thu,  1 Oct 2020 20:33:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732643AbgJASdE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Oct 2020 14:33:04 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:21448 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730008AbgJASdE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Oct 2020 14:33:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1601577183;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=A30saAIR3YxcWA7P0bhHO0+t1Ec37MkrDxbuOWUzyS4=;
        b=B8+C0j0eff70ud9Q4D0DKwDbBx8hUjelzLeSHwb7XI2kaWOd+H90oj6Z4Q8U7KZB5lYJkD
        KihIQL4KiYDH2XUniHkbWM/cDg7fqXtqfEqQyQrU7dyEMrLpsfky+VZrTOrARKJp4JtSN1
        4VHcns7qLflJjjRzS1mFoAsCMttmm5Q=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-408-JH1UqoEbNnayi4bhWm_9qA-1; Thu, 01 Oct 2020 14:30:18 -0400
X-MC-Unique: JH1UqoEbNnayi4bhWm_9qA-1
Received: by mail-wr1-f72.google.com with SMTP id j7so2407645wro.14
        for <netdev@vger.kernel.org>; Thu, 01 Oct 2020 11:30:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=A30saAIR3YxcWA7P0bhHO0+t1Ec37MkrDxbuOWUzyS4=;
        b=BeLfiEpe2L9If0FUwmKUwH8a03KBn1b8FnoftGxpjtg2ThcmYwqbp1moSqKsOoHZSx
         9tSMwJWSx0NrlL8w1CIYr/rOSFD+ONI55m/5uhgc5ks5whVl8p+o0Am2738o9xKAvyF7
         mXRfPIy+0w5lBETgJVkkEiDDK9M6275tqlp45NPUBw2nUiCPGhmNpaVAPUjR/5z7f2b8
         qLehEQbIs4XCfy9ZRVIs84BbN75Dwi4hrRuocaQhHckJ/cxsu537pbX8wKyVWldoB3Hx
         cxvX1ROQerC4WuBY/ziYy7qqYjGR4oQP2DkOJlhApScoStgo0U5BkfdOn/XHH8OOQ52j
         oE8w==
X-Gm-Message-State: AOAM530PcjtBOL5vvCYiL3p8MiyIVqUrug3lPJ4Sh3TMraElXWvJh/Og
        ujAwvGlmBrzIKFzaBhRKa+0so3l0nqKwFd3NusVyppBNTsaaszZT9NfLp4q2L+z4BRjBcNiFlub
        hRHNhVCQPYU2dVJD7
X-Received: by 2002:a1c:6055:: with SMTP id u82mr1388395wmb.126.1601577017172;
        Thu, 01 Oct 2020 11:30:17 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJySc6x6UwskKVwVIo0nAaudFFkQz6xw2Bq9tFSoqIihr7ndt8Hw+olRL6PsBOBxA+bJxjdRHA==
X-Received: by 2002:a1c:6055:: with SMTP id u82mr1388372wmb.126.1601577016916;
        Thu, 01 Oct 2020 11:30:16 -0700 (PDT)
Received: from pc-2.home (2a01cb058d4f8400c9f0d639f7c74c26.ipv6.abo.wanadoo.fr. [2a01:cb05:8d4f:8400:c9f0:d639:f7c7:4c26])
        by smtp.gmail.com with ESMTPSA id 70sm1251268wmb.41.2020.10.01.11.30.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Oct 2020 11:30:16 -0700 (PDT)
Date:   Thu, 1 Oct 2020 20:30:14 +0200
From:   Guillaume Nault <gnault@redhat.com>
To:     Tom Parkin <tparkin@katalix.com>
Cc:     netdev@vger.kernel.org, jchapman@katalix.com
Subject: Re: [PATCH net-next 0/6] l2tp: add ac/pppoe driver
Message-ID: <20201001183014.GC14747@pc-2.home>
References: <20200930210707.10717-1-tparkin@katalix.com>
 <20201001122617.GA9528@pc-2.home>
 <20201001145728.GA4708@katalix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201001145728.GA4708@katalix.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 01, 2020 at 03:57:29PM +0100, Tom Parkin wrote:
> I'll wait on a little to let any other review comments come in, but
> if doing as you suggest is still the preferred approach I'll happily
> look at implementing it -- assuming you don't have a patch ready to go?

I unfortunately don't. All I saved from my previous ongoing L2TP and
PPP work is a (long) TODO list.

