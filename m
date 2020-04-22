Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9011A1B48FB
	for <lists+netdev@lfdr.de>; Wed, 22 Apr 2020 17:43:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726523AbgDVPnw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Apr 2020 11:43:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726245AbgDVPnw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Apr 2020 11:43:52 -0400
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E179C03C1A9
        for <netdev@vger.kernel.org>; Wed, 22 Apr 2020 08:43:52 -0700 (PDT)
Received: by mail-wr1-x441.google.com with SMTP id x17so2239386wrt.5
        for <netdev@vger.kernel.org>; Wed, 22 Apr 2020 08:43:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=eBBIVsuMA6t1t1eSE9bVr1OmDDkyvsRpxDkHIBhRoLc=;
        b=XiwZsWhcUJaNSUnESwyEZXExobIECoC4bBQ9MMmMORD4EwYFRYWBQePdmSBO44oLIC
         ieQiGAwahrX82CfLVW8YBOXvLC8MHWKZOBcE4uF3fomQCDqCExiT7n2rw0PCu4sPDBx3
         Try4lVs4YLEpz8Vzk3JLBuUGvsW2QR3ae8NQ3ozktZV8fWOtbW/3VHVBnCux9sfTsCoc
         FVxCV/IUo0tIr+fSixsGkUdGHz/zVyZ2tHGEVybPCOIWbAfBfisvfs6KSlzcwwm04P+N
         MkLQMnJBcqZ2F1Pz0aMX8jDZLs3IuPR3mDYwPA1k7Roku9FOpXAiAJ9tqFG47N5PNiqN
         9uVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=eBBIVsuMA6t1t1eSE9bVr1OmDDkyvsRpxDkHIBhRoLc=;
        b=UAux5g8OcAm8QWjzPVeZDlypMkpSBJRQX1jmt6ihzVK/CRazuf2Ddw29YGEOvN3MZL
         CgIe63XotrQGtsxo90qfE8L2XEhtb4vGQDpaa3dKcjlDefTTxBGwt7NbeTwu4mUD4MTj
         MWHlGghvpDmMOzoe9zXdCluXCZnBGgUmuCfQNC1+3bLjihxCBUlId0goFRheksXCRnTO
         epjetO2nFG4JsKFScm4/0yyLVmr6gpwxuAj6xNbP78n/5Jmn+0nIMQmDg5+EkYw/3t+f
         GE+0PsmWW8kHg0KOINmZ54HeEqcXuVmbsWljL6TVluwX0x6dguS+251hba998malelmx
         j+PQ==
X-Gm-Message-State: AGi0PuYy6KJcBRlrHsy6BxSU9TSOPDE0rBgpSl3TxKibsyM7nXejIGE2
        cKIrBIzCdXcVZHS0EyLerKh5wzGvddkXt3mLQ+A=
X-Google-Smtp-Source: APiQypLCUpGtQSgVjIclyUaBa2RZIC2v5AAob70EYKauTGS/7etmvwN/xzGaMAAqx1lQFwCCBgR9xk1zEu06/DwVNII=
X-Received: by 2002:adf:cd0a:: with SMTP id w10mr29761963wrm.404.1587570230938;
 Wed, 22 Apr 2020 08:43:50 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1587568231.git.sd@queasysnail.net>
In-Reply-To: <cover.1587568231.git.sd@queasysnail.net>
From:   Xin Long <lucien.xin@gmail.com>
Date:   Wed, 22 Apr 2020 23:48:44 +0800
Message-ID: <CADvbK_e0ZYsjdAkpxgPAAjvb_d-16Uz7vuf3Q1y-2CG_-kkuSQ@mail.gmail.com>
Subject: Re: [PATCH net 0/2] net: vxlan/geneve: use the correct nlattr array
 for extack
To:     Sabrina Dubroca <sd@queasysnail.net>
Cc:     network dev <netdev@vger.kernel.org>,
        Stefano Brivio <sbrivio@redhat.com>,
        Girish Moodalbail <girish.moodalbail@oracle.com>,
        Matthias Schiffer <mschiffer@universe-factory.net>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 22, 2020 at 11:30 PM Sabrina Dubroca <sd@queasysnail.net> wrote:
>
> The ->validate callbacks for vxlan and geneve have a couple of typos
> in extack, where the nlattr array for IFLA_* attributes is used
> instead of the link-specific one.
>
> Sabrina Dubroca (2):
>   vxlan: use the correct nlattr array in NL_SET_ERR_MSG_ATTR
>   geneve: use the correct nlattr array in NL_SET_ERR_MSG_ATTR
>
>  drivers/net/geneve.c | 2 +-
>  drivers/net/vxlan.c  | 6 +++---
>  2 files changed, 4 insertions(+), 4 deletions(-)
>
> --
> 2.26.1
>
Reviewed-by: Xin Long <lucien.xin@gmail.com>
