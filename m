Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EFAF13346F
	for <lists+netdev@lfdr.de>; Mon,  3 Jun 2019 18:01:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728364AbfFCQBi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Jun 2019 12:01:38 -0400
Received: from mail-lf1-f68.google.com ([209.85.167.68]:43993 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728688AbfFCQBh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Jun 2019 12:01:37 -0400
Received: by mail-lf1-f68.google.com with SMTP id j29so110413lfk.10
        for <netdev@vger.kernel.org>; Mon, 03 Jun 2019 09:01:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=wwAb+fjZakb4SE3XBU2vDo+/FsY9YcZ27a86p6XEaAs=;
        b=RAknaK6HJEQ5zkQCebN0zIeweiFarG87mqZWgTXpU/mJYEt/DEie3H3GUrpMAkizhf
         DAjrek0lkfPev895ypNRKOioKwTHoHppJhQCGVAq+NcSFX9QQKad4aQE4NgXUszbotod
         HpqE5XLtyZaVR5/qdNcdgb7ceGwsUQvR666euqtSsqc3OmniQ2styCZ5A6fa8wFzmYab
         XQWs/R8Zv9uWMeeBYycMepmlBwpgKHulJsqz5096zetgsMifJSoInjVF+zauJ7Lcd+ZK
         poQFphqqutbXYOSTji0TJpFkZiZboByLaWGvrwJDqBIG4csRSA2uepIebTq5Rhzk3wDG
         LSOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=wwAb+fjZakb4SE3XBU2vDo+/FsY9YcZ27a86p6XEaAs=;
        b=p+Xah6zl3WBgne664xAa7WLMMNEA6N49BCfuvLULtfcC3Cb4AtVW3s5shftriqkFjn
         PDl38iH7OzVN+oElmR0s9iIt+mg/ASJk0oBFj11mEOZcQkMXnMLQnyEq7VPnfxjPvpNZ
         F9qeBHxbcFsGzsczEmdn/jCl+ZQh1n3rTCIq2l4218v0MPq5qk6fxUtVWPMTHfIY/2G0
         UIyH5Fy1/KndttMNZnXnC5AbAbpYclea6q0AQcmfsd4xp9Fh7y2+p57pBjVZEEacrLBd
         KwUT4PNMIcEkxvfcRyEDt0To1nlZ3PVzOgAKOyE3klZa+WfHI9cCzwP+R8a2hxldZZol
         sqKA==
X-Gm-Message-State: APjAAAWIfboIC3gb+ISNlbItL5SExO6k+68U6QelJUe8PPggS9H09u74
        4lJnsjzDQHS1efaIu+fT8jy17pGUr/UNKiFhKMxU
X-Google-Smtp-Source: APXvYqzF84jTm/2bsJE8Z7872PStSoK3LKry51awtLL9AllXtZ9eS6eWxt9+Bys/+Qo1UsfILlV7LgRg51RsyxVhV98=
X-Received: by 2002:ac2:446b:: with SMTP id y11mr9514878lfl.158.1559577695379;
 Mon, 03 Jun 2019 09:01:35 -0700 (PDT)
MIME-Version: 1.0
References: <fadb320e38a899441fcc693bbbc822a3b57f1a46.1559239558.git.rgb@redhat.com>
In-Reply-To: <fadb320e38a899441fcc693bbbc822a3b57f1a46.1559239558.git.rgb@redhat.com>
From:   Paul Moore <paul@paul-moore.com>
Date:   Mon, 3 Jun 2019 12:01:24 -0400
Message-ID: <CAHC9VhQZuOXiK4yj4xeRwGF_qepeg7qDL02GDdYhwTNRLRdmPA@mail.gmail.com>
Subject: Re: [PATCH ghak90 V6] fixup! audit: add containerid filtering
To:     Richard Guy Briggs <rgb@redhat.com>
Cc:     containers@lists.linux-foundation.org, linux-api@vger.kernel.org,
        Linux-Audit Mailing List <linux-audit@redhat.com>,
        linux-fsdevel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        sgrubb@redhat.com, omosnace@redhat.com, dhowells@redhat.com,
        simo@redhat.com, Eric Paris <eparis@parisplace.org>,
        Serge Hallyn <serge@hallyn.com>, ebiederm@xmission.com,
        nhorman@tuxdriver.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 31, 2019 at 1:54 PM Richard Guy Briggs <rgb@redhat.com> wrote:
>
> Remove the BUG() call since we will never have an invalid op value as
> audit_data_to_entry()/audit_to_op() ensure that the op value is a a
> known good value.
>
> Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
> ---
>  kernel/auditfilter.c | 1 -
>  1 file changed, 1 deletion(-)

Thanks for sending this out.  However, in light of the discussion in
the patchset's cover letter it looks like we need to better support
nested container orchestrators which is likely going to require some
non-trivial changes to the kernel/userspace API.  Because of this I'm
going to hold off pulling these patches into a "working" branch,
hopefully the next revision of these patches will solve the nested
orchestrator issue enough that we can continue to move forward with
testing.

> diff --git a/kernel/auditfilter.c b/kernel/auditfilter.c
> index 407b5bb3b4c6..385a114a1254 100644
> --- a/kernel/auditfilter.c
> +++ b/kernel/auditfilter.c
> @@ -1244,7 +1244,6 @@ int audit_comparator64(u64 left, u32 op, u64 right)
>         case Audit_bittest:
>                 return ((left & right) == right);
>         default:
> -               BUG();
>                 return 0;
>         }
>  }
> --
> 1.8.3.1
>


-- 
paul moore
www.paul-moore.com
