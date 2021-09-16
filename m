Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4002340D97B
	for <lists+netdev@lfdr.de>; Thu, 16 Sep 2021 14:08:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239151AbhIPMJ0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Sep 2021 08:09:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239086AbhIPMJZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Sep 2021 08:09:25 -0400
Received: from mail-lf1-x12e.google.com (mail-lf1-x12e.google.com [IPv6:2a00:1450:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1744C061574;
        Thu, 16 Sep 2021 05:08:04 -0700 (PDT)
Received: by mail-lf1-x12e.google.com with SMTP id b18so16356032lfb.1;
        Thu, 16 Sep 2021 05:08:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=gx8WrC9z8YFXZyGyok96l3Xw1N/IRmVwR+qMVh5xouk=;
        b=FQDWahQIHHuYSdvwp4TKH+JtAF1A/8UKyPcxRirlEcUChUwKA0XTiaGKPp+KrnplQP
         Las8ouxa/5+QsVVc3a+DNhQOUVqdsItyldRl5cuWMHkCPBs50WSXXIeMAm7i9jxZNb1o
         nD28qS7H+RGBmKPL64kNioSzm8Z7FtF6YGeZx8ybyIDe7qC6hFgMWAoRXxNJp8By1W3G
         shReY+JVw3jWJYDEemyWtGG4vUi+cT4PpSp81KXzA+P5JultXmwJ5HKfnl3kfvbpmK1z
         CVGeTPNpkuuAxdrzz2iezm0h4dmtCwFL8s+kSEAqEzTJOdJR2CbAFASTm8NIXrtp/VkO
         R0Wg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=gx8WrC9z8YFXZyGyok96l3Xw1N/IRmVwR+qMVh5xouk=;
        b=jeEL8umu04lNhw3wgwQQzUGKvIvdkReB17vFNc+lHKgPGIWyUjKlRrzlbnGunVVog2
         L+1Z9ClVv49inUs8qAkl+9fjeGWwcqSMRQA2Ty3M2zshGmSVx2nVDAOn8tXaf6J+Nrhu
         WaFFAcinV3inT4SB2kFdHb2VXNdYOkqkup2BU26sbhU3n5ZdFFQLp0wtlb5WNj6DoW8J
         JqZsXWGqy9EBMg02RJd1tgYveimbWMZf4gNbBHrDnT0ibYUwF8IrGSn/r9YEHO78smnO
         ndFbOv/ljyRaBailoU4wD9M53yEcdwkhimgxTml2ZCk8B0Ce/m1nK8PZMuGzeNYBCbH5
         lb9A==
X-Gm-Message-State: AOAM531AZM25Vi3iIjTMZSQbf86icYL0+60tyIhzS9nns0H9hFidflMu
        KvHtCgsqpi+dSzPNG4A4FH6K90jdJywjFSUW5dkPmLznRDS5iA==
X-Google-Smtp-Source: ABdhPJypP/0/O+j/C7G6slq8HMTxvXhDGqkFek2o141s436UyANTaO0dyXLgHJk8fM60LJ7J0wCbDcMOu0LrNusEavs=
X-Received: by 2002:a19:500e:: with SMTP id e14mr3785791lfb.673.1631794078566;
 Thu, 16 Sep 2021 05:07:58 -0700 (PDT)
MIME-Version: 1.0
References: <20210916115212.24246-1-wangxiang@cdjrlc.com>
In-Reply-To: <20210916115212.24246-1-wangxiang@cdjrlc.com>
From:   Bongsu Jeon <bongsu.jeon2@gmail.com>
Date:   Thu, 16 Sep 2021 21:07:47 +0900
Message-ID: <CACwDmQCbmSo1viWUqUciXUx0jbznPiSj4na+XE2QaD+_B39GWQ@mail.gmail.com>
Subject: Re: [PATCH v2] selftests: nci: replace unsigned int with int
To:     Xiang wangx <wangxiang@cdjrlc.com>
Cc:     Bongsu Jeon <bongsu.jeon@samsung.com>, shuah@kernel.org,
        netdev@vger.kernel.org, linux-kselftest@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I asked you two things.
Please check them below.

On Thu, Sep 16, 2021 at 8:54 PM Xiang wangx <wangxiang@cdjrlc.com> wrote:
>
> Should not use comparison of unsigned expressions < 0

Please put '.' at the end of the log and add the changelog.
For example
=> Should not use comparison of unsigned expressions < 0.

>
> Signed-off-by: Xiang wangx <wangxiang@cdjrlc.com>
> ---

Please add the change log here.
For example =>
Changes since v1
* Change commit log

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
