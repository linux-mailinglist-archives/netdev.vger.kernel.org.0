Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1868F40D3AB
	for <lists+netdev@lfdr.de>; Thu, 16 Sep 2021 09:18:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234642AbhIPHT0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Sep 2021 03:19:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232254AbhIPHTV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Sep 2021 03:19:21 -0400
Received: from mail-lf1-x136.google.com (mail-lf1-x136.google.com [IPv6:2a00:1450:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A776C061574
        for <netdev@vger.kernel.org>; Thu, 16 Sep 2021 00:18:00 -0700 (PDT)
Received: by mail-lf1-x136.google.com with SMTP id y28so14776094lfb.0
        for <netdev@vger.kernel.org>; Thu, 16 Sep 2021 00:18:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=D4ivxItkQdSMohX3qJ/w2JOj8Hig6YwbQ23bBenFjKY=;
        b=NIp56w1+tnsB3DvXXqqIN3areORYZisEeC6cPVMN29l/9XVGU+uKhtWYrIfcqO82sQ
         bKzvD20Hz6UWX7XLtrQlWd46JyeqCdXTFTikqY24hU7uZWH5Al3Mxz3r2fxQ5jrb0tt/
         rlC9enoF/VLbNPZjLnxfkP6OhZnBhRlL1NotE2daHZikjoHr8tQkjLyN7mPIJMTgOkxJ
         VH4kJwVnBx/yS7XK61aeiWPXn8Oo6lYo2r8xeZxgbV8LKqhdtjs5GJB+GF1PixdLJza3
         rcqQie1/JQYHqAbeYRIPDNJd2F/B3vAgWhvjGtoyl342/C0XBdgga/pruH6nuw3fslz8
         aJuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=D4ivxItkQdSMohX3qJ/w2JOj8Hig6YwbQ23bBenFjKY=;
        b=cyhepGfpLxisHcjmcxjgqGuMptKAlJq8RfynCBgVa0H3Wg9H6Wg98d+zp54sX2DrFT
         FqF69ftm1mAvXe3I3h8sfmjE+uXTjyxzm3LC8Lc9oTM3mh3hHwtS1dS3nncoFVYAWtEO
         lbJQ7u5QMHgVKnrmM2AG3dPZPlJHXH9RaZ9zT40+FdiZGm9Vg0T/oStMtv3QMklpFn+S
         Turq9TUdyZ7Yo/Vc+TjiSEFdaaRtIPQWuwTDcTymj5x32eTRlafZOlrgAg9K7nLXSA4u
         /x4mRqbxxELkkbzQnLiqxsmPBwne4DAD0X/agWnxFputBnBQKHEWAdB0YJIF2+8pM6xe
         Rtag==
X-Gm-Message-State: AOAM531bBheoOAXOM/MS/RCvaHSIcBByCxnBQXJPDstz98Pv9Ob55Y6l
        oCPLEytOYbeyvAzixNSdJZXkqfCljC9tMcXShvnK3mPV6ig=
X-Google-Smtp-Source: ABdhPJzzGKKtUdu0GD7g+0tvRt2LpeHVLEJtio0zvqGoeX91+898nx3jfXTANBzU16f7JV4LswBiPz6epEXTATQ/D5g=
X-Received: by 2002:a05:6512:450:: with SMTP id y16mr2958760lfk.200.1631776678762;
 Thu, 16 Sep 2021 00:17:58 -0700 (PDT)
MIME-Version: 1.0
References: <20210916055045.60032-1-wangxiang@cdjrlc.com>
In-Reply-To: <20210916055045.60032-1-wangxiang@cdjrlc.com>
From:   Bongsu Jeon <bongsu.jeon2@gmail.com>
Date:   Thu, 16 Sep 2021 16:17:44 +0900
Message-ID: <CACwDmQCyswon-WkVKtG7AUg2uwa0DD_xdvd=VrtK3OtJ_6i09w@mail.gmail.com>
Subject: Re: [PATCH] selftests: nci: use int replace unsigned int
To:     Xiang wangx <wangxiang@cdjrlc.com>
Cc:     netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 16, 2021 at 2:55 PM Xiang wangx <wangxiang@cdjrlc.com> wrote:
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

Thanks for fixing it.

Reviewed-by: Bongsu Jeon

Best regards,
Bongsu
