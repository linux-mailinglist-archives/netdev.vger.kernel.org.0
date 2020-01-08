Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6278213380D
	for <lists+netdev@lfdr.de>; Wed,  8 Jan 2020 01:34:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727158AbgAHAeX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jan 2020 19:34:23 -0500
Received: from mail-ot1-f53.google.com ([209.85.210.53]:33952 "EHLO
        mail-ot1-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727139AbgAHAeX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jan 2020 19:34:23 -0500
Received: by mail-ot1-f53.google.com with SMTP id a15so1935565otf.1
        for <netdev@vger.kernel.org>; Tue, 07 Jan 2020 16:34:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=niWhBRhKXmzjQvQ9xA9c9ow/qbkjjEi+sqGmzoce9JQ=;
        b=PmL2VCRAf1FOxeLsGkCXOz2ma0tzVgRna6HFAAXkNnx4q072/A23l37Lb38cY1skZ3
         tGmETHuVzW+eici+axAuQu3nETBInRWGnLyh6XZz5iukb2yjXlt4EZPSQVctmvDAtTgT
         NCdLQ8qLVkjIiPCCUa/g5irbIW8+XZb9f0AhLVhB7Gw+w0SCgPpEASL1IV04hpH1o2fy
         gZRqMDSGB2zdsBZr6uBDFm5BH2cnyLMbYT8jprwpy/qtLnhfGp0gxAj6QXBzc6LBUZVa
         eEL5kis/W/fZ2tPqomacujf1SeAw97FOhaAfi/STf2js2n/2KwN8xbw9x5okAdC4v46E
         0IpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=niWhBRhKXmzjQvQ9xA9c9ow/qbkjjEi+sqGmzoce9JQ=;
        b=pLVi0pQUyXNouv+Bvd2UY9CoakNtYgTIOChLtJPuN1pm8iKkvh9CBFdS8pPTQv2QrF
         t1VbNslmwSP0764mLkAVZYYmUX1+YQR5IUpYhZVfvMlkxaOK9mBhaJVtaOAuRZh235+O
         r2FvStEXlj4lfrylW+tW5TxqijPMLUYNmYaGpo+IyGXwfWcCuNgnTnDNo+J9bNrAoC4A
         o+vLMLwa5Yg5X05A+W1XtpIDMRzShKMAnwRG7PgaRQloxerxwmWHO2pdTEGAS2twJDcj
         Mi7pdzLuh7QNkdPuO7nPQEiXh43GRR+VW2HgERS4z+Qa5/K0aG56iozd3QlDeKts0h2R
         WuCA==
X-Gm-Message-State: APjAAAV8gl+Py2NMKA4yZ+K1Xbt6X4eKckns75dcTn8c79Wh+NlFjF7E
        a57nPzGectluoEld2vFmQqTbeS4yP2z+dYAf8Fc=
X-Google-Smtp-Source: APXvYqxAT620gIC2x/ih1hDhDGZDOCHhJVRxVhcGtLVe01Cxx/VypQjWm5lh+ky5xxfHYGSAMXXnPi4MHYYO8IiRGcY=
X-Received: by 2002:a9d:53c4:: with SMTP id i4mr2385557oth.48.1578443662689;
 Tue, 07 Jan 2020 16:34:22 -0800 (PST)
MIME-Version: 1.0
References: <000000000000ab3f800598cec624@google.com> <000000000000802598059b6c7989@google.com>
 <CAM_iQpX7-BF=C+CAV3o=VeCZX7=CgdscZaazTD6QT-Tw1=XY9Q@mail.gmail.com> <CAMArcTXTtJB8WUuJUumP2NHVg_c19m-6EheC3JRGxzseYmHVDw@mail.gmail.com>
In-Reply-To: <CAMArcTXTtJB8WUuJUumP2NHVg_c19m-6EheC3JRGxzseYmHVDw@mail.gmail.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Tue, 7 Jan 2020 16:34:11 -0800
Message-ID: <CAM_iQpVJiYHnhUJKzQpoPzaUhjrd=O4WR6zFJ+329KnWi6jJig@mail.gmail.com>
Subject: Re: WARNING: bad unlock balance in sch_direct_xmit
To:     Taehee Yoo <ap420073@gmail.com>
Cc:     syzbot <syzbot+4ec99438ed7450da6272@syzkaller.appspotmail.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 7, 2020 at 3:31 AM Taehee Yoo <ap420073@gmail.com> wrote:
> After "ip link set team0 master team1", the "team1 -> team0" locking path
> will be recorded in lockdep key of both team1 and team0.
> Then, if "ip link set team1 master team0" is executed, "team0 -> team1"
> locking path also will be recorded in lockdep key. At this moment,
> lockdep will catch possible deadlock situation and it prints the above
> warning message. But, both "team0 -> team1" and "team1 -> team0"
> will not be existing concurrently. so the above message is actually wrong.
> In order to avoid this message, a recorded locking path should be
> removed. So, both lockdep_unregister_key() and lockdep_register_key()
> are needed.
>

So, after you move the key down to each netdevice, they are now treated
as different locks. Is this stacked device scenario the reason why you
move it to per-netdevice? If so, I wonder why not just use nested locks?
Like:

netif_addr_nested_lock(upper, 0);
netif_addr_nested_lock(lower, 1);
netif_addr_nested_unlock(lower);
netif_addr_nested_unlock(upper);

For this case, they could still share a same key.

Thanks for the details!
