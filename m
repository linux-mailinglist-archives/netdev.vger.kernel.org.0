Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C1E724C289
	for <lists+netdev@lfdr.de>; Wed, 19 Jun 2019 22:46:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730182AbfFSUqs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Jun 2019 16:46:48 -0400
Received: from mail-pl1-f195.google.com ([209.85.214.195]:38405 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726244AbfFSUqr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Jun 2019 16:46:47 -0400
Received: by mail-pl1-f195.google.com with SMTP id g4so335633plb.5
        for <netdev@vger.kernel.org>; Wed, 19 Jun 2019 13:46:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=i1hoWgXM/3sJXE0yzoEO9MJswGh6V3NEiQS35pfe8xs=;
        b=DE7SwvGJQoDgdPZwnJjXq3/xBzZ49J16GbQvaq3+CHo3OOGAmoQxMsckz7arQjwRdZ
         wiy5it8XOYRDMaIHk6idFtABMqjrytaCLe209QHxK1RVnszyZi7t5OF9mAniHjiaVosK
         MQrSwl2pxkdIep5s5ZEzTstBCVBdsK8/Y6T6UPnLLp8r6AIcap5hUwQYcAURuSovAHf9
         avuU8OxdSGnoCZ86gtmaud6e2GjZm1ouMLwslCxcxcWnHPf/GOwg0wZe0mA48TcXdLPY
         X87SVTjIufSVYzM27oh0Hoxt3nHUpGoOCcl+AnYyiA+h3/5X7FMPGwrQGE2Pt92c7f3m
         fTcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=i1hoWgXM/3sJXE0yzoEO9MJswGh6V3NEiQS35pfe8xs=;
        b=J7hkRA/o8tVGU8jOomXPBMiqbMexEGFnxOhlE1pa7DxrjLdywdBSb9bZgXxr/tVOYn
         3+ic9VEyiAaV9Nn5tg6yRdkHuNSGeT6pdk9c52VWWTxyfzD1H5x2A5jQ59Y95Hio0Ydr
         N9iXuHhX4kBfM8S6ZreTqLOa8UEQ5fngEU42vOohVkrbQURZgG5EYyhyL3+biYCYue9x
         nB+py9d1hwfz0dytPYq4J/NNLLUKuLZ6CgEt2nai2EwUGrzuZiTLCdvKbDTpOiT0AQYY
         ezB2w/qcOFFIJsR6PuVhCUZOqTgT8xv4c82gK1SA0aCmfvYiXaAmeERrd1ujhet0zbj0
         VETg==
X-Gm-Message-State: APjAAAX1yg4rMZwyJIkqe1PrM/SM7fiLi74mTXIEe9Vi9U5nQ+HtqwtM
        o9NfFfZmdWGIU2KbEF7i4JUQ+SZLfOuV+VeNjoKWgg==
X-Google-Smtp-Source: APXvYqyHoOeUqsmfRiTdpCJaQhtM0n+ZHM7LvnKSRbOhC6JZDM1tV2GWvItN2O+RfkS2vCrqHX0e9cQ54R0YoJpWBnM=
X-Received: by 2002:a17:902:9f93:: with SMTP id g19mr105536923plq.223.1560977206524;
 Wed, 19 Jun 2019 13:46:46 -0700 (PDT)
MIME-Version: 1.0
References: <20190619084921.7e1310e0@bootlin.com> <20190619181715.253903-1-nhuck@google.com>
In-Reply-To: <20190619181715.253903-1-nhuck@google.com>
From:   Nick Desaulniers <ndesaulniers@google.com>
Date:   Wed, 19 Jun 2019 13:46:35 -0700
Message-ID: <CAKwvOdk7xOF8=xv5A7TQUWY29dH4agDWgMJVeO9emTMbH8CNQA@mail.gmail.com>
Subject: Re: [PATCH v2] net: mvpp2: debugfs: Add pmap to fs dump
To:     Nathan Huckleberry <nhuck@google.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        maxime.chevallier@bootlin.com, netdev@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        clang-built-linux <clang-built-linux@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 19, 2019 at 11:17 AM 'Nathan Huckleberry' via Clang Built
Linux <clang-built-linux@googlegroups.com> wrote:
>
> There was an unused variable 'mvpp2_dbgfs_prs_pmap_fops'
> Added a usage consistent with other fops to dump pmap
> to userspace.

> Changes from v1 -> v2
> * Fix typo
> * Change commit prefix to debugfs

Compile-
Tested-by: Nick Desaulniers <ndesaulniers@google.com>
Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>

Requires `make ... W=1` before the patch to observe the warning.

>  drivers/net/ethernet/marvell/mvpp2/mvpp2_debugfs.c | 3 +++
>  1 file changed, 3 insertions(+)
>
> diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_debugfs.c b/drivers/net/ethernet/marvell/mvpp2/mvpp2_debugfs.c
> index 0ee39ea47b6b..274fb07362cb 100644
> --- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_debugfs.c
> +++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_debugfs.c
> @@ -566,6 +566,9 @@ static int mvpp2_dbgfs_prs_entry_init(struct dentry *parent,
>         debugfs_create_file("hits", 0444, prs_entry_dir, entry,
>                             &mvpp2_dbgfs_prs_hits_fops);
>
> +       debugfs_create_file("pmap", 0444, prs_entry_dir, entry,
> +                            &mvpp2_dbgfs_prs_pmap_fops);
> +

Thanks,
~Nick Desaulniers
