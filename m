Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3EC921C5FFC
	for <lists+netdev@lfdr.de>; Tue,  5 May 2020 20:23:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730664AbgEESWz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 May 2020 14:22:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730258AbgEESWz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 May 2020 14:22:55 -0400
Received: from mail-ot1-x342.google.com (mail-ot1-x342.google.com [IPv6:2607:f8b0:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61AF2C061A0F;
        Tue,  5 May 2020 11:22:55 -0700 (PDT)
Received: by mail-ot1-x342.google.com with SMTP id m18so2490554otq.9;
        Tue, 05 May 2020 11:22:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=yviYTVBMtZlPKHZIwINfaP1mAfP/zIEStrqoObXgTUo=;
        b=pP3Kckqtimgvoy5XubnGYCNOB2JGuudEJVYHHVlv+dOFG3FJTG7VTSCV659x6WkHmE
         /O+WuTN+qcfFZfCL1aXuBuc94iCFETiZRlrpBqdx0caibDaUKYkymWseWnHYyNaZR+8/
         np8tLADc7xJSOloYBAOtLB8yDN3hJBKtxhg4+lcrjgLx//dCAUyHhIIOoSY0hyWlORpO
         slB7+ROk5GS9EukcxXz03B18/hTRYiRdXHj5sE+Op9QltHvmbtOA2Pq3xQtIQ6GU9eqv
         mMjWPgGlK8qzb9iJR51fce9AWh7gU6CpTWYNTl6t9QrNSEc/YIbIsp3w0c0JrVqMtj7Z
         5/ig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=yviYTVBMtZlPKHZIwINfaP1mAfP/zIEStrqoObXgTUo=;
        b=LoSkXrTEMtyVCy+tBokaU/6EYSgotdbH33vNLsFhl4aMqi1yl6L11oCok185L55cK4
         /dVTkEPS/0kU0A4QXlAIJmBMkEqFZKHe+wVkGI0JJl+qGgWYrMJyYbIXwwv8es0b+S3X
         JRM6uee4aP/T31JEj9PHWXpg5C0rIkFBgyytcQ+b5mugpQ6rkr3YhUOEuXVsvfIfW0Nl
         i1iScaeqOkkvHyjkTQ8CkPFamEKNtiHt9vQdt00HK9MLxITK1pyJZbznsnELe8y2bYg3
         k9fEjF7i3FALN458VZgURcw3FBjWX+88UCrfpLYBIqGDwZRw7H8tlWihmHN8ObDNHCXU
         vLEw==
X-Gm-Message-State: AGi0PubGvMBG4CeJ6siqjfi0qfcl/hpKjzkUfZ/G1QtOnkcMgymJ5+AO
        oUOmN77t8WeWa5jla3XzgAoVOY4gMahrm/K+xWY=
X-Google-Smtp-Source: APiQypJcIH28ZA04xjz6nowjz51cG1i3Y85gl8XzNhXm+Q0KvZ8zU05FCA6tYIDxaf2ZrY3ZFBLQuusK3sLE7/s5sgQ=
X-Received: by 2002:a9d:1c97:: with SMTP id l23mr1943874ota.189.1588702974749;
 Tue, 05 May 2020 11:22:54 -0700 (PDT)
MIME-Version: 1.0
References: <20200505084736.49692-1-yuehaibing@huawei.com>
In-Reply-To: <20200505084736.49692-1-yuehaibing@huawei.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Tue, 5 May 2020 11:22:43 -0700
Message-ID: <CAM_iQpXbJFrBMqcwb+AD_o-1mPp7Ak_n6hXGXK8uf8zTN0nzRg@mail.gmail.com>
Subject: Re: [PATCH net-next] net: sched: choke: Remove unused inline function choke_set_classid
To:     YueHaibing <yuehaibing@huawei.com>
Cc:     Jamal Hadi Salim <jhs@mojatatu.com>, Jiri Pirko <jiri@resnulli.us>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 5, 2020 at 1:49 AM YueHaibing <yuehaibing@huawei.com> wrote:
>
> There's no callers in-tree anymore since commit 5952fde10c35 ("net:
> sched: choke: remove dead filter classify code")

While you are at this, please also remove classid from
struct choke_skb_cb.

Thanks.
