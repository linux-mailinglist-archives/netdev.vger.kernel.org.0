Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9BC3C355961
	for <lists+netdev@lfdr.de>; Tue,  6 Apr 2021 18:40:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234809AbhDFQlB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Apr 2021 12:41:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233488AbhDFQk7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Apr 2021 12:40:59 -0400
Received: from mail-lf1-x132.google.com (mail-lf1-x132.google.com [IPv6:2a00:1450:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CEDDC06174A
        for <netdev@vger.kernel.org>; Tue,  6 Apr 2021 09:40:51 -0700 (PDT)
Received: by mail-lf1-x132.google.com with SMTP id b14so23749887lfv.8
        for <netdev@vger.kernel.org>; Tue, 06 Apr 2021 09:40:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=h6v+1TdUu3VqNbwD9pXucEv0YMc6B6LGvSVoPmT8+gU=;
        b=Q4g+oQANUHk3/7Xf9tMW69AIY0DsQemK+IWkbTbcQ6d7hkynQPIjCIvWqaLpkCD4h7
         M8vdfSb7rPbRMyxxwVK4rThKLNNzF6m7NuuU5trNk28Lu3GlO4pnGEcbQ/qMxjK5K7g9
         xfqBjpPDU6K3XzkeFhRsjDn3CbOLdWyIOFnpAHhyTft0cWiPs+ozEUzG7sgYRf3uiKVZ
         y6TPybo5wqApX0epL7xh9RfsaheG5h/kdmf4b3rm9VoBNiXP8bfkrsFlALX/pA0jbd8K
         HxqmQQNuMRDBSj91njxUBFeU1Ps3VMw6JaUITPP9Dg0r/tsMFFEDtJyoOkcs0dL3e/1b
         ChOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=h6v+1TdUu3VqNbwD9pXucEv0YMc6B6LGvSVoPmT8+gU=;
        b=J02ElMooBZNpd/UdSu/IpSyYMZpL2hH81FCW3WaBkxJXVqTVyVq4ODFoyuwYPlJd+a
         JrcbYtgEEgwiWuxgvuy9N3Wag1oxh/jTE7ksLMYCN9ZDtTApH+YuG5ZnqFuk8sjnDjKP
         jMgn0MdQuekvHEGnvsprgKjqTMAwwGoi664WIT0wmG1vDV4tnChTrNJKhli60Pj5OK9U
         KKg/8W3pnM8j5mx6GetX5/54djee14sVeWlJYHrAD7xXKFfCT1EEBAxguDdkZm9Pd/fU
         AtyXgNNR9zuO3ACg2C0v/iJf+bIOO0G2sqWaBGaP7gE4i9dpBAmoQNofYukQkvvuqC/p
         yefg==
X-Gm-Message-State: AOAM532/Bk3NZouwOTf0ttN+yv/fFmo35T43L8bLiaGZkgbJBAM3ro7L
        Ld3ZFxJptC54RLOMVa6STpDQyYlk1II8qafDyfDKNMPY
X-Google-Smtp-Source: ABdhPJwVVY6kQkbM2C5UQISMdBc/94SDYMmfFnRNHS6r5TrxkPFjFtav4EW327jjETkhRnXyF/yu+hjzjyYCpLkyUss=
X-Received: by 2002:a05:6512:303:: with SMTP id t3mr21709257lfp.196.1617727250096;
 Tue, 06 Apr 2021 09:40:50 -0700 (PDT)
MIME-Version: 1.0
References: <3ac544c09842410fb863b332917a03ad@poessinger.com> <20210406162802.9041-1-stephen@networkplumber.org>
In-Reply-To: <20210406162802.9041-1-stephen@networkplumber.org>
From:   William Tu <u9012063@gmail.com>
Date:   Tue, 6 Apr 2021 09:40:13 -0700
Message-ID: <CALDO+SZSw25ZPTU9m+y1TRqySHfCjCjRJYCLPm6JgEqZGSAj+g@mail.gmail.com>
Subject: Re: [PATCH iproute2] erspan: fix JSON output
To:     Stephen Hemminger <stephen@networkplumber.org>
Cc:     =?UTF-8?Q?Christian_P=C3=B6ssinger?= <christian@poessinger.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 6, 2021 at 9:28 AM Stephen Hemminger
<stephen@networkplumber.org> wrote:
>
> The format for erspan output is not valid JSON.
> The direction should be value and erspan_dir should be the key.
>
> Fixes: 289763626721 ("erspan: add erspan version II support")
> Cc: u9012063@gmail.com
> Reported-by: Christian P=C3=B6ssinger <christian@poessinger.com>
> Signed-off-by: Stephen Hemminger <stephen@networkplumber.org>
> ---

LGTM, Thanks.
Acked-by: William Tu <u9012063@gmail.com>
