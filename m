Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7DFCBE4F8B
	for <lists+netdev@lfdr.de>; Fri, 25 Oct 2019 16:50:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2440054AbfJYOug (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Oct 2019 10:50:36 -0400
Received: from mail-lf1-f65.google.com ([209.85.167.65]:37110 "EHLO
        mail-lf1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389921AbfJYOug (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Oct 2019 10:50:36 -0400
Received: by mail-lf1-f65.google.com with SMTP id b20so2003429lfp.4;
        Fri, 25 Oct 2019 07:50:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=GP25gDaBM4nvH/8ZwVG/JMPU5nGGHBh6V9T7g5JlEf8=;
        b=V5RhzrdsBmvh7t+Lw3dEYEjPGqnkfoF8W5qpFbRGkk67GDJTN4hYuFXuih1Aso9ZdS
         1Vs2l735wMRiT1JBJoECWpYDx5dMh8Kg6ZFn1i2YsWivnCQDFcMfVL0xu1TDrt2x4CuJ
         OvwclkxSNLpFQHjIP5WnLwJwdD35AXyuA+qGzFKXNA9A2NZV8URZjicGCcbM6BAZAdzH
         eCkxvIqYXK4+DC+u2nqe/FIU738JsEQDqjEwRuwhOczKh38uykDh7rDrLsjtO6LAhKFY
         YE+SodDfDnILZIi/HUgSF/6WDVXXYazRx/vEj3BaNJ+hoWteVv+Mnx5S9yYNsVM7lfso
         U21w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=GP25gDaBM4nvH/8ZwVG/JMPU5nGGHBh6V9T7g5JlEf8=;
        b=WVT9Jb9ufERWN+NO8dKHwywDPVBiG6JlNrC8aVxscH0etgoppDyCQGa/Q6UJzaX3Sk
         BB7slgRPYuf45OqOyUwaxG7ZUq1sxbiVqIOWcTI9cznecG5fkUIMjT/XIK4PehledC4g
         PEv6R6E2kwdgPs2ad5nSlI2dkWaGbCD3U8CZBXL76EMDH0ONRv/TFxvsImtW3/7/uayu
         7KBP+ANWzPc6S1+2l5OOHwEg7P0NtGcc7sFlh+AawexNQIiJdXm+hErHpLvuRhd89Z6x
         cw8UxJtGJcIsw9tollmji9MbrbHuGJsifONziL7QMzhCSgXBi4JfsBB54XrIptsoTEnM
         BK9A==
X-Gm-Message-State: APjAAAXx/RnVCOCkxtFKvLSGPX+cSWzn1hKCPUyWtiAtVDMHqW+JUYBQ
        g4l4TnqePe4CJrhiuQjFFo5obbx9vI0T7oCcj+9ntpNQ
X-Google-Smtp-Source: APXvYqweVC7SuoIPkuFuFnyrzGyBmzpbSNif5nmyBc2tAA6rCO7iDh9wufyw0RDlqLaNOE9/EGbMQIYncmMzGbvGd2M=
X-Received: by 2002:a19:3845:: with SMTP id d5mr2907586lfj.162.1572015033388;
 Fri, 25 Oct 2019 07:50:33 -0700 (PDT)
MIME-Version: 1.0
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Fri, 25 Oct 2019 07:50:22 -0700
Message-ID: <CAADnVQK2a=scSwGF0TwJ_P0jW41iqnv6aV3FZVmoonRUEaj0kQ@mail.gmail.com>
Subject: patch review delays
To:     bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S. Miller" <davem@davemloft.net>,
        Konstantin Ryabitsev <konstantin@linuxfoundation.org>,
        workflows@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The last few days I've experienced long email delivery when I was not
directly cc-ed on patches.
Even right now I see some patches in patchworks, but not in my inbox.
Few folks reported similar issues.
In order for everyone to review the submissions appropriately
I'll be applying only the most obvious patches and
will let others sit in the patchworks a bit longer than usual.
Sorry about that.
Ironic that I'm using email to talk about email delays.

My understanding that these delays are not vger's fault.
Some remediations may be used sporadically, but
we need to accelerate our search of long term solutions.
I think Daniel's l2md:
https://git.kernel.org/pub/scm/linux/kernel/git/dborkman/l2md.git/
is a great solution.
It's on my todo list to give it a try,
but I'm not sure how practical for every patch reviewer on this list
to switch to that model.
Thoughts?
