Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C84702458FB
	for <lists+netdev@lfdr.de>; Sun, 16 Aug 2020 20:30:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729259AbgHPS3x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 16 Aug 2020 14:29:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728551AbgHPS3v (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 16 Aug 2020 14:29:51 -0400
Received: from mail-il1-x141.google.com (mail-il1-x141.google.com [IPv6:2607:f8b0:4864:20::141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF772C061786
        for <netdev@vger.kernel.org>; Sun, 16 Aug 2020 11:29:50 -0700 (PDT)
Received: by mail-il1-x141.google.com with SMTP id p13so12654159ilh.4
        for <netdev@vger.kernel.org>; Sun, 16 Aug 2020 11:29:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=zOKA+DsIH24ZU9YG0zEM6ZNDBhiwBmlwQqaSCjTenjA=;
        b=Nrm9D+UsIyYSXRU+dYYuli1iIdpB77y7IUhQyTIs3AKDlaKjG9h8Zt275/hROCVHsQ
         egheSCuxgpsF/uoCSaLbZsIrCXuoPKkp+1mpR8VJwoSEiGF7h1MZX+acYCkn9Cq7OKET
         1m8v1SHz0Il0Xjr7WJ+oyD1JXzjtGWxv+BUWT08KvH3uRudVUNapfvmkZrAbZpqfsaLy
         wv/uhVjnEPrJLLtpjWOxAuQCgWxcETHx8z/hZ9WFNr1Fji/9MNJGOjpsP2VRLqzcU9fc
         zaYSBrHYb/Gcm7Rje4qjxtPM3IVaIv4XIr09rmBetBUL3kVF4O7q0AnB9JLYQu+BVaib
         90bA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=zOKA+DsIH24ZU9YG0zEM6ZNDBhiwBmlwQqaSCjTenjA=;
        b=fdX1F2fNx5Hz523Abe+U8LhOQR/f/k5XMus7td1CBDPuww4lL//j0wZFXy5CUW3SI9
         z/szpjTs4vnoupDzIdvtBnrTmGX1bniziNXt7Ce/ZjTNUlY4/zltt7Fxi73+xkZPPDRL
         Q+mRfGaWVq6SblDDpcnN8d4FT8hM/RlyDHXCXFZq9sSMoyqOgTpLwplX7BZn1jY0MtD5
         R0yMpiJJOjYzf/JNvCR97z+kxId23Pfr2dq354fFR5+AD2aEy7qIaUok12HjewWOmhyo
         r5U1CMlz6+4tfzJT0zTxDIhGdgdBfBc1Y9z0/JX2Gyunh0t4CG0UN2xR+f4+ueHuV0yf
         y7Pg==
X-Gm-Message-State: AOAM532znFo0xYqICsDGeWpVSPdjV27DbPVdp2GPZGXrO2skwf/az8NM
        nho6bO/csYiLyp6DGxbkaRIA8Jon4RleNhM6shg=
X-Google-Smtp-Source: ABdhPJyjPufOwAscpP+UqVymmrRGWuFLt5C/Yu1tIIiChCX5YCR/8KdLlhgPv412t+vbpWr5Dwt+qobGttcc4z3kZss=
X-Received: by 2002:a92:bad5:: with SMTP id t82mr10874246ill.22.1597602585465;
 Sun, 16 Aug 2020 11:29:45 -0700 (PDT)
MIME-Version: 1.0
References: <d20778039a791b9721bb449d493836edb742d1dc.1597570323.git.lucien.xin@gmail.com>
In-Reply-To: <d20778039a791b9721bb449d493836edb742d1dc.1597570323.git.lucien.xin@gmail.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Sun, 16 Aug 2020 11:29:32 -0700
Message-ID: <CAM_iQpU7iCjAZ3w4cnzZx1iBpUySzP-d+RDwaoAsqTaDBiVMVQ@mail.gmail.com>
Subject: Re: [PATCH net] tipc: not enable tipc when ipv6 works as a module
To:     Xin Long <lucien.xin@gmail.com>
Cc:     network dev <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Jon Maloy <jmaloy@redhat.com>,
        Ying Xue <ying.xue@windriver.com>,
        tipc-discussion@lists.sourceforge.net,
        Randy Dunlap <rdunlap@infradead.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Aug 16, 2020 at 4:54 AM Xin Long <lucien.xin@gmail.com> wrote:
>
> When using ipv6_dev_find() in one module, it requires ipv6 not to
> work as a module. Otherwise, this error occurs in build:
>
>   undefined reference to `ipv6_dev_find'.
>
> So fix it by adding "depends on IPV6 || IPV6=n" to tipc/Kconfig,
> as it does in sctp/Kconfig.

Or put it into struct ipv6_stub?
