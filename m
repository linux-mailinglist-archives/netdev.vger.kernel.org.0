Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F0DD48643B
	for <lists+netdev@lfdr.de>; Thu,  6 Jan 2022 13:17:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238736AbiAFMQ7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jan 2022 07:16:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238768AbiAFMQ4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Jan 2022 07:16:56 -0500
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE641C0611FD
        for <netdev@vger.kernel.org>; Thu,  6 Jan 2022 04:16:55 -0800 (PST)
Received: by mail-pf1-x431.google.com with SMTP id p37so2373892pfh.4
        for <netdev@vger.kernel.org>; Thu, 06 Jan 2022 04:16:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:reply-to:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=o3D1ossyij/ab8MFWq1seI/hJqCrmxj6LVgRLn3c+14=;
        b=lij8R/kECcOo3bUbkijAuv0YuxHkfbHUhqeJbS4TCFZHVrkzX6sbLgjYsyW2YqSCB0
         +pfgRqa5sV9opSXfcTaDUI7b/ty91ugDT0HZI89Wr88EzdaskBn+Xkr2lemdzm51byM9
         zLPWtyVC4sjVTzyaecBlVgVLCOIJ4EzBcJ1EL/hlllLMf5chWYaw3Rl1T1L03zarPd90
         4pw4o7x4ePAYTae97KHMLTsekwDMuimRG4/SzK8ey9M2esAY72ZweglIFnLiN6ZtN7R4
         320BM1ZROsx5dfGGRl1u+u+R1zvUtxssf/EzI0H8ZyR9LW7prfHVCYzX7HSI1EtgvQKc
         mv3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:reply-to:from:date:message-id
         :subject:to:content-transfer-encoding;
        bh=o3D1ossyij/ab8MFWq1seI/hJqCrmxj6LVgRLn3c+14=;
        b=Og/zNYDstBb7NRWvDJIiouxAzkopZjHi+pthS6G/IWZ4OTuUKI9Ul0Xrnr1nX8KF3s
         cNLubxJHnm2FCAZdMAl/kdQ771x6umyOZYK0mk6aGd7F0fl1bOH0Nr8yCE7IESTZ2hAN
         svsmm/FsP9lFGZEsSNmVKcAipzSGz7APWwgmlqsQHuTQ861MZB4YOpoDDGWLVSUGdOi2
         JcD9OXdJE0lYCjZbm3WKVECtx3SqxWY/4c+FVfiq0MK26duozqPtK6RRb4jGs8jcspzz
         ptby52FN7h3wWTUQ63ureT6ZHnrSgNECT9L5nEWp6qzBnt71wr1GlzrtJtLyiZ2kbagJ
         L28A==
X-Gm-Message-State: AOAM532BFHru3DaJXDzTzKmPMMrHW9FiAsQdWNMc9SZI0IvelfXy0aQJ
        HZIcXfFLUgcdl28+7PDgkj+qpZpJhw7o0ml4Rw==
X-Google-Smtp-Source: ABdhPJxD6H8wUZVQO032f9DqTQU6mqCJP2CNgmBReyxRC7gA9IJApfrnxsJ0iU9kZRVw6PC6jxXyxiYo7lfsK5vuhq8=
X-Received: by 2002:a63:215e:: with SMTP id s30mr50943124pgm.474.1641471415147;
 Thu, 06 Jan 2022 04:16:55 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:a05:6a10:b74f:0:0:0:0 with HTTP; Thu, 6 Jan 2022 04:16:54
 -0800 (PST)
Reply-To: orlandomoris56@gmail.com
From:   orlando moris <officepost088@gmail.com>
Date:   Thu, 6 Jan 2022 12:16:54 +0000
Message-ID: <CAG_JqcePMcd+fqc1_SDg_5TuaJDEwovdfMYyUESJ77JesnZMjA@mail.gmail.com>
Subject: 
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: base64
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

0J/RgNGL0LLRltGC0LDQvdC90LUhINCf0LDQstC10LTQsNC80LvRj9C10LwsINGI0YLQviDQs9GN
0YLRiyDQu9GW0YHRgiwg0Y/QutGWINC/0YDRi9C50YjQvtGeINC90LAg0LLQsNGI0YMg0L/QsNGI
0YLQvtCy0YPRjg0K0YHQutGA0YvQvdGOLCDQvdC1INC3J9GP0Z7Qu9GP0LXRhtGG0LAg0L/QsNC8
0YvQu9C60LDQuSwg0LAg0LHRi9GeINGB0L/QtdGG0YvRj9C70YzQvdCwINCw0LTRgNCw0YHQsNCy
0LDQvdGLINCy0LDQvCDQtNC70Y8NCtGA0LDQt9Cz0LvRj9C00YMuINCjINC80Y/QvdC1INGR0YHR
htGMINC/0YDQsNC/0LDQvdC+0LLQsCDRniDQv9Cw0LzQtdGA0YsgKCQ3LjUwMC4wMDAuMDApINCw
0LQg0LzQsNC50LPQvg0K0L3Rj9Cx0L7QttGH0YvQutCwINC60LvRltC10L3RgtCwINGW0L3QttGL
0L3QtdGA0LAg0JrQsNGA0LvQsNGB0LAsINGP0LrRliDQvdC+0YHRltGG0Ywg0LDQtNC90L7Qu9GM
0LrQsNCy0LDQtSDRltC80Y8g0Lcg0LLQsNC80ZYsDQrRj9C60ZYg0L/RgNCw0YbQsNCy0LDRniDR
liDQttGL0Z4g0YLRg9GCLCDRgyDQm9C+0LzQtSDQotCw0LPQvi4g0JzQvtC5INC90Y/QsdC+0LbR
h9GL0Log0ZYg0YHRj9C8J9GPINC/0LDRgtGA0LDQv9GW0LvRliDRng0K0LDRntGC0LDQvNCw0LHR
ltC70YzQvdGD0Y4g0LDQstCw0YDRi9GOLCDRj9C60LDRjyDQt9Cw0LHRgNCw0LvQsCDRltGFINC2
0YvRhtGG0ZEgLiDQryDQt9Cy0Y/RgNGC0LDRjtGB0Y8g0LTQsCDQstCw0YEg0Y/QuiDQtNCwDQrQ
vdCw0LnQsdC70ZbQttGN0LnRiNCw0LPQsCDRgdCy0LDRj9C60LAg0L/QsNC80LXRgNC70LDQs9Cw
LCDQutCw0LEg0LLRiyDQvNCw0LPQu9GWINCw0YLRgNGL0LzQsNGG0Ywg0YHRgNC+0LTQutGWINC/
0LANCtC/0YDRjdGC0Y3QvdC30ZbRj9GFLiDQn9Cw0YHQu9GPINCy0LDRiNCw0LPQsCDRhdGD0YLQ
utCw0LPQsCDQsNC00LrQsNC30YMg0Y8g0L/QsNCy0LXQtNCw0LzQu9GOINCy0LDQvCDRgNGN0LbR
i9C80YsNCtCy0YvQutCw0L3QsNC90L3QtSDQs9GN0YLQsNCz0LAg0L/QsNCz0LDQtNC90LXQvdC9
0Y8uLCDQt9Cy0Y/QttGL0YbQtdGB0Y8g0YHQsCDQvNC90L7QuSDQv9CwINCz0Y3RgtCw0Lkg0Y3Q
u9C10LrRgtGA0L7QvdC90LDQuSDQv9C+0YjRhtC1DQoob3JsYW5kb21vcmlzNTZAZ21haWwuY29t
KQ0K
