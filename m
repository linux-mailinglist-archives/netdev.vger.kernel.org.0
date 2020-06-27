Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A59C20C421
	for <lists+netdev@lfdr.de>; Sat, 27 Jun 2020 22:42:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725900AbgF0Umt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 27 Jun 2020 16:42:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725792AbgF0Umt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 27 Jun 2020 16:42:49 -0400
Received: from mail-qk1-x744.google.com (mail-qk1-x744.google.com [IPv6:2607:f8b0:4864:20::744])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BAEE3C061794
        for <netdev@vger.kernel.org>; Sat, 27 Jun 2020 13:42:48 -0700 (PDT)
Received: by mail-qk1-x744.google.com with SMTP id l6so12029073qkc.6
        for <netdev@vger.kernel.org>; Sat, 27 Jun 2020 13:42:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=6eGnAhM3N8Acdl82XbA2ST9Q21RjlZJfwjkcynsIH9o=;
        b=KYnKmiicj5psEFVawyUTi+GBnxaWD/2tAU1qduym/wSdd0v/ohwaP/3mwMZkHVQOWt
         CPIEguCZnVewP4aRauXgWH42YW5jJckD667JPIol7p6W5l4P/fTk90/dkvV4hTsPxH/0
         CmEnoNjCw0XmkwhrQu1zfGzyib8UazP2nELYeVa1nI/KoTbFIVRplcjmVbyiR8vBhfJ0
         zy6Dw1OBLD2NnVBvzFrEuDh7ggGpBzmskVnlcSFDunbmux1xLzTG5FlTBKBoblyd3cxh
         OGF3idr39c9FBH7leLm7v5Jk/lo+AzBEpvQhAwd27XhJqhil8kl11Qdp+IaqtGQf7Ek8
         A56w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=6eGnAhM3N8Acdl82XbA2ST9Q21RjlZJfwjkcynsIH9o=;
        b=fTONCCAfIyv5fk9y7MFksS6pwCp7A8qHfhhm4YVm84kP1JGUL1qgKgDuITcaje3Q95
         IqGhW3DDCb8y3nkfWicpUGjluWAb+VVFb047LGJGo3gPKwWSbeyNOlBfJ+1eWc/Yt+wJ
         10tgIGLKgKDcmIRb/AH3+zjTEIT6d4T0g3YJgzINA2Q4pWR0t2HKPqaZzsWLZNyr8e2k
         hstovBua3cZEBGZ4NJh5KcK2nU7kMhfy1V0i7xK40jANMlmzzjztaImZcLVQP341x1Cj
         9iTIEABJwoiX7G6K8+uJhkToBMSOjzV7OZL8Cm2v7DiinnPRCRMmZ0yFhABVDrSLB8dt
         AeJQ==
X-Gm-Message-State: AOAM531XYrFJdR/Bmcw0uTqRoHfUKnbbYxieZCEVX1P6km7BmFuepPwH
        yPgikJCzDSFuDpeIOcJUnVvTICYAOgwl8Ljb0io=
X-Google-Smtp-Source: ABdhPJyquXWScFTm1YO2wf8QRwdmLScSrNdULK390tmyXAHIFyGr9qPvknUmngekX11Y/p00dYuj4IpHvRZzbWFigRs=
X-Received: by 2002:a37:445:: with SMTP id 66mr8655154qke.188.1593290567925;
 Sat, 27 Jun 2020 13:42:47 -0700 (PDT)
MIME-Version: 1.0
References: <20200626144724.224372-1-idosch@idosch.org> <20200626144724.224372-2-idosch@idosch.org>
 <20200626151926.GE535869@lunn.ch> <CAL_jBfT93picGGoCNWQDY21pWmo3jffanhBzqVwm1kVbyEb4ow@mail.gmail.com>
 <20200626190716.GG535869@lunn.ch> <CAL_jBfQMQbMAFeHji2_Y_Y_gC20S_0QL33wjPgPBaKeVRLg1SQ@mail.gmail.com>
 <20200627191648.GA245256@shredder>
In-Reply-To: <20200627191648.GA245256@shredder>
From:   Adrian Pop <popadrian1996@gmail.com>
Date:   Sat, 27 Jun 2020 21:42:10 +0100
Message-ID: <CAL_jBfTKW_T-Pf2_shLm7N-ve_eg3G=nTD+6Fc3ZN4aHncm9YQ@mail.gmail.com>
Subject: Re: [PATCH net-next 1/2] mlxsw: core: Add ethtool support for QSFP-DD transceivers
To:     Ido Schimmel <idosch@idosch.org>
Cc:     Andrew Lunn <andrew@lunn.ch>, netdev@vger.kernel.org,
        davem@davemloft.net, kuba@kernel.org, jiri@mellanox.com,
        vadimp@mellanox.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>
> Hi Adrian, Andrew,
>
> Not sure I understand... You want the kernel to always pass page 03h to
> user space (potentially zeroed)? Page 03h is not mandatory according to
> the standard and page 01h contains information if page 03h is present or

Hi Ido!

Andrew was thinking of having 03h after 02h (potentially zeroed) just
for the purpose of having a similar layout for QSFP-DD the same way we
do for QSFP. But as you said, it is not mandatory according to the
standard and I also don't know the entire codebase for ethtool and
where it might be actually needed. I think Andrew can argue for its
presence better than me.

> not. So user space has the information it needs to determine if after
> page 02h we have page 03h or page 10h. Why always pass page 03h then?
>

If we decide to add 03h but only sometimes, I think we will add an
extra layer of complexity. Sometimes after 02h we would have 03h and
sometimes 10h. In qsfp-dd.h (following the convention from qsfp.h) in
my patch there are a lot of different constants defined with respect
to the offset of the parent page in the memory layout and "dynamic
offsets" don't sound very good, at least for me. So even if there's a
way of checking in the user space which page is after 02h, a more
stable memory layout works better on the long run.

Adrian
