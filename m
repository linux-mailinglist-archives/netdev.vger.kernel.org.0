Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 679273BBBE
	for <lists+netdev@lfdr.de>; Mon, 10 Jun 2019 20:21:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387643AbfFJSUH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jun 2019 14:20:07 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:39212 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726214AbfFJSUG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Jun 2019 14:20:06 -0400
Received: by mail-pf1-f194.google.com with SMTP id j2so5772620pfe.6
        for <netdev@vger.kernel.org>; Mon, 10 Jun 2019 11:20:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=p25gw3TB/KNJG6yDOyj9tnER9l4zPZp+hs1Uckrbjlc=;
        b=WIRoEFTYQh8FDkqjkjZpbX4XXIIV/sPriVAH5ZvZVUbmAJXf27vy5LrJxbSlcCqsDR
         7xiI7kcPAlbRvKbr+3S/414zdqtLkrtl0u3kKGizFc3gLgU/CrT5giQg1Z62ljwnNnd0
         6L6x+6oLxcjYgNJgE0m4OV6vseZB7v+0IxqmBTiD9PRr4mFUaqbpKQ3MTkLLleeoK/Or
         lO/yr0o9/5P1Tb9phLDnP72xjTSFiZvtHNhSe37hlbjSEoIQ6k8Oraq8sPqOO5Yjwo1c
         FSt8b19fvK6fiB7BIyPKV4Qk0F2MkBTaCdgCDzb2Q1odR7dS7Y5efoihaw2OyrxaMQSy
         1XVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=p25gw3TB/KNJG6yDOyj9tnER9l4zPZp+hs1Uckrbjlc=;
        b=FrzV02yH5tAMdq9yXTIUYRVpX6nUKpgxQs9NmOF2Yybk5/IK1fVvX24d4Z5isNQT2y
         asNuK340wb+pwpIlTnApHfoCHQO43li52+QT0OMdMDkacSaXzG9B0GwphyMpquA+CFPC
         mIA6eQBlO5LjamsTfPslxFJ815bzmIb5BqZfpCBGps7lGbPheNQUxl9VqunVzngs0Arv
         ViIZv3sHCqIKstakvIeAQJecSBVK0cA6xTql2/SS2UprH+FlOzP4Fmk7CGdPTIon5aK/
         IEXNmmL/+j2W0w4n6ECgrsuqXK2vtwWBdAzUQkoZYRE3NeaYo1HD6xmYDMtU5W35ZSJX
         7CAg==
X-Gm-Message-State: APjAAAW83/7t8yI4ttJvnMpXe2CgRz9aLCbSHikLAPvWDKM3Cskt8fRp
        J+QRz0G6R4SA87rvcaCKbKrgFsHsuhGSeFpt4qSGbQ==
X-Google-Smtp-Source: APXvYqwmLb2tg3myhPl6Md772ciov4MT1nzOdEEebdXQAdada68O3oGhhLOwGfayq1uQ3mCkJLr/ubVk3EAaVR2j8qY=
X-Received: by 2002:a65:62cc:: with SMTP id m12mr16661868pgv.237.1560190806309;
 Mon, 10 Jun 2019 11:20:06 -0700 (PDT)
MIME-Version: 1.0
References: <20190610063821.27007-1-jian.w.wen@oracle.com>
In-Reply-To: <20190610063821.27007-1-jian.w.wen@oracle.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Mon, 10 Jun 2019 11:19:54 -0700
Message-ID: <CAM_iQpXk_-4zKJXkEDVUKUYxEpa8QNa8u2iD4BVxTTWQe=J4cA@mail.gmail.com>
Subject: Re: [PATCH net] net_sched: sch_mqprio: handle return value of mqprio_queue_get
To:     Jacob Wen <jian.w.wen@oracle.com>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        John Fastabend <john.r.fastabend@intel.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jun 9, 2019 at 11:41 PM Jacob Wen <jian.w.wen@oracle.com> wrote:
>
> It may return NULL thus we can't ignore it.

How is this possible? All of the callers should have validated
the 'cl' before calling this, for example by calling ->find().

I don't see it is possible to be NULL at this point.

Did you see a real crash? If so, please put the full stack trace
in your changelog.

Thanks!
