Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 83630363444
	for <lists+netdev@lfdr.de>; Sun, 18 Apr 2021 09:58:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230339AbhDRH7P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Apr 2021 03:59:15 -0400
Received: from smtprelay0095.hostedemail.com ([216.40.44.95]:56644 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S229605AbhDRH7O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 18 Apr 2021 03:59:14 -0400
Received: from omf15.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay04.hostedemail.com (Postfix) with ESMTP id 625581801EC5B;
        Sun, 18 Apr 2021 07:58:45 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: joe@perches.com) by omf15.hostedemail.com (Postfix) with ESMTPA id 421D1C4171;
        Sun, 18 Apr 2021 07:58:42 +0000 (UTC)
Message-ID: <78ad5b527aa1da06569fd5ae422ea2a403ef40a0.camel@perches.com>
Subject: Re: [PATCH] brcmsmac: fix shift on 4 bit masked value
From:   Joe Perches <joe@perches.com>
To:     Kalle Valo <kvalo@codeaurora.org>,
        Colin King <colin.king@canonical.com>
Cc:     Arend van Spriel <aspriel@gmail.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Chi-hsien Lin <chi-hsien.lin@infineon.com>,
        Wright Feng <wright.feng@infineon.com>,
        Chung-hsien Hsu <chung-hsien.hsu@infineon.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        SHA-cyfmac-dev-list@infineon.com, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Date:   Sun, 18 Apr 2021 00:58:40 -0700
In-Reply-To: <20210418061021.AB25CC43217@smtp.codeaurora.org>
References: <20210318164513.19600-1-colin.king@canonical.com>
         <20210418061021.AB25CC43217@smtp.codeaurora.org>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.38.1-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=0.10
X-Rspamd-Server: rspamout02
X-Stat-Signature: 8gh465wuimw17kau5gdipacob9prza1i
X-Rspamd-Queue-Id: 421D1C4171
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Session-ID: U2FsdGVkX1/xWSqVlWo+70JHQhB8hBT2bN/Di8JdQ18=
X-HE-Tag: 1618732722-454334
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 2021-04-18 at 06:10 +0000, Kalle Valo wrote:
> Colin King <colin.king@canonical.com> wrote:
> 
> > From: Colin Ian King <colin.king@canonical.com>
> > 
> > The calculation of offtune_val seems incorrect, the u16 value in
> > pi->tx_rx_cal_radio_saveregs[2] is being masked with 0xf0 and then
> > shifted 8 places right so that always ends up as a zero result. I
> > believe the intended shift was 4 bits to the right. Fix this.
> > 
> > [Note: not tested, I don't have the H/W]
> > 
> > Addresses-Coverity: ("Operands don't affect result")
> > Fixes: 5b435de0d786 ("net: wireless: add brcm80211 drivers")
> > Signed-off-by: Colin Ian King <colin.king@canonical.com>
> 
> I think this needs review from someone familiar with the hardware.
> 
> Patch set to Changes Requested.

What "change" are you requesting here?

Likely there needs to be some other setting for the patch.

Perhaps "deferred" as you seem to be requesting a review
and there's no actual change necessary, just approval from
someone with the hardware and that someone test the patch.


