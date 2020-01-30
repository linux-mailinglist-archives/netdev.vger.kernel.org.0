Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DFF1614E3C5
	for <lists+netdev@lfdr.de>; Thu, 30 Jan 2020 21:17:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727391AbgA3URj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jan 2020 15:17:39 -0500
Received: from frisell.zx2c4.com ([192.95.5.64]:34073 "EHLO frisell.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726514AbgA3URj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 Jan 2020 15:17:39 -0500
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTP id e381a210;
        Thu, 30 Jan 2020 20:17:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=zx2c4.com; h=mime-version
        :references:in-reply-to:from:date:message-id:subject:to:cc
        :content-type; s=mail; bh=td4F/e1EqVCCmUOX3MSHfiqQwsU=; b=UN3Nbk
        JpOl+VDqu2AKIepz401+ScT/FGqZlEjjKgEPxuY6+/4T/Oo6aIAX2CbC/m26nSH9
        qzpVUtJg/3aBrpYaUJv7Zo1xEouVNxOR/JSKl22Aiv30hKIwONQESCUkusNv8kS1
        GsLvCdHrNXPTIx+Cj/QQqwQsvyLlX+0ladoTkeQgpo7hy2+vEE6pZ4furTSFOuQG
        TNpid8rXKIxg1NDmEld2Ay/hYcA4Nzyqbaj/hbo0bALvc1vX+3i1rAOOYLItWZnN
        UKTUE7gLs4MXB0R+6lQrdrQKwJ5D+Bm/qzm4eaxFhXDwvcyWkrsQH78afd2xZpFl
        p5thZdWIT3KeZCIQ==
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 643de966 (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256:NO);
        Thu, 30 Jan 2020 20:17:25 +0000 (UTC)
Received: by mail-oi1-f176.google.com with SMTP id q81so4985989oig.0;
        Thu, 30 Jan 2020 12:17:36 -0800 (PST)
X-Gm-Message-State: APjAAAULenGWfT0fmASplfINpHf14EPxhLWHPdoVz2XmkgOJ3TGColDx
        3aVrjSlaUbSvGBKaF+gMp7DxcuPmbAmYUILvac0=
X-Google-Smtp-Source: APXvYqx8dQxBMLMTc7XIDyqF/4jHhnMkRGye1GLdLfkdp8BKkxkLAEwojzkpiEiLvksM/GmZHW1A3Unk1oz2j/OER/k=
X-Received: by 2002:aca:815:: with SMTP id 21mr4231619oii.52.1580415455872;
 Thu, 30 Jan 2020 12:17:35 -0800 (PST)
MIME-Version: 1.0
References: <20200130192853.3528-1-krzk@kernel.org>
In-Reply-To: <20200130192853.3528-1-krzk@kernel.org>
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
Date:   Thu, 30 Jan 2020 21:17:24 +0100
X-Gmail-Original-Message-ID: <CAHmME9rUrq5jrMx=Rsw+w2oeJDj+-R_MtcFxcO91kbOUP7363Q@mail.gmail.com>
Message-ID: <CAHmME9rUrq5jrMx=Rsw+w2oeJDj+-R_MtcFxcO91kbOUP7363Q@mail.gmail.com>
Subject: Re: [PATCH] wireguard: selftests: Cleanup CONFIG_ENABLE_WARN_DEPRECATED
To:     Krzysztof Kozlowski <krzk@kernel.org>
Cc:     Shuah Khan <shuah@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        WireGuard mailing list <wireguard@lists.zx2c4.com>,
        Netdev <netdev@vger.kernel.org>, linux-kselftest@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 30, 2020 at 8:29 PM Krzysztof Kozlowski <krzk@kernel.org> wrote:
>
> CONFIG_ENABLE_WARN_DEPRECATED is gone since
> commit 771c035372a0 ("deprecate the '__deprecated' attribute warnings
> entirely and for good").

Some nice wisdom tucked away in the message of the commit you reference.

Thanks for the patch. Queued up in wireguard-linux.git:
https://git.zx2c4.com/wireguard-linux/commit/?id=e7989992d4908df74402836300b83bacb26cd349

Jason
