Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 899D12DC3A4
	for <lists+netdev@lfdr.de>; Wed, 16 Dec 2020 17:02:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725831AbgLPQBz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Dec 2020 11:01:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725287AbgLPQBz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Dec 2020 11:01:55 -0500
Received: from mail-lf1-x12c.google.com (mail-lf1-x12c.google.com [IPv6:2a00:1450:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 451D2C06179C;
        Wed, 16 Dec 2020 08:01:14 -0800 (PST)
Received: by mail-lf1-x12c.google.com with SMTP id u18so49609617lfd.9;
        Wed, 16 Dec 2020 08:01:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Kx/f87ywu7inr0rh378haTMjHJCyIdAT53Dvjxsco78=;
        b=A5t1TGQFhCxRFhcoiRpwJQ3bbWC+enUDoYMD1JcqT1wRzOGnlIeYc/s1M5QI0DgEV6
         kEnCzeuxPF/kGCPh3bu0M5ZfcWVH19hCuSJSgrzyhhBAIs+6quv40gooDF3Iw6Mbpa95
         oKmpwJ3bzWVz520ew8+I/uy5ilkgT16MNKbBYpCgIawIGl9/ZtH14w6F/W6EkfDs+lF8
         3hNKMolyXcsrkxmjQHznVtsISDZ83gT+V1JJ0MM7/BxaWm49WpeqilMc9BJ3cRic3HuM
         BTU9pVLzVbaralwq0GSXRh58ethvPl4OJnH07seM0jLlp0DbkJXa5bsx1C21dIwQRUzZ
         K4Fw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Kx/f87ywu7inr0rh378haTMjHJCyIdAT53Dvjxsco78=;
        b=rRuwJhh3xcuK9VhgxwoeB28wtrH0D/rfYKAry1TVVyOiQAe4EAFAx5AY+u3pA4AslI
         ac3aSGs5Klra3KeZLbFXMM/+MiK6vm7U71zXp3EQEc5OBZpk/3qcX41Qu+sYHh04CkM6
         eOBbbdafZaZA4wDlP1w6afjlr6fX5PKe7ESBFm40qSfjx323PWDKisHCTBM4J+iUjJU5
         ajcXAop/hf3MBs23ZtccAmnP7da4N5fhi0xmN8Z+0fm8yOjbt53YyG2mTVcfVTsNdQDh
         jkZwzolBeH25DMBFQPdClXGliGCwLuTX8Opk8OSHh3E72UWSO6Y3TFeqqIaGxeN4FiOF
         ESwA==
X-Gm-Message-State: AOAM530gcCubZI4qwAu91asaJA7ok6Obz7oVKuPgAOj6rS+d75iyHrmc
        u40tBuWWMpqMs6a7SxQb2DtMG4/xKapibRatsu87DL2xo1Y=
X-Google-Smtp-Source: ABdhPJxQKVaJZkKfZDM4v/nBEO60fq6pocpcPSL45goi2KrIOZ2kU+rwSF4iGE0GZMf3iNOHL+ZQc9JfT2J9sb+oIdA=
X-Received: by 2002:a2e:87cb:: with SMTP id v11mr14384454ljj.218.1608134471054;
 Wed, 16 Dec 2020 08:01:11 -0800 (PST)
MIME-Version: 1.0
References: <SN6PR2101MB1069AC2DC98C74F7C2A71EA3E4C59@SN6PR2101MB1069.namprd21.prod.outlook.com>
 <20201216210735.2893dd92@canb.auug.org.au>
In-Reply-To: <20201216210735.2893dd92@canb.auug.org.au>
From:   Steve French <smfrench@gmail.com>
Date:   Wed, 16 Dec 2020 10:00:59 -0600
Message-ID: <CAH2r5mt8ZeX1j2doiZOwJQr_gkDACgeR=F5k1fxXpW8eXYvJew@mail.gmail.com>
Subject: Re: [EXTERNAL] Re: linux-next: build failure after merge of the
 net-next tree
To:     Stephen Rothwell <sfr@canb.auug.org.au>
Cc:     Steven French <Steven.French@microsoft.com>,
        David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Samuel Cabrero <scabrero@suse.de>,
        Francis Laniel <laniel_francis@privacyrequired.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        "linux-cifs@vger.kernel.org" <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 16, 2020 at 4:08 AM Stephen Rothwell <sfr@canb.auug.org.au> wrote:
>
> Hi Steven,
>
> On Wed, 16 Dec 2020 02:21:26 +0000 Steven French <Steven.French@microsoft.com> wrote:
> >
> > I applied your patch to the tip of my tree (cifs-2.6.git for-next) -
> > hopefully that makes it easier when I sent the PR in a day or two for
> > cifs/smb3 changes.
>
> I think you have just made your tree fail to build as nla_strscpy does
> not exist in your tree ... Just remove that commit and tell Linus about
> the necessary change and he can add it to the merge.

Done. Removed.


-- 
Thanks,

Steve
