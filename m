Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C1D326D32F
	for <lists+netdev@lfdr.de>; Thu, 17 Sep 2020 07:42:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726151AbgIQFm4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Sep 2020 01:42:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726106AbgIQFm4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Sep 2020 01:42:56 -0400
Received: from mail-oi1-x243.google.com (mail-oi1-x243.google.com [IPv6:2607:f8b0:4864:20::243])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D44BC06174A;
        Wed, 16 Sep 2020 22:42:55 -0700 (PDT)
Received: by mail-oi1-x243.google.com with SMTP id x14so1110814oic.9;
        Wed, 16 Sep 2020 22:42:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:reply-to:from:date:message-id
         :subject:to:cc;
        bh=ZiCysG9rGG0ieg+s7X253x3mvbTARAdRWOXVI95pEMg=;
        b=FNCfH6IuT6kTlzKOC9rjiTAIw5PAbNQ9xlZshvDYoY8iwUk25gSqJOIHq1+kVELp1W
         DF+JvftYWYcuHAjve2MwLyPJkRdkX9ff1Eb0ITUykXlPOamZKYVYFpZ6hz/UdNczuQT6
         /3htkSqS18vdfCCq8tdKkTMVOz9HTI5P/6RzN3Y5c/tB3zf5qJyTxxHktLL26+6iqVzX
         EU5+wAmWmnaATGDSJKqeVKmHtxt7s8FDkE3PnoUkvXvXROnPhNJ0hXr1WDU4qke6eZjJ
         fFAR4e0bXxYRTOi+t3iu6MKIivLBywMz1X+B3gvNL5aEGLmEiajttblKJm41KXBNljKD
         qgxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:reply-to
         :from:date:message-id:subject:to:cc;
        bh=ZiCysG9rGG0ieg+s7X253x3mvbTARAdRWOXVI95pEMg=;
        b=fZrynUJP0oBTBhvURxgp0t/9PJZSWV99udpnE9nvJo6HdfJg2n502c7A5+n8WaT0F8
         GtvDbz3FnmK4cMecI5OrkU4K/AxHihgG78VuCajgE5lOlyuARgCUwRF8PmK3ZVzXQoBK
         5eNpIlmO6dxyA61kw2kWLvlwV+NOH2+6iDEAPYDr215EMOpWS0EqPt8PGeI8T9eyMijw
         bRhdSjhgouGM5M1YZBt8+0fHtAfl+oHg5BW+yNq3ism56razKdgQwPKfNgCDsG4DwqWi
         NEZ6BWflWyrJWMy3OilhYawc+Ahn6xyYUHEtxFLhXh++KXkXv36k7eeJoT6+WtQO6Bv7
         8tRQ==
X-Gm-Message-State: AOAM531mukXQzFt9FB+OR0ArMVstTS7wgSxtm96LqVVEKyqnFGhFFuqI
        GwVINEJWGIsGu28my6ZkRVCzcVXpuydFvo60i5E=
X-Google-Smtp-Source: ABdhPJwyTsIk2A34T/0C/jclVNbj1SEzX9/td6vL5Jh+OSlZKJCflhcxhU+xCP3zpUJmQ7d8NO5RSYx2UKl0g9JTBZM=
X-Received: by 2002:aca:5903:: with SMTP id n3mr5443792oib.159.1600321374909;
 Wed, 16 Sep 2020 22:42:54 -0700 (PDT)
MIME-Version: 1.0
References: <CAA+iEG_gYH0Em5Ff+xwFkcuph32AKvAu=CQvREEy1q8c8C7Tvg@mail.gmail.com>
In-Reply-To: <CAA+iEG_gYH0Em5Ff+xwFkcuph32AKvAu=CQvREEy1q8c8C7Tvg@mail.gmail.com>
Reply-To: mtk.manpages@gmail.com
From:   "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Date:   Thu, 17 Sep 2020 07:42:43 +0200
Message-ID: <CAKgNAkgQO+Spi=g6sC8dXdEGkJDOLziBYaxa7phdT9tQL=BuVA@mail.gmail.com>
Subject: Re: [patch] freeaddrinfo.3: memory leaks in freeaddrinfo examples
To:     Marko Hrastovec <marko.hrastovec@gmail.com>
Cc:     linux-man <linux-man@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Marko,

On Thu, 17 Sep 2020 at 07:34, Marko Hrastovec <marko.hrastovec@gmail.com> wrote:
>
> Hi,
>
> examples in freeaddrinfo.3 have a memory leak, which is replicated in many real world programs copying an example from manual pages. The two examples should have different order of lines, which is done in the following patch.
>
> diff --git a/man3/getaddrinfo.3 b/man3/getaddrinfo.3
> index c9a4b3e43..4d383bea0 100644
> --- a/man3/getaddrinfo.3
> +++ b/man3/getaddrinfo.3
> @@ -711,13 +711,13 @@ main(int argc, char *argv[])
>          close(sfd);
>      }
>
> +    freeaddrinfo(result);           /* No longer needed */
> +
>      if (rp == NULL) {               /* No address succeeded */
>          fprintf(stderr, "Could not bind\en");
>          exit(EXIT_FAILURE);
>      }
>
> -    freeaddrinfo(result);           /* No longer needed */
> -
>      /* Read datagrams and echo them back to sender */
>
>      for (;;) {
> @@ -804,13 +804,13 @@ main(int argc, char *argv[])
>          close(sfd);
>      }
>
> +    freeaddrinfo(result);           /* No longer needed */
> +
>      if (rp == NULL) {               /* No address succeeded */
>          fprintf(stderr, "Could not connect\en");
>          exit(EXIT_FAILURE);
>      }
>
> -    freeaddrinfo(result);           /* No longer needed */
> -
>      /* Send remaining command\-line arguments as separate
>         datagrams, and read responses from server */
>

When you say "memory leak", do you mean that something like valgrind
complains? I mean, strictly speaking, there is no memory leak that I
can see that is fixed by that patch, since the if-branches that the
freeaddrinfo() calls are shifted above terminates the process in each
case.

Thanks,

Michael


-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Linux/UNIX System Programming Training: http://man7.org/training/
