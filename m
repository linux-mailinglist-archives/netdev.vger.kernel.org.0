Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F415312BB93
	for <lists+netdev@lfdr.de>; Fri, 27 Dec 2019 23:13:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726400AbfL0WNZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Dec 2019 17:13:25 -0500
Received: from mail-lf1-f68.google.com ([209.85.167.68]:33800 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725957AbfL0WNX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Dec 2019 17:13:23 -0500
Received: by mail-lf1-f68.google.com with SMTP id l18so13372335lfc.1
        for <netdev@vger.kernel.org>; Fri, 27 Dec 2019 14:13:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=TzNDgewdty9+XCRaXDaU2bPI7xNE/bDJBnpHNO7m5MI=;
        b=eXwiGLZOx9BivEyNJf7zzgLYHeRiMJI1uecqF8smMsuOgs+Cx53GMofDb4oWPS3MGQ
         BIGX05y8iL3+DicrPwXvF3BPXyBut0xRzAix260rRPvJOGlkag7p9e2Li+ta+DW4rH92
         vmo8HQ9NZJTCKxHKlc/BhYmbqDJhF15/q1dNE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=TzNDgewdty9+XCRaXDaU2bPI7xNE/bDJBnpHNO7m5MI=;
        b=d7pMidGmgBtWwVUsIrPRMQTHx8rTtdQ5XbufYZpogfCn+DGCpgXQUW0NZK9z2CKX8V
         2SXovMiIUvZ7xmH4k6Dlw9ETlyhqo7sK6w5N9oOoasexMTSPbu1mG+o+rg5Cl41OL9Xc
         GLJwGET1aXadBMKkRS1GfvXG+dv1UNen34rn7G9ENPgBBVFnAodoFo80J08CodiC1/zs
         vini+Bc8a4eS05wikmxP++heWmP91ZoAfeQCitvAUA5g1l0QsczV2hltjopkHFrSSZzD
         V3t58+ONoJ5hTzPHI1BTwMNAMfbAfH65CdVAReieTK+IZXW4lot5XKxC7e+ZZHK7WKwi
         /qLg==
X-Gm-Message-State: APjAAAXi8U2zU+EYKy85BmdQ4etD/GwvXswpQt/v6H6h6kZNhr6wDRR5
        d/s0Jf02EkkuCPG7Oe07h0JOlwSwXNQ=
X-Google-Smtp-Source: APXvYqyn5HeYfmXLCI4pzOAcxnQIXLKgDhgSST3E3gUNHt64ZsJJVWmLWXCPhcOEjuBqNd4OZXphaw==
X-Received: by 2002:a19:710a:: with SMTP id m10mr29830742lfc.58.1577484801243;
        Fri, 27 Dec 2019 14:13:21 -0800 (PST)
Received: from mail-lj1-f174.google.com (mail-lj1-f174.google.com. [209.85.208.174])
        by smtp.gmail.com with ESMTPSA id c189sm15302513lfg.75.2019.12.27.14.13.20
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 27 Dec 2019 14:13:20 -0800 (PST)
Received: by mail-lj1-f174.google.com with SMTP id w1so6124991ljh.5
        for <netdev@vger.kernel.org>; Fri, 27 Dec 2019 14:13:20 -0800 (PST)
X-Received: by 2002:a2e:8946:: with SMTP id b6mr27871105ljk.1.1577484799595;
 Fri, 27 Dec 2019 14:13:19 -0800 (PST)
MIME-Version: 1.0
References: <20191221.180914.601367701836089009.davem@davemloft.net>
In-Reply-To: <20191221.180914.601367701836089009.davem@davemloft.net>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Fri, 27 Dec 2019 14:13:03 -0800
X-Gmail-Original-Message-ID: <CAHk-=whpoNwcb2fXH3e=pFjY1Tjb9rHLVjq_q-OzK3FMgvx2wA@mail.gmail.com>
Message-ID: <CAHk-=whpoNwcb2fXH3e=pFjY1Tjb9rHLVjq_q-OzK3FMgvx2wA@mail.gmail.com>
Subject: Re: [GIT] Networking
To:     David Miller <davem@davemloft.net>,
        Antoine Tenart <antoine.tenart@bootlin.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Dec 21, 2019 at 6:09 PM David Miller <davem@davemloft.net> wrote:
>
> Antoine Tenart (2):
>       of: mdio: export of_mdiobus_child_is_phy

I didn't notice until now (bad me - I've actually been taking a few
days off due to xmas), but this causes a new warning in some
configurations.

In particular, it causes a warning about

   'of_mdiobus_child_is_phy' defined but noy used

because when CONFIG_OF_MDIO is disabled, the <linux/of_mdio.h> header now has

  static bool of_mdiobus_child_is_phy(struct device_node *child)
  {
         return false;
  }

which is all kinds of stupid.

I'm assuming that dummy function should just be marked "inline", the
way the other helper dummy functions are defined when OF_MDIO is not
enabled.

                 Linus
