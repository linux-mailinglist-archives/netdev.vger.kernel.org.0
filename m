Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6B99713960
	for <lists+netdev@lfdr.de>; Sat,  4 May 2019 12:57:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727208AbfEDK5h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 May 2019 06:57:37 -0400
Received: from mail-ot1-f65.google.com ([209.85.210.65]:37910 "EHLO
        mail-ot1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725981AbfEDK5h (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 May 2019 06:57:37 -0400
Received: by mail-ot1-f65.google.com with SMTP id b1so7576115otp.5;
        Sat, 04 May 2019 03:57:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=PtqbTcb72Q7KVyfWSiqnpI2Et59naldE4J83TTDiAbk=;
        b=HbavCllmnSyLHIwTYPQZBvV+IexfpvZpAijOH7LH/3wbBSs+cd0OhiHxidH3xfGF3M
         +C0iDYL4iQpte32qkK/ZBTbU2S48PIMmygYWABxE0Uu2rfvnpNkoPn0N+xkIBWN3zdgO
         xwbgyZYq4RVJVKbAi4AMwvsZ+Qmvag7tJsYBD9lPbaVkbTjPJq3mNyIbrqdbWFxtTagO
         xah72q7MWHLz87X2jcdimvx60ZTf37s49B6Ge8SocgFfihIRCe7JUXju5YIBtZ04ERKY
         9jrwPIQ/JjiCCia6A5m3TlmNhiiprzWmqICBAjSFM+WQ7PifWfbEP+dZpoTit6lIqwPF
         0Waw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=PtqbTcb72Q7KVyfWSiqnpI2Et59naldE4J83TTDiAbk=;
        b=n2XCnJ0J8+I4phSE9oY6gAksZF7T/zQMUz2PepdXHqX9D44b7jS7av2yiLr9B5+Qhp
         xrWU2eWcjMHQLuzDTk9p5L/OUbRMaLlZmnqdZG4hBsdqDfpQHj4+uPNgEwAbnkbl8fyc
         2zRsuCkcHDF9j3faPLUaJF0hkdv8kGs1kTb/gFCrtOyOSKuHN7X7B5ba1uvRLjXxtjMo
         8n8Y5LbgB0Ayotm2yUyzvGLP8Y9uHQH2KZeunKnVKd5bhjeIv1anZxZ5EG0pzb9rrUbY
         rCKlV+SdPt6cCsAkB+NnkQcwj982I0PsduPiXKHz4hdH+YEF+t9fK62oaD/isfazygvd
         GcDQ==
X-Gm-Message-State: APjAAAV160VF4nnzA03WE6DggYkb/0PNvhPmvQSz8EQ2pdS+ofaG3gdG
        ynelD4M8Yad2BaMP/85G8w1UL2/pYh/hppnuT/cGS7No
X-Google-Smtp-Source: APXvYqxJusKgJURVXUVLzDE2XjKyLIJZvdJlVTmwtwordrYhDZcxPBU+rlwhXgx9E/7iP8tCkp2bpzWnGN1Iq6I1KRM=
X-Received: by 2002:a9d:77d6:: with SMTP id w22mr9767065otl.154.1556967456419;
 Sat, 04 May 2019 03:57:36 -0700 (PDT)
MIME-Version: 1.0
References: <20190503154007.32495-1-kristian.evensen@gmail.com>
 <0326116f-f163-5ae1-ce19-6a891323eb03@6wind.com> <20190503170510.dn3z2363bsc5y4zp@salvia>
In-Reply-To: <20190503170510.dn3z2363bsc5y4zp@salvia>
From:   Kristian Evensen <kristian.evensen@gmail.com>
Date:   Sat, 4 May 2019 12:57:03 +0200
Message-ID: <CAKfDRXiTy0dMko5=_H-gi5gtW6GHdSNhJYLf5+_=x1ZkUxe8kA@mail.gmail.com>
Subject: Re: [PATCH] netfilter: ctnetlink: Resolve conntrack L3-protocol flush regression
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Nicolas Dichtel <nicolas.dichtel@6wind.com>,
        Network Development <netdev@vger.kernel.org>,
        Netfilter Development Mailing list 
        <netfilter-devel@vger.kernel.org>, Florian Westphal <fw@strlen.de>,
        David Miller <davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 3, 2019 at 7:05 PM Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> Will fix this before applying, no worries.

Thanks for taking care of my mistake :)

BR,
Kristian
