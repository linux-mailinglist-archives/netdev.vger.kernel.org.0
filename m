Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 03871638802
	for <lists+netdev@lfdr.de>; Fri, 25 Nov 2022 11:57:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229552AbiKYK5b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Nov 2022 05:57:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229538AbiKYK53 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Nov 2022 05:57:29 -0500
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73B2BF49
        for <netdev@vger.kernel.org>; Fri, 25 Nov 2022 02:57:27 -0800 (PST)
Received: by mail-ed1-x52b.google.com with SMTP id m19so4645400edj.8
        for <netdev@vger.kernel.org>; Fri, 25 Nov 2022 02:57:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=W9SNaL7uJ0YuklVo9C5zB6ecLm66pWeFN9g8kTnhchc=;
        b=A5WUQqaGMpXu9yqbxXIvxbhZ9W4Z2OYaifdaKVsZwFeG/Oe9ud92NOceCcAXuH9sjV
         Iz0vrq5Cm2jZLSjOK7RYMV/D/Q7xZKq1V1nGFeFkrlJ0kqzM2KPYOHzolwRXDh6S76Hm
         QR5hYvmJzxGQh0aVbCadKqE+tjjt7rZxuTZLpMUea9p9XQn9DiddGK9MJXn5eYcL/HxT
         0CTIkKQjLHVy0Kjr4iATJvjBDz7mQn+XJhr2Nk3HnW1YjJRIo7XarEBEdzx9Ge1bKXly
         wEJdqsi3CGUxgeN/ou5W+zcvKWgKI2N7ONelZQUWQ9HLlA786uy6OXmeHs82zsJ4ltgG
         /qkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=W9SNaL7uJ0YuklVo9C5zB6ecLm66pWeFN9g8kTnhchc=;
        b=nJpHxwNj+za8I/uGANrF4sYU6vqdwRZBriUJrgaiJvu0sbYM80WPL0/bP/t8vIRH+N
         w3tyLFA/l2MUpEqMPHCQLUsezbV4p+lIWmc4+cVGohxkvqY03dz6DTsAS6F15kDX6NsV
         QcuQ8FMCYGNbEL1YhL9/27DdjqlqgD6uO3oFFsKotJaznzSESqSrEo6morlOUzGeyrq6
         XPM88YZmSX2koLbe75SNJgH0LUY+82n+1iFSab9J10ye+mD2JCXzuRGLHfT51KnMS1FG
         17cEQPSjQjIPBRIkVlxzU1J4AY2qlIajauq3+EkQpH1MfIfnZXUXOEhInFvOQ3zQoajN
         L6jA==
X-Gm-Message-State: ANoB5pmnvK7a3J7k78RqwWiJEk+qqGMah9K5xSbwx4AxtpcP2t/RpPhA
        imzF1xrQEnO7mvsdcxGB3VwOnTcTMGrM3Q==
X-Google-Smtp-Source: AA0mqf7kUV8MYgwAY4RM0wCddDKZanrkSyoG7hJcPnCGOXXGp2WZ/dgpYUaaiHSAqz5MsTsFkIT7Cw==
X-Received: by 2002:a05:6402:5007:b0:44e:baab:54e7 with SMTP id p7-20020a056402500700b0044ebaab54e7mr17808266eda.265.1669373845778;
        Fri, 25 Nov 2022 02:57:25 -0800 (PST)
Received: from skbuf ([188.26.57.184])
        by smtp.gmail.com with ESMTPSA id kx20-20020a170907775400b00788c622fa2csm1417937ejc.135.2022.11.25.02.57.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Nov 2022 02:57:25 -0800 (PST)
Date:   Fri, 25 Nov 2022 12:57:15 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Piergiorgio Beruto <piergiorgio.beruto@gmail.com>
Cc:     netdev@vger.kernel.org
Subject: Re: stmmac compile error
Message-ID: <20221125105715.obo2vz6mkilmsva4@skbuf>
References: <Y4CK8n8AiwOOTRFJ@gvm01>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Y4CK8n8AiwOOTRFJ@gvm01>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Piergiorgio,

On Fri, Nov 25, 2022 at 10:29:22AM +0100, Piergiorgio Beruto wrote:
> Hello!
> I've just checked-out the latest changes from
> git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git/master
> commit b084f6cc3563faf4f4d16c98852c0c734fe18914
> 
> When compiling, I got the following error:
> 
> drivers/net/ethernet/stmicro/stmmac/stmmac_main.c: In function ‘stmmac_cmdline_opt’:
> drivers/net/ethernet/stmicro/stmmac/stmmac_main.c:7583:28: error: too many arguments to function ‘sysfs_streq’
>  7583 |                 } else if (sysfs_streq(opt, "pause:", 6)) {
>       |                            ^~~~~~~~~~~
> In file included from ./include/linux/bitmap.h:11,
>                  from ./include/linux/cpumask.h:12,
>                  from ./include/linux/smp.h:13,
>                  from ./include/linux/lockdep.h:14,
>                  from ./include/linux/mutex.h:17,
>                  from ./include/linux/notifier.h:14,
>                  from ./include/linux/clk.h:14,
>                  from drivers/net/ethernet/stmicro/stmmac/stmmac_main.c:17:
> ./include/linux/string.h:185:13: note: declared here
>   185 | extern bool sysfs_streq(const char *s1, const char *s2);
>       |             ^~~~~~~~~~~
> make[6]: *** [scripts/Makefile.build:250: drivers/net/ethernet/stmicro/stmmac/stmmac_main.o] Error 1
> 
> NOTE: I did not make any changes, it is a clean build.
> Anyone knows what this could be?
> 
> Thank you,
> Piergiorgio

That's pretty sad. Something went terribly wrong with the review process of this patch.
https://patchwork.kernel.org/project/netdevbpf/patch/202211222009239312149@zte.com.cn/
I've sent a revert here:
https://patchwork.kernel.org/project/netdevbpf/patch/20221125105304.3012153-1-vladimir.oltean@nxp.com/
