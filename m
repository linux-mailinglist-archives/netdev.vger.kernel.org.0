Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D696E23269D
	for <lists+netdev@lfdr.de>; Wed, 29 Jul 2020 23:07:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727074AbgG2VHd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jul 2020 17:07:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727069AbgG2VHd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jul 2020 17:07:33 -0400
Received: from mail-qv1-xf44.google.com (mail-qv1-xf44.google.com [IPv6:2607:f8b0:4864:20::f44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7905C061794
        for <netdev@vger.kernel.org>; Wed, 29 Jul 2020 14:07:32 -0700 (PDT)
Received: by mail-qv1-xf44.google.com with SMTP id a19so5551303qvy.3
        for <netdev@vger.kernel.org>; Wed, 29 Jul 2020 14:07:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ZgwzftiYCU2Bm6Kc71hxTC3rIDIRuG8IFbfyknH8uww=;
        b=SplXiv4glKSmM6f/sgymx7Rc8PBhiMtKg3UKdoLVoT/0R8BBCgFaPmBi4UnNZJ5szk
         XlxMdvVeUhfbmOePS4ePAkdtHYyA8jH/QvM3v4Tl8Ku2JKpa/Sjyje2qH9RSyudnPAOf
         Wj52ASgapQ0VdYofY2bdXFB5T3V2c0+5UladSdkru+pAoWqvXeaTEsql5aEnhe41cBJz
         cHgohprLxo7QRGgOBr13qKmMUm2ziInee9bkJbF9xugKB3XnRmrE+yJHxKMJZW9tbDVZ
         eY88VOz+pw3+7znWQffWsXhvdSNE9nV9ZyE6VFfDxgjCZNZBvSty5egbKHxIY3uGqUOd
         p6KA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ZgwzftiYCU2Bm6Kc71hxTC3rIDIRuG8IFbfyknH8uww=;
        b=CgVtaXTBQMgjAZxwqBwOuKxSxCzUpG60Vj6VsxsQn6P/QJ9adqhwBOQMJOs7p6stFL
         dUKVkyUJk93S7zKq64tv33hdapXT7HbR9nguXNLVxq2P+LkSF9tyDNE8u5cKk6s3x1or
         GVHwOkcUvf4kTzVR0KqKdtAIQwY19TPfZiVRbXlzIfCvhOgt0qeAI5s/ePha26jBkZ+n
         wNZviC3XJ2k7tj+nlz2iDyZnVbWNQZ9Jphkz9/m27n39mgHwI2ZKxJke+wRmpugGeUwo
         hRvylRgl2ilWHMcpW/MIi/Y0W2fESFKJ2pRnLwaN7aeV1a9TJNI9V4626oH60kR7a/Mu
         2BWQ==
X-Gm-Message-State: AOAM531myoxkB7xQry4q90b7vPicBdUggVMCFadFFvE3sez3ENnz0d0Z
        a6XlOQmKwyhacSlz6n2SYpomkL6oWDXduPvteRE=
X-Google-Smtp-Source: ABdhPJzsfKAaNr8JmoLkS63T02laNIgoaHUjiAIrUooNottL/4OCeXWBStYLXniJCQGpuYY0Sw7lxVwoOXJ3WoN1gPo=
X-Received: by 2002:ad4:4089:: with SMTP id l9mr167253qvp.175.1596056851970;
 Wed, 29 Jul 2020 14:07:31 -0700 (PDT)
MIME-Version: 1.0
References: <20200729085658.403794-1-liuhangbin@gmail.com> <CAPhsuW6m8P_7Wjuxz64RQDs85Xv530WjtRS=uUgRihdRLf2mfA@mail.gmail.com>
In-Reply-To: <CAPhsuW6m8P_7Wjuxz64RQDs85Xv530WjtRS=uUgRihdRLf2mfA@mail.gmail.com>
From:   William Tu <u9012063@gmail.com>
Date:   Wed, 29 Jul 2020 14:06:54 -0700
Message-ID: <CALDO+SaL6zNzrdnyyG9Sb6eg2o3T4uPRtedMHMEhjO+R16qf_w@mail.gmail.com>
Subject: Re: [PATCH net] selftests/bpf: add xdpdrv mode for test_xdp_redirect
To:     Song Liu <song@kernel.org>
Cc:     Hangbin Liu <liuhangbin@gmail.com>,
        Networking <netdev@vger.kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S . Miller" <davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 29, 2020 at 1:59 PM Song Liu <song@kernel.org> wrote:
>
> On Wed, Jul 29, 2020 at 1:59 AM Hangbin Liu <liuhangbin@gmail.com> wrote:
> >
> > This patch add xdpdrv mode for test_xdp_redirect.sh since veth has
> > support native mode. After update here is the test result:
> >
> > ]# ./test_xdp_redirect.sh
> > selftests: test_xdp_redirect xdpgeneric [PASS]
> > selftests: test_xdp_redirect xdpdrv [PASS]
> >
> > Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
>
> Acked-by: Song Liu <songliubraving@fb.com>
LGTM.
Acked-by: William Tu <u9012063@gmail.com>
