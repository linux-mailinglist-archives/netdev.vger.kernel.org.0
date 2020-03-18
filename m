Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 24D3018960D
	for <lists+netdev@lfdr.de>; Wed, 18 Mar 2020 07:56:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727025AbgCRG4A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Mar 2020 02:56:00 -0400
Received: from mail-lf1-f65.google.com ([209.85.167.65]:37998 "EHLO
        mail-lf1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726553AbgCRG4A (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Mar 2020 02:56:00 -0400
Received: by mail-lf1-f65.google.com with SMTP id n13so17560844lfh.5;
        Tue, 17 Mar 2020 23:55:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=6y3t64Yd4j5RpirdwwhuwY7CC2uNQrHmAGAU1umYUmo=;
        b=pi8CyOJIltAD5ODitBIA4BO4EU9vUeOygVoJzBwfXRL0f+ORqjyOgpPcHbnwJJ0elG
         I5P/QfbVxpJGFXAKJFGu/UmpVAgF+akYOSOzTldXWlmPdHhdEEv2ORtEMZElsRHLOCLP
         OMXFhl8xAC2AR0qg373GEzzg2XszafzzkRetVnhrL7Zrd649mZj+4Akefvv5cUM3+nBu
         W6L7ryRZbP8zlFxc0SI5gqVSmd7CSquXLrJeu8N7lBLq9QdorC/9Grqjwo152tCFjIF5
         5yVjQOojhr55x7/eWVBGPjleJLF8pIBHZOBFfksOBSqW4R4oL1kEbe1AMPMnGCAJfmaK
         4gRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=6y3t64Yd4j5RpirdwwhuwY7CC2uNQrHmAGAU1umYUmo=;
        b=fra3xzChHbd7cjbUShYYXUnGcquRVCCzMf3cv8rcFc+3J8c2F7v6QsjaKgASjRmgKD
         G0i2vZVb4969CCnvm5y2W/FR8gRf9kcxZ2fgpK/pShAWmpiQ9YOuNgSW5794yVtzxgm4
         P4RQlp97krsCADCB+d4Qgoqm9TagXXuSp2MtttX1WSb4u9GI5SXxF5rNH20qNBmZ7Nms
         Ad6SiJJ/ga6GJi0hXel9K/7Q03h4I3B91x4lLI97F8LcgxQs2Z/P9jjEWYln5LVGBIu2
         uEYFfKtc03AHqega4sAEAI0yVtvGIft9xarNwJLggSofcsNMOabW3VAI3LBFFqYgTCXr
         ln0A==
X-Gm-Message-State: ANhLgQ0dfm+6k/C55VPyyHqq+1pHMNxich1aIKg5uAVMxK6K2ZojUqwR
        fBQckyIDhfUqfkw+FYpjase9qnhTYtxYe7LwzWcdxw==
X-Google-Smtp-Source: ADFU+vvqET6sGndnLrsIjtAg66Cx0m4SltXtlgu2dPuTgVXNvBhWpy+lREdvK4J1MyjoC5pUGOMvRke9Zkfo/51Y+1M=
X-Received: by 2002:a19:a401:: with SMTP id q1mr1884737lfc.157.1584514558253;
 Tue, 17 Mar 2020 23:55:58 -0700 (PDT)
MIME-Version: 1.0
References: <20200318003956.73573-1-pablo@netfilter.org>
In-Reply-To: <20200318003956.73573-1-pablo@netfilter.org>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Tue, 17 Mar 2020 20:55:46 -1000
Message-ID: <CAADnVQLWa-mAXB10OQoC+aDwpcrJc7e0Tr=z9uXBjB7dFjOvYQ@mail.gmail.com>
Subject: Re: [PATCH 00/29] Netfilter updates for net-next
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel <netfilter-devel@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Network Development <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 17, 2020 at 2:42 PM Pablo Neira Ayuso <pablo@netfilter.org> wrote:
>
>
> 15) Add new egress hook, from Lukas Wunner.

NACKed-by: Alexei Starovoitov <ast@kernel.org>
