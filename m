Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8712D2DFD8
	for <lists+netdev@lfdr.de>; Wed, 29 May 2019 16:34:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726544AbfE2OeM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 May 2019 10:34:12 -0400
Received: from mail-lf1-f65.google.com ([209.85.167.65]:43485 "EHLO
        mail-lf1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726068AbfE2OeM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 May 2019 10:34:12 -0400
Received: by mail-lf1-f65.google.com with SMTP id u27so2257828lfg.10;
        Wed, 29 May 2019 07:34:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=zI70QWGFplV2olmPh92cmXfu6wdcq8DiRPpOk3E9130=;
        b=jXCkru3UC3l+qKETouZYsiZiocYiZXZBqx1YKPYhBhQ9A61+o0TQIf+h94wLweTi6l
         PJ/HAQm0NOCDkzbqVRewFDxs6OZAQ0MuVjLZg31zN8iA2fV9589pX4E7vvF066BlZbE7
         Fnt08E3G3cLIB4EkXTJrR370X/3sgE9CFRNOqK+/FCr3FTt6A7t1eyLHkBqPmt3bebHz
         AoXslMLlW17y6UJCCOJj7XMcXwCiJEQH/B9OnmJbN+jx7VvpTeym4geeHzdXcsCUR98a
         7tuV0kLKzcdfV6cWO8jSSGHsqVQgHEDP/PdGxDeBEN6QZi7jT7a5Bd17O7U0tjlAfZ8c
         TE8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=zI70QWGFplV2olmPh92cmXfu6wdcq8DiRPpOk3E9130=;
        b=J4FPUhIsNejWkGaBctr3Wkk1CE62HzYpsO78xHtbgRWNkTuFLLLnXIzSVlwwkxqu9d
         gw8buu3Gc5bRBIMKDgVmIGOKIyLsSkv64sqXXYaeGglAVBJ9TlxI/PwqB2TSsbSxAhLU
         6OEtdgb/dPpigJ/uVvBLD7STyseLnWTcHQ7/fhM4tzop4B5+9FoZesGXy4eLeyo7tl7A
         kbN4HM+b1RowDT4J1d7tihLEgWKTDoXxngS2XlBXtYXqR5y2Ai/ReP0LJDvI89ksIdDw
         f82PtDYIi6HcvsC9S2UrWgi7VaZ/sWMlrWdwkJdKLFqvm3+Otql//lSOxitdlEshRdPB
         QI+Q==
X-Gm-Message-State: APjAAAW1e7dEg8/ztC+biXDgQL64BNBJrJD/tow7CKKbKR6g6lHoCAnv
        +1u3VRrjfJM783YnfoSr8Gl0GrIhgc6ouwwuFQMG+g==
X-Google-Smtp-Source: APXvYqw2p8byOoHi+UD/L6/XXNO04MYdg05GEh6RSLDrBHDRizvs9h6OiioTb3dcyrjEhzqrfdO2wrBMkKIc002E24k=
X-Received: by 2002:a19:ca0e:: with SMTP id a14mr12126071lfg.19.1559140449819;
 Wed, 29 May 2019 07:34:09 -0700 (PDT)
MIME-Version: 1.0
References: <20190529130656.23979-1-tonylu@linux.alibaba.com>
In-Reply-To: <20190529130656.23979-1-tonylu@linux.alibaba.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Wed, 29 May 2019 07:33:57 -0700
Message-ID: <CAADnVQLtZ0oih5cd7FFq8-tQO1N4NR7K5KO9wCvhtFcsJ_=-uQ@mail.gmail.com>
Subject: Re: [PATCH net-next 0/3] introduce two new tracepoints for udp
To:     Tony Lu <tonylu@linux.alibaba.com>
Cc:     Network Development <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Yafang Shao <laoar.shao@gmail.com>,
        Song Liu <songliubraving@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 29, 2019 at 6:10 AM Tony Lu <tonylu@linux.alibaba.com> wrote:
>
> This series introduces two new tracepoints trace_udp_send and
> trace_udp_queue_rcv, and removes redundant new line from
> tcp_event_sk_skb.

Though I like new tracepoints this patch set gets a nack, since commit log
says nothing about use case. Why kprobes cannot achieve the same?
