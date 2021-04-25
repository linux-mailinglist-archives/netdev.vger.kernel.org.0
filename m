Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 432C436A703
	for <lists+netdev@lfdr.de>; Sun, 25 Apr 2021 14:05:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230136AbhDYMGd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 25 Apr 2021 08:06:33 -0400
Received: from mail-yb1-f172.google.com ([209.85.219.172]:35643 "EHLO
        mail-yb1-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229659AbhDYMGc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 25 Apr 2021 08:06:32 -0400
Received: by mail-yb1-f172.google.com with SMTP id i4so23709654ybe.2;
        Sun, 25 Apr 2021 05:05:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ny7WbLjMQ4t7bzWSXAtRrXbQnCz5/PIPT3fCe4HvYk8=;
        b=PXJOBtgfCkYoZYfBZJDk27S+IBgXpnq3CW345ImH/20Nt3wUegF9RJMs6dhsMNw5bq
         ynLtC8pcJrXqU5VdTxtMIzq+82CGdL80VyAYwQv+GjnsdLqBUij3KGsUMcuLgMVcUG+i
         upKVwAyqxx/te/9Pw4a4BUkP2MQRKbQwmXU8C2Ab+cFLGlLXVoyIIWu/NNqsiFR9i9sA
         vufmkQcpC/5jfVBFMDglD2hy+uQLltztBwclm56ABjsycCHFowrfQ5bFPjiUCuXWkoh5
         GYuIKLMCvtNF1jKLSaMVOzy0SD5QA9aJQPqXV/dayVZrTco/a+G51ourSi1tvsOQrBA8
         DO/Q==
X-Gm-Message-State: AOAM530x1md5E0kB+AyzdNdiyMnA7s6rX3TL9wwL8AlC9IPFPNzdJQe4
        L5FfEHCb4yPDpsnL/HVyhfzvfMzkXpOFFCKsEBatd4PIJp8=
X-Google-Smtp-Source: ABdhPJyv2pA+UDuQDU7IQKAFqUjMAGBJPffErJyX6yWSovPs6jUg6YAvDTpiqwQt32+xkq7pPRXlPW9T6ReA/ui29GM=
X-Received: by 2002:a25:c696:: with SMTP id k144mr14734051ybf.307.1619352352695;
 Sun, 25 Apr 2021 05:05:52 -0700 (PDT)
MIME-Version: 1.0
References: <20210425090751.2jqj4yqx5ztyqhvg@pengutronix.de>
 <20210425095249.177588-1-erik@flodin.me> <CAAMKmodFEXj69mA2nHNfdtJYBTUR+sBpPc_2krm27oKUyVtqKA@mail.gmail.com>
In-Reply-To: <CAAMKmodFEXj69mA2nHNfdtJYBTUR+sBpPc_2krm27oKUyVtqKA@mail.gmail.com>
From:   Vincent MAILHOL <mailhol.vincent@wanadoo.fr>
Date:   Sun, 25 Apr 2021 21:05:41 +0900
Message-ID: <CAMZ6RqLdjYg49Sq3cp3dpseMMgTk+WoOvqXac=YuxdWas_xi7g@mail.gmail.com>
Subject: Re: [PATCH] can: proc: fix rcvlist_* header alignment on 64-bit system
To:     Erik Flodin <erik@flodin.me>
Cc:     Oliver Hartkopp <socketcan@hartkopp.net>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-can <linux-can@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun. 25 Apr 2021 at 20:40, Erik Flodin <erik@flodin.me> wrote:
>
> None of these versions are really grep friendly though. If that is
> needed, a third variant with two full strings can be used instead.
> Just let me know which one that's preferred.

Out of all the propositions, my favorite is the third variant
with two full strings.  It is optimal in terms of computing
time (not that this is a bottleneck...), it can be grepped and
the source code is easy to understand.
