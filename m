Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1BAA9628BC4
	for <lists+netdev@lfdr.de>; Mon, 14 Nov 2022 23:05:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236988AbiKNWFj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Nov 2022 17:05:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236124AbiKNWFi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Nov 2022 17:05:38 -0500
Received: from mail-lf1-x136.google.com (mail-lf1-x136.google.com [IPv6:2a00:1450:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D828645E;
        Mon, 14 Nov 2022 14:05:37 -0800 (PST)
Received: by mail-lf1-x136.google.com with SMTP id p8so21601316lfu.11;
        Mon, 14 Nov 2022 14:05:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=OvIKu8xYhgEpbqXECsNQ5zYgFCSscSAylV2o5sVbq4A=;
        b=XvZTor6KuexX5oMvV2vFohasI4/uU0LLUW82V/FUBd+vNsfEJGTDkwTViSioQX3e22
         vWYwRW1pT5ZOUy1hhvLEu2hudOt3JR12XKgwa8OVyVgAZriz2r6jmFs+75ZAqdJ90dhB
         aWXYkg7DzAaU7PS/ENvmag5ep/GVEdDNFeFDTF1ADH1NFQuuhB1cd6iOaMYJWIGWKnjo
         X9HGmHWoEYqOkQdDFZR2IFmVrxaPBQ5PAZKNVCvswtVoqWWHU9aLtZo2qnqrRHWgwuJ3
         1c1jifWgtzM0pDP2rK9ws/RRkH51Yu45pJtynUG4Zn7O6rppoUkcYKiUMZbtNz8YUyOK
         YHQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=OvIKu8xYhgEpbqXECsNQ5zYgFCSscSAylV2o5sVbq4A=;
        b=IcYVWUjfRipe2/1d0VIbK+CHP90wC3Mr8hce6tfX1+kTbZbNxYHceHr5W92dVUae/Y
         dcG9gqzc8KZ32CczZaFt6RVdepLmwBV+qyuQywJlSsfYmg+Dqf2LpuDDMaAdKxKLpaw1
         ufeD7PylI9Lt6E7+xHn1x0yrfe8N7MNae/AZZtztMzUz1KCQ7vPOBjwnWWvdp00MQlD8
         7QQH2EyaoYd7lFYWYZr+GO9PvwbTcu7kqpTdDX/oOvIXpD4F66QHScP9QKMGcUjP6rEP
         0Sj6AGlLD5bN95Dbh5d5UCrRCzevgk7VfIRdux28LB0ebo9V+FzPFjRu0IeNmBllESyW
         hA8A==
X-Gm-Message-State: ANoB5pmT+Hi0k2anbJNZ+RlE3EASrta52c3Eb2W8xW5aYoYD7+8+3bkm
        noOVlmzCtzi6k8GIF+1hYBaxP/XSSMWZCFwd7FE=
X-Google-Smtp-Source: AA0mqf6UE2R647BTGVfpuE9wrdHjinFcpncPaeNyxnyss9EIMKAtD683t+/1AfAr7s89vGjdPvHGNWy6TMeJKQg3DM8=
X-Received: by 2002:a19:2d48:0:b0:4a2:2d7b:838 with SMTP id
 t8-20020a192d48000000b004a22d7b0838mr4410510lft.251.1668463535758; Mon, 14
 Nov 2022 14:05:35 -0800 (PST)
MIME-Version: 1.0
References: <CAJNyHpJ7hbmDK-Tq==L1D3gWB2ac4MTVYynf57JM0GmEN9-i7Q@mail.gmail.com>
In-Reply-To: <CAJNyHpJ7hbmDK-Tq==L1D3gWB2ac4MTVYynf57JM0GmEN9-i7Q@mail.gmail.com>
From:   Luiz Augusto von Dentz <luiz.dentz@gmail.com>
Date:   Mon, 14 Nov 2022 14:05:24 -0800
Message-ID: <CABBYNZJ-BjuUcriLpNzs95SDqXP+_6-LJZ-t_00Q6ppy8qYg2Q@mail.gmail.com>
Subject: Re: L2CAP: Spec violation
To:     Sungwoo Kim <iam@sung-woo.kim>
Cc:     marcel@holtmann.org, johan.hedberg@gmail.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
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

Hi Kim,

On Fri, Nov 4, 2022 at 9:13 AM Sungwoo Kim <iam@sung-woo.kim> wrote:
>
> Hello,
>
> Our fuzzer found a BT spec violation, illegal state transition on L2cap.
> Specifically, l2cap_chan::state is transitioned from BT_CONFIG to
> BT_DISCONN by CONFIG_RSP by following trace:
>
> l2cap_config_rsp l2cap_core.c:4498
> l2cap_send_disconn_req l2cap_core.c:4585
> l2cap_state_change l2cap_core.c:1618
>
> According to the spec 5.3 vol.3 part A 6.1.4, CONFIG_RSP cannot cause
> that transition, i.e., CONFIG -> DISCONN by CONFIG_RSP is illegal.
> It'd be great if we could discuss.

Can you include some btmon traces?


-- 
Luiz Augusto von Dentz
