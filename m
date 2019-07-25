Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 29F5F75012
	for <lists+netdev@lfdr.de>; Thu, 25 Jul 2019 15:49:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390704AbfGYNtP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Jul 2019 09:49:15 -0400
Received: from mail-yb1-f195.google.com ([209.85.219.195]:38985 "EHLO
        mail-yb1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389122AbfGYNtP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Jul 2019 09:49:15 -0400
Received: by mail-yb1-f195.google.com with SMTP id z128so15098261yba.6
        for <netdev@vger.kernel.org>; Thu, 25 Jul 2019 06:49:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=+94dksNMcufTeD/gyuUattLxpQAoVrZBBEnx6NzwFI8=;
        b=igwlp1jjMjzAEk8NRn0H5RDYphkcWR6yJ2kmjtXjspl/BBg41z7oa2nDhRSfy9sosJ
         TpW/84vSFYnbJbxDU5/bVkAoqDFU2nES1vtt1Wm8iH4WEzQuFgawY6ddeO7JZEI5P3j0
         1EV4KfGrwCfJjlke104b3pme0tBDfKJgovzggLxwjSN1mk3CPDWpgUKlNycor5Juxii7
         b7LZ3RVbvvdV5pg80c0Ia75qccs+K/9YEoPwVTQO0tpstlttM6wo4dCZLxJsubbsiztv
         o3jc1JRLjkl+Y+x4zBBuEXGcKReNCQQUaFUYk659QHdnLHv3n3eUfOQeK82Yw7VBK3E/
         OYkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=+94dksNMcufTeD/gyuUattLxpQAoVrZBBEnx6NzwFI8=;
        b=MylT3GUtOOYKq+9NpsD6du83JFcf/90mxXGltURJbPnsRQPbTv1yIRnWwRspZ+B2D2
         ZwoU0rNEASR3mi6ETrFu3f1OJEytbAGNfSbNbOO5ZA4zVfgbKeGqMWs3bcK9CUW7inK9
         N8QxnbiRIcYpwpGZcwnb6pjxMF9R3AleTH15bwfIk6lnalVVbyYKctINMwIajp1dKwTU
         nTyGbMweZUG7MlDdTpSnv8SP1cc6aQfpdFFa6lB0RH8MSbhrBuxsMo8XGkUA/CebczN4
         GEsgNNxHykhS2QPIj2xk7sP9tfVlk3wvhcaT0DNsKatGBaTmDgR+ypxYfNUUtm7c/f/H
         diAg==
X-Gm-Message-State: APjAAAXAResd05/4pZEBWxKw5QHW873Ea3tj8aSxG9pojetquCHeQB+y
        dd5feYxy4XvY2/XG+QpnKaZm2o/y
X-Google-Smtp-Source: APXvYqzC74QUa5xitT6fJj2JXW1dVkFVIvBAorpE0qGc5zgOffv9r0SN3GBm9czO9IYe6zHK54v+0g==
X-Received: by 2002:a25:6756:: with SMTP id b83mr53847436ybc.37.1564062553956;
        Thu, 25 Jul 2019 06:49:13 -0700 (PDT)
Received: from mail-yb1-f179.google.com (mail-yb1-f179.google.com. [209.85.219.179])
        by smtp.gmail.com with ESMTPSA id 1sm11555888ywm.50.2019.07.25.06.49.13
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Thu, 25 Jul 2019 06:49:13 -0700 (PDT)
Received: by mail-yb1-f179.google.com with SMTP id d9so12088306ybf.3
        for <netdev@vger.kernel.org>; Thu, 25 Jul 2019 06:49:13 -0700 (PDT)
X-Received: by 2002:a25:2516:: with SMTP id l22mr21764852ybl.441.1564062552540;
 Thu, 25 Jul 2019 06:49:12 -0700 (PDT)
MIME-Version: 1.0
References: <1564024076-13764-1-git-send-email-yanhaishuang@cmss.chinamobile.com>
 <1564024076-13764-2-git-send-email-yanhaishuang@cmss.chinamobile.com>
In-Reply-To: <1564024076-13764-2-git-send-email-yanhaishuang@cmss.chinamobile.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Thu, 25 Jul 2019 09:48:32 -0400
X-Gmail-Original-Message-ID: <CA+FuTSfqMRtbJFPiAGyPKpoKjxcVQp_YYXD5Xtj0bHmSQBMpkQ@mail.gmail.com>
Message-ID: <CA+FuTSfqMRtbJFPiAGyPKpoKjxcVQp_YYXD5Xtj0bHmSQBMpkQ@mail.gmail.com>
Subject: Re: [PATCH] ipip: validate header length in ipip_tunnel_xmit
To:     Haishuang Yan <yanhaishuang@cmss.chinamobile.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Network Development <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 24, 2019 at 11:09 PM Haishuang Yan
<yanhaishuang@cmss.chinamobile.com> wrote:
>
> We need the same checks introduced by commit cb9f1b783850
> ("ip: validate header length on virtual device xmit") for
> ipip tunnel.

Fixes: cb9f1b783850b ("ip: validate header length on virtual device xmit")

> Signed-off-by: Haishuang Yan <yanhaishuang@cmss.chinamobile.com>

Good catch. reg_vif_xmit in net/ipv4/ipmr.c probably also needs it.
All other ndo_start_xmit under net/ipv4 and net/ipv6 have this check
as of the above commit.
