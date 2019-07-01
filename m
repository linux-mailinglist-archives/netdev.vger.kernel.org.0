Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0BBF75C5F3
	for <lists+netdev@lfdr.de>; Tue,  2 Jul 2019 01:38:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727017AbfGAXiO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jul 2019 19:38:14 -0400
Received: from mail-lj1-f196.google.com ([209.85.208.196]:40775 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726866AbfGAXiO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Jul 2019 19:38:14 -0400
Received: by mail-lj1-f196.google.com with SMTP id a21so14966440ljh.7
        for <netdev@vger.kernel.org>; Mon, 01 Jul 2019 16:38:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=45E+pv+3t9aW+XS9b/OTGyiIoCLSUfAELQt3yHQYe2Q=;
        b=t4IkauG+5FiO/mh6s3hs7lTvWbIl7BnpZhFaF3iF/5XCEnoHyTXHDLP/maccuW01kK
         ZtgQsQu/rTZ+P5EmulMshj6g4zT0pPXfE8AqZ4wsujAXtG/GDGFK3xw+z9XClE3K1sbu
         oerVPcONT89ByXIHIQh91/gPuIqdmFzLZZ06wtTuFCW0z1ykJS4SE8c1CtssfsXYagAM
         6OQ09H9pCSkUJiiuAF7tfQsbnffgh9DePwbcxLTG9swy0FSZaH/MXWinzIDRunPTBEeK
         P2ium5mHHRPAQ35iIvawMitvVTkrNjb+0jAcvSWEJ/cvKtSRa8jmEJrtvZCU8N4FtUdh
         pAAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=45E+pv+3t9aW+XS9b/OTGyiIoCLSUfAELQt3yHQYe2Q=;
        b=YtjlvIKqck2nu/MdW0yZae3n9zBCL5nSxkZrRUrrEZ2JeY3o2AQ5r2RYu8VrPp949I
         F1jLPMxdWwdV4VHqdvSK2Intb0g3JKb5HD04BzLN/OKIZiQtjg2L5EBSsog5rDkKcvhk
         M34WrZhK8yJMmDyQSaDy6QzpCAmE+PnItBTEI9zh62zqqccDGhrrOtjZT5el0XJGMZYE
         ED1SouO2JG7rq+tt+ZZlSOZH2liHbNYxa20OxoYhOjLagFQtvOwQNMxzcewp6Q7meCDt
         tNoEHc06jDJe+FKPrO8as6MifE1bwUzVzj5OxvyKA0LvR8HbtdYPjpsyrNVOZ0gaCCXe
         wLSA==
X-Gm-Message-State: APjAAAVNMaokLN+l2ur0mVYzjaEIMMHPffnR5QwfVh9Hw2unIbMM+UgO
        +82M8VyYUZu5EeHauQowCrc0BBEmSDkvOgrOmdylR4QiCLk=
X-Google-Smtp-Source: APXvYqyhG5TDNoczfOqy+CupJib9DwFfGfybtVgoAyM8nXkqMcL1saVNGRL8mjdfT/zEul0nEkyqJqJ2+kLRr1AImc8=
X-Received: by 2002:a2e:9788:: with SMTP id y8mr15553861lji.41.1562024291791;
 Mon, 01 Jul 2019 16:38:11 -0700 (PDT)
MIME-Version: 1.0
References: <20190628230733.54169-1-csully@google.com> <20190629112829.698d2d8b@cakuba.netronome.com>
In-Reply-To: <20190629112829.698d2d8b@cakuba.netronome.com>
From:   Catherine Sullivan <csully@google.com>
Date:   Mon, 1 Jul 2019 16:37:59 -0700
Message-ID: <CAH_-1qwF6f=uyxNM8Ys_MaM+p8xMui7zYdSEjkHLf4f1sHmGyg@mail.gmail.com>
Subject: Re: [PATCH net-next v3 0/4] Add gve driver
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Done in v4, thanks!

On Sat, Jun 29, 2019 at 11:28 AM Jakub Kicinski
<jakub.kicinski@netronome.com> wrote:
>
> On Fri, 28 Jun 2019 16:07:29 -0700, Catherine Sullivan wrote:
> > This patch series adds the gve driver which will support the
> > Compute Engine Virtual NIC that will be available in the future.
>
> Looks like buildbot also found a bunch of bad endian casts.
> Please make sure the driver builds with no warnings with W=1 C=1.
