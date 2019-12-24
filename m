Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0A4C9129FCA
	for <lists+netdev@lfdr.de>; Tue, 24 Dec 2019 10:45:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726174AbfLXJpD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Dec 2019 04:45:03 -0500
Received: from mail-lj1-f194.google.com ([209.85.208.194]:46941 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726084AbfLXJpD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Dec 2019 04:45:03 -0500
Received: by mail-lj1-f194.google.com with SMTP id m26so17897658ljc.13;
        Tue, 24 Dec 2019 01:45:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=P6IbNtAeZX26SPmEoOJPgBtk2mM++6U9PCnvdGJBX/k=;
        b=e+MwYW7oNYxt3VheW4hLM/PG7DtRwDCUyVZEs6t0T7+8CE+Yl7MfenhngT0/OgHYUG
         1lrshywM55Sw3A3VTCUPBRuE3JJbu1kuaAxioCZ7faxd1bBQIlZmcWnEG1Fj7RK+fOSt
         2Lv23+L1v+oV4bsxI0R2inbM9Q1S93sv1Zh+5pjyczVpfhGPOg4d5esrH2SdkLPYLf3Z
         xXvoKb5lmt2a7hFNWx7/qU8Nm4tBa7JfacilrwSEZroidCpRIy/6ApFJF9ziTBrxehx0
         oPv7Fli/WO1dT6FbrP9AqdpphfO53BKok986EyjqmbOoXUxJuuAk9G/X5O0ohvp+lAaq
         WbzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=P6IbNtAeZX26SPmEoOJPgBtk2mM++6U9PCnvdGJBX/k=;
        b=qWh18sYGe09f47SOSAuNzBcPMhbviXZerIhfiT7F7ULPrD+fTJGCSbXP6BJnc52pV0
         S5+7iJtsI9xkE50xfR2KyQaxnpwOf/1yy4QTxk9+L+b/4UR2aYCsxYrrr4MjPtqXWYJW
         aOCMuhs8v7MNBReRCZAm0PBkJouH9ryWDwzGw88jilO/MW9JWABBx4FsLHfqrh5O5JAe
         NBAf8F60jU20aQfm5xnxd11hJcl9L8j/ExD94RkL3gzdaXbPk6HAJ44mNav47SsWltf2
         9UA6smL00RjbBGiWfAfkWDMXq82GOoLRPFvUXL+oFxdRfABLIDaqXFdNyVNDFNbL+U8v
         Jp3Q==
X-Gm-Message-State: APjAAAXabm8rX4IHWMWsfz45VeORNnI8S/cfW480adZIBnvoH8HgZFhH
        t4vx+8usAWq31dFy3xfdwCA=
X-Google-Smtp-Source: APXvYqyKB74FAyB/+SJCoryM883h5LTWtyijzg+2Mk4n5Qh+uy4iWs79Zblpjyc+J6oIVQxrgDw6DQ==
X-Received: by 2002:a2e:2283:: with SMTP id i125mr20593893lji.244.1577180700841;
        Tue, 24 Dec 2019 01:45:00 -0800 (PST)
Received: from [172.16.20.20] ([87.200.95.144])
        by smtp.gmail.com with ESMTPSA id n30sm11591851lfi.54.2019.12.24.01.44.57
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 24 Dec 2019 01:45:00 -0800 (PST)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 12.4 \(3445.104.11\))
Subject: Re: [PATCH v2 0/9] brcmfmac: add support for BCM4359 SDIO chipset
From:   Christian Hewitt <christianshewitt@gmail.com>
In-Reply-To: <3c42d6de-670d-fee8-aa81-99f44d447e87@broadcom.com>
Date:   Tue, 24 Dec 2019 13:44:55 +0400
Cc:     Soeren Moch <smoch@web.de>, Kalle Valo <kvalo@codeaurora.org>,
        Heiko Stuebner <heiko@sntech.de>,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        brcm80211-dev-list@cypress.com, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-rockchip@lists.infradead.org, linux-kernel@vger.kernel.org,
        Neil Armstrong <narmstrong@baylibre.com>
Content-Transfer-Encoding: quoted-printable
Message-Id: <F311713B-D7DC-4029-90F2-5E162648349D@gmail.com>
References: <20191211235253.2539-1-smoch@web.de>
 <D1B53CE9-E87C-4514-A2D7-0FE70A4D1A5D@gmail.com>
 <cb3ac55f-4c8f-b0a0-41ee-f16b3232c87e@web.de>
 <47DB71CE-ACC4-431D-9E66-D28A8C18C0A4@gmail.com>
 <3c42d6de-670d-fee8-aa81-99f44d447e87@broadcom.com>
To:     Arend Van Spriel <arend.vanspriel@broadcom.com>
X-Mailer: Apple Mail (2.3445.104.11)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On 24 Dec 2019, at 1:01 pm, Arend Van Spriel =
<arend.vanspriel@broadcom.com> wrote:
>=20
> Can you elaborate on the "known SDIO issue"? Is it an issue with ADMA =
or something else. I am asking because there is a workaround in brcmfmac =
to avoid scatter-gather lists, which may or may not address the issue.

This describes the issue: https://patchwork.kernel.org/cover/10962975/

Below is the current workaround I=E2=80=99m using, which restricts the =
hack to Amlogic G12A and G12B devices that inherit =
=E2=80=9Camlogic,dram-access-quirk=E2=80=9D from a common SoC dtsi.

=
https://github.com/chewitt/linux/commit/187527747861b047c835f494fe3267d9b4=
959be1

Testing by Khadas staff found the max_segs/max_blk_count values and =
shows a performance impact (not a big surprise) but they appear to give =
a stable connection, which is better than a very unstable one. I=E2=80=99v=
e flagged things to linux-amlogic maintainer Neil Armstrong (on CC) and =
I expect he or colleagues will take a more scientific look in January.

NB: I=E2=80=99m happy to test other things. Just remember that I don=E2=80=
=99t code so you need to spoon-feed me with patches not suggestions.

Christian=
