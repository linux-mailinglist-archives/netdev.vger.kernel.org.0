Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1784E62D53
	for <lists+netdev@lfdr.de>; Tue,  9 Jul 2019 03:18:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725941AbfGIBSA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jul 2019 21:18:00 -0400
Received: from mail-ot1-f68.google.com ([209.85.210.68]:35258 "EHLO
        mail-ot1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725857AbfGIBSA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Jul 2019 21:18:00 -0400
Received: by mail-ot1-f68.google.com with SMTP id j19so18237626otq.2
        for <netdev@vger.kernel.org>; Mon, 08 Jul 2019 18:18:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=aTXqcAS9u+B85awmg441/y+vcGSXsJQ48IseMoczl58=;
        b=ygu9KOeYgd6MSij+3q0EOuOyYXAY8xeXyEILBLb5OBk4hRb3M5+7WmaGr2RfMsleZG
         c7EgF3cilEWypqAFWgmMungnD85IHm94d76WfOuOFqV6BAu7uWupnYGT3KvgoEdfrGQL
         m3Or3Jbsw+KBALQyPEOr6EDHicyDdVf3ULmKr28HAS2R8K49yVa7nXpwkjvsqENAEK6Z
         lr/Bhwx8gxnTEhqt3DYYtEXdRzgPNIA/mnguEE9uMGHzCImdbfFuQ5IdlAjgpmW/YUSk
         7zVjH8P2ZeYm9b2YBk010holOKtvpviDfW4ZeEOpJIerj6lVV0UtU7Xz7JcDNY++w4k5
         KyLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=aTXqcAS9u+B85awmg441/y+vcGSXsJQ48IseMoczl58=;
        b=sZaEtOzgRMa4f3zyKrFvifwwENcm284KkMkwGLJ5uQzr649RGeWOGg9x2VvyYqC2NF
         dt3T0bt2/YS79K6CtfvZ68i+XXGkzEyj8JP7ioVYbNM9u3UecKQnJsC/QdoHk28NMFBO
         9u5RT1NVGiG7yJJNS+PXnC89biDuFqK4l1gIYCHKTtZhweKjn71QmDrrnl85ZLEFlC+g
         +Kd7WoQIZlIlWDpB1PowcsJq6g+eT6Rvj5cKgq0Vyl3/yyC5TvB1PIzhW0c1NROT6jYj
         mPOaq4/nTHtbR2Buh9+O7EwPscWCCKwF5TQj7B1ymnD+yKdUzY2ClqYJBVkNXVh/SYLw
         Tj4Q==
X-Gm-Message-State: APjAAAXZzoaSNCNpNMP37D0XDmQGkiszLdY04A/XU3oNsk5ddC7KGFuK
        DQiGavg9KQ4AEjyEjK0W1R3pVSXybHSNeQwIbVsjxA==
X-Google-Smtp-Source: APXvYqzLjRyHAunw4lZH8fdTfz+3F4ySvruZyET5mJD+NUtJdYTuaAZSk1kjKF16hvRJLXykadAj9ZdbkpFIG7y1GkY=
X-Received: by 2002:a9d:19e5:: with SMTP id k92mr9248063otk.65.1562635080008;
 Mon, 08 Jul 2019 18:18:00 -0700 (PDT)
MIME-Version: 1.0
References: <1562201102-4332-1-git-send-email-lucasb@mojatatu.com>
 <1562201102-4332-2-git-send-email-lucasb@mojatatu.com> <20190704202130.tv2ivy5tjj7pjasj@x220t>
 <CAMDBHY+Mg9W0wJRQWeUBHCk=G0Qp4nij8B4Oz77XA6AK2Dt7Gw@mail.gmail.com> <20190708172458.syopc3bvvkjb3sxv@x220t>
In-Reply-To: <20190708172458.syopc3bvvkjb3sxv@x220t>
From:   Lucas Bates <lucasb@mojatatu.com>
Date:   Mon, 8 Jul 2019 21:17:48 -0400
Message-ID: <CAMDBHYKyV2CH=1yV16hj0xaBkAp2nRjc1PoXRj6OE=0ykOp9VA@mail.gmail.com>
Subject: Re: [PATCH v2 net-next 1/3] tc-testing: Add JSON verification to tdc
To:     Alexander Aring <aring@mojatatu.com>
Cc:     David Miller <davem@davemloft.net>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Marcelo Ricardo Leitner <mleitner@redhat.com>,
        Vlad Buslov <vladbu@mellanox.com>,
        Davide Caratti <dcaratti@redhat.com>, kernel@mojatatu.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 8, 2019 at 1:25 PM Alexander Aring <aring@mojatatu.com> wrote:
> > Unless I'm off-base here?
>
> yes you need to know some python, complex code can be hidden by some
> helper functionality I guess.
>
> I have no problem to let this patch in, it will not harm anything...
I think I'm going to pull it for the moment - I started thinking about
the patch today and I think it needs more testing against larger
amounts of data.

> Maybe I work on a matchEval and show some examples... in a human
> readable way you can even concatenate bool expressions in combinations
> with helpers.
>
> I just was curious, so I might add the matchEval or something to show
> this approach.

Go for it, I think you have a much better grasp on the use of eval
than I do - and it could be very useful for test cases.
