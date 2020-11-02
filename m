Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D268C2A2380
	for <lists+netdev@lfdr.de>; Mon,  2 Nov 2020 04:37:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727652AbgKBDgs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 1 Nov 2020 22:36:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727461AbgKBDgr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 1 Nov 2020 22:36:47 -0500
Received: from mail-qt1-x844.google.com (mail-qt1-x844.google.com [IPv6:2607:f8b0:4864:20::844])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19525C0617A6
        for <netdev@vger.kernel.org>; Sun,  1 Nov 2020 19:36:46 -0800 (PST)
Received: by mail-qt1-x844.google.com with SMTP id m65so8392065qte.11
        for <netdev@vger.kernel.org>; Sun, 01 Nov 2020 19:36:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to;
        bh=X2rrIuVPDGLDA1noBEoZtA396fe11qvLWYIDaBUe4cY=;
        b=VCBfTBPZ4gF8v4FXRLjSDYvVoUiyd38Sa9rymC2nTsZRRCtnJV/i0WyQiem/deaICq
         SxrarR9L5T3S8wSzMjBRtCr7vne6NpC9UXuN60oLEcYTDeyqIDZ8YxxlR5UKVw/G/vnU
         QyNMPQyVbesOPdUTKmHgD3XEPoifhCZ/U07J7VuJsSC9bmE+0JAbHk30U1L95iXx60ON
         DAEuVYr5AVzDs0i85JVBDexc6oCMzf4pzi+fL2nk0uiX6+OSOYZ7dzxosMqtzvd/kOxA
         9S7gjVd+gyGwEBb2cp5oyVLXNamy22yJalBOYVGoGP8FFVnd4/txDkfFQwKQDfBcgZyB
         gExQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to;
        bh=X2rrIuVPDGLDA1noBEoZtA396fe11qvLWYIDaBUe4cY=;
        b=DwZFEGD2Iv8snKZZ0kAiNvzOI+mpq+ZpHAcTsyyYBQDNatoFQvLw7PYLwlN5LqGKI5
         bDAGl3Nmql3j4sSn+U7v+sFXbrnpkpkt0ANSfy8vKBj4cBUqttn7509ivHXY9m2BDjZO
         7Sxc32xLXaPjLuQc3zC2n8P6o9MHokuK4bT/EzilLHPU7GgvYtrKyisL3v92x+QcSa4v
         HOTpTRxyA9VHSFC0ry+ePsbm5edg1QTJ0BU6sDHefarAsVvhItYUO+9SDRWCbF0+gCEx
         MNZd/P5Wj1h4sMOgPr4F8uPwMxDIQccDgA3ayJYBYgEBNMvmL+r3Ek2w/Aw7Rqh2vdhC
         HAtg==
X-Gm-Message-State: AOAM533RjES+pVT6Ip83PasI9eZCMW9KG4SMHLQ3xa8E+Uw1e5cf3KYY
        uKxUKu2gjBjN+zkojjkYqjLE91Ft0Uppsmn7sZ8ZrzupQuk=
X-Google-Smtp-Source: ABdhPJxm2qvyPtfWlUi0qCy4wms6FnalQXUog7yxEwsp6dHz/8b77e672s1xty0rzTzngw6z8hNNyVC1IEMLIkHPCqw=
X-Received: by 2002:ac8:4d03:: with SMTP id w3mr12782270qtv.360.1604288203753;
 Sun, 01 Nov 2020 19:36:43 -0800 (PST)
MIME-Version: 1.0
References: <CAOKSTBtcsqFZTzvgF-HQGRmvcd=Qanq7r2PREB2qGmnSQZJ_-A@mail.gmail.com>
In-Reply-To: <CAOKSTBtcsqFZTzvgF-HQGRmvcd=Qanq7r2PREB2qGmnSQZJ_-A@mail.gmail.com>
From:   Gilberto Nunes <gilberto.nunes32@gmail.com>
Date:   Mon, 2 Nov 2020 00:36:07 -0300
Message-ID: <CAOKSTBuRw-H2VbADd6b0dw=cLBz+wwOCc7Bwz_pGve6_XHrqfw@mail.gmail.com>
Subject: Fwd: Problem with r8169 module
To:     netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi there

I am in trouble when using newer kernels than 5.4.x regarding Realtek NIC r8169

Kernel 5.9.2-050902-lowlatency (from
https://kernel.ubuntu.com/~kernel-ppa/mainline/ and also compiled from
kernel.org)

Generic FE-GE Realtek PHY r8169-101:00: Downshift occurred from
negotiated speed 1Gbps to actual speed 100Mbps, check cabling!
r8169 0000:01:00.1 enp1s0f1: Link is Up - 100Mbps/Full (downshifted) -
flow control rx/tx

Kernel 5.4.73-050473-lowlatency (from
https://kernel.ubuntu.com/~kernel-ppa/mainline/)

IPv6: ADDRCONF(NETDEV_CHANGE): enp1s0f1: link becomes ready
r8169 0000:01:00.1 enp1s0f1: Link is Up - 1Gbps/Full - flow control rx/tx

Cable is ok! I double check it....





---
Gilberto Nunes Ferreira
