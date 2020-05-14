Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4DEBA1D404B
	for <lists+netdev@lfdr.de>; Thu, 14 May 2020 23:41:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727975AbgENVk4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 May 2020 17:40:56 -0400
Received: from mout.kundenserver.de ([212.227.17.24]:45707 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726332AbgENVkz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 May 2020 17:40:55 -0400
Received: from mail-qk1-f177.google.com ([209.85.222.177]) by
 mrelayeu.kundenserver.de (mreue108 [212.227.15.145]) with ESMTPSA (Nemesis)
 id 1M7sM0-1jVTiZ3pMA-004zA4; Thu, 14 May 2020 23:40:54 +0200
Received: by mail-qk1-f177.google.com with SMTP id y22so501809qki.3;
        Thu, 14 May 2020 14:40:53 -0700 (PDT)
X-Gm-Message-State: AOAM530M/0kPZXIUL8aESXZ3UWWXORPfPkzLNZ9ZqtpnZ9Th5kZ8Z/uw
        ILMb39YAVT1eVt+xFu+jaySDE+W07Q9+hHpwbLE=
X-Google-Smtp-Source: ABdhPJz3lFMXREcxWwfkvePMkAsRL2iQV9Tceu+/2iNpVvgU3Gbaj4sPdvLuSPlEUI5bUXpE0fcj2+Jo8E9UDNF0qB0=
X-Received: by 2002:a37:aa82:: with SMTP id t124mr416689qke.3.1589492452637;
 Thu, 14 May 2020 14:40:52 -0700 (PDT)
MIME-Version: 1.0
References: <20200514185147.19716-1-sashal@kernel.org> <20200514185147.19716-30-sashal@kernel.org>
In-Reply-To: <20200514185147.19716-30-sashal@kernel.org>
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Thu, 14 May 2020 23:40:36 +0200
X-Gmail-Original-Message-ID: <CAK8P3a1Yh-qeh_CCVQZFcT0JMvhoxHx72KUWf3FXYD4yk_ptTw@mail.gmail.com>
Message-ID: <CAK8P3a1Yh-qeh_CCVQZFcT0JMvhoxHx72KUWf3FXYD4yk_ptTw@mail.gmail.com>
Subject: Re: [PATCH AUTOSEL 5.6 30/62] net: Make PTP-specific drivers depend
 on PTP_1588_CLOCK
To:     Sasha Levin <sashal@kernel.org>
Cc:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "# 3.4.x" <stable@vger.kernel.org>,
        Clay McClure <clay@daemons.net>,
        Richard Cochran <richardcochran@gmail.com>,
        Nicolas Pitre <nico@fluxnic.net>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        "David S . Miller" <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Provags-ID: V03:K1:nin5AzYekkm5bPWobWWm0GFVgpxuVZwbicarE8x7omZt0TSiFz/
 E/1vtMJMLoLMfo4feiKcZHtgzxCia0xBXZzhlHPJnUP+qdGFxTuhguOS6U9ySTVChkQ+DRL
 UtmGSNooPHyHQvUzuuJiyXZpyZXjXm/mXi7Yuxx774olTWUDmNB5Qo7dWmIqxpUQsguZCHP
 UaPAvvbiSIfNlYQsBzXeQ==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:/Fq5p7z8AQM=:Kfb7TSD8E02CZdz+J4hBKQ
 aLVNJFoPT5D44Gq60BWHh60LbzHQYn6q5yzP2zg5CAP87FDKKpEFHRJlvLXrEKLWAygI3qP32
 WSSXUZJnnf8RXuNvl0QqUSFlrWte2pFRKBaMlDoeeSvCjM6+J1Jf9S+R8dI6ZanLVN5a0Sn5t
 DpZbP+Hx3i/uj6v7CN+GpLTB8W6V7A98zJOcq7ef8l3tk6RSWJRrhK0M4VHc5XgfnZEsTvjjR
 aR/dLSJbJ7vIcbkFR4UnoFSdt5gIcawY0gxARykVirVxRPMh4EdhmaqxHtUBpuMhgU58R24mF
 hxdXMkE+WcCJM+aSzmqYAuWn6RaEO9kgZSN7A8H/2AJUpavRuRiCQQbPrc3UuSHlZqzhdES5z
 Lo202yE5wPwBcziplkQv3rXGzRAKRMiMXUOOzQ4EsC2Dp4Q4iXx6mYIzJOw9J7PXHkr9EYYbI
 ttPTpRqXELclLb3yDhbaxU730p/jMezuES5AsvJEMFS+LVZUui57MdnGx4O/zMDlEMclgXTlg
 iGcIuRDRoGgalYSUA2C7pfjhSKxrBhMsxkWGy7PwBC17DIokojMHqs7kRTCXOUc7xzbsUEK8w
 c/Y/GVbux55G5dYq1z6CEfnC7z2i8ddL2QZ/OnasIwRjJ2XnwTzl/XNVUidnp8NwAH/HziD/4
 pkjgGpKJZKkRHa6UqWP7l11HWij6Sgx6b53AmpWru7wfcaakzIjB5PNagjZ/4DYfRXiUbb375
 qGT7edHkbHy4flRn/X36HDYob2aI7I+iFPbmGFSZWTemFQfjChMN/hkRhBRjgi0Q8NG+4NhQg
 dqxBcldDD/A2UqAAKIc9LiECPksZ1FZ6RhH+/G5Ci/C4NuPp3k=
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 14, 2020 at 8:52 PM Sasha Levin <sashal@kernel.org> wrote:
>
> From: Clay McClure <clay@daemons.net>
>
> [ Upstream commit b6d49cab44b567b3e0a5544b3d61e516a7355fad ]
>
> Commit d1cbfd771ce8 ("ptp_clock: Allow for it to be optional") changed
> all PTP-capable Ethernet drivers from `select PTP_1588_CLOCK` to `imply
> PTP_1588_CLOCK`, "in order to break the hard dependency between the PTP
> clock subsystem and ethernet drivers capable of being clock providers."

I don't think this one should be backported unless 3a9dd3ecb207 ("kconfig:
make 'imply' obey the direct dependency") is already backported to v5.6
(which I don't think it should either).

       Arnd
