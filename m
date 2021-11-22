Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C4F7845938C
	for <lists+netdev@lfdr.de>; Mon, 22 Nov 2021 17:59:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233392AbhKVRC6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Nov 2021 12:02:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:58970 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230370AbhKVRC5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 22 Nov 2021 12:02:57 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 98DE160F51;
        Mon, 22 Nov 2021 16:59:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637600391;
        bh=7rlk0Z/QE97jTJY/pIOkev1o3iWMYQSxn+wWGvx6Ir8=;
        h=In-Reply-To:References:To:From:Subject:Cc:Date:From;
        b=ntyIr8vSUCKvtJqKkT8NaPBKbB3ufYKPHE6iuMMZNa0yi1ZY9VMd4vywtv8crqZ6b
         iReDuIkAojGcuZOoWg8dI8Rfv4XVGVkPbAPn9dNv6cN0BNbw+ER1IgZzYTci+GSfSL
         h6SzuBsZeH2SQyUREfqW21XjzHPSKoaNG1tVs4U3GBpcInNBnWLNX5rzpIkHsDWrlY
         aFX7p0fBxtZo3caOB+cBFs7aBUqf5kxHl4i2m5Gpd6xRHtJ+cRPRW1T/+7FCt0mBAw
         KBQBsESZh7M9HZfFSCdMVGYedsoKi/g5aizlox0XGSOmy+xLn46sF1YsE4jmjUDjG3
         BEvhN0l3+a5lA==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <CAPFHKzcph=MiDWgiZ2TLAZukARsL1wi2FGAfLQ2MX_T+oe4KyQ@mail.gmail.com>
References: <20211122142456.181724-1-atenart@kernel.org> <CAPFHKzcph=MiDWgiZ2TLAZukARsL1wi2FGAfLQ2MX_T+oe4KyQ@mail.gmail.com>
To:     Jonathon Reinhart <jonathon.reinhart@gmail.com>
From:   Antoine Tenart <atenart@kernel.org>
Subject: Re: [PATCH net-next v2] sections: global data can be in .bss
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, arnd@arndb.de,
        Linux Netdev List <netdev@vger.kernel.org>,
        linux-arch@vger.kernel.org, tglx@linutronix.de,
        peterz@infradead.org, Steven Rostedt <rostedt@goodmis.org>
Message-ID: <163760038800.3195.16423720862554044024@kwain>
Date:   Mon, 22 Nov 2021 17:59:48 +0100
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Quoting Jonathon Reinhart (2021-11-22 17:56:55)
> On Mon, Nov 22, 2021 at 9:24 AM Antoine Tenart <atenart@kernel.org> wrote:
> >
> > - @Jonathon: with your analysis and suggestion I think you should be
> >   listed as a co-developer. If that's fine please say so, and reply
> >   with both a Co-developed-by and a Signed-off-by tags.
>=20
> Added, thanks. Although it appears I may have missed the boat.

Yes, the patch was applied quickly. Anyway, thanks for the investigation!

Antoine
