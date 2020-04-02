Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3DFD419C175
	for <lists+netdev@lfdr.de>; Thu,  2 Apr 2020 14:52:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388387AbgDBMwk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Apr 2020 08:52:40 -0400
Received: from mail-qt1-f170.google.com ([209.85.160.170]:40325 "EHLO
        mail-qt1-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388312AbgDBMwk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Apr 2020 08:52:40 -0400
Received: by mail-qt1-f170.google.com with SMTP id y25so3068412qtv.7;
        Thu, 02 Apr 2020 05:52:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=user-agent:date:subject:from:to:cc:message-id:thread-topic
         :references:in-reply-to:mime-version:content-transfer-encoding;
        bh=QCBSvIRHgvM9RB9j7/TK8QMBYlllJbQ88T/ZrB7LOlg=;
        b=rxWVzi84N9Yox2z4OP2zTO+PlmSxEpcLGO8k3ZVnZL6M7pAMPlcH0rBfDGFv5RKP9/
         5SL2SCY0yDfn/Csc94aWkccfrYEJ3elLY+ICVUdGlu/pbdLF0P5CrujRipiDMO+deB9u
         OGhbNazla9/hsfA/RMW6LJ/Xd2HjgiIbKpffg4625920aRJRyh6ms2AiNYbwxGfXRcQm
         msOx8Qc44A2Q6l1u+kNYvwEIINUqvrnQaIHA7RZnsqBp4MLQB9fy7J9rJyjiqZKskpxY
         Q01JJnmVhW5xzCZMTy9ZpGn5dw2TV8Et7ezVm7oRCUEFFroTolbTHo4nKx179G+hmzF/
         Mzow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:user-agent:date:subject:from:to:cc:message-id
         :thread-topic:references:in-reply-to:mime-version
         :content-transfer-encoding;
        bh=QCBSvIRHgvM9RB9j7/TK8QMBYlllJbQ88T/ZrB7LOlg=;
        b=s0rM8BGwq6Z0en3xlwcEFkx1acV0VvbJJtZDYUOX9ZXmosxpU6mZ62Ji+ZRgw38UEx
         kfwSXTm51SGRB/gyLstC6YFWjmdz9wkzUfAzOJqeu2flt0O3wjjoQCL+raVUAR4V7NrG
         GGs2RV+w1X4vny+EY92vl1mRASHkkiaKNRyJx4EeJbeL2in9D7a8YfWqql4OCHo21R23
         QHtX9za3Hi5dy3WJqpdzTynnXzpf/A2Ej91isEemIKcw/OLKpdkkR8HSVr7JYoA1FAq5
         f99YQki9xuEPq7AfEfxuO013aQpQg5HV27Lpma6GFyICdLGH6CBtUvsBlLZ/blq4ymyp
         IVzA==
X-Gm-Message-State: AGi0PuaqXqldm8vXjWjRnx/ShLxENy/3kCnm99f1PbRmzQXszZWXkyd8
        ssFY6rJVQiKCQ35f3gp15/jJzzVvBvnIF6Eh
X-Google-Smtp-Source: APiQypLPzzNH+hciFsKE1g7LPJof51tBqx8QdAHBsI1DHPhMx4+PYNj3Fl1b/mcdTTORnyKG7LuWtg==
X-Received: by 2002:ac8:568b:: with SMTP id h11mr2685282qta.105.1585831959148;
        Thu, 02 Apr 2020 05:52:39 -0700 (PDT)
Received: from [10.117.94.148] ([2001:470:b16e:20::200])
        by smtp.gmail.com with ESMTPSA id g201sm3403591qke.99.2020.04.02.05.52.38
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 02 Apr 2020 05:52:38 -0700 (PDT)
User-Agent: Microsoft-MacOutlook/16.35.20030802
Date:   Thu, 02 Apr 2020 08:52:37 -0400
Subject: Re: [ANNOUNCE] nftables 0.9.4 release
From:   sbezverk <sbezverk@gmail.com>
To:     Phil Sutter <phil@nwl.cc>
CC:     Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter <netfilter@vger.kernel.org>,
        netfilter-devel <netfilter-devel@vger.kernel.org>,
        <netdev@vger.kernel.org>, <lwn@lwn.net>
Message-ID: <60AB079D-9481-4767-9E07-BDEE7E691B6B@gmail.com>
Thread-Topic: [ANNOUNCE] nftables 0.9.4 release
References: <20200401143114.yfdfej6bldpk5inx@salvia>
 <8174B383-989D-4F9D-BDCA-3A82DE5090D2@gmail.com>
 <20200402124744.GY7493@orbyte.nwl.cc>
In-Reply-To: <20200402124744.GY7493@orbyte.nwl.cc>
Mime-version: 1.0
Content-type: text/plain;
        charset="UTF-8"
Content-transfer-encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Phil,

Thank you for letting me know, indeed it is sad, but hopefully it will get =
in sooner rather than later.

Best regards
Serguei

=EF=BB=BFOn 2020-04-02, 8:47 AM, "Phil Sutter" <n0-1@orbyte.nwl.cc on behalf of p=
hil@nwl.cc> wrote:

    Hi Serguei,
   =20
    On Thu, Apr 02, 2020 at 08:38:10AM -0400, sbezverk wrote:
    > Did this commit make into 0.9.4?
    >=20
    > https://patchwork.ozlabs.org/patch/1202696/
   =20
    Sadly not, as it is incomplete (anonymous LHS maps don't work due to
    lack of type info). IIRC, Florian wanted to address this but I don't
    know how far he got with it.
   =20
    Cheers, Phil
   =20


