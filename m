Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2B55D115D9
	for <lists+netdev@lfdr.de>; Thu,  2 May 2019 10:55:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726458AbfEBIzM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 May 2019 04:55:12 -0400
Received: from mail-lj1-f193.google.com ([209.85.208.193]:36577 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726127AbfEBIzM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 May 2019 04:55:12 -0400
Received: by mail-lj1-f193.google.com with SMTP id y8so1230266ljd.3
        for <netdev@vger.kernel.org>; Thu, 02 May 2019 01:55:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=XcwQBg8J7QsNVW/WrwQtCeiLPV6+gS2aQiC/Sl4nM9M=;
        b=RPFy3+dCeVREXH9FwiTrugWwEaAasMVV3Gf1i4SWx0v8LPuLBhfHi2DY8C1PQkXDV6
         7hW81i6R1F+Fu596QmxR32/RCciqCykxrMT59m8NE5Gn+FubVPtpPYK4Cl2eKYN/K1o4
         mUdF9+vKQ1xiHApDkY6JKKTT32BVDca0itsE4bI5ySxRjDHeHpXOAeJ25Bp/RwxbHsy7
         ajtvD26CCmcbARYKiJao6Za1doUSkNfhhV0GlE3zQHBfH39mBNrpDbiQO6lBx24r5rgG
         DSTFFB/qHIO45DziTZyavDVnjVre7pHco8sW71k6vny5wzjXggvaEjI5zr1UBl1OtegX
         a4qQ==
X-Gm-Message-State: APjAAAUEE8lkRFwZz7xEHefAXnUi8VNMbRL3ZVK0LJ4bRMbr7xaFvN7l
        7R5QJmq4K+mWPVYVbFq4FYihxUV+vo4ucrvYOiXGMRrK
X-Google-Smtp-Source: APXvYqz2pqQelrV7mW5UIHU/z27RQVBlfb9cw8OqwPI7xGo8xR/m90tdJZzhWRDEb/SHdQyQANIdyO2H6klgOfE8Btw=
X-Received: by 2002:a2e:9f53:: with SMTP id v19mr1269972ljk.0.1556787310088;
 Thu, 02 May 2019 01:55:10 -0700 (PDT)
MIME-Version: 1.0
References: <20190502085105.2967-1-mcroce@redhat.com>
In-Reply-To: <20190502085105.2967-1-mcroce@redhat.com>
From:   Matteo Croce <mcroce@redhat.com>
Date:   Thu, 2 May 2019 10:54:34 +0200
Message-ID: <CAGnkfhwWnST_uMOOpBtz4scN50T_9X+bJnVYaHeFvLzPHgRGtA@mail.gmail.com>
Subject: Re: [PATCH net] cls_matchall: avoid panic when receiving a packet
 before filter set
To:     netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Cc:     Cong Wang <xiyou.wangcong@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 2, 2019 at 10:51 AM Matteo Croce <mcroce@redhat.com> wrote:
>
> When a matchall classifier is added, there is a small time interval in
> which tp->root is NULL. If we receive a packet in this small time slice
> a NULL pointer dereference will happen, leading to a kernel panic:
>

Hi,

I forgot to mark it as v2. Will someone handle it, or I have to
resubmit a v2 or v3?

Regards,
-- 
Matteo Croce
per aspera ad upstream
