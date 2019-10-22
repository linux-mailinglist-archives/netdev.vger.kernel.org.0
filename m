Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C530EE0D99
	for <lists+netdev@lfdr.de>; Tue, 22 Oct 2019 23:03:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731611AbfJVVDn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Oct 2019 17:03:43 -0400
Received: from mail-lf1-f66.google.com ([209.85.167.66]:46728 "EHLO
        mail-lf1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725874AbfJVVDn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Oct 2019 17:03:43 -0400
Received: by mail-lf1-f66.google.com with SMTP id t8so14215049lfc.13
        for <netdev@vger.kernel.org>; Tue, 22 Oct 2019 14:03:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=cRpQDSEjQlczYAoIQS/QqoOkNA1oJSQFhmT+5TdKaHw=;
        b=C0yNgRXLXSzIEJDysTvqwh3ofn/6c6fWsaypjNaPDK5pKVndUTnfk7MAjoGNji2I12
         qMMgdcMEU51y9w+mpDlalt5I1bgzA80ieOGjwypydRaSv30V/ewyn15TIYkJHr6wdE4l
         MppuMKCfIRucqb0kKnC+MniimPaITFdrwYmmSEFi0AxIdp8RXN06gJhpYi/aBai+fZkA
         styg21AnP14ZXcYnR2cfH+af2LxViaVm/J7keA6VvMfyvfEGmvwyH2OsJIkNm38xlPLj
         GIWV4H6YMQ8Fti2A/BKIY2ALcnR258p8sJ7t+AdLN3qtRuIXdChnBidASbw4qR0Or8by
         /J/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=cRpQDSEjQlczYAoIQS/QqoOkNA1oJSQFhmT+5TdKaHw=;
        b=Mj9ehQAAyYlkwTuauBWLTBTB5XkqkJ5bw4cBvZuRiUb1GjrhZCHT/HCHiu4XY0huSS
         Q8Af9kKAzUj9L2vbfXcI9Lohdfx8XllZGK2c3Cg3FN3wn7n0duXth5jzK4D505jh2glP
         sggwtocgTGG2xvaOMesH8gfvH4kiCt6HxRiAJYBuO18k9H6DLumGcRXkAQmyrNpNJl6i
         LQMeO4ewR9ilod8E3GfKX6jy81yMnxz2KqNVKuRGQ83ZMv6c2o4Q3b3gcfIL1//6wdS/
         fCOEvulvKKx4yhh1YjcmPblCw3LPDXcuxwOmZ2TLreaO+/DQgmNrByOT8M+arwnChnZI
         pQqA==
X-Gm-Message-State: APjAAAUabyEP41yWUnauIYb/JlaEVQmrUtDsBm3bLqLz1HHFDqlTaQWA
        ZtX/PbTflgf2mvigOyIa7j5liQ==
X-Google-Smtp-Source: APXvYqxhE74DX4bGzVY9J6zn6n7FIpIEbN/AT76ZxqpP9OkwWmSe8qy1QwsCwNG7YrxhwyTBD/fwBA==
X-Received: by 2002:ac2:43a3:: with SMTP id t3mr11566101lfl.121.1571778221169;
        Tue, 22 Oct 2019 14:03:41 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id u26sm8530872lfg.18.2019.10.22.14.03.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Oct 2019 14:03:40 -0700 (PDT)
Date:   Tue, 22 Oct 2019 14:03:32 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     David Ahern <dsahern@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        David Ahern <dsahern@gmail.com>,
        kernel test robot <rong.a.chen@intel.com>
Subject: Re: [PATCH net] selftests: Make l2tp.sh executable
Message-ID: <20191022140332.422279cc@cakuba.netronome.com>
In-Reply-To: <20191022010243.60916-1-dsahern@kernel.org>
References: <20191022010243.60916-1-dsahern@kernel.org>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 21 Oct 2019 19:02:43 -0600, David Ahern wrote:
> From: David Ahern <dsahern@gmail.com>
> 
> Kernel test robot reported that the l2tp.sh test script failed:
>     # selftests: net: l2tp.sh
>     # Warning: file l2tp.sh is not executable, correct this.
> 
> Set executable bits.
> 
> Fixes: e858ef1cd4bc ("selftests: Add l2tp tests")
> Reported-by: kernel test robot <rong.a.chen@intel.com>
> Signed-off-by: David Ahern <dsahern@gmail.com>

Looks like this one didn't make it into patchwork, perhaps because
there is no traditional diff?

Anyway, applied to net, thanks!
