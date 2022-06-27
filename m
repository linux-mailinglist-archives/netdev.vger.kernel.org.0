Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D3E8355CAE8
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 14:59:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233449AbiF0Kam (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jun 2022 06:30:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232441AbiF0Kal (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jun 2022 06:30:41 -0400
Received: from mail-qv1-xf2d.google.com (mail-qv1-xf2d.google.com [IPv6:2607:f8b0:4864:20::f2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36BA86261;
        Mon, 27 Jun 2022 03:30:39 -0700 (PDT)
Received: by mail-qv1-xf2d.google.com with SMTP id 89so14165695qvc.0;
        Mon, 27 Jun 2022 03:30:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=cZfAPaEvqTx34DnDPzb0WJHLTgfejH45gbcwnO/wivg=;
        b=G2l+hKTC3b/3VUqvEpG03cbAWnBPUCxVt0TElZyrlXe9sLwg2fGZr+Xbz7KNps23gX
         FUHqn/6nL6V+5PnjpOPvbU4+0MmRB82Um2XU44C0uYkdL/cw5EC6nUECFdLsKTNCSEIL
         TYiO7Zif4ZqUm3feIrFdS5VmRvbQcaaCtvnT2zdYqNg6RoAbf/rb6RLjUw4wzHMJvJJo
         FmbQ93mhlFAyaXF901/8R+aOozJuguPprdQpTYaYCVaftU/st+gZ+DjZ4DzPsSSYEcVo
         KBQi1zWKuk77SiLYtPDPK8cAa3OTSPMfBFrqeaP0+noIs6TO5oysc1G4glI+yYaHj6nx
         GIvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=cZfAPaEvqTx34DnDPzb0WJHLTgfejH45gbcwnO/wivg=;
        b=YcpWuWmC7AWCvvtsu8YSe61YPS/2vBbs9ohJQcxdK7gO9m/daWje/8CFZ6UD0uuIS/
         TqNRU8QSiyXMyITnunAIqMrHRz6hkW0XpZGUn3qYO5rfnONSMFfZMMI5tIfx/GojunuC
         yv2NWhDmw06EaTDSxU2gEpSv/9iNf0MhOXCa2d+fnxFcaK9Z4gJRl7PQoa3a10+32Sj8
         v4FMv5njJEPC3uQJC9HW3XPakB/uuutYNquntqtCMZAKBULsPouxYqRAUFnktocSsNc2
         o4L+pkYdy3x4tjv7+svpVerfSn6mXmZjQbIYjXETAC+iU3sWguTcWuwdL9GAMgVBRbkT
         fVCA==
X-Gm-Message-State: AJIora+8TfA0F3xzWX/FFhYGpCbd8gAfUaR64hakAfaaq+kUbU3kOCkm
        rAyjg0rCgckKrYNo1PAUlxOpgRUSTCo6ESsO9jM=
X-Google-Smtp-Source: AGRyM1voIwXZ4dMPnpLAqnCx3C8loYQQRTztZqdu3BPiOLJoENjZC+j0T+13kENmWdRQC8XyE5oler0toFCdYmPZk3w=
X-Received: by 2002:a05:622a:1791:b0:317:76d8:d17f with SMTP id
 s17-20020a05622a179100b0031776d8d17fmr8667214qtk.82.1656325838358; Mon, 27
 Jun 2022 03:30:38 -0700 (PDT)
MIME-Version: 1.0
References: <20220621135339.1269409-1-robimarko@gmail.com> <87o7yeo104.fsf@kernel.org>
In-Reply-To: <87o7yeo104.fsf@kernel.org>
From:   Robert Marko <robimarko@gmail.com>
Date:   Mon, 27 Jun 2022 12:30:27 +0200
Message-ID: <CAOX2RU4G-009qYZF7-LcCT9SCeAmj=v9Hdk+NU-nebq=fGdjBQ@mail.gmail.com>
Subject: Re: [PATCH 1/2] dt-bindings: net: wireless: ath11k: add new DT entry
 for board ID
To:     Kalle Valo <kvalo@kernel.org>
Cc:     davem@davemloft.net, Eric Dumazet <edumazet@google.com>,
        kuba@kernel.org, pabeni@redhat.com,
        Rob Herring <robh+dt@kernel.org>,
        krzysztof.kozlowski+dt@linaro.org, ath11k@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        Devicetree List <devicetree@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 27 Jun 2022 at 12:27, Kalle Valo <kvalo@kernel.org> wrote:
>
> Robert Marko <robimarko@gmail.com> writes:
>
> > bus + qmi-chip-id + qmi-board-id and optionally the variant are currently
> > used for identifying the correct board data file.
> >
> > This however is sometimes not enough as all of the IPQ8074 boards that I
> > have access to dont have the qmi-board-id properly fused and simply return
> > the default value of 0xFF.
> >
> > So, to provide the correct qmi-board-id add a new DT property that allows
> > the qmi-board-id to be overridden from DTS in cases where its not set.
> > This is what vendors have been doing in the stock firmwares that were
> > shipped on boards I have.
>
> What's wrong with using 0xff? Ie. something like this:
>
> bus=ahb,qmi-chip-id=0,qmi-board-id=255,variant=foo
>
> Or maybe even just skip qmi-board-id entirely if it's not supported? So
> that the board file string would be something like:
>
> bus=ahb,qmi-chip-id=0,variant=foo
>
> I really would like to avoid adding more DT properties unless it's
> absolutely critical.

Well, I suppose that due to the variant property we can avoid "correcting" the
qmi-board-id

Regards,
Robert
>
> --
> https://patchwork.kernel.org/project/linux-wireless/list/
>
> https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
