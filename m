Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 02F33128C93
	for <lists+netdev@lfdr.de>; Sun, 22 Dec 2019 05:36:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726716AbfLVEft (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 21 Dec 2019 23:35:49 -0500
Received: from mail-lj1-f196.google.com ([209.85.208.196]:38168 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726339AbfLVEft (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 21 Dec 2019 23:35:49 -0500
Received: by mail-lj1-f196.google.com with SMTP id k8so14357197ljh.5;
        Sat, 21 Dec 2019 20:35:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=COqV+F9ei+E2oY/KUB0AC+nOpaJlD5cnAnx3su+cln8=;
        b=Cv0SnhHugHFXM1wehyT8ZP9WXuaIPyVcBG6QAPwrblORdbVMiTAq5PHe4q50nyM/yb
         7uEgLheCNNJx5Q34a5dRlsr3bz70WQoFgnfd0vNUZc/DPyzWEnmrb/N7VVxEpHzA6gte
         O8jawT7C5MPN4poBDjy1xgqL74lKqd7+xQmN5rVfGQIr7BuYYHWMPG/V9aqYIthcXXSg
         cazi3FoZXNrpwOAhTN/CBxTcxmMwWW7jMBTMGZcf16SPjrPx+z7QlU9i6arOrqjdSYZ/
         N42CdQnpuBqd4eOwRVh7LrPJAQ2OX3lVzj95Ewy1hLSsPULxOhX8qH2uuHbXR11a+KCJ
         /oyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=COqV+F9ei+E2oY/KUB0AC+nOpaJlD5cnAnx3su+cln8=;
        b=ZVjCXS11NRf2SAS7Mkw6Mh3wDSNCNAVzBuoE8WOg+Fs1GNvbTM+ugWXSH7SKcCBbXb
         dDCzZPICULzcrtu6tmazoFBck4ahWVgGqEuYQo1NOq0hVNb16A6z28KsD8Pl7arlMF7m
         ilDZH+wnF/4ohk9yq0fdDxgO9+84o6eXfoUiE6lfRlFblzHJFwuB+5cAwA3p1NQ/Eypc
         YyMkOtCtLhluRR+G9xOB60OgemzUZwo/PgflbuY9CAhtggLLkp+MDJbMPj/hIQ4t7fJ9
         NxQsssUK6wWi1ECqtw9mm2tT6vCmLCK4qUukIvtZek/9VNOuCCrvEMogt5o9Phd4ED7c
         QtxQ==
X-Gm-Message-State: APjAAAWPKW7Ugkr0TxWXA3KYNtwNm5PQRuyeV5mK+BankAckDlAR7fVG
        qtbm7/NO4VPLJnMcnrnukiU=
X-Google-Smtp-Source: APXvYqwwHNpyqONsjbrnnDi7Do8gsYy7HpNpEiploEtWoEqRQpQQl2rppymPVsg7yDY255l1Q74Klw==
X-Received: by 2002:a2e:88c5:: with SMTP id a5mr14669392ljk.201.1576989347408;
        Sat, 21 Dec 2019 20:35:47 -0800 (PST)
Received: from [172.20.1.19] ([5.42.224.242])
        by smtp.gmail.com with ESMTPSA id g15sm1827895ljl.10.2019.12.21.20.35.44
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 21 Dec 2019 20:35:46 -0800 (PST)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 12.4 \(3445.104.11\))
Subject: Re: [PATCH v2 0/9] brcmfmac: add support for BCM4359 SDIO chipset
From:   Christian Hewitt <christianshewitt@gmail.com>
In-Reply-To: <cb3ac55f-4c8f-b0a0-41ee-f16b3232c87e@web.de>
Date:   Sun, 22 Dec 2019 07:35:43 +0300
Cc:     Kalle Valo <kvalo@codeaurora.org>,
        Heiko Stuebner <heiko@sntech.de>,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        brcm80211-dev-list@cypress.com, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-rockchip@lists.infradead.org, linux-kernel@vger.kernel.org,
        Neil Armstrong <narmstrong@baylibre.com>
Content-Transfer-Encoding: quoted-printable
Message-Id: <47DB71CE-ACC4-431D-9E66-D28A8C18C0A4@gmail.com>
References: <20191211235253.2539-1-smoch@web.de>
 <D1B53CE9-E87C-4514-A2D7-0FE70A4D1A5D@gmail.com>
 <cb3ac55f-4c8f-b0a0-41ee-f16b3232c87e@web.de>
To:     Soeren Moch <smoch@web.de>
X-Mailer: Apple Mail (2.3445.104.11)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


> On 19 Dec 2019, at 2:04 am, Soeren Moch <smoch@web.de> wrote:
>=20
> I guess you need similar enhancements of the board device tree as in
> patch 8 of this series for your VIM3 board.

Wider testing now points to a known SDIO issue (SoC bug) with Amlogic =
G12A/B hardware. The merged workaround for the bug was only tested with =
bcmdhd and brcmfmac may require tweaking as the same issue exhibits on =
an Amlogic G12B device with BCM4356 chip. Testing the series with =
Amlogic GXM (older) and SM1 (newer) hardware to exclude the SoC bug =
shows everything working as expected.

Christian=
