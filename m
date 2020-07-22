Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 17EBE228E6F
	for <lists+netdev@lfdr.de>; Wed, 22 Jul 2020 05:10:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731943AbgGVDKR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jul 2020 23:10:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731846AbgGVDKR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jul 2020 23:10:17 -0400
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C306C061794;
        Tue, 21 Jul 2020 20:10:17 -0700 (PDT)
Received: by mail-pj1-x1041.google.com with SMTP id o22so426163pjw.2;
        Tue, 21 Jul 2020 20:10:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=2gBvT+YIZWph6R5sz1Mzm8EtE/EDwKEAunOqRTotXyo=;
        b=q9RN/uqnI7m54W20WphAIPLxv7ob4CoSESjI6zwgl1jN1JoSJoH6jay7n6BGHS/UVs
         lyQibjJ0DoG1nI57ZndSvSpC3HQ190VTua9p7vZKR2uwzzq60lhrGegRyWv8Stpri2e/
         xLJesIQYH/A1bok2VBt0m2U7rn0/eDsDV36bg/arKrAEBXj7cc3xAtpXmSGtZnyOTZ3H
         Rt+XSKPXmUv30IU9KqagydgRTz8IRM4fLWvGVtUYFePc30GuvvrbKYSvQjLJOe7shlP4
         qIWcF9QHSo+w4jDOS3rIATUbqEigYlM/0XgQ4C2rljFpPb1Qv/J/yy7W/h0pqhgI9meS
         4vpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=2gBvT+YIZWph6R5sz1Mzm8EtE/EDwKEAunOqRTotXyo=;
        b=TaaAFouU3z8wLJYnYwgE2ZV8VujebS75lvS6mRSZIjKzFlTFZu1U8LTOl+1olR4Ovt
         igKHpqhfVObYTLjO+l1BvmPJa02x+M6NMSk7YO1FZdmcFWqDOGIb5Vo8++Pag9JUuYCQ
         AEz0kryLIosNMAE8eK9PJm7bYWNlKU4Lqad/8oZjXTGKz7k2P/Aac7OmqSO7k0QgWNsb
         gpAQ4k451Ev3ypCP73zZofP3o3IdWCsHdQ092i7eqleA+xIwpxwE6TWfTvUme9Kz5Qgy
         U6AhelxMrrlcUPR52Hc60BXZ0D0AmJ8IRE4ulQjH3Ds05DxqDvob2Lt1ijayZdYKFVtw
         cIeg==
X-Gm-Message-State: AOAM531jxUnuTCImPk2ev2mStBatVkAInrcgjATMwsLTq06vTvp92mTb
        hZzNULxLwOokW+ETilzDoyGdvYqUV2+zK0cWTZe07A==
X-Google-Smtp-Source: ABdhPJyv2GHk8TN/MZSFEiPFxK0gKt1FYX4Jq8haDv8r/hp4UrmdePuIrNMYy/LdEBZgWIs/FlAKNbdCmV1xeuCwCyM=
X-Received: by 2002:a17:90a:e48:: with SMTP id p8mr7807430pja.210.1595387416843;
 Tue, 21 Jul 2020 20:10:16 -0700 (PDT)
MIME-Version: 1.0
References: <20200716234433.6490-1-xie.he.0141@gmail.com> <20200721.183022.1464053417235565089.davem@davemloft.net>
In-Reply-To: <20200721.183022.1464053417235565089.davem@davemloft.net>
From:   Xie He <xie.he.0141@gmail.com>
Date:   Tue, 21 Jul 2020 20:10:05 -0700
Message-ID: <CAJht_EN8NNrCbN9B+_Axn=cPk7hXtE8nL8_h=UnRvqjJWNf0Bw@mail.gmail.com>
Subject: Re: [PATCH v2] drivers/net/wan/x25_asy: Fix to make it work
To:     David Miller <davem@davemloft.net>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Martin Schiller <ms@dev.tdt.de>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Linux X25 <linux-x25@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 21, 2020 at 6:30 PM -0700
David Miller <davem@davemloft.net> wrote:
>
> Applied, thank you.

Thank you so much, David!
