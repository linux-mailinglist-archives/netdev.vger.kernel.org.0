Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B81D45DADF
	for <lists+netdev@lfdr.de>; Wed,  3 Jul 2019 03:31:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727171AbfGCBbh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Jul 2019 21:31:37 -0400
Received: from mail-ot1-f67.google.com ([209.85.210.67]:46759 "EHLO
        mail-ot1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727080AbfGCBbg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Jul 2019 21:31:36 -0400
Received: by mail-ot1-f67.google.com with SMTP id z23so543741ote.13
        for <netdev@vger.kernel.org>; Tue, 02 Jul 2019 18:31:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Kz+9zOW0wyQSZRd/JBrHskK3qA1pb0xtBKwU/DLH+ig=;
        b=lcHFy3XBY6mPR7agONYFug4R4ipehKYSL5c1oCIb+hVX3SU2LBI1H8YsXTu/xWx5Bn
         0bhg+/w6qfKzB2bmihP1NcuqZDss+g9jEPhDYJ4yDN+8gta4m5LjWGBZphAnyeihTx+P
         6D7l9LHlfor3f1RdGbQJWDAyqNmMOif0XJROzoSZnEEY+kquBiZemdvG1py5zhcdGhaX
         nz0BmaBxHtL744e3M2mIiTy4STUvryc8SzUDiYE3hae4asXlKgq9HfyxOREC2bAY3Jjp
         m/+7JqGkT95RmbvUc+P2G5EBSOXleK2rhNGHlxtFe5zNtSuKnXDKsnTbrCFoXuSerfm7
         S+MA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Kz+9zOW0wyQSZRd/JBrHskK3qA1pb0xtBKwU/DLH+ig=;
        b=Dhxchv0Tk4sOCQ9bXo7/K83s1QXOyX/64VXhC5mylFewQPK33vc5hYMDe0xdBq3MDZ
         HvPRRpdwjmDPt6MgcJ618chCMiCcMXxdga0fTOeH95jjGfFRWGtTIY7h21C7bvMTTIOK
         mefxkztkMwvRO7AeexxIjOj3Q+edpMJzpPJWh/VVHt9FOuU7iPxnQSVwTLZ40RvK8LcL
         euqY1BnlTnON9xiRZR/AStdWhA40T75plucuOopj+cRluufJtxPb3NA5+fFBFHmGpcXw
         JZg8Kkm5ZwHUxDF2v0yEBtHjglHv+4va+Edvfya4aqNMtlcEC5+Z4dkSMdBiIARIlOc+
         7X9w==
X-Gm-Message-State: APjAAAUj3jDZ6P3zcIhQ84llKmTRsEDVnOEoFfzbB5oq+qjLoavGBKp/
        Z8NziLNiGQ5hvvOf9HmAN1vE7ptYJO4XGZF7ONZ8IABN
X-Google-Smtp-Source: APXvYqwKf5pL/iFUn7NBNyhieLaTrpWjs0YyKF18I4f3TLzxJcXF92K8ULUkW/57t1g5/m/MH4VMgorV2yNG8cx4eJk=
X-Received: by 2002:a05:6830:2010:: with SMTP id e16mr972947otp.344.1562117495945;
 Tue, 02 Jul 2019 18:31:35 -0700 (PDT)
MIME-Version: 1.0
References: <20190702152034.22412-1-ap420073@gmail.com> <20190703010856.GA11901@nataraja>
In-Reply-To: <20190703010856.GA11901@nataraja>
From:   Taehee Yoo <ap420073@gmail.com>
Date:   Wed, 3 Jul 2019 10:31:25 +0900
Message-ID: <CAMArcTVkO=axymtvyRBg8RTq4YLrhcg-1x2HaK9URywjbiLnXw@mail.gmail.com>
Subject: Re: [PATCH net 0/6] gtp: fix several bugs
To:     Harald Welte <laforge@gnumonks.org>
Cc:     David Miller <davem@davemloft.net>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Pau Espin <pespin@sysmocom.de>,
        osmocom-net-gprs@lists.osmocom.org, Netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Harald,

On Wed, 3 Jul 2019 at 09:10, Harald Welte <laforge@gnumonks.org> wrote:
>
> Hi Taehee,
>
> On Wed, Jul 03, 2019 at 12:20:34AM +0900, Taehee Yoo wrote:
> > This patch series fixes several bugs in the gtp module.
>
> thanks a lot for your patches, they are much appreciated.
>
> They look valid to me after a brief initial review.
>
> However, I'm currently on holidays and don't have the ability to test
> any patches until my return on July 17.  Maybe Pablo and/or Pau can have
> a look meanwhile?  Thanks in advance.
>

Thank you for letting me know.

Thanks a lot!

> Regards,
>         Harald
> --
> - Harald Welte <laforge@gnumonks.org>           http://laforge.gnumonks.org/
> ============================================================================
> "Privacy in residential applications is a desirable marketing option."
>                                                   (ETSI EN 300 175-7 Ch. A6)
