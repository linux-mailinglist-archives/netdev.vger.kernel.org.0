Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B437883DDD
	for <lists+netdev@lfdr.de>; Wed,  7 Aug 2019 01:37:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727256AbfHFXhj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Aug 2019 19:37:39 -0400
Received: from mail-ot1-f51.google.com ([209.85.210.51]:39021 "EHLO
        mail-ot1-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726044AbfHFXhj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Aug 2019 19:37:39 -0400
Received: by mail-ot1-f51.google.com with SMTP id r21so91019629otq.6;
        Tue, 06 Aug 2019 16:37:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=8L9+kA0ZqqoXXOvjVGsnYHKbZZYVFf05tAiM0vqOfpY=;
        b=Aat9VujIbakXAbrANx5VLitNoxcOmDSXhUPZoTZt2JOLtepc2KnR/KDSbYgkdqscTY
         h+/woRs4GEMd+/BND8Xi9UVfmBAGdphXhw7uY3ek9ZQlHkWd7g+tSqZJ/HfSyiARHcNQ
         dtRokDXuScQueRKy+qUuSWqvPN7ZsS33aaEaywzZIHQmyOaBbtrVhmyanRqF6Nvlxkx2
         lgM0SVKEmpzOWCbLCESXylW8Da0VuzkKHby6yXe+Wi8T/dG8CZgF+Hz82sWwAVD7ttTf
         kmDCLXSHGeHTuQIL87GePfCPxJsfgM5vdmu3UpCr2454jWbrkBR78X5WzS+w5UAR6/CL
         QF4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=8L9+kA0ZqqoXXOvjVGsnYHKbZZYVFf05tAiM0vqOfpY=;
        b=tyHRHSLu0P/B/dETKVFgSmJxY/wqj+xLLsW+d8ddzF7p85K48/lWEd1GTWqi7OlQz3
         J7cwgzGim9qyl7b2e6pAlHZBxaA5vy37To9KtZp9a7cRc6b4f3SdJVAp89ajsiK0vCVA
         XDgYDdW6MDsxFfQJjS965XsVPiYWkxPh8VUHmkmy57oo6gAeBGtRbzGwAfK9gwjOVLj9
         g5UHEM/L075SN7oh/D9BFEpPNpYbhfD7pZnadD7URlVl0YQIDzfqCmNnOBjB1Cgv1Jtx
         NYCXrpiIyjz5JU/RoMVdBaS9oulEHYHDB/vt6/h9pE2EdtLPiIMyQSwiLziZzFP+64uu
         /0BA==
X-Gm-Message-State: APjAAAUJu9vwCViSmvoYeXPoO/Is7TXR9IliFnZMJk4kcf4KLa2+dsab
        e7zLcWiE/ll1uzknlMhEKRPqd7Li3QB6LqBpc0Hmk7qKH9s=
X-Google-Smtp-Source: APXvYqwWhdojtNp06dNBY/mjr5KCbVJJTzbQYRADOl71ExYCcR1ZqHsrFWcbV6lA3DN8mFMbxMFajwdBnxPsohodEso=
X-Received: by 2002:aca:2211:: with SMTP id b17mr3691703oic.64.1565134657862;
 Tue, 06 Aug 2019 16:37:37 -0700 (PDT)
MIME-Version: 1.0
References: <20190807093037.65ac614e@canb.auug.org.au>
In-Reply-To: <20190807093037.65ac614e@canb.auug.org.au>
From:   Yifeng Sun <pkusunyifeng@gmail.com>
Date:   Tue, 6 Aug 2019 16:37:26 -0700
Message-ID: <CAEYOeXMV1DbTsy7U1-Fu0eztVGpw-+ZEJTK0Hzm8xbqCL7fabw@mail.gmail.com>
Subject: Re: linux-next: Signed-off-by missing for commit in the net-next tree
To:     Stephen Rothwell <sfr@canb.auug.org.au>
Cc:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Stephen,

My apologies, thanks for the email. Please add the signed-off if you can.

Signed-off-by: Yifeng Sun <pkusunyifeng@gmail.com>

Thanks,
Yifeng

On Tue, Aug 6, 2019 at 4:30 PM Stephen Rothwell <sfr@canb.auug.org.au> wrote:
>
> Hi all,
>
> Commit
>
>   aa733660dbd8 ("openvswitch: Print error when ovs_execute_actions() fails")
>
> is missing a Signed-off-by from its author.
>
> --
> Cheers,
> Stephen Rothwell
