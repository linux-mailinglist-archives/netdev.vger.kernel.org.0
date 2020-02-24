Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 39C39169F95
	for <lists+netdev@lfdr.de>; Mon, 24 Feb 2020 08:55:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727278AbgBXHzn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Feb 2020 02:55:43 -0500
Received: from mail-yw1-f54.google.com ([209.85.161.54]:36372 "EHLO
        mail-yw1-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726216AbgBXHzn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Feb 2020 02:55:43 -0500
Received: by mail-yw1-f54.google.com with SMTP id n184so4835734ywc.3
        for <netdev@vger.kernel.org>; Sun, 23 Feb 2020 23:55:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=NwDglkCE3KCGCr8mSWguqia//IgT+7ZlD/tzIEgVMjE=;
        b=L7gh2BQs5BCZTVrXeYnBFwr5hScC44bLJ9/knaANW1FDQUreTHdUyhmuYYoWWlP+Ks
         kNUSegeoWwZDuFfEsGcECrGHO8qfVAWLJrRrFCK64h9jULogE374jMfvISfPUBgg7yWc
         MMUDITb019/4bMmnla9ueP+h3mSIsULgVoPmFPJubAEvR0LUUtoat5v6fDR4/1WaKwSN
         qiHBBBrjKxDd7u3I52jcrCnb6ueM++a/AdVPqe836aObvQ/edIr/s9aiv22hENHkZIKy
         rJR6Tm5yoR1fMdhjiVwNJJ8LJzdeVgXunz9V5Ez9fxsD754ZUDNWC47RnOtSLLhPMmep
         yFfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=NwDglkCE3KCGCr8mSWguqia//IgT+7ZlD/tzIEgVMjE=;
        b=YxGDIoTW1b0KqrgoocDDDd9h4nxa5JE92aumrXjLUDgfF22oUweXDAMJLOPmIDnaiX
         vizWQIPqD6fRgb0aLbQA+Ij1tW0EEzsCziuTDETFxVMldCswNNUPeLLLwph9mNuwHyyW
         s5eDsRXwTyND8myhMRbg3k7pgLSqdYZJFWYN0tZGV8zHJ1q8cZ2mjN21NP5F8XbzJJN/
         A1Miw+k5XMKHd8tw7IRqCLRGwqfgUcUbstC5PiQBebYOjQBYdzTC59r6+6LilKqV5f/K
         SSkUDUTrZxnGyOv8qOpBRe1UugEIsuBRxyuxmknrqiLGTFstYqPVLEnm22Qg6DoWYXiF
         p3YA==
X-Gm-Message-State: APjAAAUna41U1qdgr5lShedTVcvkLmyHJpizJ6ivW+2/WbjUxCweCELC
        yrrC3glAsbJwMZz8rgfELuUqNDtcCBgjXRHY4m4gkg==
X-Google-Smtp-Source: APXvYqwlvVEzzcdlgbN/oopHn9KsTFPn9Uoo6MO2DmmJEHjo/UsaMiXV3MGkskmuRdumOU3RMhS+MxBaZ0NfwTFE03Y=
X-Received: by 2002:a81:3845:: with SMTP id f66mr44395590ywa.220.1582530941173;
 Sun, 23 Feb 2020 23:55:41 -0800 (PST)
MIME-Version: 1.0
References: <CABLYT9ixWZu2NckMg689NdCTO08=-+UOHbALYrQFHCY26Bw91Q@mail.gmail.com>
 <CADVnQyn8t7EiorqHjGQe7wqH6jQy_sgK=M=gieb7JMjWqvbBHw@mail.gmail.com>
 <b390a9ed-84a7-d6ef-0647-107259fbd787@gmail.com> <CABLYT9jCD-FPZkJwsKP4gtgGaA8=P5DVtJkzUhuX9YoA5LLdww@mail.gmail.com>
In-Reply-To: <CABLYT9jCD-FPZkJwsKP4gtgGaA8=P5DVtJkzUhuX9YoA5LLdww@mail.gmail.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Sun, 23 Feb 2020 23:55:29 -0800
Message-ID: <CANn89i+r0r2WcKf9cGQVCQHFdmWhvVdDOFXVfdS9vkq0BPTjhg@mail.gmail.com>
Subject: Re: warning messages for net/ipv4/tcp_output.c
To:     Vieri Di Paola <vieridipaola@gmail.com>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        Neal Cardwell <ncardwell@google.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 21, 2020 at 2:11 PM Vieri Di Paola <vieridipaola@gmail.com> wrote:
>
> On Wed, Feb 12, 2020 at 4:47 AM Eric Dumazet <eric.dumazet@gmail.com> wrote:
> >
> > >> I get a lot of messages regarding net/ipv4/tcp_output.c in syslog.
>
> Hi,
>
> These warning messages were triggered by the Suricata IDS/IPS software
> when used in NFQUEUE "repeat mode".
> I've found a workaround, so I don't know if this issue needs to be addressed.
>

I would contact netfilter team ( netfilter-devel@vger.kernel.org )
since this looks like a netfilter issue.

Thanks.

> Regards,
>
> Vieri
