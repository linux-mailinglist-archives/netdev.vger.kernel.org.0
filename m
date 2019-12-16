Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9193011FE6A
	for <lists+netdev@lfdr.de>; Mon, 16 Dec 2019 07:19:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726638AbfLPGTA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Dec 2019 01:19:00 -0500
Received: from mail-lf1-f68.google.com ([209.85.167.68]:42030 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726054AbfLPGS7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Dec 2019 01:18:59 -0500
Received: by mail-lf1-f68.google.com with SMTP id y19so3326779lfl.9;
        Sun, 15 Dec 2019 22:18:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Lk0BXIIiWqEO9kfeGGGJrJLDU8Vj1PjkOxOAYcW+QLc=;
        b=nm3RMFhC0srV1g0QGrUSXww7JWUzdFhBP9sMb8Cx8bQkg/0X9t9KWdLtmTiQyWMFbN
         pVwjq+Oaws8GRuTysRty6CiMsZOYoYlnZJmsQaFfZufrR0I1gcyz9+ywGYGQE56q0eJL
         SknHfKC83O/XI6KLc/QbHlrzqgH77ko0UkzYsWSBh0nPOVGZ8lO95dJvVo0e1AoD9Dk5
         8tKU+O8BbvLcg738ZBOnosvOd64ktIDz9GxAhlhttUIjvEczkaq4opElVI1CR7AmQ5N5
         Iiu+bJZFrGbR+s5eszBAkdDAdlZr1tFin7jOxWjbAZGh4K0qpAPugrDmPagKxEpxzAGI
         JVMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Lk0BXIIiWqEO9kfeGGGJrJLDU8Vj1PjkOxOAYcW+QLc=;
        b=ndr+zSPXcyXOJtzsdOuHHEJD303Kup87v3gdICmjaCE7G00rpinFdzTrTc/gqCTdmj
         Kc54glgi23IaJVeXmTby8xvwiobgCqYnVwECPuCOOc2mmFa4qUaNJxnUCgXtNLeksdc6
         KUNOWOJHIqACE3riBi8t7GkAiSWDvn7CICN+l9LLz9qDqwpPXA4zJkSg1ZxzO2xyPaZ0
         6lgVac63uSgKmtIAsgS+D6gp2GD5k/fVEqpS+ohX/Ms3vNBSXx7C9VX4LiP2YG7QyUcf
         BrJkdeC1vpdkn5VvHY58PsGWLe8p6wEDos5ndeiQHp3mMVCt1u+yoqOQ3JWsUupoxL+H
         g81Q==
X-Gm-Message-State: APjAAAXeKnBKWuW0FZh284bcwnZhxVALV3M5BoIPO08GrvqAKvF4ByJ5
        GoUkiX6E53zfE9wzBtPHJtseuN+8MdOUCdmNHNHvbA==
X-Google-Smtp-Source: APXvYqzVlFw1aI21I6iZcTCXHbdyY0F1kGU9byOxk6ZA2qRNn21TUTU2wODR03Nic4UFqQ7HYHbGEnO5AciswL3pCbE=
X-Received: by 2002:ac2:47ec:: with SMTP id b12mr14968038lfp.162.1576477137015;
 Sun, 15 Dec 2019 22:18:57 -0800 (PST)
MIME-Version: 1.0
References: <20191215233046.78212-1-jbi.octave@gmail.com> <dd0b6577-aaf6-a557-4cdd-ddc490995c38@fb.com>
 <9d195192-551f-377c-d440-8156dfe20b7b@fb.com>
In-Reply-To: <9d195192-551f-377c-d440-8156dfe20b7b@fb.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Sun, 15 Dec 2019 22:18:45 -0800
Message-ID: <CAADnVQJYnt4WKMV8hDKAhf3w6Ju0Th3qVJCkbLFOnYPdnQe+pw@mail.gmail.com>
Subject: Re: [PATCH] kernel: bpf: add __release sparse annotation
To:     Yonghong Song <yhs@fb.com>
Cc:     Jules Irenge <jbi.octave@gmail.com>,
        "bokun.feng@gmail.com" <bokun.feng@gmail.com>,
        Martin Lau <kafai@fb.com>, Song Liu <songliubraving@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Dec 15, 2019 at 10:17 PM Yonghong Song <yhs@fb.com> wrote:
>
> Resend due to incorrect bpf vger email address in the original email.

This patch is not in patchworks. Cannot be reviewed/applied.
