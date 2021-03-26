Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8311E34A35C
	for <lists+netdev@lfdr.de>; Fri, 26 Mar 2021 09:46:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229871AbhCZIpk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Mar 2021 04:45:40 -0400
Received: from mout.kundenserver.de ([212.227.126.133]:36513 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229671AbhCZIpT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Mar 2021 04:45:19 -0400
Received: from mail-oi1-f180.google.com ([209.85.167.180]) by
 mrelayeu.kundenserver.de (mreue012 [213.165.67.97]) with ESMTPSA (Nemesis) id
 1N4vFE-1loyFd2PIq-010px0 for <netdev@vger.kernel.org>; Fri, 26 Mar 2021
 09:45:17 +0100
Received: by mail-oi1-f180.google.com with SMTP id x2so5026898oiv.2
        for <netdev@vger.kernel.org>; Fri, 26 Mar 2021 01:45:17 -0700 (PDT)
X-Gm-Message-State: AOAM532q59TCuXzjJHC12C9AYgvDQNuWHNFd8C1cUNb9bADFDb209F6H
        U2hJWtUdEUhrsQUAa+6MkWbn9iHPkuft1xSD0uo=
X-Google-Smtp-Source: ABdhPJxSlHUfTfAG6ImGqpKyfPjCxMkh4aNoBR2w5cs5eH6sZYpvapOuPLKS0zwt+f+fAswKs9kVV0d3ZoZvgYU9xAA=
X-Received: by 2002:aca:5945:: with SMTP id n66mr8764771oib.11.1616748316427;
 Fri, 26 Mar 2021 01:45:16 -0700 (PDT)
MIME-Version: 1.0
References: <20210326025345.456475-1-saeed@kernel.org> <20210326025345.456475-2-saeed@kernel.org>
In-Reply-To: <20210326025345.456475-2-saeed@kernel.org>
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Fri, 26 Mar 2021 09:45:01 +0100
X-Gmail-Original-Message-ID: <CAK8P3a0JPEUg7y7Jq-t7tDyMVWr+wqa8Hzf16K89sY-=eyHYvQ@mail.gmail.com>
Message-ID: <CAK8P3a0JPEUg7y7Jq-t7tDyMVWr+wqa8Hzf16K89sY-=eyHYvQ@mail.gmail.com>
Subject: Re: [net-next V2 01/13] net/mlx5e: alloc the correct size for indirection_rqt
To:     Saeed Mahameed <saeed@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Saeed Mahameed <saeedm@nvidia.com>
Content-Type: text/plain; charset="UTF-8"
X-Provags-ID: V03:K1:IpF1hC/12HBbvYHfviBb4FHn+yGfS5qTXwUU4Mk4VRlLPQAppTk
 B5Xfct0uFAc4ApHzH1vQXOKzVV7n7aWQhbnnnCSA1D145cGSsXt3m2rchSc2A8lE1tKpYMf
 ZSgF62hNDdd23kIkFyZmJILGP6lz7c4eYByzLDj08tm4MSnYIZng4wNpiKDOAHh3vfhMc3l
 Xp7m6CesbyooTVGyLCniQ==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:h/oXGB9T/sE=:xyCZeTlytsIcuXyYQINE0/
 sI9Cvp8b8G4nNWqRGdwJQAkr8649Tsj/rRgIiSOYnFPjVgiDi8IkgVdEv9BZvduJaOuk2bsTh
 oWin2GTLjJ26+jH4fjfpgiHd2itbckeiy+sJK5v5l28jg5ZWTx7Qz1UmF0K+NP0EEIuJ1xFov
 fLi05niFl9GHA+GCeUiXrur1VXYOYaeIC+Q1RsIFtGWfWEACL6PA/mVRF08AtjsTz/YBiuZqR
 vqLrekQmtPdulRrc0tcUahbpjNBtCo687w8KP/Lkp5fbfnuwWoIaCiUxdONMCJltOUmZUwLwy
 Kv9U8jHHo3PF/rAmbrX7anUKLEnqfBU4jOMcOggOJSrGLuXYnOqrQ4Yn4g0Hfl+e0ZE3ThFqa
 1oyssNPKQu4+S36G0FdpQykOS3EGpxBV6DV9oUkDtJ7NP9bC4OXuoLysilZ4M7OQGrI1TWYoJ
 IOtlyIQZcyPRSumiDlzFH1kLph0mOJ6viBHTiO5Q4Gf/bFZ4XYA84SUOL+IYnke8UXXVKrqV8
 CNra28v1sc6LowvBwCjoOeeEE/UZpqXcbS33RHzUJH/IOMdNZcV608zIepFkcL8NeFzbuykXk
 f8tCHYkxShvnu7p1ZV/rDJhwFl6b2B6Pln
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 26, 2021 at 3:53 AM Saeed Mahameed <saeed@kernel.org> wrote:
>
> From: Saeed Mahameed <saeedm@nvidia.com>
>
> The cited patch allocated the wrong size for the indirection_rqt table,
> fix that.
>
> Fixes: 2119bda642c4 ("net/mlx5e: allocate 'indirection_rqt' buffer dynamically")
> CC: Arnd Bergmann <arnd@arndb.de>
> Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>

Thanks for fixing my mistake

Acked-by: Arnd Bergmann <arnd@arndb.dew>
