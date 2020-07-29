Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 323E423268B
	for <lists+netdev@lfdr.de>; Wed, 29 Jul 2020 22:59:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727045AbgG2U7y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jul 2020 16:59:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:35330 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726496AbgG2U7x (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 29 Jul 2020 16:59:53 -0400
Received: from mail-lf1-f46.google.com (mail-lf1-f46.google.com [209.85.167.46])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 574932075D
        for <netdev@vger.kernel.org>; Wed, 29 Jul 2020 20:59:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596056393;
        bh=qSr59HkD8r7arHVfTyPcNq12RpxpSj3YSotGq0Xf1xE=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=cA8joFMnCCTUHXZOBMLlj7QY19mXV26K7VdOPY4Lv5MXkyOI04h7vT+8Kt2ry7Swu
         /Wv4xYoz7hdsC4Fi4gBxCLyy5AYuePkdw6uC6g6y47ejLsOhF2G7jgZ04Ztek3I5cv
         Csq2tSXARn1ND+kUg+crLLn/0OMdMDYEJUf5oRt8=
Received: by mail-lf1-f46.google.com with SMTP id h8so13766516lfp.9
        for <netdev@vger.kernel.org>; Wed, 29 Jul 2020 13:59:53 -0700 (PDT)
X-Gm-Message-State: AOAM532IHvdjz4lQg5w7vSGOAZATXgz0FG8MeBuvRJJTioBFlcmTtzGs
        bGHWreNtQjx8vKGhSkzzNDl/dnU55lGZ8Na1LEA=
X-Google-Smtp-Source: ABdhPJx0+8HGHD6JyZqatII4IyX0yOZh80VYttS9KBQiXSQYN9ecRDMx1J6H87CrEP3N5nG1euvshQKfJyrkcO5bRQs=
X-Received: by 2002:a19:830a:: with SMTP id f10mr49540lfd.28.1596056391740;
 Wed, 29 Jul 2020 13:59:51 -0700 (PDT)
MIME-Version: 1.0
References: <20200729085658.403794-1-liuhangbin@gmail.com>
In-Reply-To: <20200729085658.403794-1-liuhangbin@gmail.com>
From:   Song Liu <song@kernel.org>
Date:   Wed, 29 Jul 2020 13:59:40 -0700
X-Gmail-Original-Message-ID: <CAPhsuW6m8P_7Wjuxz64RQDs85Xv530WjtRS=uUgRihdRLf2mfA@mail.gmail.com>
Message-ID: <CAPhsuW6m8P_7Wjuxz64RQDs85Xv530WjtRS=uUgRihdRLf2mfA@mail.gmail.com>
Subject: Re: [PATCH net] selftests/bpf: add xdpdrv mode for test_xdp_redirect
To:     Hangbin Liu <liuhangbin@gmail.com>
Cc:     Networking <netdev@vger.kernel.org>,
        William Tu <u9012063@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S . Miller" <davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 29, 2020 at 1:59 AM Hangbin Liu <liuhangbin@gmail.com> wrote:
>
> This patch add xdpdrv mode for test_xdp_redirect.sh since veth has
> support native mode. After update here is the test result:
>
> ]# ./test_xdp_redirect.sh
> selftests: test_xdp_redirect xdpgeneric [PASS]
> selftests: test_xdp_redirect xdpdrv [PASS]
>
> Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>

Acked-by: Song Liu <songliubraving@fb.com>
