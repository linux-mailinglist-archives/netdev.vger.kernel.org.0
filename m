Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 14B6633A93
	for <lists+netdev@lfdr.de>; Tue,  4 Jun 2019 00:00:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726559AbfFCWA5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Jun 2019 18:00:57 -0400
Received: from mail-pl1-f195.google.com ([209.85.214.195]:35030 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726025AbfFCWA4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Jun 2019 18:00:56 -0400
Received: by mail-pl1-f195.google.com with SMTP id p1so7484466plo.2
        for <netdev@vger.kernel.org>; Mon, 03 Jun 2019 15:00:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=OE+DV1iDnGanqSUQ3gSDQa7SpBzGqjCR4U6alQ1giEk=;
        b=ETzhMp4AEe8Flmgo/kSIOHAb7In2pkCCzlaZrVqjGS9VomKBpb1Ew6hcj8mmKX5knn
         qGoou8mTUyHaPd6kEBiCAvMFFqs9xPDPAahfq2DISXT7b3tUfemptyic2Dfi0t9BpdxU
         F1j3aJwvPscd/wm+FgfdySro9d9yOzeALIWESgnLEF5tzpnxDb2/J7Pmfzvivo3Be7Xf
         UBUVP+ncVzuScyUppESTqcypqYa4JYtDfPpuKlBTvwzBSTFHthCGJDOBUB/d/qalXVgs
         nCETrnR6yqwNkehtkPxHB2rObaxAN8vz1FJTz7TaCD84ah988wtYkhqREBsjw4zTgvvw
         Nfdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=OE+DV1iDnGanqSUQ3gSDQa7SpBzGqjCR4U6alQ1giEk=;
        b=FA0W8was+ej7lm+0jEvOaqNQQNo1GcG8MU6LjRFjXfPsEg/wkzMgTOuHw7xC9J0Hkz
         QbkM01OdrJY8TQ9MrK7H3PV0WXgr4oYa5iKT1ndnG4FwQXmWSrHrcyXc+JSrHRIzqfPc
         ew/DxhJma9oj+mDFssCmhPymoJUUTs0dWnLUsn0uWcrWaS6kAk33biBgeXp28rf+nQuP
         G4sMdTXS/J0fowq05zytRCFS1UbIQfl/eu93q78G2eDq+NcGcW+dT8yWi04j/QvuK3S6
         NZ/CjcoEl5ZID+Sgb8IJMqt3AV93mR9ARxpLmVs0iVjBhK0XRr8rA4eVQiG9OAd7sqbO
         FnAw==
X-Gm-Message-State: APjAAAWqiFqQrPbJmi4unklcgVJGN5+9WDwMjcypDro5+bF1rRanuD9A
        81rapOoVmIwB9XTq248iRu1Wz12cdTRBBHHITBLr08qQ
X-Google-Smtp-Source: APXvYqzWBbPLVBPrbFmTJEk5UIt7x6cHDuEBIJzj+RPH298Lvex7X1nAJmKmLK8YBWA/7kyIcORyGRLOjXTDhT0qVT4=
X-Received: by 2002:a17:902:b944:: with SMTP id h4mr31112655pls.179.1559595616814;
 Mon, 03 Jun 2019 14:00:16 -0700 (PDT)
MIME-Version: 1.0
References: <20190603204953.44235-1-natechancellor@gmail.com>
In-Reply-To: <20190603204953.44235-1-natechancellor@gmail.com>
From:   Nick Desaulniers <ndesaulniers@google.com>
Date:   Mon, 3 Jun 2019 14:00:05 -0700
Message-ID: <CAKwvOdkSJzTrJMvRzOvLrSh7Bwqf+a3_X8Z=v8_mbpNC46A9yw@mail.gmail.com>
Subject: Re: [PATCH] net: mscc: ocelot: Fix some struct initializations
To:     Nathan Chancellor <natechancellor@gmail.com>
Cc:     Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        clang-built-linux <clang-built-linux@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 3, 2019 at 1:51 PM Nathan Chancellor
<natechancellor@gmail.com> wrote:
> Fixes: b596229448dd ("net: mscc: ocelot: Add support for tcam")
> Link: https://github.com/ClangBuiltLinux/linux/issues/505
> Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>

LGTM thanks Nathan.
Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>
-- 
Thanks,
~Nick Desaulniers
