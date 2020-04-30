Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E7E5F1C099B
	for <lists+netdev@lfdr.de>; Thu, 30 Apr 2020 23:44:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727070AbgD3Vog (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Apr 2020 17:44:36 -0400
Received: from mout.kundenserver.de ([217.72.192.73]:60459 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726447AbgD3Vof (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Apr 2020 17:44:35 -0400
Received: from mail-qk1-f178.google.com ([209.85.222.178]) by
 mrelayeu.kundenserver.de (mreue107 [212.227.15.145]) with ESMTPSA (Nemesis)
 id 1MJEpp-1jimlN0NSd-00Khm9; Thu, 30 Apr 2020 23:44:34 +0200
Received: by mail-qk1-f178.google.com with SMTP id s9so4748399qkm.6;
        Thu, 30 Apr 2020 14:44:33 -0700 (PDT)
X-Gm-Message-State: AGi0PuZghjhx/xayLprs8SLRh1slG58kMxKQ2L1E4Zrvs+TJooOskv55
        wYYqOHCuTuBgWS+b0WwgUoKO/19OG/B9CKSQ/MU=
X-Google-Smtp-Source: APiQypJG61UgX2jVL3xX+glRo4MMKBEeabgc3GqvItqPEIiPOYIHTXVB0ewjzbQUwQBm4qyJilYhp6OqGHyHSKdeL8Q=
X-Received: by 2002:a37:63d0:: with SMTP id x199mr594389qkb.3.1588283072801;
 Thu, 30 Apr 2020 14:44:32 -0700 (PDT)
MIME-Version: 1.0
References: <20200430213101.135134-1-arnd@arndb.de> <20200430213101.135134-5-arnd@arndb.de>
 <49831bca-b9cf-4b9a-1a60-f4289e9c83c0@embeddedor.com>
In-Reply-To: <49831bca-b9cf-4b9a-1a60-f4289e9c83c0@embeddedor.com>
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Thu, 30 Apr 2020 23:44:16 +0200
X-Gmail-Original-Message-ID: <CAK8P3a0y0JTrsjFx1XRh7A6YdSZ=aJ1V3-Eajfsbz3HtQOEu7A@mail.gmail.com>
Message-ID: <CAK8P3a0y0JTrsjFx1XRh7A6YdSZ=aJ1V3-Eajfsbz3HtQOEu7A@mail.gmail.com>
Subject: Re: [PATCH 04/15] ath10k: fix gcc-10 zero-length-bounds warnings
To:     "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Cc:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Michal Kazior <michal.kazior@tieto.com>,
        Kalle Valo <kvalo@qca.qualcomm.com>,
        Maharaja Kennadyrajan <mkenna@codeaurora.org>,
        Wen Gong <wgong@codeaurora.org>,
        Erik Stromdahl <erik.stromdahl@gmail.com>,
        ath10k@lists.infradead.org,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Kees Cook <keescook@chromium.org>
Content-Type: text/plain; charset="UTF-8"
X-Provags-ID: V03:K1:UzqWa1uTx+8qlS57U8rov8c8CfYZsP5wisVZbCwro749WkrbXdK
 0cV6I4ErTSyxR50khFsv5dK2Qa5SPh+/eDNZLi/Az7qv6cPL3BM1YfmQ6fX+460XHHB33Vj
 I+hvKmYefNAW1DnDXSpYy3qtOp6BcXt6qNdNKgt3WB31bXgVC2X/V55SJg5IVlhwktVcPvn
 gMS2w0/Rpd0FDqaHt1Lcw==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:AffdSqvvlvY=:2+GBVTlK354dDFmmZnrEkl
 M5pB+N7FiY+DIwhiGS/NIZS4Q9MEIhO7sgPEC6R+iz5kPSvJAJ8FPfNf195oLq2reuRyd1GrD
 hijlBApvjh//G2bw+HeRCmcslf7QCWtJzg85Wbmx8SQTCBtbjFlnjQCzvZDQ6BtxO9U4qggTA
 6HNud3R4LmHMN7mK1yVCNFfUUgtGglT8n0oxfBTLluh3kr90cta/XH9rayjvEQ7TgkmYyn4G7
 6nU8q8dZ4A6YkgpRvyNVuCce4ONFlfHfAQ34cY/o24kLYVe9vyi1nDKorzSjJio6+FQC6auDw
 ou6xFlch0fN/xniowavN1QR2VJ3nvr1CtctWiFqWjOaGir1QXVgNoVvHJ9TxZwNu3LrcUMdz2
 4aBh7kttMZWJMLPijwHl4BAO+1G1BrHmyJ/FF1NHARdLVU4z2ffZI1mvu1Hfh19j5t6Qq6S41
 KEa7adNCtIgI42364dQA3Y4iOrdlqyr//oIA4Ua3m1rG35s58MgER3fvQ2liTGJmEzZXzMtgo
 xSNrkaS407eMaktZfdVjgwRXhrfcBd0sRguIOghxGkBWb4/1p0UZgOkQbv1yBVzBQyqbn2iS3
 I3z/C3HjgQ85rnCJogdO7EpfHhi+VWr/Dbdgkh6Capx0tPKqQfMPp2rB+MCpq2xqfx3M8QNsr
 DlHWUdEkZ5aPKY5dhmVnJo50BN5dSt9AVk/wwMkKUql04VrY41mglfxMuVF1OwvZsTOKt/yBs
 gzDpH2dV6uyB4j32Sn2KXv6X4lV3t0Wh+PYQItub43mcAaTx6mXJ3p6UvR93ZCl8AqEhXa2Hm
 X2j3c5qoM9H1RG5xbeLdY0k2+9QZMgcR+UUwIluqSgWjKes5IM=
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 30, 2020 at 11:41 PM Gustavo A. R. Silva
<gustavo@embeddedor.com> wrote:
> On 4/30/20 16:30, Arnd Bergmann wrote:
> > gcc-10 started warning about out-of-bounds access for zero-length
> > arrays:
> The treewide patch is an experimental change and, as this change only applies
> to my -next tree, I will carry this patch in it, so other people don't have
> to worry about this at all.

Ok, thanks!

       Arnd
