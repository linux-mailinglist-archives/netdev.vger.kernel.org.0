Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2048E2DA69B
	for <lists+netdev@lfdr.de>; Tue, 15 Dec 2020 04:03:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726627AbgLODCi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Dec 2020 22:02:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725876AbgLODC1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Dec 2020 22:02:27 -0500
Received: from mail-lf1-x143.google.com (mail-lf1-x143.google.com [IPv6:2a00:1450:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D2D3C061793;
        Mon, 14 Dec 2020 19:01:47 -0800 (PST)
Received: by mail-lf1-x143.google.com with SMTP id s26so895748lfc.8;
        Mon, 14 Dec 2020 19:01:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=2v5zQ4ASqwUEaImz7xFZXnky0JeRmzUKfNWkHn9qJfM=;
        b=GFwc/SmQThkfuiijlhBZC/sL7/Mh9X0gSRoxzCiFmWN7uXQlyORRlUa8F7MVTsRLZw
         MjvFn/0ePlj1h79IHnldGV0sRP89Z7tc8ECMEVBv3B8zKqD5dD5GyuoDkqL8onj8GKHX
         9SoUFrxHFWczz56aY67YAu5OK4hK/FlcV0cOA70tnjbu5uYzXZmLz/Eq8imDs6iG4jvh
         rw0PA24KGL2yjKHXkdJiTYfjwp8qwuQvFqtLLErxpApES3wLwrdNyjRgPFn8nV+VCRwp
         v+XZvTQdfADTHOrUd7f+A913L32vYpDFsP7PpzizvOApaQbT2yHGn/fSNZIK6UkanxTw
         NYYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=2v5zQ4ASqwUEaImz7xFZXnky0JeRmzUKfNWkHn9qJfM=;
        b=LyPUccTQJkRZT9CgOiU1Y0H699q/j9+LXZnQUxyxrWgu3VRO/dKJj9DCoCsivaKHCN
         c8F4p56J9u2I65DU4bDvty4f20spgY7yU+AXYPm0MM6+1fsyy9cpkB8XTsMHJ1OXNkgc
         H1VzMz8QrWRNj5/vB0tzHCFC5TcL7486uuXjixyx689YC5A3c846Hiz6velplYTGiDyT
         azNcr8MaoDOAtoIu+wPNTZU9LefTQ9hwbYjqX9fNENC701+lqvSkOANwUJS4saDhGzQn
         tPyZCS+VKK8J6rYOI8/yU57B/DQEfGzyon2hmHKXTtIln+Qhhp4Sv8Ui4lI3DWvYDBJ0
         Ckiw==
X-Gm-Message-State: AOAM531v7XfueNafOFOzFQh4D/QiqvztDk1Y4IY+W98mYxnkt01B5ZDc
        Z5rsSEHH6qBpf+JPUzUqtr68hukCqENu3YKio4J8rV85
X-Google-Smtp-Source: ABdhPJzb2LVI/Hael6CXe7Dd9N0jB+vHDofiXD9LcZUelPja+WQVgBFG0Fb0ZKnSnTDR/IdvA1iYa1tHnAMmK+oBzSQ=
X-Received: by 2002:a05:651c:1255:: with SMTP id h21mr12465905ljh.8.1608001306008;
 Mon, 14 Dec 2020 19:01:46 -0800 (PST)
MIME-Version: 1.0
References: <20201214122823.2061-1-bongsu.jeon@samsung.com> <20201214154444.GA2493@kozik-lap>
In-Reply-To: <20201214154444.GA2493@kozik-lap>
From:   Bongsu Jeon <bongsu.jeon2@gmail.com>
Date:   Tue, 15 Dec 2020 12:01:34 +0900
Message-ID: <CACwDmQA5xVvyyO21t5meyJr7fbTa4sFwMR-dECJ01Cb6qrh5OA@mail.gmail.com>
Subject: Re: [linux-nfc] [PATCH net-next] MAINTAINERS: Update maintainer for
 SAMSUNG S3FWRN5 NFC
To:     Krzysztof Kozlowski <krzk@kernel.org>
Cc:     linux-nfc@lists.01.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Bongsu Jeon <bongsu.jeon@samsung.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 15, 2020 at 12:44 AM Krzysztof Kozlowski <krzk@kernel.org> wrote:
>
> On Mon, Dec 14, 2020 at 09:28:23PM +0900, Bongsu Jeon wrote:
> > From: Bongsu Jeon <bongsu.jeon@samsung.com>
> >
> > add an email to look after the SAMSUNG NFC driver.
>
> Hi Bongsu,
>
> Review and testing is always appreciated. However before adding an entry
> to Maintainers, I would prefer to see some activity in maintainer-like
> tasks. So far there are none:
> https://lore.kernel.org/lkml/?q=f%3A%22Bongsu+Jeon%22
>
> Contributing patches is not the same as maintenance. Please subscribe to
> relevant mailing lists and devote effort for improving other people
> code.
>
> We had too many maintainers from many companies which did not perform
> actual maintainership for long time and clearly that's not the point.
>
> Best regards,
> Krzysztof

Ok, I  understand it.
