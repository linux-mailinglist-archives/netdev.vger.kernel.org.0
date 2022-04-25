Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2122A50ED0A
	for <lists+netdev@lfdr.de>; Tue, 26 Apr 2022 01:56:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237497AbiDYX7A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Apr 2022 19:59:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232853AbiDYX67 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Apr 2022 19:58:59 -0400
Received: from mail-vs1-xe2f.google.com (mail-vs1-xe2f.google.com [IPv6:2607:f8b0:4864:20::e2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73F3B34B98;
        Mon, 25 Apr 2022 16:55:54 -0700 (PDT)
Received: by mail-vs1-xe2f.google.com with SMTP id y74so7176713vsy.7;
        Mon, 25 Apr 2022 16:55:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Bv57S0OvM1aFezwJzyGZ87lOYSC5nBjuQM0tf53bOpU=;
        b=G8v6hbD41qZ2NtXy7HU1p3rgwYYUEUfh922IBRou3zGedeJK+qCRdNj1sksuxeS9c2
         6WA437rRDM8ngerjp5Fg2YZJmCRV9rD1JwFEpw+V4rsnieHSECxuKqb8WCPS1niYRw2H
         0HQw1VipNhwvydH3Wy+SCdI/kMsN23TzOqlFSbWxXf/YWA6giIzxmPyLHAr32B45jMs3
         pz/N1AVhDglAHo5jsC6jQl1gQF9ynGy9Nw0dh2FMmXL7qxS4VJUrFWe4N7B6bKBjkieT
         /eG609XzOuaDjwLOCOMYdE+3xSRwqkTHRfx0L1E3ShWJDC07YBl5vCATE9e50q3Dhic0
         VqXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Bv57S0OvM1aFezwJzyGZ87lOYSC5nBjuQM0tf53bOpU=;
        b=OYIg6Z/OkZR6B/WIIoOo4L9YWXK183G8GEzlv16UxT7X2N4Dv4xz+AR5Vy7xQYThYX
         h/KBvtWx/RNtBvPfMD5tnezlzit+5gGUBt7rOw0/zEhYBoWEvFHz3q1KvWyMMo+XkB1M
         UfVeiW+0XFgcRD0qLyxEkyy2aOCMz3DhqWWWwBi0fV21Oj4qrG2gAg3min3HiRWVxbPR
         iZeJR9Q6P+ecoL2lJE8DQtCOXmErIJdwS4wXU65rj1d7yzRBBQ5hW5I98tAmai5a4unX
         DDq8aFtQEOxh5jb8dNXGR0jDYtOwmhRxBfV/17mPgx7+ZnrgwH/t6TMu98qWzPs9z14c
         fZoQ==
X-Gm-Message-State: AOAM5309Mf7l0J6p8t7XqDZMWoGnpr4TWQ034XjBa9UK3tJVy7iDa/9W
        oPi2MbkvJUPCmCSXs7B887esM3ydWvIfkCBoI8c=
X-Google-Smtp-Source: ABdhPJwc9UboT1X21g0gaZewc07K8v+X9O7kYBV9FR/eYrLaTOVxkDbgp5pjw0F/6hSoxlyGHaMt0X9HPW8JeWkKeBo=
X-Received: by 2002:a05:6102:3346:b0:32a:837d:3bec with SMTP id
 j6-20020a056102334600b0032a837d3becmr6125916vse.69.1650930953620; Mon, 25 Apr
 2022 16:55:53 -0700 (PDT)
MIME-Version: 1.0
References: <20220407223629.21487-1-ricardo.martinez@linux.intel.com> <20220407223629.21487-14-ricardo.martinez@linux.intel.com>
In-Reply-To: <20220407223629.21487-14-ricardo.martinez@linux.intel.com>
From:   Sergey Ryazanov <ryazanov.s.a@gmail.com>
Date:   Tue, 26 Apr 2022 02:55:53 +0300
Message-ID: <CAHNKnsTsPxDFqrydq2VdTOU2BS4=J6_yTBA0--2kvwKYVL+SFw@mail.gmail.com>
Subject: Re: [PATCH net-next v6 13/13] net: wwan: t7xx: Add maintainers and documentation
To:     Ricardo Martinez <ricardo.martinez@linux.intel.com>
Cc:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Johannes Berg <johannes@sipsolutions.net>,
        Loic Poulain <loic.poulain@linaro.org>,
        M Chetan Kumar <m.chetan.kumar@intel.com>,
        chandrashekar.devegowda@intel.com,
        Intel Corporation <linuxwwan@intel.com>,
        chiranjeevi.rapolu@linux.intel.com,
        =?UTF-8?B?SGFpanVuIExpdSAo5YiY5rW35YabKQ==?= 
        <haijun.liu@mediatek.com>, amir.hanania@intel.com,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        dinesh.sharma@intel.com, eliot.lee@intel.com,
        ilpo.johannes.jarvinen@intel.com, moises.veleta@intel.com,
        pierre-louis.bossart@intel.com, muralidharan.sethuraman@intel.com,
        Soumya.Prakash.Mishra@intel.com, sreehari.kancharla@intel.com,
        madhusmita.sahu@intel.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 8, 2022 at 1:37 AM Ricardo Martinez
<ricardo.martinez@linux.intel.com> wrote:
> Adds maintainers and documentation for MediaTek t7xx 5G WWAN modem
> device driver.
>
> Signed-off-by: Ricardo Martinez <ricardo.martinez@linux.intel.com>
>
> From a WWAN framework perspective:
> Reviewed-by: Loic Poulain <loic.poulain@linaro.org>

Reviewed-by: Sergey Ryazanov <ryazanov.s.a@gmail.com>
