Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C19B2FFAD6
	for <lists+netdev@lfdr.de>; Fri, 22 Jan 2021 04:10:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726160AbhAVDJ0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jan 2021 22:09:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726044AbhAVDJY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Jan 2021 22:09:24 -0500
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 470AEC06174A
        for <netdev@vger.kernel.org>; Thu, 21 Jan 2021 19:08:44 -0800 (PST)
Received: by mail-wr1-x429.google.com with SMTP id v15so3713966wrx.4
        for <netdev@vger.kernel.org>; Thu, 21 Jan 2021 19:08:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=jJ3PyGZRAIkRDgrNezAY8Cgj65X9oPSlmSnMZzc7qa8=;
        b=MMhQeLo1OeddV8VFxhNwgXZs4584v4QpkvrYJL/54w864+fuDy4K9U+nOHXHV4CVUG
         R9w9p9xCTxZ0vudSQNZHnIUkhCNBHAwk5F73O0Ld2rDLuNL6IXB9xmsrSLJjSWcMuQQT
         j8NIuyVdgTD78XI+IVQ+NraSSCVC60ryBtJv3DQmJqORYhRAZ+TQ2dr+DFIT1EqEKwpL
         tVR/Nbm0wyLKlsnuDRCRcIFlcSRc+/I+PzWbTEadvzR4WsStP4Ns/PWKLWod587OcEc5
         VfgvExlvbtLdRjRkdx5pAEarKkLxBRDWq+ym+spF9NgA+ukaNgYN1MdUcDdYm5K6Zds2
         W6og==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=jJ3PyGZRAIkRDgrNezAY8Cgj65X9oPSlmSnMZzc7qa8=;
        b=n92lBsdMovhe/eKYYPwrGECcQ1iQpeHpP4KC29kN7ZkSWao3+sSgDERiMvSNSelIqJ
         +dO+eD+pqAk3trtUrMcvRy2Tkcv5AzpCtNqsu0setFh+/CPQWjFoYQPomwK9KkhiQfgV
         YUuc3te2xFzu9LxDA7MSb3Jt/eckHXKlipQ3Y2GVd05inDm9snXBBQkNdvV/0bX0caH5
         8EiRGeuwD0NYILpjiyRlmxjoPfrpYZUvTMTWtQILCxRQds0azZClg3R/8X98lDL7jWnv
         6a+BwqS6qqw0kDfjEa71cBXKAgDpmQxFS1HzrYj6sXi2c+exvcnSmRqCfqBnoBtgXLlL
         cUaQ==
X-Gm-Message-State: AOAM530f34ctue1T+RA2ckhS3kgU2OIEjqODorNuewW1nglg5cvzmJ1/
        fD1bcLxPMi5POWdNxSwGzPnqODsxoxSA1D9tJ7A=
X-Google-Smtp-Source: ABdhPJxs9Yz6OvApd/KH15gSWE46TN/7y29JRUJGJKmjfOG2nvGGC2hdXP9Oljbm1XDZlc5J8UE+WbvL1DqK4BRM1EU=
X-Received: by 2002:a5d:6749:: with SMTP id l9mr2257078wrw.395.1611284922804;
 Thu, 21 Jan 2021 19:08:42 -0800 (PST)
MIME-Version: 1.0
References: <cover.1611218673.git.lucien.xin@gmail.com> <0fa4f7f04222e0c4e7bd27cbd86ffe22148f6476.1611218673.git.lucien.xin@gmail.com>
 <20210121185018.4ba57d3d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210121185018.4ba57d3d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Xin Long <lucien.xin@gmail.com>
Date:   Fri, 22 Jan 2021 11:08:31 +0800
Message-ID: <CADvbK_d8Vf9ghNqqQf7UAHPHH9WVwtaJMs8=q7Qw_Sz24wWxRA@mail.gmail.com>
Subject: Re: [PATCH net-next 1/3] net: rename csum_not_inet to csum_type
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     network dev <netdev@vger.kernel.org>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Davide Caratti <dcaratti@redhat.com>,
        davem <davem@davemloft.net>,
        Alexander Duyck <alexander.duyck@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 22, 2021 at 10:50 AM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Thu, 21 Jan 2021 16:45:36 +0800 Xin Long wrote:
> > This patch is to rename csum_not_inet to csum_type, as later
> > more csum type would be introduced in the next patch.
> >
> > Signed-off-by: Xin Long <lucien.xin@gmail.com>
>
> drivers/net/ethernet/hisilicon/hns3/hns3_enet.c:1073:11: error: =E2=80=98=
struct sk_buff=E2=80=99 has no member named =E2=80=98csum_not_inet=E2=80=99=
; did you mean =E2=80=98csum_offset=E2=80=99?
>  1073 |  if (skb->csum_not_inet || skb_is_gso(skb) ||
>       |           ^~~~~~~~~~~~~
>       |           csum_offset
I will replace it with skb_csum_is_sctp(). Thanks.
