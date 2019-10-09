Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C01ABD1250
	for <lists+netdev@lfdr.de>; Wed,  9 Oct 2019 17:22:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731592AbfJIPWW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Oct 2019 11:22:22 -0400
Received: from mail-yb1-f196.google.com ([209.85.219.196]:39616 "EHLO
        mail-yb1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728019AbfJIPWV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Oct 2019 11:22:21 -0400
Received: by mail-yb1-f196.google.com with SMTP id v37so857412ybi.6
        for <netdev@vger.kernel.org>; Wed, 09 Oct 2019 08:22:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=CWOz1QdEXP+wpK9Ockn2qmCFEU7lhRlGRIngMhuNF5I=;
        b=KFmh28fL6uaxo5c3BTfc9tBAQTg7OlbZxBSJ5yXZtFdKk25fAhY0tUw7/49ajAUiTz
         Xk8ZtarH0fWKVXJuL6wuLK7ukwovsJzXmvocqjrs7Eg7Yrae2TFxOB+/EBmvjXxWSPRe
         zdcyxP1VomE6zRjaRWmmXdB0kn5kZivXET9I4h9KMem6enIvXn0KmOV21fEotrDeTo5D
         EQhWZDCHap0MJmC0cIXVRSpdPOrOLrzMqU+qMggPwuP7jlhKSZSE/KMydFGMVFJ3a5Vb
         SRLj320eseJ0x/phD3J4HL0TesuFrBSuF2EDWeAKOkRhnLDLWjF1HY1PArryMpZN5CsH
         l9ng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=CWOz1QdEXP+wpK9Ockn2qmCFEU7lhRlGRIngMhuNF5I=;
        b=Gzv4/oZJLHPI3uToLFLCfZU0d1XRWlW7akExLl1C73bo5+qqFbnWTOBoIAEBy06KbC
         f4bPG/qHNWjbQEOZvLGXEhjr80AQdgOJZA+drdpXHsChM7jefhoRw71c/r9ZtCoDQFU5
         IDtYI0FC9w3caiqwY+obs503p3SGc8N0VGDOd0wqRO4iVWwmKdYTN+dHsnuVQK/cw4oR
         zVve2Wp9ZXeQqtqdgsjMtCVaZB9FbUdclF5xTv+4OSeSMGtZtybGLiE8/Ddd3rABeryJ
         gG0fBbNcNHmN/9TYXblrGYu8ULiOXykRIsEUSvDGFAydgWmWMwX8A1V8AZ2GEPSIy6Ee
         nY9w==
X-Gm-Message-State: APjAAAUFncErlHZe8a4zbe0oavzU6h88o0CBiP1w2yMVj8FXVxunVVoN
        LFSxVNLAWtFEgMy4hHi6rBMO4Tm8
X-Google-Smtp-Source: APXvYqx30svXPPJnbykZjgvmvbSmrSrly9ZkcXSPnen4EYSQMgdBr/ZklfpnfZa9QUp4R7GIFQxulg==
X-Received: by 2002:a25:be88:: with SMTP id i8mr2601822ybk.118.1570634538794;
        Wed, 09 Oct 2019 08:22:18 -0700 (PDT)
Received: from mail-yb1-f175.google.com (mail-yb1-f175.google.com. [209.85.219.175])
        by smtp.gmail.com with ESMTPSA id 12sm683263ywu.59.2019.10.09.08.22.17
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Oct 2019 08:22:17 -0700 (PDT)
Received: by mail-yb1-f175.google.com with SMTP id y204so849429yby.10
        for <netdev@vger.kernel.org>; Wed, 09 Oct 2019 08:22:17 -0700 (PDT)
X-Received: by 2002:a25:84ce:: with SMTP id x14mr2480392ybm.443.1570634537210;
 Wed, 09 Oct 2019 08:22:17 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1570455278.git.martinvarghesenokia@gmail.com>
 <5979d1bf0b5521c66f2f6fa31b7e1cbdddd8cea8.1570455278.git.martinvarghesenokia@gmail.com>
 <CA+FuTSc=uTot72dxn7VRfCv59GcfWb32ZM5XU1_GHt3Ci3PL_A@mail.gmail.com>
 <20191009124814.GB17712@martin-VirtualBox> <CA+FuTSdGR2G8Wp0khT9nCD49oi2U_GZiyS5vJTBikPRm+0fGPg@mail.gmail.com>
In-Reply-To: <CA+FuTSdGR2G8Wp0khT9nCD49oi2U_GZiyS5vJTBikPRm+0fGPg@mail.gmail.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Wed, 9 Oct 2019 11:21:40 -0400
X-Gmail-Original-Message-ID: <CA+FuTSe2x+fAcMLNaT-pfB_m=6tK6AQQ+K3AcNNXyCORaH7rdA@mail.gmail.com>
Message-ID: <CA+FuTSe2x+fAcMLNaT-pfB_m=6tK6AQQ+K3AcNNXyCORaH7rdA@mail.gmail.com>
Subject: Re: [PATCH net-next 1/2] UDP tunnel encapsulation module for
 tunnelling different protocols like MPLS,IP,NSH etc.
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     Martin Varghese <martinvarghesenokia@gmail.com>,
        Network Development <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>, corbet@lwn.net,
        scott.drennan@nokia.com, Jiri Benc <jbenc@redhat.com>,
        martin.varghese@nokia.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > Yes  we could. We can move these to a common place. include/net/ip_tunnels.h ?
>
> I think it will be preferable to work the other way around and extend
> existing ip tunnel infra to add MPLS.

But that may not be entirely feasible, not sure yet. Else, indeed
moving such helpers to a common location sounds good.
