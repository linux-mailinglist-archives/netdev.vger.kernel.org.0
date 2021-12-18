Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE51F4799AD
	for <lists+netdev@lfdr.de>; Sat, 18 Dec 2021 09:19:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229684AbhLRITg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Dec 2021 03:19:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229595AbhLRITg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Dec 2021 03:19:36 -0500
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E2C3C061574
        for <netdev@vger.kernel.org>; Sat, 18 Dec 2021 00:19:36 -0800 (PST)
Received: by mail-pl1-x636.google.com with SMTP id q17so3799449plr.11
        for <netdev@vger.kernel.org>; Sat, 18 Dec 2021 00:19:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to;
        bh=5BuK8AhWhq0FJ/puivAvR911u07fjZdsxrC2dGBF+MM=;
        b=W/Ow+dUhyK4LyiMMKGpwfC/HFR97C1yveYRdyx829stueflWw98BlXz5QEZeMHEeQA
         ZeDzSFk6xEH+w74lFi5F9fy8DwEGbEqBqBZnCfcOlLYr+NYcVVC0bHJe+i+Vfx1Ur19p
         XKC1ss+RVbQ/e5DFArHYiXbOcnJa/LUN3QKQmUh443kUEMDowl/4A0J6Se051lVrYRIj
         3N551Bj+k7AZWkTMl32iTsYISJlzAuBORUnhlInnfIr9n8oWrK3mEtFAIPVGAPX81Gom
         6GBWH5qaOCljRGrYSPaajOP6S5F/zLP1u1uplg9xW9x+P0Vv/glJgjNTumN3GVuSlGGM
         Ch7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to;
        bh=5BuK8AhWhq0FJ/puivAvR911u07fjZdsxrC2dGBF+MM=;
        b=bgD+NGzWIaaMDTs+XHkoQjTE/Xdd6y6HCe/UoLVCTzkWNIOABnO2yTmxC8DhefU4ZB
         n7Fhw6n3Vmw53jOC8fKxf1JMBuX9FSCHHjqFlinalS/Mm158YXXvWqErjXz4rX8OD19g
         h9SC/q9oMs9JLNm1ZYav0CwStsQq5pC+QVqMvHQ6MCfWpJ3v7LSg4tzW9B5scYzH3ojO
         rpACA8mKBHHIDqbWv6FLtzBqABhczK2mMalDaN+KMUYF1fbMi7bCuP1V4yfkZDoVukUI
         fKJcc9CajmhQkSy8mBUIKlHNPu62ncC8H4yYa312gQ0gSeSanpSz3lT3onzijr0IVI3o
         iZ8A==
X-Gm-Message-State: AOAM533BauwiythnD2SH+0dsn3Rb7SquiIXBxLE2lrzgANe3NfB3aDKo
        Dq2ekI/lgKw5Oy4s3KrwfoABMZcanyYOjNNN3hHOewLBhVY=
X-Google-Smtp-Source: ABdhPJytCy+P9zHgWzv656Po33Rnht5YgVj+J9AzO1jDr6OSCWTe+ZSVR77wUawJdTrYEZfzZ8VbW6J+OqUJXwCQB5U=
X-Received: by 2002:a17:903:246:b0:143:c007:7d41 with SMTP id
 j6-20020a170903024600b00143c0077d41mr7149743plh.59.1639815575512; Sat, 18 Dec
 2021 00:19:35 -0800 (PST)
MIME-Version: 1.0
References: <20211216201342.25587-1-luizluca@gmail.com> <20211218081425.18722-1-luizluca@gmail.com>
In-Reply-To: <20211218081425.18722-1-luizluca@gmail.com>
From:   Luiz Angelo Daros de Luca <luizluca@gmail.com>
Date:   Sat, 18 Dec 2021 05:19:24 -0300
Message-ID: <CAJq09z7_rKFN8B_X3yHURafr3iWdOUcgUp+nNYeAJbntsf9UjQ@mail.gmail.com>
Subject: Re: net: dsa: realtek: MDIO interface and RTL8367S
To:     netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As I finish the code side, I'm sending the patches to review. The doc
part might still require
the yaml conversion and forward to the corresponding maillist.

The rename was removed and I applied the suggested changes. I hope I
didn't forget any Reviewed-By.
Thank you all.

Luiz
