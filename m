Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A473723FFA9
	for <lists+netdev@lfdr.de>; Sun,  9 Aug 2020 20:17:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726296AbgHISQM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 Aug 2020 14:16:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726266AbgHISQM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 9 Aug 2020 14:16:12 -0400
Received: from mail-il1-x141.google.com (mail-il1-x141.google.com [IPv6:2607:f8b0:4864:20::141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FBD5C061756
        for <netdev@vger.kernel.org>; Sun,  9 Aug 2020 11:16:11 -0700 (PDT)
Received: by mail-il1-x141.google.com with SMTP id t4so5842585iln.1
        for <netdev@vger.kernel.org>; Sun, 09 Aug 2020 11:16:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=gaT5BFHsJcebBIKlFgtrRUArSY2UQIboXRgPBE74EX0=;
        b=UtDRc3HuN8n4EXOk1rvCuOwdG1MHNSoeAhLsSy+98jdBWs65wg9Op5TCzzqikST3Tn
         4VwxsQVaWrF0TxHGxopucBZTbNb/19qIq7BLC+koiM37pX+YMiqNKTqCBq7UnvkzUg2L
         BbwugaZ4A1o0udDWIPN/rMT9D4JLKvdInL/m/MmirWve5Y6hPQa21ywf75J6X4IvXpID
         Eup2DHQCbMME64/di7CG7WGCnf8aTaUb+bAD2CinW+bFn6fLGWlUxZgPSvl8bdeQur9p
         v4prDo8nYib1hXf9Gqz/SDkZNnP3WEqkMbxcRcamXAf5RJXZo6WEp0NvBU9LhR2rhVwn
         NrKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=gaT5BFHsJcebBIKlFgtrRUArSY2UQIboXRgPBE74EX0=;
        b=qbzpP6IqcQI2FF9CxtzU+3sl9xsySNXdyEPIa5k5Vm4H5PU7E1CzgqXPj4fXeh8lbm
         GNRmeFRUId3OInWVkZcsAWFks2JZfm2dZwNvqi5DK8lSSR/O5ouC7cx2mr1eMzUNiCsb
         QKsINhJNZwYg7VGYPGbPb+zTL8wKo31neWgFxgx3mFv292MpGjUrQTGQl+4z9sYruRD9
         h6KyZ/stQciK4lPLIUBrgmQbxwdYGUyhSd8VimFA5jnt1XadBukiL5m8bsrUzQh9Nsch
         /bW1vd6yYLAjGuicXNRgdEq7V99V1xz58LdMCSEEjFZsXmMUYjZ5NWtjx3lf7nyGZhti
         fvlw==
X-Gm-Message-State: AOAM533baDP+w9ps6+U9S9qdiajt+aCSzZ+0jevZedqEya9c7nvEkWxQ
        8KhO6B419D15KuLRG2Xso46ICql9TsC4bzhZjZ8=
X-Google-Smtp-Source: ABdhPJzT12+Jk3P/Ovx1d/W3NQbW93cHtAux9QNd+F0a6/hfDLUvw7SsoF2ikv/PCDpahBxCWVL9o84iQCz9c8cPNo8=
X-Received: by 2002:a92:9116:: with SMTP id t22mr14139363ild.305.1596996969254;
 Sun, 09 Aug 2020 11:16:09 -0700 (PDT)
MIME-Version: 1.0
References: <20200807222816.18026-1-jhs@emojatatu.com>
In-Reply-To: <20200807222816.18026-1-jhs@emojatatu.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Sun, 9 Aug 2020 11:15:58 -0700
Message-ID: <CAM_iQpU6j2TVOu2uYFcFWhBdMj_nu1TuLWfnR3O+2F2CPG+Wzw@mail.gmail.com>
Subject: Re: [PATCH net-next 1/1] net/sched: Introduce skb hash classifier
To:     Jamal Hadi Salim <jhs@mojatatu.com>
Cc:     David Miller <davem@davemloft.net>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Jiri Pirko <jiri@resnulli.us>,
        Ariel Levkovich <lariel@mellanox.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Aug 7, 2020 at 3:28 PM Jamal Hadi Salim <jhs@mojatatu.com> wrote:
>
> From: Jamal Hadi Salim <jhs@mojatatu.com>
>
> his classifier, in the same spirit as the tc skb mark classifier,
> provides a generic (fast lookup) approach to filter on the hash value
> and optional mask.
>
> like skb->mark, skb->hash could be set by multiple entities in the
> datapath including but not limited to hardware offloaded classification
> policies, hardware RSS (which already sets it today), XDP, ebpf programs
> and even by other tc actions like skbedit and IFE.

Looks like a lot of code duplication with cls_fw, is there any way to
reuse the code?

And I wonder if it is time to introduce a filter to match multiple skb
fields, as adding a filter for each skb field clearly does not scale.
Perhaps something like:

$TC filter add dev $DEV1 parent ffff: protocol ip prio 3 handle X skb \
hash Y mark Z flowid 1:12

Thanks.
