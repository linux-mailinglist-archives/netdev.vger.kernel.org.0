Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CD36E58E5DC
	for <lists+netdev@lfdr.de>; Wed, 10 Aug 2022 05:58:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229674AbiHJD51 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Aug 2022 23:57:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230513AbiHJD4v (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Aug 2022 23:56:51 -0400
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FED8183A4;
        Tue,  9 Aug 2022 20:56:50 -0700 (PDT)
Received: by mail-pf1-x431.google.com with SMTP id 130so12542181pfv.13;
        Tue, 09 Aug 2022 20:56:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc;
        bh=VbViPiMfYEo8YsJHLIxFOe8vL6Rq5IJv4yeCTON2bn0=;
        b=LtJYBCDz/z/nZlg9Q8qpy/FIKNCW9+23OttzYV+4ke6lubt5u2GZBh20KXuC+CP80N
         Gh7ypSCDjn/auZxIhN6O10SgZzd9GOqMwtvPq6R6FEqatQtD10E2EAp9qINvVuaqtKg4
         7ECwfa2CX4+prA9JCMELKwUxQKyj5Ahsbg2+kpMccJ7+szHL/7d1wCjhWVyjEAoaxLUF
         BJguzAfNUkfQ6XlQ0rd+FWG7UD8tGwYV4okJVlFWveAmrznTN8ssIBQ0qpty0qKYTWsU
         N9uvWBtvjXfVLR2imZgLbmIDruGO7EDIdjRiS5MKMdZ1nIep2lMaK2I01chasUQtY6Zy
         9YDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc;
        bh=VbViPiMfYEo8YsJHLIxFOe8vL6Rq5IJv4yeCTON2bn0=;
        b=z2L7Srq26hbk58ZsYyEoaX+1slSz0RbreXA7bJQsy9DivVhI8j+Mj7BW7RFLe+qmAa
         UdFwNhqluW/bzOUK0sBdP0WH6rUqwJTJ/ib4gRIrepojKILk/KaFsx7YSda0y7xBAcms
         OohTeV2RqyNknG3ZEFIPBlfKR9oMlhLP8+J4keUacYZ+JejJB638wo09XXYezSdyer0x
         J9538BtLm533AeJykj6S4M241Ed3iIJ4l2t0+iIuANvDndi7ZVRKxC2s6e1vS0S95pVC
         Kz0wGsHwPwm6+Dfj2JAff5UKGnzzLPqMbsMk9vJLHxs39HxScZJVSVvvuIEdQW0KFDeL
         V0AA==
X-Gm-Message-State: ACgBeo23SX84AxQhpvwT2/I1Gic0bxv8tuGu5obx4JelpzjzdXpaDJ9P
        6SIq7aBqglS/WGdOGRqhEbQ=
X-Google-Smtp-Source: AA6agR6VL0M0iJuauiW+AZPM/GFw2xXN2YCUH62y8MdtjS/5TiTtLlywRoRggvK46EYXbV9QfEWPJw==
X-Received: by 2002:a63:f545:0:b0:41d:f8cd:8a2a with SMTP id e5-20020a63f545000000b0041df8cd8a2amr779448pgk.572.1660103809743;
        Tue, 09 Aug 2022 20:56:49 -0700 (PDT)
Received: from Laptop-X1 ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id a67-20020a624d46000000b0052d8405bcd2sm675741pfb.163.2022.08.09.20.56.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Aug 2022 20:56:49 -0700 (PDT)
Date:   Wed, 10 Aug 2022 11:56:44 +0800
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     Jonathan Toppins <jtoppins@redhat.com>
Cc:     netdev@vger.kernel.org, Shuah Khan <shuah@kernel.org>,
        linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH net v2 1/2] selftests: include bonding tests into the
 kselftest infra
Message-ID: <YvMsfHf1HebcoQNp@Laptop-X1>
References: <cover.1660098382.git.jtoppins@redhat.com>
 <d7902978499da81c6fa8bc530d16e2f71f84c0f1.1660098382.git.jtoppins@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <d7902978499da81c6fa8bc530d16e2f71f84c0f1.1660098382.git.jtoppins@redhat.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 09, 2022 at 10:33:21PM -0400, Jonathan Toppins wrote:
> +++ b/tools/testing/selftests/drivers/net/bonding/bond-break-lacpdu-tx.sh
> @@ -0,0 +1,82 @@
> +#!/bin/sh
> +# SPDX-License-Identifier: GPL-2.0
> +
> +# Regression Test:
> +#   Verify LACPDUs get transmitted after setting the MAC address of
> +#   the bond.
> +#
> +# https://bugzilla.redhat.com/show_bug.cgi?id=2020773
> +#
> +#       +---------+
> +#       | fab-br0 |
> +#       +---------+
> +#            |
> +#       +---------+
> +#       |  fbond  |
> +#       +---------+
> +#        |       |
> +#    +------+ +------+
> +#    |veth1 | |veth2 |
> +#    +------+ +------+
> +#
> +# We use veths instead of physical interfaces
> +
> +set -e
> +#set -x

nit： maybe remove this debug comment when you post a new version?

Others looks good to me.

Thanks
Hangbin
