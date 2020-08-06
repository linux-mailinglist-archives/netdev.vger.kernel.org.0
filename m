Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C847E23DDBA
	for <lists+netdev@lfdr.de>; Thu,  6 Aug 2020 19:14:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730415AbgHFROE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Aug 2020 13:14:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730437AbgHFRNj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Aug 2020 13:13:39 -0400
Received: from mail-qk1-x742.google.com (mail-qk1-x742.google.com [IPv6:2607:f8b0:4864:20::742])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4330C061574
        for <netdev@vger.kernel.org>; Thu,  6 Aug 2020 10:13:39 -0700 (PDT)
Received: by mail-qk1-x742.google.com with SMTP id 77so13333611qkm.5
        for <netdev@vger.kernel.org>; Thu, 06 Aug 2020 10:13:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=NW92KbR9UouvdFrt5XetfgHy1gtk7pfw1B0ZeXt20hw=;
        b=LSYSUKnfN8GHmOGAA2cjdiF0ZMaNduRH9RxMgx6s3tpIFIQn88KSHvUxzPrrjyOtPE
         tTC6WKSmYIJ1/whfulxa43pkmb1MoEs+cvC95G3wtDaWrvDibI4i3CcAqa4wmE85p60a
         LX3IlUMiWTcGGxxirAOivo+qH1z2OfwDGx07T4Pse1GiWUdr5ecSOyFRWNDiZGFQbNsS
         XHyhS+qbYb+HfbBceQAGSs0q676/tsWFsuppdAJnF+csfSjqDzGfcXHkIV/SL9bRuiqD
         +aEHKhmQ4+aCpAf7Ac5KbEvWK/cNPZY56G1Q5vC6g027JkOUMECsGVMwPofHY65/d6Du
         JgFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=NW92KbR9UouvdFrt5XetfgHy1gtk7pfw1B0ZeXt20hw=;
        b=Ix3zDbAPKdD9UMVgOi1sFP+SeULUJ9as1Ew+oqjDWClS2PuTc/lZf53CbqA+JRaIDE
         psqFdHR7QeaP7DdXdVN35SF/PqqmNLG0T5CaxJINDKS7vX/cH8BBsAWz5/i3i75EBlp5
         pV+UazcovJ4K0WmCHCg4vEFebh4kTEOmBhfwDmY8ov4imOpq/8VpP2tLhnHt0zwJidTQ
         ErBU15ES3f8U8LC5nycZ5THApcqZOAxKMUE/mcTqJNssGMbwbQzWfwljJkLjvbl3cFdn
         HUtQcsZqy9i1A2IJHS6FzTnwdFEvDpC0qqP1PT/OPJvfo3TEsm54NG5Xj1dXvJ95Kvm1
         n0/A==
X-Gm-Message-State: AOAM530w9+pIBHP9yn5dsU1Cq66BPqnLLeIsZ3PMd3mq1eVtoYIB6dIx
        pOaR02BaRUCB/ZA5NZyG7QDq92rCRNL6GPiH7xY=
X-Google-Smtp-Source: ABdhPJw66o3GeduSPZ79e3DP7S6XY9OQs/s7pG0Mhd6kvMMVidTqOj/I7sXSdL8fA8vnQot0fdqvcpd7/aZwKAVKJwA=
X-Received: by 2002:a37:d201:: with SMTP id f1mr9533213qkj.188.1596734018964;
 Thu, 06 Aug 2020 10:13:38 -0700 (PDT)
MIME-Version: 1.0
References: <20200731084725.7804-1-popadrian1996@gmail.com>
 <20200804101456.4cfv4agv6etufi7a@lion.mk-sys.cz> <CAL_jBfRyKxaFqU5m7oXNyfvC3_T_TVAjaF+04NV7rZksCqmszg@mail.gmail.com>
 <20200804171828.sbrnaqak6y2xxhly@lion.mk-sys.cz>
In-Reply-To: <20200804171828.sbrnaqak6y2xxhly@lion.mk-sys.cz>
From:   Adrian Pop <popadrian1996@gmail.com>
Date:   Thu, 6 Aug 2020 18:13:02 +0300
Message-ID: <CAL_jBfQX+xobk+wv+ZYb-u7NOdBhdyQr+xQU9jBK3AkH5ku5hA@mail.gmail.com>
Subject: Re: [PATCH] ethtool: Add QSFP-DD support
To:     Michal Kubecek <mkubecek@suse.cz>
Cc:     netdev@vger.kernel.org, linville@tuxdriver.com,
        davem@davemloft.net, kuba@kernel.org, jiri@mellanox.com,
        vadimp@mellanox.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>,
        Andrew Lunn <andrew@lunn.ch>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>
> Branch "next" is merged into master now so you can base v2 on master.
>

Hi Michal!

Just submitted v2. I fixed the little problems noticed by Ido and you.
The submission consists of only one patch, since I noticed that some
extra whitespace 'fixes' were wrongly introduced by my editor so I
supposed the code is already well formatted and there's no need for a
separate one. I hope everything is okay now.

Adrian
