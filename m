Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 02A144A786
	for <lists+netdev@lfdr.de>; Tue, 18 Jun 2019 18:50:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729774AbfFRQtz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jun 2019 12:49:55 -0400
Received: from mail-io1-f67.google.com ([209.85.166.67]:41821 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729472AbfFRQtz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Jun 2019 12:49:55 -0400
Received: by mail-io1-f67.google.com with SMTP id w25so31341566ioc.8
        for <netdev@vger.kernel.org>; Tue, 18 Jun 2019 09:49:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=J5nux9DmROYeE56s/BQAf6HcvIGxMJ51i9fQdjtJRGo=;
        b=hqS5I/CprE/DXrjhB2RtBrF+oejKGdk3zNCPfvhEilNd8g6oS+9FCyeX5xoWyR95Pv
         QXfQpUrDVSyyPbwMEGtN/Anc7PQkgQch9Ion+L5uVbaRRsodXcJAWiAUSSTp5br1+rqC
         Nob53UB4jzbHqZydh8I42+TynMH/npouE7S2Z4PEOQ+I9MAAdV002tFiTkmYHOab8byS
         jhMHwalM8OjU3wLxgs3gZ4IwWYogLkZl4yUaunnYG6H9SmzH9RHYFHwmJYqs59Dx7kzn
         QlOSOVrA6U7UdmnKfYIHqVc7p0uQD/EUtAdDuexdd4hLamN0a9q8EEJCyuLh6ELLJcYO
         G+oA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=J5nux9DmROYeE56s/BQAf6HcvIGxMJ51i9fQdjtJRGo=;
        b=E7QDvR6qUaQbvFo2r5SY5/5dEWbhu1/BknHUmtTzlc/QyxkNXSc5fIRuyycE7+kNPe
         lgLU9Zv8EnHw4KGGIOUdAyGJ+eFofDs2jyC47cNCgMgt+RclV9ocJSM0KzqSk8k7ljWE
         pWLa8FNnm2fPvNIRrlP5kiabJlPzkVmC20knmQ6AedMCCuytouSJOy+6TEnlWBr+2JU9
         L3P94z/w1ALPuHntVMW1q2jJtIt2k7xwYDygchymE8bvwOMGAqosriztmHBsbVgTUs04
         lvg0qCGrQxAuhVLpMvG8bCA9rjXIQcUn+apoai171lS6Ve9ygpntPIbrb3Dn9zl62rCJ
         ERlw==
X-Gm-Message-State: APjAAAW1+0Ogcl+uQmPSNG6Z9FnGPk339Y7r5dTxwmH1uxBX9hbRgtWK
        /dvFShI29q94ZsiLkWmP8/B9Kw==
X-Google-Smtp-Source: APXvYqyQiMRJSW+WsgFrJq67pivLuHVMSleBEdiKqkJFj7YjDFmJQLp16dpykNpYQIUlonlZMP6LSA==
X-Received: by 2002:a5d:9291:: with SMTP id s17mr3521902iom.10.1560876593344;
        Tue, 18 Jun 2019 09:49:53 -0700 (PDT)
Received: from [192.168.1.196] ([216.160.37.230])
        by smtp.gmail.com with ESMTPSA id b6sm11518234iok.71.2019.06.18.09.49.52
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 18 Jun 2019 09:49:52 -0700 (PDT)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 11.5 \(3445.9.1\))
Subject: Re: [PATCH v2 0/2] Add macb support for SiFive FU540-C000
From:   Troy Benjegerdes <troy.benjegerdes@sifive.com>
In-Reply-To: <CAAhSdy3zODw=JFaN=2F4K5-umihJDivLO8J8LBdkFkuZgzu41Q@mail.gmail.com>
Date:   Tue, 18 Jun 2019 11:49:51 -0500
Cc:     Paul Walmsley <paul.walmsley@sifive.com>,
        "palmer@sifive.com" <palmer@sifive.com>,
        Alistair Francis <Alistair.Francis@wdc.com>,
        "jamez@wit.com" <jamez@wit.com>,
        "linux-riscv@lists.infradead.org" <linux-riscv@lists.infradead.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "schwab@suse.de" <schwab@suse.de>,
        "nicolas.ferre@microchip.com" <nicolas.ferre@microchip.com>,
        "mark.rutland@arm.com" <mark.rutland@arm.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "aou@eecs.berkeley.edu" <aou@eecs.berkeley.edu>,
        "sachin.ghadi@sifive.com" <sachin.ghadi@sifive.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "ynezz@true.cz" <ynezz@true.cz>,
        "yash.shah@sifive.com" <yash.shah@sifive.com>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        Atish Patra <atish.patra@wdc.com>,
        Bin Meng <bmeng.cn@gmail.com>,
        Lukas Auer <lukas.auer@aisec.fraunhofer.de>
Content-Transfer-Encoding: quoted-printable
Message-Id: <946B2B53-7A16-4B8D-8CB9-34EFFB9E84D6@sifive.com>
References: <1560745167-9866-1-git-send-email-yash.shah@sifive.com>
 <mvmtvco62k9.fsf@suse.de>
 <alpine.DEB.2.21.9999.1906170252410.19994@viisi.sifive.com>
 <mvmpnnc5y49.fsf@suse.de>
 <alpine.DEB.2.21.9999.1906170305020.19994@viisi.sifive.com>
 <mvmh88o5xi5.fsf@suse.de>
 <alpine.DEB.2.21.9999.1906170419010.19994@viisi.sifive.com>
 <F48A4F7F-0B0D-4191-91AD-DC51686D1E78@sifive.com>
 <d2836a90b92f3522a398d57ab8555d08956a0d1f.camel@wdc.com>
 <alpine.DEB.2.21.9999.1906172019040.15057@viisi.sifive.com>
 <CAAhSdy3zODw=JFaN=2F4K5-umihJDivLO8J8LBdkFkuZgzu41Q@mail.gmail.com>
To:     Anup Patel <anup@brainfault.org>
X-Mailer: Apple Mail (2.3445.9.1)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Jun 18, 2019, at 4:32 AM, Anup Patel <anup@brainfault.org> wrote:
>=20
>> =
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/=
?id=3D72296bde4f4207566872ee355950a59cbc29f852

I added your patches, along with two of mine, and rebased them
to the latest U-boot master, and put them on the =E2=80=98to-upstream=E2=80=
=99 branch
at https://github.com/sifive/u-boot/tree/to-upstream

I am most interested in review of the patch that adds the DTS files
from Linux to U-boot, along with a =E2=80=98-u-boot.dtsi=E2=80=99 file =
which includes
several extra things, most notably an ethernet entry [1] which does
not match the new proposed changes for the MacB driver that Yash
is working on.

How close are we to consensus on the new =E2=80=9Csifive,fu540-macb=E2=80=9D=

device tree entry format? Is this something that is stable enough to
start basing some work in M-mode U-boot on yet, or do we expect
more changes?

[1] =
https://github.com/sifive/u-boot/commit/35e4168e36139722f30143a0ca0aa8637d=
d3ee04#diff-27d2d375ddac52f1bca71594075e1be4R93=
