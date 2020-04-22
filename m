Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A6BFE1B3788
	for <lists+netdev@lfdr.de>; Wed, 22 Apr 2020 08:27:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726321AbgDVG1W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Apr 2020 02:27:22 -0400
Received: from mail.zx2c4.com ([192.95.5.64]:49429 "EHLO mail.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725308AbgDVG1W (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 22 Apr 2020 02:27:22 -0400
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTP id 8b2f9940
        for <netdev@vger.kernel.org>;
        Wed, 22 Apr 2020 06:16:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=zx2c4.com; h=mime-version
        :references:in-reply-to:from:date:message-id:subject:to:cc
        :content-type; s=mail; bh=Uehlb2Q1NbpPTv2SoCRdL4Q6SF4=; b=mrGOhf
        YjGvF4KgY6slPdROQGwAgFDo3eomALbBpuAoWUoVj9lskhVm/HsInYwgO5O1/45C
        05r8q7SxHgDJflN9tjj9P7HIPHtzWuJwwcA0irErtI+XPoch8dPs0sm7B1CJ2C0p
        UTyboijkfareTS3q/Vtb2anmIDrMPtHFDtS+7NwKD2i9Eepa3Iqasrk6PGsrG6nt
        aoOnTSRGQoD01BohJy4pnFisH34owwoePOhXGv2twivpQDS/5jGQeo01zmAlb91i
        3/S9cWB1bhJyoiCTKl7iXUX8N2aNcnNCpa5+HpgJk3ZiQxY3KQFJw/Ex7/sdQ52s
        FbAWjlD0wAlFHIUQ==
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 09b5092c (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO)
        for <netdev@vger.kernel.org>;
        Wed, 22 Apr 2020 06:16:24 +0000 (UTC)
Received: by mail-il1-f181.google.com with SMTP id b18so796753ilf.2
        for <netdev@vger.kernel.org>; Tue, 21 Apr 2020 23:27:14 -0700 (PDT)
X-Gm-Message-State: AGi0PuaejNF3DKVsF+Tf6ftbHj25ysYUS5+1NrFJomxEu5mmuTFlRFk7
        pD2JUmaPs9ZqKsyz2O7EX++AJO3WwVZFfQyJzAM=
X-Google-Smtp-Source: APiQypLPVfLg8zJ7gz5Bq24SqvMynIuEsKpkMKME1EcQewetJu9/4M70wWw/ymirtysCzgj6r69TZO2UTSShOj0i2zE=
X-Received: by 2002:a92:d98c:: with SMTP id r12mr25229133iln.224.1587536833413;
 Tue, 21 Apr 2020 23:27:13 -0700 (PDT)
MIME-Version: 1.0
References: <20200422062513.13953-1-sultan@kerneltoast.com>
In-Reply-To: <20200422062513.13953-1-sultan@kerneltoast.com>
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
Date:   Wed, 22 Apr 2020 00:27:02 -0600
X-Gmail-Original-Message-ID: <CAHmME9p=_oBBGGCSqshbFsOeS=Hg7RBnoEZ--MPO5jiJS+P4Ew@mail.gmail.com>
Message-ID: <CAHmME9p=_oBBGGCSqshbFsOeS=Hg7RBnoEZ--MPO5jiJS+P4Ew@mail.gmail.com>
Subject: Re: [PATCH] wireguard: remove errant newline from wg_packet_encrypt_worker()
To:     Sultan Alsawaf <sultan@kerneltoast.com>
Cc:     WireGuard mailing list <wireguard@lists.zx2c4.com>,
        Netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Applied to the wireguard tree and will go out with the next wireguard
update patchset I post on netdev.

Thanks,
Jason
