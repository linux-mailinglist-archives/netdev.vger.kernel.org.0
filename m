Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7BBEC2595C
	for <lists+netdev@lfdr.de>; Tue, 21 May 2019 22:48:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727453AbfEUUqF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 May 2019 16:46:05 -0400
Received: from mail-qt1-f194.google.com ([209.85.160.194]:35179 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727341AbfEUUqE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 May 2019 16:46:04 -0400
Received: by mail-qt1-f194.google.com with SMTP id a39so22255367qtk.2
        for <netdev@vger.kernel.org>; Tue, 21 May 2019 13:46:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=rC2JACh+/sXFYvPs0HovLWPgyg+9I7Oj1wsQYpOKjFE=;
        b=IlVjp5FAkotmAarAoeKBm5VyT6Il6JLdZDMq3PgBpFBGb6RI2WdkanCxKAudI94d+V
         UB8SQy2GN+VbxFhpZA+xKZZR7aMhzh87tTVq2xYxyzs0CzmDURNhl67D6MqFHqVbp4qo
         4lKYQpLE6l7kL7iKy5k0gYCYfS7lg/Rh/aOP7QYthoy5cnQEVSpE/D9FHyE+tbRA6mRm
         xWtUZZmm+xRItnElzMpyPjVv6SmkWFvSSRM5Jqts3xjfRIe2RQt72nEGf++LzbEDEJVH
         fF6eLoKfG728TGOklokDI4/ABKvj/8H4zD0AjeT321vypQ9SQPS5zWb/AV8pLBMfbi0j
         RdZg==
X-Gm-Message-State: APjAAAUwm8QWeg6Z1JsThi97EQC1CBbxWC+TBwMYpPaHdFN1RqTYaq7D
        KZpZFyyhfDjXAYtgILnS9hsCPSlWZTY/C4h9fHmrOSkh
X-Google-Smtp-Source: APXvYqwNd8+rFAtedH5LBodQ10W9l4kH/LbTnnWQiBXXGTBLZ/TkUtTyFZ0S7fJEpvfUxKCzjm9PHKPAkKfNKiPvNuM=
X-Received: by 2002:ac8:2433:: with SMTP id c48mr56225862qtc.18.1558471563691;
 Tue, 21 May 2019 13:46:03 -0700 (PDT)
MIME-Version: 1.0
References: <1558467302-17072-1-git-send-email-subashab@codeaurora.org>
In-Reply-To: <1558467302-17072-1-git-send-email-subashab@codeaurora.org>
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Tue, 21 May 2019 22:45:46 +0200
Message-ID: <CAK8P3a0JpCnV59uWmrot7KeLPCOq_FqPb--xD_fMpaPd7x0zRg@mail.gmail.com>
Subject: Re: [PATCH RFC] net: qualcomm: rmnet: Move common struct definitions
 to include
To:     Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>
Cc:     Alex Elder <elder@linaro.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 21, 2019 at 9:35 PM Subash Abhinov Kasiviswanathan
<subashab@codeaurora.org> wrote:
>
> Create if_rmnet.h and move the rmnet MAP packet structs to this
> common include file. To account for portability, add little and
> big endian bitfield definitions similar to the ip & tcp headers.
>
> The definitions in the headers can now be re-used by the
> upcoming ipa driver series as well as qmi_wwan.
>
> Signed-off-by: Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>
> ---
> This patch is an alternate implementation of the series posted by Elder.
> This eliminates the changes needed in the rmnet packet parsing
> while maintaining portability.
> ---

I think I'd just duplicate the structure definitions then, to avoid having
the bitfield definitions in a common header and using them in the new
driver.

       Arnd
