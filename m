Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E8FD52F893E
	for <lists+netdev@lfdr.de>; Sat, 16 Jan 2021 00:15:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727327AbhAOXOQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jan 2021 18:14:16 -0500
Received: from linux.microsoft.com ([13.77.154.182]:45550 "EHLO
        linux.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726176AbhAOXOP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jan 2021 18:14:15 -0500
Received: from mail-pj1-f50.google.com (mail-pj1-f50.google.com [209.85.216.50])
        by linux.microsoft.com (Postfix) with ESMTPSA id 9CBAD20B7192;
        Fri, 15 Jan 2021 15:13:34 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 9CBAD20B7192
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1610752414;
        bh=ZnnxvcbSW5Y/2t8bOhHfmWYOCev32IJP7Jbk+jU2aXc=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=kDbcJcyAsTfXDYkez6kiPURos70JY1gsWpSdsl/IWOjjIJq4vMSyYFYoXgjB/af0h
         VnOlwBTLlmDHgNq3oza+kdAg4hzSPfe2wiBcgsiI41I7mrkJgBbSmmsv4jWYRpHfVQ
         EzML4Nl16X0E+KEJhTeLKW6OWOvCR8g/wOPfHMCY=
Received: by mail-pj1-f50.google.com with SMTP id w1so6874419pjc.0;
        Fri, 15 Jan 2021 15:13:34 -0800 (PST)
X-Gm-Message-State: AOAM533BhrxhNB0+zlyjcvn9Uv/OwC6ELkDzVrXtWuA/8b3ZMVaR950E
        f3e2xeE9Z1IktQqnjruOnh7faBIiGDbUtekvXek=
X-Google-Smtp-Source: ABdhPJyyegYPTx667lZGDuFWWB3JOch82FMT0AMt/wubd4rCGHZk1Ad3x4T+XLaZqfbVDd+2p2PmPBhpDTP99HeJlyg=
X-Received: by 2002:a17:902:7d84:b029:db:feae:425e with SMTP id
 a4-20020a1709027d84b02900dbfeae425emr14761734plm.43.1610752414154; Fri, 15
 Jan 2021 15:13:34 -0800 (PST)
MIME-Version: 1.0
References: <20210115184209.78611-1-mcroce@linux.microsoft.com> <20210115145028.3cb6997f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210115145028.3cb6997f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Matteo Croce <mcroce@linux.microsoft.com>
Date:   Sat, 16 Jan 2021 00:12:58 +0100
X-Gmail-Original-Message-ID: <CAFnufp2DLgmO_paMoTGPUAGHbp9=hVgWR5UxmYbQQE=n642Ejw@mail.gmail.com>
Message-ID: <CAFnufp2DLgmO_paMoTGPUAGHbp9=hVgWR5UxmYbQQE=n642Ejw@mail.gmail.com>
Subject: Re: [PATCH net 0/2] ipv6: fixes for the multicast routes
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Thomas Graf <tgraf@suug.ch>, David Ahern <dsahern@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 15, 2021 at 11:50 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Fri, 15 Jan 2021 19:42:07 +0100 Matteo Croce wrote:
> > From: Matteo Croce <mcroce@microsoft.com>
> >
> > Fix two wrong flags in the IPv6 multicast routes created
> > by the autoconf code.
>
> Any chance for Fixes tags here?

Right.
For 1/2 I don't know exactly, that code was touched last time in
86872cb57925 ("[IPv6] route: FIB6 configuration using struct
fib6_config"), but it was only refactored. Before 86872cb57925, it was
pushed in the git import commit by Linus: 1da177e4c3f4
("Linux-2.6.12-rc2").
BTW, according the history repo, it entered the tree in the 2.4.0
import, so I'd say it's here since the beginning.

While for 2/2 I'd say:

Fixes: e8478e80e5a7 ("net/ipv6: Save route type in rt6_info")

-- 
per aspera ad upstream
