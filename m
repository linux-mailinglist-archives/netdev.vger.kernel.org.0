Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 99C5340D870
	for <lists+netdev@lfdr.de>; Thu, 16 Sep 2021 13:22:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238036AbhIPLXH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Sep 2021 07:23:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237538AbhIPLXG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Sep 2021 07:23:06 -0400
Received: from mail-lf1-x132.google.com (mail-lf1-x132.google.com [IPv6:2a00:1450:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35D64C061574;
        Thu, 16 Sep 2021 04:21:46 -0700 (PDT)
Received: by mail-lf1-x132.google.com with SMTP id k4so17095717lfj.7;
        Thu, 16 Sep 2021 04:21:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=wDLR99OSOvM6KNDG/1C/l2KjuCZ0rHPNIZ2eSIT1O9s=;
        b=JlbJfqfV7CFnbvr6e2bh7h8ilYZnH/NDcO6pB1JnTDyXp47ju5Uvks0o+vuAG/P5AQ
         R5ByurJRPP9V0eahCWvEkhk9H4yI29JL25lNEWrDc+hbnR0pqaxYEOR+y5+FFeefTOCA
         E4YV+43/Ecxt6e3UUmHvXAjnHcBiJug4BPTrFCoM1PbxfDDJfAoNc5XwvwA2eC7dBHi7
         SnOb3ghN3Y3+UR0AczDfIO1QhEUnmfSbiLeEZdvNze7EztUNe94yS4H8/Z/6TUOOjv5w
         LNSOE47E1YFeQuRVlDG+2SY2OOTRX2c1Lze1AtsG4Cw030rfZ5dToVUziuYZGHTQefR6
         wt1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=wDLR99OSOvM6KNDG/1C/l2KjuCZ0rHPNIZ2eSIT1O9s=;
        b=vBKxk+gKaPCaO78vgcs6/8NxKrLNZk0LzAVIfz1+RdqrRmaYI5roa2VMpk7Rel0U2d
         FPBSMJtLHUTsdagjOfoHU7nrtE+0M/gGTn1Hb39prrFOlzZ2cVnxJYho3W/LPHqFrf02
         hnGDBehgfXOJV1u40f8OhK9JLC0iWbvX3zJ/EUy6S6gkoMhMUAiaAkPj2vUCA+0dP7Pr
         d1MZtxovOp0cOZiQobeXYCsR0wF3Nxd3PHHNU4hcw4Yay2RwJvjGAkmelsC2cYQ8bgdm
         S5i/dFJE81240VJBxuDgS+y1E+BmV+35K6o2V2EimxBWTY1owH+BVvIkYsNqvg2dcugz
         KuFw==
X-Gm-Message-State: AOAM533t64F8/fQJT8p1JazGVKWCKEt4mF3XnCz9Jfek0idIRvBsTD0P
        xmyk0Ux3LI3OTgmXNt0I5OkLQ8YXD0iP7o+1RIk=
X-Google-Smtp-Source: ABdhPJyFx6upj60lPvi4jHawht0NQ+ZagUGFLSGRPDKJ7pQQYo3Mx7byy+gn2vsbOPl2hf+tIMLWEa01WGak4AdD7LU=
X-Received: by 2002:a05:6512:450:: with SMTP id y16mr3603749lfk.200.1631791304159;
 Thu, 16 Sep 2021 04:21:44 -0700 (PDT)
MIME-Version: 1.0
References: <20210916105122.12523-1-wangxiang@cdjrlc.com>
In-Reply-To: <20210916105122.12523-1-wangxiang@cdjrlc.com>
From:   Bongsu Jeon <bongsu.jeon2@gmail.com>
Date:   Thu, 16 Sep 2021 20:21:32 +0900
Message-ID: <CACwDmQA+wzo06R1kEB-rcz=Td+egF+Kd8+mh46NHnXHK1sOh7w@mail.gmail.com>
Subject: Re: [PATCH] selftests: nci: fix grammatical errors
To:     Xiang wangx <wangxiang@cdjrlc.com>
Cc:     shuah@kernel.org, Bongsu Jeon <bongsu.jeon@samsung.com>,
        netdev@vger.kernel.org, linux-kselftest@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Actually I asked to fix grammatical errors in the subject.
  For example => selftests: nci: replace unsigned int with int

 And please change the log in more detail and  put a period at the end
of the log.
 For example => Should not use comparison of unsigned expressions < 0.

In addition to that, please send patch version 2 with changelog.
 For example=> [PATCH v2 net] ~~~~.


On Thu, Sep 16, 2021 at 7:53 PM Xiang wangx <wangxiang@cdjrlc.com> wrote:
>
> Should not use unsigned expression compared with zero
>
> Signed-off-by: Xiang wangx <wangxiang@cdjrlc.com>
> ---
>  tools/testing/selftests/nci/nci_dev.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/tools/testing/selftests/nci/nci_dev.c b/tools/testing/selftests/nci/nci_dev.c
> index e1bf55dabdf6..162c41e9bcae 100644
> --- a/tools/testing/selftests/nci/nci_dev.c
> +++ b/tools/testing/selftests/nci/nci_dev.c
> @@ -746,7 +746,7 @@ int read_write_nci_cmd(int nfc_sock, int virtual_fd, const __u8 *cmd, __u32 cmd_
>                        const __u8 *rsp, __u32 rsp_len)
>  {
>         char buf[256];
> -       unsigned int len;
> +       int len;
>
>         send(nfc_sock, &cmd[3], cmd_len - 3, 0);
>         len = read(virtual_fd, buf, cmd_len);
> --
> 2.20.1
>
