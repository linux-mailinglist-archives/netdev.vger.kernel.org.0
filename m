Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F4732F4443
	for <lists+netdev@lfdr.de>; Wed, 13 Jan 2021 07:06:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726184AbhAMGFi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jan 2021 01:05:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725927AbhAMGFi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Jan 2021 01:05:38 -0500
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D4F5C061786
        for <netdev@vger.kernel.org>; Tue, 12 Jan 2021 22:04:57 -0800 (PST)
Received: by mail-wm1-x332.google.com with SMTP id n16so2985105wmc.0
        for <netdev@vger.kernel.org>; Tue, 12 Jan 2021 22:04:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=FZNQTvdjPC53Xp86ta/XNIwBG6Vi97YwbLkonzPm9xY=;
        b=kaTyrXHtKDIYiaIAfA9pDhR258o/Z0/EOFjTzbNiFGPiTgcGIbpt97v94sjR6guPrC
         7hkYFskqHm2W6rJ+s7JSiOtj3gxXbD+/g+cqUbk5H1MfCs6PLRso5p73iHdQQ2SKdq0+
         ipZfQ8fq+38KOJc2Z/7+V0XLyEhvDBq3HrvVFV8uKV7dQ7owl15+P2FAa1ueRbj6IqGg
         mms3pWRYXudLm1aNN0ol1jON9jZQ7LUhbnckdSIvQ+/sWkl8mK1OzX7/9kupXJ4H3KuD
         5sC7A8CpPs61oFk/kAdbpPTuVGJXxvyCvjeAMgdYsn4cB8+faVlflB9U+1vdStfXh/SQ
         phew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=FZNQTvdjPC53Xp86ta/XNIwBG6Vi97YwbLkonzPm9xY=;
        b=Y29w8HbTBHvhJ882LBcIBaJpTJYBqIhP4fYZ6eHBb20DE00ENYTQhF5yfmDCdBZEAN
         A2os4Tq+mopHfoOQbowIgH+T7Nw8jLCvEMHiuqTZPyxL0JR6HH5zvvX2OHnDw60rziYt
         1GY1EhJU96c0QbQD3IHhJ8IsaMn5bua3dMIIBDDi0maGAsUN1sXX4XmBuMeY7KFVuAAy
         CovFHvjSQFhxjEq/c6znBuMxGAjMyEkJ0WO982utMSQ2ZzBOK3YWtx8CYA3OsbXmZGYJ
         S589NE8+ECQu+17SYbmpXTJTziAWpiST4ycpzpYD2d9Kt6TMjF+UzbsO4OUHt6Qm9g2D
         bB2A==
X-Gm-Message-State: AOAM5322iiekq+YKE6z0tf7RR1PdKmUZ42QBCxYXU0azuYwwF+IajaWH
        9qC4b8DRhIVgmaOBrkz/LSSi1LyIPC6fmNnb4fQ=
X-Google-Smtp-Source: ABdhPJyAqYsyJMUaRuQdTdRGqDR6ESFZMpcDhva56p4cxTnjGzrKcHcw4FNOlTr3JCwhEZ7T73W7qdfkGNaVRcDvFus=
X-Received: by 2002:a1c:1fc2:: with SMTP id f185mr524519wmf.134.1610517896481;
 Tue, 12 Jan 2021 22:04:56 -0800 (PST)
MIME-Version: 1.0
References: <20210112064305.31606-1-lijunp213@gmail.com> <20210112155434.38005330@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210112155434.38005330@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Lijun Pan <lijunp213@gmail.com>
Date:   Wed, 13 Jan 2021 00:04:45 -0600
Message-ID: <CAOhMmr5Nisoy8FfH+gFPG7s=SuR8WhVcNXLBy9-_vdSSxmXtaA@mail.gmail.com>
Subject: Re: [PATCH net-next 0/7] a set of fixes of coding style
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 12, 2021 at 5:54 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Tue, 12 Jan 2021 00:42:58 -0600 Lijun Pan wrote:
> > This series address several coding style problems.
>
> Erm, are you sure this series will not conflict with the fixes
> Sukadev is sending?

Maybe one or two if the fixes go to net. And not if they all
go to net-next. It looks like they going to net-next would be
a simpler solution for both of us.
It seems to me Suka's patches are more of refactoring and feature
changes (a new approach) though some of them claim to fix some bugs.
