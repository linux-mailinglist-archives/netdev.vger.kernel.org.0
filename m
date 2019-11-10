Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 15A66F6B68
	for <lists+netdev@lfdr.de>; Sun, 10 Nov 2019 21:45:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727132AbfKJUpA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Nov 2019 15:45:00 -0500
Received: from mail-io1-f66.google.com ([209.85.166.66]:46499 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726800AbfKJUpA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 Nov 2019 15:45:00 -0500
Received: by mail-io1-f66.google.com with SMTP id c6so12208794ioo.13;
        Sun, 10 Nov 2019 12:44:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=yaSU/J7wlwhTU7SEKEjJAOkDsbzoJGXODvxt454XJLw=;
        b=KtlviDbx5K8fQa8EmJ8dUdQnS1D25sFLvv2BnO2y7dXoCuUhulaZO74INtMIofaTnK
         VSVZztuWWj7q4rrcrHVu3cnF2vmzUckJjbtc5el/QxweFP48BFjiaaNA19BC5VG9zsHf
         c6aeY/UjfmFSeehd0ik8DWnkOufaXDmX6Sykm+HJzLofRSOFzbN0dGTSvsocWi7A7wpo
         dxeq6+AQu484WIh/EWR4zlREMoUXumyCY82AsEZOdIpJ1YPJXtAUejzCJ0NT4bVu8c2t
         CsLdoHuV3G/OO41dQBMANVf0QE1VdqLwQZe+91mkuxG8vARrlqF1YAieAYJX+14kYlJP
         Y3kw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=yaSU/J7wlwhTU7SEKEjJAOkDsbzoJGXODvxt454XJLw=;
        b=eQ12r9rVr33emIBwsiJDT0BZ9ew1ai7S2reCvR/Vg2uxzUQZYRQ3Bl1YkKnxrhlOyy
         6TIgfY3sz0qVzGBVr1wHHablqU9H9PufijSkX2J6O34qyUeXxv4AhreS6TztgRY2TkvQ
         NcWGSzOrMdkafOzJu4bG3vOzLDqu/6jcIMsnTdR8shaTkdlFDq7IHlZ7+vnHZq1JcC0Q
         +uYbOaEaibn5Q4qQlJiPsCQlKnKyPixXnYZ/5fQe5tRP4dNPUOUlL9Kc+RYepnFOldk4
         snu4/R1fJbHuTv+h413rXNYCwjlVEV1wA7qo1yHcEk27SU4Fk0cCBHMt1t1dSQyS4HHj
         6zOw==
X-Gm-Message-State: APjAAAXR+qcjkqkmvr9QH2dzKDfnEezf0Fc5onFBlERd38ptlarKIASC
        4yWqtJAJTBeMd0QA4IFv44tUWT5txT7q0vPF76Y=
X-Google-Smtp-Source: APXvYqxUtHARm63QIbtf3dnp/mGo21LjhNNOLCCRMHawHaZzV1Uw/kjAiyImL9JKD0L6y84nu5mO5CwtpN3rCYvInds=
X-Received: by 2002:a02:a402:: with SMTP id c2mr8814473jal.5.1573418699329;
 Sun, 10 Nov 2019 12:44:59 -0800 (PST)
MIME-Version: 1.0
References: <20191108203435.112759-1-arnd@arndb.de> <20191108203435.112759-2-arnd@arndb.de>
In-Reply-To: <20191108203435.112759-2-arnd@arndb.de>
From:   Deepa Dinamani <deepa.kernel@gmail.com>
Date:   Sun, 10 Nov 2019 12:44:47 -0800
Message-ID: <CABeXuvqFmQU+Qr_2nqTwDO_mKWdcym=DP+4v4ray=GYgUFRetw@mail.gmail.com>
Subject: Re: [PATCH 1/8] y2038: timex: remove incorrect time_t truncation
To:     Arnd Bergmann <arnd@arndb.de>
Cc:     y2038 Mailman List <y2038@lists.linaro.org>,
        John Stultz <john.stultz@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "# 3.4.x" <stable@vger.kernel.org>,
        alpha <linux-alpha@vger.kernel.org>,
        Linux Network Devel Mailing List <netdev@vger.kernel.org>,
        Stephen Boyd <sboyd@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thanks for fixing the bug.

Acked-by: Deepa Dinamani <deepa.kernel@gmail.com>
