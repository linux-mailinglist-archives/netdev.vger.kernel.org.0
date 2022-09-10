Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2B73B5B46FD
	for <lists+netdev@lfdr.de>; Sat, 10 Sep 2022 16:42:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229502AbiIJOmV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 10 Sep 2022 10:42:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229775AbiIJOmN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 10 Sep 2022 10:42:13 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0B4252DE5;
        Sat, 10 Sep 2022 07:41:59 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id q62-20020a17090a17c400b00202a3497516so1863557pja.1;
        Sat, 10 Sep 2022 07:41:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=PG/mGX8QEZuC06hyl49KKoZrNKlkAqfm0kcJIll2Hvc=;
        b=oQwc2UScYPQEEifKKEJjfJYQkpZTGK0kfdV7YZtSzZYH82e3ZaZln9ToVFXbVGxaqU
         N1cFGsvGMw83Wtz852PCwsEakgB3MBXASXBr7q+uXyT5PnKy/XHNhVkf8PM0bGv/DVlU
         zO9wYb70hhD0S2WIA3IKkWXPlhzc5BAf9mwO+DJuPsyI8wqTxcnlGKomcIvU6bcJJLQe
         P2kRdVTpNxl6NQGia+O99Oagavw0u026BnktisYak3x1P6F6DoTeHRGOCCLMi3+NGBIX
         M3zzk0Tt4HJG1OGMso8rYE8d9j32ca04IjUWXdTRDc7diO7bYpwj/4oJ0YARhMtyBvBb
         i25w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=PG/mGX8QEZuC06hyl49KKoZrNKlkAqfm0kcJIll2Hvc=;
        b=oxdPaysEoSrazM+Onw+YpA+Gmb4ORNlww0lzVJLNV6IEe4Xm7VUds1ug1opGid06Fs
         ORlATKTozz0dkuA4Snhx9uY+7+lANywo0VYsXqFu5BdHAmUZ2xLDzKm99TGLFYBhI0Mf
         raD7TBe1T1pUdidRufnVAt7Of/LFGj3pdSddhcDK51V+ew6d5zoH3i2bxxl7oKMtjhL0
         Dp2lUby0lAh9+6TIJp6W9Lo43f0vfskF+eEqMxxBF11ez8JhA2w/Y48mm/+1QWaxI1y3
         atZ/GSq51QpkpRp/F/N9D8kpSFnv1Gjm+DzSDNv5FGi+xdwCGi+3KfrwacntUjwNeLcm
         vC0g==
X-Gm-Message-State: ACgBeo0orZwkcCfmmXcDiVXtrL4PtWMkkqxw2H1Ls0iLoRdgU1NCavUw
        fe6pWhn/buZJfv8NRYh4TUUhdX12kiw=
X-Google-Smtp-Source: AA6agR7dF2pAwnWaOlIWl24pk7iOiXZnN5xW0n1ZG+DlK0nvuAyCmKY2QbmX0/UjSKdk/K1m3/M41g==
X-Received: by 2002:a17:902:7d86:b0:170:a752:cbd1 with SMTP id a6-20020a1709027d8600b00170a752cbd1mr18234845plm.17.1662820918939;
        Sat, 10 Sep 2022 07:41:58 -0700 (PDT)
Received: from hoboy.vegasvil.org ([2601:640:8200:33:e2d5:5eff:fea5:802f])
        by smtp.gmail.com with ESMTPSA id d8-20020a631d08000000b00434feb1841dsm2274505pgd.66.2022.09.10.07.41.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 10 Sep 2022 07:41:58 -0700 (PDT)
Date:   Sat, 10 Sep 2022 07:41:56 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     Naveen Mamindlapalli <naveenm@marvell.com>
Cc:     kuba@kernel.org, davem@davemloft.net, edumazet@google.com,
        pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, sgoutham@marvell.com,
        hkelam@marvell.com
Subject: Re: [net-next PATCH 0/4] Add PTP support for CN10K silicon
Message-ID: <YxyiNLh4/0jSStwc@hoboy.vegasvil.org>
References: <20220910075416.22887-1-naveenm@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220910075416.22887-1-naveenm@marvell.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Sep 10, 2022 at 01:24:12PM +0530, Naveen Mamindlapalli wrote:
> This patchset adds PTP support for CN10K silicon, specifically
> to workaround few hardware issues and to add 1-step mode.
> 
> Patchset overview:
> 
> Patch #1 returns correct ptp timestamp in nanoseconds captured
>          when external timestamp event occurs.
> 
> Patch #2 adds 1-step mode support.
> 
> Patch #3 implements software workaround to generate PPS output properly.
> 
> Patch #4 provides a software workaround for the rollover register default
>          value, which causes ptp to return the wrong timestamp.
> 
> Hariprasad Kelam (1):
>   octeontx2-pf: Add support for ptp 1-step mode on CN10K silicon
> 
> Naveen Mamindlapalli (3):
>   octeontx2-af: return correct ptp timestamp for CN10K silicon
>   octeontx2-af: Add PTP PPS Errata workaround on CN10K silicon
>   octeontx2-af: Initialize PTP_SEC_ROLLOVER register properly

For the series:

Acked-by: Richard Cochran <richardcochran@gmail.com>
