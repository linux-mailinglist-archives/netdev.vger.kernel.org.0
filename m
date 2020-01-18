Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DA3DA14199F
	for <lists+netdev@lfdr.de>; Sat, 18 Jan 2020 21:38:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726960AbgARUiC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Jan 2020 15:38:02 -0500
Received: from mail-ot1-f68.google.com ([209.85.210.68]:37737 "EHLO
        mail-ot1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726838AbgARUiC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Jan 2020 15:38:02 -0500
Received: by mail-ot1-f68.google.com with SMTP id k14so25543388otn.4;
        Sat, 18 Jan 2020 12:38:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=uJEbQzmpxhRn2TxnG/Vp+tPcStgS+c9inVRNuUQjBAE=;
        b=spXa0pm7dzXQADeqkLovzg/N8tqXtafLJrK7kzhbmdmOCsDOUtfp0STqY9rI7fFbCA
         vTQDlj9Fc2syQT4m3P/EralPIRFZEoeJdYKl/lGc1fmVxXmrirHNKkOHliJlIro97Oy1
         ZCdlSpQCD9HRrpFN+ThmsgdKR/FARytALhPSe331fuxz9oG48ZWJ3/kNFz9/IqbYgamN
         p32CJnsGM5MCgKU6Y8MJw5FtdO1/qjmEgZEi8nhkLDdJcK6AEEmUCQjO3Af/gfh4zGf6
         EcmW64q1RU3a0pgqT11kuYjy75txD9MRSYDP99bF3lvhycDgGvhyxQI8sC4LzAGvUdd4
         GBlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=uJEbQzmpxhRn2TxnG/Vp+tPcStgS+c9inVRNuUQjBAE=;
        b=SPXuwjAGJjp5HVmygMAKeHfttmPgsVOpIxMYh4+Rcm4zjjhVQ4jLO6qaoFbwSOeWYR
         PbxnMXffgN8Z2ippw1R4o9owyFiVfN7ejPvSmA3bmf2c+grsdTyBiby1MWcZbnqCqE3C
         QKb+RO8QSyBLUeFyeiu19ENo+hQ/saqhRZhAKOmFG6Qu4yIOD+FX7s75/Dd74dzed/BO
         QQuaoYsqlvcSRAe68sNH8StrPo1RttC4GQLhYVhu45ilkre1yoFQNluwZIpimGOq3fuS
         SG24zmXckUsF/LtJYhV425e/yu1qFS1HyfFpnIDui4mUN3EGJ0uvWu0cQlLDOzkwfWA0
         XHGg==
X-Gm-Message-State: APjAAAWdEdw4SW9SHn0XC64ekwM+jUtdujZZZoYPtg9jB9z45aNI7Ox/
        6zF5/30/ktwzMeTNGHsFfqjlwMA5M51fbjFyCQQ=
X-Google-Smtp-Source: APXvYqzV0R83ChIYU3NAaqXIaREYcOl429lK4ZNx0HvWCUd43Kg1syfrEHxMfuL5rwQrRmGQfxJsP3l7t3aQHb85H78=
X-Received: by 2002:a9d:da2:: with SMTP id 31mr10561681ots.319.1579379881062;
 Sat, 18 Jan 2020 12:38:01 -0800 (PST)
MIME-Version: 1.0
References: <20200118194015.14988-1-xiyou.wangcong@gmail.com> <20200118201933.wm3b25hhqe7fpqg7@salvia>
In-Reply-To: <20200118201933.wm3b25hhqe7fpqg7@salvia>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Sat, 18 Jan 2020 12:37:49 -0800
Message-ID: <CAM_iQpWRMa8SsDomk3DFQgD=Su0mBQSSPkNXuqzapuoG1kEXxw@mail.gmail.com>
Subject: Re: [Patch nf] netfilter: nft_osf: NFTA_OSF_DREG must not be null
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        NetFilter <netfilter-devel@vger.kernel.org>,
        syzbot+cf23983d697c26c34f60@syzkaller.appspotmail.com,
        Florian Westphal <fw@strlen.de>,
        Fernando Fernandez Mancera <ffmancera@riseup.net>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jan 18, 2020 at 12:19 PM Pablo Neira Ayuso <pablo@netfilter.org> wrote:
>
> Thanks. This is a dup though:
>
> https://patchwork.ozlabs.org/patch/1225125/
>
> Thanks in any case.

I didn't see it on netdev. But glad to see there is already a fix.

Thanks.
