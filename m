Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D1F291F4BD8
	for <lists+netdev@lfdr.de>; Wed, 10 Jun 2020 05:42:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726119AbgFJDme (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Jun 2020 23:42:34 -0400
Received: from mail.zx2c4.com ([192.95.5.64]:54639 "EHLO mail.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725988AbgFJDmb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 9 Jun 2020 23:42:31 -0400
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTP id 57a7c409;
        Wed, 10 Jun 2020 03:25:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=zx2c4.com; h=mime-version
        :references:in-reply-to:from:date:message-id:subject:to:cc
        :content-type; s=mail; bh=WxP0YQVGb/GYzrViQS1WSXQeXn0=; b=mglb60
        q1f9pE6Z0km3nCh1BLlFIbPBqHvVd9o8Bvxxdxy1GpSliPBCABWVONUCX1MquAhh
        KwihUVHvxUAXselUs9QqgKTIEPqg9/NvZ/T/Q/d2xY0gfV2nXlzCf++RIAhu7wmN
        +aZ+3cpc3dEjOPYnygGMPYV7DNTxM/+peGnU00CSt7OlmlvI7xhJ3KeobZFtT7Fh
        L32UKyNHyOuygFTpF+LPi9imak9Ww9THc8a1mhb+BnlDy+UbMQFqiTGD0MwrCn6N
        hAlwaagJrgO98/v2pK4du5WKcj7zQ46wD6kfmElHOsF5v4mb78Q4EzrNO7IIzf3l
        wkk2FqCdvSqNv5GA==
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id b2dfa9f6 (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO);
        Wed, 10 Jun 2020 03:25:21 +0000 (UTC)
Received: by mail-il1-f178.google.com with SMTP id i1so552180ils.11;
        Tue, 09 Jun 2020 20:42:29 -0700 (PDT)
X-Gm-Message-State: AOAM530wm1xO3ns2aOQ/0AugdUqbQavg7FaN43vIPu6HU1W4UAB8uCKB
        fMhBCBlGS4ePLyTkISWUyJF5FCK++zZjCvZA2zg=
X-Google-Smtp-Source: ABdhPJwVJTXyE+0max50h/3oBgdpiw7jusy9UrhqCRBjWU+q8aFts18KzyGm+1NfOmpt9VMpjqD84e79vUICw3dl1Q0=
X-Received: by 2002:a92:2515:: with SMTP id l21mr1170698ill.64.1591760548653;
 Tue, 09 Jun 2020 20:42:28 -0700 (PDT)
MIME-Version: 1.0
References: <20200609152100.29612-1-mail@hb9fxq.ch>
In-Reply-To: <20200609152100.29612-1-mail@hb9fxq.ch>
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
Date:   Tue, 9 Jun 2020 21:42:17 -0600
X-Gmail-Original-Message-ID: <CAHmME9o=VwZQtQH7i2qE2Jf6OLP_vcOzyA4U+NhLkiATnyN2Bg@mail.gmail.com>
Message-ID: <CAHmME9o=VwZQtQH7i2qE2Jf6OLP_vcOzyA4U+NhLkiATnyN2Bg@mail.gmail.com>
Subject: Re: [PATCH] Do not assign in if condition wg_noise_handshake_consume_initiation()
To:     Frank Werner-Krippendorf <mail@hb9fxq.ch>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        WireGuard mailing list <wireguard@lists.zx2c4.com>,
        Netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 9, 2020 at 9:21 AM Frank Werner-Krippendorf <mail@hb9fxq.ch> wrote:
>
> Fixes an error condition reported by checkpatch.pl which caused by
> assigning a variable in an if condition in
> wg_noise_handshake_consume_initiation().
>
> Signed-off-by: Frank Werner-Krippendorf <mail@hb9fxq.ch>

Thanks. Queued up in the wireguard-linux.git tree.

Jason
