Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 819A7479923
	for <lists+netdev@lfdr.de>; Sat, 18 Dec 2021 07:13:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232192AbhLRGM7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Dec 2021 01:12:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232184AbhLRGM6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Dec 2021 01:12:58 -0500
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A941C061401
        for <netdev@vger.kernel.org>; Fri, 17 Dec 2021 22:12:58 -0800 (PST)
Received: by mail-pf1-x42f.google.com with SMTP id m1so2928202pfk.8
        for <netdev@vger.kernel.org>; Fri, 17 Dec 2021 22:12:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=E/hdGTyyQXKE79OTwsvdu7cglvijklxETQqGuwk7xBA=;
        b=DUiWR6oDS+TJ1jzN7OlswoJ4jFk5Nj1GmN8oMQWzrvNVxdSWnCWooeKJddajZC46lg
         k2uN9gsrz/XWQoRjUxDZG2e4ry8VSj3bztZm1FCnOnmAi2NavqKWYu81fNVSNVa3FmKL
         lUw3c+Panl+jsu2Yb72BOmgoKDdlnG3YMwGd7AMhoh1h+xynpTCm6hsbV5CR8cH5KhLT
         p3nnak5AxsQqGk3WfYBh1/qWuS2QXdelz73SseuQFMMNLvbLPTANUS+u3NE8yrWgf/6/
         7QyEQSUnZGUoDc7ZnuvR2SwATJz+5uJVzQhw/1qX4tmjxlEQzXsmW3SE57hghZ+aLaT4
         JWLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=E/hdGTyyQXKE79OTwsvdu7cglvijklxETQqGuwk7xBA=;
        b=yqDKFWwxmDSVMi/ftjVD2LhK6ZZd9ZoicCQfBPOjajd9sYosCezKTwlZxm3eZRPLuP
         4QFMIqir3bRW9OI17JsTp7b+WeV9FslMO58z4BQF4u1kFGw3fCGeCbYDKncZ3RqmPXYV
         1S5+Vt8R4WNj8U57ILwM+7ErjRzX8mibD8mTbauU8F2MG50Qs33uSYkc8b6KZfrTWWo8
         72fQzc1VjhHYUsFNAI+MCH5OOL6X/yR0I7yKaXM5ZBSk5EES/ajZp4wsO4frknBS0DW1
         WD6iGhafW9aXqWsexZq2tpB6HcUNw9htmbmdozZNOZsYy8VSjP+YA4/pTKoGEtMxybTU
         f5rQ==
X-Gm-Message-State: AOAM531wV66Qg0fHWdEPYehQS1mg/ZjDX9H7Aur7UFUwY8rNWdgEkwN4
        4qdvfEArwqaaabIZMUV1KnQ5yBjVTlwv/mC1GK0=
X-Google-Smtp-Source: ABdhPJzYCQkejsonpIEn2hVHogI7jAkOYAFWXm+zyikDEaW3yGF20V7d5tTj3zbehIiHstolWfiZ6QtaDVm8cD3b3b0=
X-Received: by 2002:a63:596:: with SMTP id 144mr5977077pgf.456.1639807978010;
 Fri, 17 Dec 2021 22:12:58 -0800 (PST)
MIME-Version: 1.0
References: <20211216201342.25587-1-luizluca@gmail.com> <20211216201342.25587-2-luizluca@gmail.com>
 <CACRpkdaWY=YMHgbpuvghCMaYk1Fa9_PLdUknmTHyHh7vb1kSjQ@mail.gmail.com>
In-Reply-To: <CACRpkdaWY=YMHgbpuvghCMaYk1Fa9_PLdUknmTHyHh7vb1kSjQ@mail.gmail.com>
From:   Luiz Angelo Daros de Luca <luizluca@gmail.com>
Date:   Sat, 18 Dec 2021 03:12:47 -0300
Message-ID: <CAJq09z4e=9-A8bz-pE45izAXb9kXttN9RGg1HBxFb9p7wyF4Kg@mail.gmail.com>
Subject: Re: [PATCH net-next 01/13] dt-bindings: net: dsa: realtek-smi: remove
 unsupported switches
To:     Linus Walleij <linus.walleij@linaro.org>
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        vivien.didelot@gmail.com, Florian Fainelli <f.fainelli@gmail.com>,
        olteanv@gmail.com,
        =?UTF-8?Q?Alvin_=C5=A0ipraga?= <ALSI@bang-olufsen.dk>,
        =?UTF-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>
> On Thu, Dec 16, 2021 at 9:14 PM <luizluca@gmail.com> wrote:
>
> > From: Luiz Angelo Daros de Luca <luizluca@gmail.com>
> >
> > Remove some switch models that are not cited in the code. Although rtl8=
366s
> > was kept, it looks like a stub driver (with a FIXME comment).
> >
> > Reviewed-by: Ar=C4=B1n=C3=A7 =C3=9CNAL <arinc.unal@arinc9.com>
> > Signed-off-by: Luiz Angelo Daros de Luca <luizluca@gmail.com>
>
> Why? The device tree bindings are done with the ambition to be used
> on several operating systems and the fact that the code in the Linux
> kernel is not using them or citing them is not a reason to remove them.
> We often define bindings for devices which don't even have a driver
> in Linux.
>
> A reason to delete them would be if they are family names and not
> product names, i.e. no devices have this printed on the package.
> I have seen physical packages saying "RTL8366RB" and
> "RTL8366S" for sure, the rest I don't know about...
>
> So we need compatibles for each physically existing component
> that people might want to put in their device tree. Whether they have
> drivers or not.

Thanks Linus,

However, it also gives the users a false expectative that it is
supported (it has happened to me a couple of times). I would not like
to simply drop this. How about adding a "(not supported)" comment.
Would it be acceptable?
