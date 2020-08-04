Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E01AA23B6BC
	for <lists+netdev@lfdr.de>; Tue,  4 Aug 2020 10:24:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726584AbgHDIYG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Aug 2020 04:24:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726058AbgHDIYG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Aug 2020 04:24:06 -0400
Received: from mail-qk1-x743.google.com (mail-qk1-x743.google.com [IPv6:2607:f8b0:4864:20::743])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3943C06174A
        for <netdev@vger.kernel.org>; Tue,  4 Aug 2020 01:24:05 -0700 (PDT)
Received: by mail-qk1-x743.google.com with SMTP id j187so37611766qke.11
        for <netdev@vger.kernel.org>; Tue, 04 Aug 2020 01:24:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Qc8OnS8eo/f364Dmr6b1F9RIWD056YvL9wJkAmZ9u3E=;
        b=fidzUteznnhMs1/7UrPxhEoqe+mnPyGhW8SwPHSEoVhSOcOoEbERhnKJU+0UUNzR9/
         fUF4q2wCieuBefS+qmtO3hLObWTDoW0hCESuahTm/wf8gX82/42/R+p+8A/pqrWstOIw
         UtE9dkXyODoOYR/Q0LxIJUjGIx5TqPcR3xWyo4unFR9slhYhkSblCQu2rv+J5thFUgXh
         xVoWzi2ptLk5AVFm/S6OJ947lvaBRHKlTMV3A2hSpKL0g+LuPkLvUkyLlHI9ObxkfL7J
         uaow94rs6nlM1iY8WqcvmJpQoJUPVH9hBplWbc0J1uUa7TYoZm4ufzTPEjjh5QOrukn9
         s36g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Qc8OnS8eo/f364Dmr6b1F9RIWD056YvL9wJkAmZ9u3E=;
        b=Xtbyz1X3j9j87PjV6o9YhHg8wZu0TEIuRGdMZvisVKngfENw4GfjezSpH4MzE+y7KI
         xtfxi1lux/b7iWEW30TfRMLnRFMKGgwpE7u7vJFIt0XCl83RQgaTSiTmUxnO72SDPouT
         Xv10rh3HdGDD5H+b7UvkIo+UvokyizrZZEXxP/X06n0ea7IX/EdvVwxi55gRLqnspb0c
         TOhNrqfPqq73x1VanzRn/3nacDESdbTt9q+ziBhT27sjWDfq/LcNZTb1Gv9qHVaxmIoH
         gD3oNE7jqFynvyzG1KRKPEOHEN79LNjfhmn4SEIID7FWogE3dCExmV8jWMqaxN2aSYKn
         FOHQ==
X-Gm-Message-State: AOAM531JOdmERO01WiH++ATpJKDEQpdtHuZPPs7+MADc/lTuaGwo+QCg
        DiruEYO+82EMsyFzeAkQrodVkPF7a/DewVuPuU8=
X-Google-Smtp-Source: ABdhPJy4y4eNIRs6Em3m00gTa4U5D21bGBwk7xAC/ulnu4YVv46DzOSoncDusWBOcY3wO9pO+fuTfYc5VZjFOaTeFA0=
X-Received: by 2002:a37:de15:: with SMTP id h21mr19287346qkj.77.1596529444997;
 Tue, 04 Aug 2020 01:24:04 -0700 (PDT)
MIME-Version: 1.0
References: <20200731084725.7804-1-popadrian1996@gmail.com> <20200804074413.GA2534462@shredder>
In-Reply-To: <20200804074413.GA2534462@shredder>
From:   Adrian Pop <popadrian1996@gmail.com>
Date:   Tue, 4 Aug 2020 09:23:28 +0100
Message-ID: <CAL_jBfSMe5YDxsKgdX8yD+2yjdQ7LCm3BVi22F+NZ7L1dJm+Ww@mail.gmail.com>
Subject: Re: [PATCH] ethtool: Add QSFP-DD support
To:     Ido Schimmel <idosch@idosch.org>
Cc:     netdev@vger.kernel.org, linville@tuxdriver.com,
        davem@davemloft.net, kuba@kernel.org, jiri@mellanox.com,
        vadimp@mellanox.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>,
        Andrew Lunn <andrew@lunn.ch>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andrew, Ido!

> Hi Adrian, thanks again for submitting this patch. I got two comments
> off-list. Sharing them here.

Thanks for pointing that out, I took a look and you're right. I'll fix them.

> Didn't we discuss that page 3 might be useful? I would prefer not to
> document that pages 0x10 and 0x11 would follow page 2 until we have a
> driver which does actually provide pages 0x10 and 0x11.

Should I just remove that bit about 0x10 and 0x11 from the commit
message (so keep only the first two paragraphs) and leave the code as
it is?

Adrian
