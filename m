Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B74CA50ECE0
	for <lists+netdev@lfdr.de>; Tue, 26 Apr 2022 01:52:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238263AbiDYXzn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Apr 2022 19:55:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229717AbiDYXzk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Apr 2022 19:55:40 -0400
Received: from mail-vk1-xa34.google.com (mail-vk1-xa34.google.com [IPv6:2607:f8b0:4864:20::a34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C520424BC;
        Mon, 25 Apr 2022 16:52:34 -0700 (PDT)
Received: by mail-vk1-xa34.google.com with SMTP id x9so1164747vke.4;
        Mon, 25 Apr 2022 16:52:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=kRi2wSV1gKOPCuawVWDR+a9p7KIRocgDlL0VVtXwYpU=;
        b=Qr9knCpTMeTtylfPWqjf6gQ5EtnDN3OZ8M/yuGiApKBoSj3wfPDD2JIUm/x2YX5tT5
         e30oLMFHo7Wgt+7tO7wByI/BbCjYsphCwMPDiVZJEV4sYom0Nbzy29bVPciw2h/2/BKq
         zqjKUxHV9kyvc8wApNddZcvQYX/NxDi+ZCilYX6j79/pns7lJJP07OESZNSbdGplh7V/
         4eORhtlUJfz5TNMcxGWFhF/PEmJiaDaOx8kA5XWAshktnxQyesKzlAQSbBmKW12ARnqk
         Zs0yp70xmsS3Hkark8XNLrjMCuYioVVOVvGOObaW+8Sq1GDQm5ulaNYBs+D6iiQOq35f
         vydg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=kRi2wSV1gKOPCuawVWDR+a9p7KIRocgDlL0VVtXwYpU=;
        b=i9fZCvPTDeim+PeISRAGQZmLynCE7JgOUzDG4t/SzE+I6zgp0nXetD4rUZGac9CyH5
         agzD0SnjlBAqPxJ/2ITjTRDvN+NqL+nixibzvuULrRSTzK9V9wczPnOIhqhzKMr5X1Xu
         B0FJuUZ9oWfv/GmP32i1J+7RpJOOeMbcK+1bLasKKPmXYMrZATgrPKTOH+np9bVGifYl
         YIyB65wkZKWPf47mACbuKtXzQLzemGWA/syeqhucs36QrqHluuXRW9y7oX5hurphSWP8
         Hnvy17T+d/WKsFbpqTUBnAkp6OPkFt1l3/hxucAutygd95tsNbk+omecv88j5PYENytu
         WNOg==
X-Gm-Message-State: AOAM530mxN6d6R9Y7iGAFQsY7+GTxPs/EoDGK1FV1+oJgW7g9lzA+2sV
        y05z3+SunR7FewM81EZJnLPTc2uWUfdnu0xfpdA=
X-Google-Smtp-Source: ABdhPJyo9XZLsZzD4ut0CC5UIeXTbNe2xGR9J5jqXAsvMif4WFNmt5TBlpmU3m+IC5xoLjLSaitx2woIl4b96hBCVE4=
X-Received: by 2002:a1f:9dca:0:b0:349:6bb2:1c1a with SMTP id
 g193-20020a1f9dca000000b003496bb21c1amr6056899vke.1.1650930754111; Mon, 25
 Apr 2022 16:52:34 -0700 (PDT)
MIME-Version: 1.0
References: <20220407223629.21487-1-ricardo.martinez@linux.intel.com> <20220407223629.21487-4-ricardo.martinez@linux.intel.com>
In-Reply-To: <20220407223629.21487-4-ricardo.martinez@linux.intel.com>
From:   Sergey Ryazanov <ryazanov.s.a@gmail.com>
Date:   Tue, 26 Apr 2022 02:52:33 +0300
Message-ID: <CAHNKnsTiXK++iY4nJLNSjF+U0phPfx=05Zb8EdyF4jjCkXGyyw@mail.gmail.com>
Subject: Re: [PATCH net-next v6 03/13] net: wwan: t7xx: Add core components
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
> Registers the t7xx device driver with the kernel. Setup all the core
> components: PCIe layer, Modem Host Cross Core Interface (MHCCIF),
> modem control operations, modem state machine, and build
> infrastructure.
>
> * PCIe layer code implements driver probe and removal.
> * MHCCIF provides interrupt channels to communicate events
>   such as handshake, PM and port enumeration.
> * Modem control implements the entry point for modem init,
>   reset and exit.
> * The modem status monitor is a state machine used by modem control
>   to complete initialization and stop. It is used also to propagate
>   exception events reported by other components.
>
> Signed-off-by: Haijun Liu <haijun.liu@mediatek.com>
> Signed-off-by: Chandrashekar Devegowda <chandrashekar.devegowda@intel.com>
> Co-developed-by: Ricardo Martinez <ricardo.martinez@linux.intel.com>
> Signed-off-by: Ricardo Martinez <ricardo.martinez@linux.intel.com>
>
> From a WWAN framework perspective:
> Reviewed-by: Loic Poulain <loic.poulain@linaro.org>

Reviewed-by: Sergey Ryazanov <ryazanov.s.a@gmail.com>
