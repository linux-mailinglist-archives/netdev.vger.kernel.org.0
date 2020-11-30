Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF8BB2C86A7
	for <lists+netdev@lfdr.de>; Mon, 30 Nov 2020 15:28:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727106AbgK3O1U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Nov 2020 09:27:20 -0500
Received: from mail-ot1-f67.google.com ([209.85.210.67]:39794 "EHLO
        mail-ot1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726332AbgK3O1T (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Nov 2020 09:27:19 -0500
Received: by mail-ot1-f67.google.com with SMTP id z24so11420298oto.6;
        Mon, 30 Nov 2020 06:27:04 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=7Kgz7vpUpOeErTGDxAtq8lWybdzY5kh8zq+GaD4KNlg=;
        b=YPUY/ozBasGHjzE1kVy8ORZQqWY9JRM6E+SwNUpsvBzktwoPMYXM5XK15Ubf/Kp2OC
         eoAy7CeHwL2JTi1y3LIP/THJZP9Y9QQnBR/AXOnWMCAzG/Pf9zTwvWFzfrAUWBpayRqz
         FPmF5usVOpldpt39tDBwhxOycTZKLZUpA4ic8EgwD0Sdx3Y9FyhjO8dYdHlholXja82N
         6TRNj2yDbz+H0LD55x7/lkzFRzSyvy7cYehNB4SCGHOuCUTayI8dmUTaeX0QOgWbzsbu
         wllg88eHKWGskD0fy3Ex6bWTPqJT7coaFU9AO6qiIqMAazvZyWWstYdzNsc59p8pE0dR
         1YnQ==
X-Gm-Message-State: AOAM532LK2JDRPAKI5TSygJmQrrKyZZYBXm0VLwsxTFXUThT9ONxrKQQ
        dX6GzxOHtoivUsT/zufpu/eLzRZvZnJHDO3PO1WaapDo
X-Google-Smtp-Source: ABdhPJx1bAyu5oT+zcQjk02uktjjGOsbzVEQqy6uanYfRqPDlmSEzM1l1IVBdgj6UkeA0P9dZ4SqHqwC4WBR+z+ie4Y=
X-Received: by 2002:a9d:171a:: with SMTP id i26mr16815761ota.260.1606746398981;
 Mon, 30 Nov 2020 06:26:38 -0800 (PST)
MIME-Version: 1.0
References: <20201128065243.2870987-1-zhangqilong3@huawei.com>
In-Reply-To: <20201128065243.2870987-1-zhangqilong3@huawei.com>
From:   "Rafael J. Wysocki" <rafael@kernel.org>
Date:   Mon, 30 Nov 2020 15:26:21 +0100
Message-ID: <CAJZ5v0ghayA4pqCY4=qbTwd6qSJ=JvZZb93SPkCtBoaaDkXQ=Q@mail.gmail.com>
Subject: Re: [PATCH v2] PM: runtime: replace pm_runtime_resume_and_get with pm_runtime_resume_and_get_sync
To:     Zhang Qilong <zhangqilong3@huawei.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Fugang Duan <fugang.duan@nxp.com>,
        David Miller <davem@davemloft.net>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        netdev <netdev@vger.kernel.org>,
        Linux PM <linux-pm@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Nov 28, 2020 at 11:17 PM Zhang Qilong <zhangqilong3@huawei.com> wrote:
>
> In the pm_runtime_resume_and_get, pm_runtime_resume() is
> synchronous. Caller had to look into the implementation
> to verify that a change for pm_runtime_resume_and_get [0].

Well, "resume" is "sync" by definition.

> So we use pm_rauntime_resume_and_get_sync to replace it to
> avoid making the same mistake while fixing
> pm_runtime_get_sync.

No, we are not making this change.

Thanks!
