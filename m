Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3FE80324DD6
	for <lists+netdev@lfdr.de>; Thu, 25 Feb 2021 11:21:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233117AbhBYKPP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Feb 2021 05:15:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234871AbhBYKMr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Feb 2021 05:12:47 -0500
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6ADABC061788;
        Thu, 25 Feb 2021 02:12:07 -0800 (PST)
Received: by mail-ej1-x62a.google.com with SMTP id k13so7880721ejs.10;
        Thu, 25 Feb 2021 02:12:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=/RUb5WY27Oz2vzRcOsNokpjBKH5ToeFvji20EJddXt8=;
        b=HrVGaTWwtvm4kYU+nFUKoHA2vGZD3GpxgO0KHLRR9quykd3c8ZaC0n5mWK/zS+vXpy
         QtSAZPK0T72Gq4dNVcgCrudhamLhiniP6d/YJZKTCu2G5j2lHMKmvpFGbW9CZAroEo3+
         6R/Qmt27MgqM1eKbgNlvnOz0YXJ5FKZ0CUsMJxt3ekJFNPS3u5r1U02cuAnhUKDM3SrT
         Po/cy7UhuA40Dm1SD0qoU41ieUcjPFBpwHG7tolpXWC4rMSI5yDoFvgcc9feoW9FT6PJ
         DwW7TYtlmeqPhmfzNE8mjsjxV3E83LFygje5ArNDZBx0tSDaPfsW+5n85+T033L1IFiO
         tRpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/RUb5WY27Oz2vzRcOsNokpjBKH5ToeFvji20EJddXt8=;
        b=ta9P0gGULInPanU2NnQBSdTbqccM9Id4/83IZtGabP/uGL6c0sePFMizDVIbxyGrDH
         RjN1rbxRzH+8FKBOl3zQZdTg71h4O5FjbDYvsaYEZ0OamtMBw8bAAhdmhjge6r6mESgO
         rfkSsL7gqjQBZEnCYSh7lf2++MFIPWErnUWVtMkd9sg+P29QTj6/0n33Gbk0zNTvpCKO
         cOafdhW0qLbNTcGhTMP7SgHznqdL8wQ7yDS/5IknwI9tvRpaa6wmWEkv9k3arU8iFocs
         bTEUk6u9yzgRxsA5hTu7So2Vnij6ZPuVgeDLEUA/iajUMcUy1CodKA5CW4EX3gNg98Ew
         5gdw==
X-Gm-Message-State: AOAM533FtZ8E7J/LqIymPKGKRdJXxbr0rVwaV3NtKeKw05bnmPR0MVqL
        sM7XiMOUUIX0HkJTnw8e7krHNEFbjpOZyM7mmwu2xI6lTIc=
X-Google-Smtp-Source: ABdhPJzBL9430otKC5elC9WkKe50wlxD8dqzv+bEvgKMOBOKS/CYLXGpJ/4v6O7qgGTmKsHX59ltKnw+UJ/e+8zmWVY=
X-Received: by 2002:a17:906:b210:: with SMTP id p16mr2034515ejz.256.1614247926177;
 Thu, 25 Feb 2021 02:12:06 -0800 (PST)
MIME-Version: 1.0
References: <20210222070701.16416-1-coxu@redhat.com> <20210222070701.16416-5-coxu@redhat.com>
In-Reply-To: <20210222070701.16416-5-coxu@redhat.com>
From:   Bhupesh SHARMA <bhupesh.linux@gmail.com>
Date:   Thu, 25 Feb 2021 15:41:55 +0530
Message-ID: <CAFTCetS=G_JV4Ax6=Ty20uifoL1jscrqPGhdh7d2k+t=0d+L8g@mail.gmail.com>
Subject: Re: [RFC PATCH 4/4] i40e: don't open i40iw client for kdump
To:     Coiby Xu <coxu@redhat.com>
Cc:     netdev@vger.kernel.org, kexec@lists.infradead.org,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        open list <linux-kernel@vger.kernel.org>,
        intel-wired-lan@lists.osuosl.org, Jakub Kicinski <kuba@kernel.org>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        "David S. Miller" <davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Coiby,

On Mon, Feb 22, 2021 at 12:40 PM Coiby Xu <coxu@redhat.com> wrote:
>
> i40iw consumes huge amounts of memory. For example, on a x86_64 machine,
> i40iw consumed 1.5GB for Intel Corporation Ethernet Connection X722 for
> for 1GbE while "craskernel=auto" only reserved 160M. With the module
> parameter "resource_profile=2", we can reduce the memory usage of i40iw
> to ~300M which is still too much for kdump.
>
> Disabling the client registration would spare us the client interface
> operation open , i.e., i40iw_open for iwarp/uda device. Thus memory is
> saved for kdump.
>
> Signed-off-by: Coiby Xu <coxu@redhat.com>
> ---
>  drivers/net/ethernet/intel/i40e/i40e_client.c | 7 +++++++
>  1 file changed, 7 insertions(+)
>
> diff --git a/drivers/net/ethernet/intel/i40e/i40e_client.c b/drivers/net/ethernet/intel/i40e/i40e_client.c
> index a2dba32383f6..aafc2587f389 100644
> --- a/drivers/net/ethernet/intel/i40e/i40e_client.c
> +++ b/drivers/net/ethernet/intel/i40e/i40e_client.c
> @@ -4,6 +4,7 @@
>  #include <linux/list.h>
>  #include <linux/errno.h>
>  #include <linux/net/intel/i40e_client.h>
> +#include <linux/crash_dump.h>
>
>  #include "i40e.h"
>  #include "i40e_prototype.h"
> @@ -741,6 +742,12 @@ int i40e_register_client(struct i40e_client *client)
>  {
>         int ret = 0;
>
> +       /* Don't open i40iw client for kdump because i40iw will consume huge
> +        * amounts of memory.
> +        */
> +       if (is_kdump_kernel())
> +               return ret;
> +

Since crashkernel size can be manually set on the command line by a
user, and some users might be fine with a ~300M memory usage by i40iw
client [with resource_profile=2"], in my view, disabling the client
for all kdump cases seems too restrictive.

We can probably check the crash kernel size allocated (
$ cat /sys/kernel/kexec_crash_size) and then make a decision
accordingly, so for example something like:

 +       if (is_kdump_kernel() && kexec_crash_size < 512M)
 +               return ret;

What do you think?

Regards,
Bhupesh

>         if (!client) {
>                 ret = -EIO;
>                 goto out;
> --
> 2.30.1
>
>
> _______________________________________________
> kexec mailing list
> kexec@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/kexec
