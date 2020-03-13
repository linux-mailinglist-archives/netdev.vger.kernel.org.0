Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A860618489D
	for <lists+netdev@lfdr.de>; Fri, 13 Mar 2020 14:58:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726741AbgCMN6j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Mar 2020 09:58:39 -0400
Received: from mail-qt1-f194.google.com ([209.85.160.194]:45406 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726715AbgCMN6i (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Mar 2020 09:58:38 -0400
Received: by mail-qt1-f194.google.com with SMTP id z8so4142526qto.12
        for <netdev@vger.kernel.org>; Fri, 13 Mar 2020 06:58:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=wMg17JE3CXCH8+Vb38WmkOF6ZlTAYIdN7eKPZ3OxXqQ=;
        b=Vwy7TS1TX4n8rv9JX4s9188VrREJkDpFdboY/iP5HRK/r+HY0gOMuJGgfWZz6RxLL0
         BknqB/jpkOzUNxAc0dMCVjNZw5uEK0o+MhZQ6t7owom52oSIyb5GuO4d9NXT4h6HNYv+
         zaA+5flJY5+OdacIzvY3Jk6mvRaDGUaXuIwoyScXNLGzIgv/HSKHlZt8J4Y93bKk8k8u
         8jWAdvM/WUemTrhBdbhEQfiroI53McuTsWFcT6VyAfftG6lJOm+0957MsByvHZGzPP+v
         S6rQyhmaWmvQY5VB7mG70kYG0o+f/hszgHFOybHPgc3fkKI61aayFewO+fpx/D34eJnL
         9rog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=wMg17JE3CXCH8+Vb38WmkOF6ZlTAYIdN7eKPZ3OxXqQ=;
        b=ATOQJLbzOmyqmxCe4g3mD+3VXOClB3rQ9hlsb0Qqi8/O9UGPLeF04AIT/2ktzz11nN
         OkCMsVKzFxUXGAOj3HQONR32/g/N7S5bwfGmyUBr+iR2UnJVFjU1pJxSRUqg5fV7c72M
         84KX2EFGB7JoNH+mzxIft2CUVpLucpXWwgUmhsKNGoclFpqsfUrvO+WQLEeJWzSZSHbh
         s213noghG1+TdFKaBm3MK6mKpAUOJNJjeDloSmgow4uNwKoejpofGw4wtATpSfSGaIFr
         SYXQtylcxtuhBsunBMItiKFz5oKIzIhVfCMyOsZPkvVJHatwoxWlHwT5VaK7EyPTK9Ci
         BntQ==
X-Gm-Message-State: ANhLgQ303w9sCCnSNYSeuRcK5vcK6W+U0Did1Xzy+aE3Gi1Zl43GQo6W
        IHpjUb14DBzFBL0ByNsm6Y3+rzBm
X-Google-Smtp-Source: ADFU+vuNEfxF6U9lBLzh4sRqJIozVniSOkTIDs53Mmxtta/YheH3bGNVt1REtMNI3SK4zXq1JWnQTg==
X-Received: by 2002:ac8:1b46:: with SMTP id p6mr12764123qtk.369.1584107916208;
        Fri, 13 Mar 2020 06:58:36 -0700 (PDT)
Received: from mail-qk1-f172.google.com (mail-qk1-f172.google.com. [209.85.222.172])
        by smtp.gmail.com with ESMTPSA id b189sm3447591qkc.104.2020.03.13.06.58.33
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 13 Mar 2020 06:58:34 -0700 (PDT)
Received: by mail-qk1-f172.google.com with SMTP id h14so12591274qke.5
        for <netdev@vger.kernel.org>; Fri, 13 Mar 2020 06:58:33 -0700 (PDT)
X-Received: by 2002:a25:7c7:: with SMTP id 190mr17348658ybh.428.1584107913426;
 Fri, 13 Mar 2020 06:58:33 -0700 (PDT)
MIME-Version: 1.0
References: <20200228.120150.302053489768447737.davem@davemloft.net>
 <1583131910-29260-1-git-send-email-kyk.segfault@gmail.com>
 <CABGOaVRdsw=4nqBMR0h8JPEiunOEpHR+02H=HRbgt_TxhVviiA@mail.gmail.com>
 <945f6cafc86b4f1bb18fa40e60d5c113@AcuMS.aculab.com> <CABGOaVQMq-AxwQOJ5DdDY6yLBOXqBg6G7qC_MdOYj_z4y-QQiw@mail.gmail.com>
 <de1012794ec54314b6fe790c01dee60b@AcuMS.aculab.com> <CABGOaVSddVL-T-Sz_GPuRoZbKM_HsZND84rJUm2G9RRw6cUwCQ@mail.gmail.com>
 <CA+FuTSc5QVF_kv8FNs03obXGbf6axrG5umCipE=LXvqQ_-hDAA@mail.gmail.com>
 <817a6418ac8742e6bb872992711beb47@AcuMS.aculab.com> <91fafe40-7856-8b22-c279-55df5d06ca39@gmail.com>
 <e8b84bcaee634b53bee797aa041824a4@AcuMS.aculab.com> <CABGOaVTzjJengG0e8AWFZE9ZG1245keuQHfRJ0zpoAMQrNmJ6g@mail.gmail.com>
In-Reply-To: <CABGOaVTzjJengG0e8AWFZE9ZG1245keuQHfRJ0zpoAMQrNmJ6g@mail.gmail.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Fri, 13 Mar 2020 09:57:56 -0400
X-Gmail-Original-Message-ID: <CA+FuTSfO-kNWd0qzuUsCyDjad0dVJEdLh9x4bfRzMYs9wdqQ=g@mail.gmail.com>
Message-ID: <CA+FuTSfO-kNWd0qzuUsCyDjad0dVJEdLh9x4bfRzMYs9wdqQ=g@mail.gmail.com>
Subject: Re: [PATCH v2] net: Make skb_segment not to compute checksum if
 network controller supports checksumming
To:     Yadu Kishore <kyk.segfault@gmail.com>
Cc:     David Miller <davem@davemloft.net>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Network Development <netdev@vger.kernel.org>,
        David Laight <David.Laight@aculab.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 13, 2020 at 2:36 AM Yadu Kishore <kyk.segfault@gmail.com> wrote:
>
> > Yes, given the discussion I have no objections. The change to
> > skb_segment in v2 look fine.
>
> I'm assuming that the changes in patch V2 are ok to be accepted and merged
> to the kernel. Please let me know if there is anything else that is pending
> from my side with respect to the patch.

I think you can rebase and submit against net-next.
