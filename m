Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1642D481285
	for <lists+netdev@lfdr.de>; Wed, 29 Dec 2021 13:16:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235180AbhL2MQI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Dec 2021 07:16:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235711AbhL2MQI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Dec 2021 07:16:08 -0500
Received: from mail-yb1-xb41.google.com (mail-yb1-xb41.google.com [IPv6:2607:f8b0:4864:20::b41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2AA22C061574
        for <netdev@vger.kernel.org>; Wed, 29 Dec 2021 04:16:08 -0800 (PST)
Received: by mail-yb1-xb41.google.com with SMTP id y130so38041444ybe.8
        for <netdev@vger.kernel.org>; Wed, 29 Dec 2021 04:16:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:sender:from:date:message-id:subject:to;
        bh=PqeKwfGtry3Hm5mwkXDEHiRgHh6Y5S1ouypmzni3hLo=;
        b=QBSusZb1tJS2ijUx7KLftNcgvERir2xs0qA36vQFICXEyzgVLjJx83WKZOcQ33lhpg
         SxRi/zMzuVPqK9lmDErfpynGPzaxe2i1/hj+TL60jLZrLZh29hAp/yjT9lErVhg7Bwbh
         HvcLTswyFTIM6045u2ISdGHU0SceYUacdE3BAGUxX9UyOLmppwc1cgDa/FVeMDKFxTuB
         86XxkxSByYdS+YFnG1q5Jxp3ioIK/HsxGgZzdA3ZSjfrCdCqx7UFZGkG205TBiMvaqC1
         9mUpC6L2/Z63hhRPCrYNuQpxcqRAg9frRD2K4LY0LFmMi9YzIW0JZrQ3Vo92mfFJfAMG
         0xQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:sender:from:date:message-id:subject
         :to;
        bh=PqeKwfGtry3Hm5mwkXDEHiRgHh6Y5S1ouypmzni3hLo=;
        b=Oqkk5DNc1PQEcwAOKW8Vg6Ee/E+ILPhip95YWZfsoIFDTsFqOBRpIbkRyjyDEEa7HK
         FoSimJ9LF5mDAvfry4nYYRvzQIiJcknp7Suf6FFVz+f/QMIs00HpcEBL3yfDgdXDbd67
         iGuk8u7DY9TrAC45ePKmTQfLoO2DUEkEiyaGJucECeAVoaTqceRQbm97U47o4P+0UBkD
         2ku1bWS+rRfJtI1M6yxH04y1AdnRxAyMgNxSwj0TQ+YDGd5oPixV4HJB/e5ZuEaK1DLQ
         3B0yvQM6Kcqmd1RB6Fubl+AaU+UiijwVKRSVD1ds4WaBSyyoqfgjo4XgAOZbUfuBdhfD
         8lbQ==
X-Gm-Message-State: AOAM530fYiatX2t5UXu00pDjBHC7BFPT3GFoQyq/ZDaEIyYDO/lvkX+V
        jW+SGiuZkd2XQIw+JbpJZRDd2onRQHEz2fsKkGo=
X-Google-Smtp-Source: ABdhPJwP9vxpiNQ17Q5PTeQg1xuK9E1txfLrRL+tFqC7hkHN78WL88vKbj9cxWQAqWJreU0WoO4HAzM3o7xJt4htVU4=
X-Received: by 2002:a25:4c46:: with SMTP id z67mr32038290yba.28.1640780166739;
 Wed, 29 Dec 2021 04:16:06 -0800 (PST)
MIME-Version: 1.0
Sender: mrrnra.kabore@gmail.com
Received: by 2002:a05:7000:4882:0:0:0:0 with HTTP; Wed, 29 Dec 2021 04:16:06
 -0800 (PST)
From:   Anderson Thereza <anderson.thereza24@gmail.com>
Date:   Wed, 29 Dec 2021 04:16:06 -0800
X-Google-Sender-Auth: oHLduzl95qTHsf7agbqZbJknFmk
Message-ID: <CAObd1coErp_85aSh-hNLdGMXRqoBp4AFaEJLmb0uvuBqZJWbjw@mail.gmail.com>
Subject: Re: Greetings My Dear,
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Greetings,

I sent this mail praying it will find you in a good condition, since I
myself am in a very critical health condition in which I sleep every
night without knowing if I may be alive to see the next day. I am
Mrs.Theresa Anderson, a widow suffering from a long time illness. I
have some funds I inherited from my late husband, the sum of
($11,000,000.00, Eleven Million Dollars) my Doctor told me recently
that I have serious sickness which is a cancer problem. What disturbs
me most is my stroke sickness. Having known my condition, I decided to
donate this fund to a good person that will utilize it the way I am
going to instruct herein. I need a very honest God.

fearing a person who can claim this money and use it for Charity
works, for orphanages, widows and also build schools for less
privileges that will be named after my late husband if possible and to
promote the word of God and the effort that the house of God is
maintained. I do not want a situation where this money will be used in
an ungodly manner. That's why I' making this decision. I'm not afraid
of death so I know where I'm going. I accept this decision because I
do not have any child who will inherit this money after I die. Please
I want your sincere and urgent answer to know if you will be able to
execute this project, and I will give you more information on how the
fund will be transferred to your bank account. I am waiting for your
reply.

May God Bless you,
Mrs.Theresa Anderson,
