Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A04ED459059
	for <lists+netdev@lfdr.de>; Mon, 22 Nov 2021 15:39:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239255AbhKVOmp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Nov 2021 09:42:45 -0500
Received: from mout.kundenserver.de ([217.72.192.74]:57233 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235099AbhKVOmm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Nov 2021 09:42:42 -0500
Received: from mail-wr1-f52.google.com ([209.85.221.52]) by
 mrelayeu.kundenserver.de (mreue108 [213.165.67.113]) with ESMTPSA (Nemesis)
 id 1N33AR-1mesv21QMv-013Q0r; Mon, 22 Nov 2021 15:39:33 +0100
Received: by mail-wr1-f52.google.com with SMTP id a9so33126234wrr.8;
        Mon, 22 Nov 2021 06:39:33 -0800 (PST)
X-Gm-Message-State: AOAM533uP+WPOG114F7zHMXk8WFMQmulxPgjHA3hOA0EGP9prBcu9T2Z
        1UFvNaZ3hyNdvMsrkJ0o89nhjJ0UHL/okSCjA7Y=
X-Google-Smtp-Source: ABdhPJygFngHjkn45wpqA3TMfwBcuoS+FF08B+BI5ToUHT7hRt8PVaAua7a/ELfa/nF7nPAMj628E8TQmkkwjEop3/g=
X-Received: by 2002:adf:df89:: with SMTP id z9mr37896119wrl.336.1637591972963;
 Mon, 22 Nov 2021 06:39:32 -0800 (PST)
MIME-Version: 1.0
References: <20211122142456.181724-1-atenart@kernel.org>
In-Reply-To: <20211122142456.181724-1-atenart@kernel.org>
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Mon, 22 Nov 2021 15:39:17 +0100
X-Gmail-Original-Message-ID: <CAK8P3a3eKS6vvMmvXm402VGezqyBjbONuLTcXVS2fgJmrP-hOg@mail.gmail.com>
Message-ID: <CAK8P3a3eKS6vvMmvXm402VGezqyBjbONuLTcXVS2fgJmrP-hOg@mail.gmail.com>
Subject: Re: [PATCH net-next v2] sections: global data can be in .bss
To:     Antoine Tenart <atenart@kernel.org>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Networking <netdev@vger.kernel.org>,
        linux-arch <linux-arch@vger.kernel.org>,
        jonathon.reinhart@gmail.com, Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>
Content-Type: text/plain; charset="UTF-8"
X-Provags-ID: V03:K1:OYOXZs7RGba4Z3/8K2c4DzLGqw7VDSdPBzG88Qwl5J2Vy964QIl
 WC7XNlWMMpAmGByNPz8gAUy/aUzUXrnL4dGZ4LNCBirpxzYXEvcPx6novcqaW9s8AaFJNjh
 gIGKitL0ZJy4nA7LCakknebAZrHTBKEL1wPQUzHVAdsANKSPVIEXoXc3sqG82LnRQkWOzzk
 cm9dgG8WxzYfnjbJZ0Bdw==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:ZwQ/vCVrvE8=:K2XjxFY8V5wYvWuh9G9doi
 0sEcVC2JRColBuSMuFYL2upPSONEIsc3zQIPF4uXMCscJiFBexOaIdzhkD6+vb6yNjmuEQGJP
 8e6UqOw4GxAECeGnV5qKLSG/kRC45UDX3exxZk+CkSsQrwGOgHLpjiqctCZ1WLWqOnba22Tvx
 5SVRXhWVEGic4Vn4bjqUsD4qlfjDz+H/CfAykUd3CyvK7AEdTRe/+oIo+UGe7E/gF5TIEWWLU
 BWZ96QFBOHVA0LIC+p6QUB43Iy6UgUdZeFbSjeGILfkScofTlo9q6iLA2s8vgqJjKDGk/BsFU
 z0dw7MXYCaGDl3ZEgYDWaP00keiqw3GadBuEebzl4H0P2HO11YTciAFDaIZzLa3uJnzP/poIS
 cYjxjRbwTBrFIsC0jT9+j8oGK74qSfjTBuTBxW6rczmSqzOIG+1aF8BLkc1m0eLIDiJcxzKWr
 KV2JITFz32SunynllUbdjGeQ8y49QPgqxY7fXPGIEbMvJsoKK94GgVaeDAem7q9r78zS6FCfk
 0iEyIG3D876giZrupawljf8uy/tDyeFpVpYwjou9ATJFXLMYf8DnvP0DewO8PNKEPT9MOsuak
 kL2rsHO/kPk6UyKlECQUjj4wG4Y8YZ1VIqw5SwueQNqXvRldt5a0xqdSCccbxuV/zA95srgwg
 AYQ4DvJVhQoXYyKgwvi/BnjX9lyuCuxZiK/7GOtr+O92NjAJTBb0mt7Sn88TuuBkz8zE2r3QK
 bq5ACpRITCUESsHZHfBrR9oTf0rPFihkoaNK9RD9l1+vTCCFOhh5Ql6qQvcDDJ4O+1OwhSgTp
 KvVTrH9RF+SmjQjXp41q3Cw+Dpa+YlMc9O/LLWO4ohFpxY+K64=
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 22, 2021 at 3:24 PM Antoine Tenart <atenart@kernel.org> wrote:
>
> When checking an address is located in a global data section also check
> for the .bss section as global variables initialized to 0 can be in
> there (-fzero-initialized-in-bss).
>
> This was found when looking at ensure_safe_net_sysctl which was failing
> to detect non-init sysctl pointing to a global data section when the
> data was in the .bss section.
>
> Signed-off-by: Antoine Tenart <atenart@kernel.org>
> Acked-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
> ---
>
> A few remarks:
>
> - This still targets net-next but I added Arnd if he prefers to take it
>   through the 'asm-generic' tree, now that is_kernel_core_data is in
>   include/asm-generic/.

I have nothing else for asm-generic at the moment, please take
this through net-next.

Acked-by: Arnd Bergmann <arnd@arndb.de>
