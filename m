Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DFA25CF123
	for <lists+netdev@lfdr.de>; Tue,  8 Oct 2019 05:15:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729882AbfJHDPj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Oct 2019 23:15:39 -0400
Received: from mail-lj1-f194.google.com ([209.85.208.194]:40570 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729536AbfJHDPj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Oct 2019 23:15:39 -0400
Received: by mail-lj1-f194.google.com with SMTP id 7so15869931ljw.7;
        Mon, 07 Oct 2019 20:15:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=BivRDFAMa00Dwta7AtpjxEuKDkhZIuq1wk86qxnm16U=;
        b=ddRZYpmlc9NyB+GC8vS66mnw1aUxRo5N6UI5psYzKJAvT9eFobI46halvUm8j6R1QA
         MubHQ0VIlKzs0hfhvVVWdAAuy9vkx5/pCZC9OnFiwA4EiCl5Hsc4ky+RiMoX75oZVkQs
         GniEU8rdIOf3E/Sixd8or5Vc6H3iFFrHqd0cYhCYcQIsUSkhjMYzjsiMXHrd16DU6R+r
         /ezK5qCDV1K0+rh8hrdJUeHX+3I6D860YyZMSinZlS7yShUlHtbm7rF4feqvIh5kzC+X
         jiryYtiiPg1b90W0z9zgODEwvriuTBfOfW4yoJMNYRnxy+EwCUAA1AErPYmnJvXDpHy0
         VKRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=BivRDFAMa00Dwta7AtpjxEuKDkhZIuq1wk86qxnm16U=;
        b=ovEQvwSm5bWzApUvDy6ssz7Bvcu3jfoxoJMX/Sf4C6CxoJKB//2zBEJhDEnhkM7Dlq
         6fYWyw90dqeeTD2VQRR+7zPgeBzQYIBIlGiQOxUNsS6DEiEpu1QCgvStXIT7ltwLB3YV
         ajYJc0iqqGtcmZRl3+rNzEqwPeakpmrnqr5h0Zxazmw2RWePn+S6rzXqjUVDXK+1t5kK
         PVnY7jk5qE96OMLbhzQS6l6CwQ2PMxEA8akmGNpMsdLuggp9MTr157d6g/CEgL+Rcsd6
         maGZz3QgkWT3kyZRUvqZaz9hBSqMhiOXayDC90Xi4dRw5NkU/DLhScXSnkdTV1GyFwM4
         qGKw==
X-Gm-Message-State: APjAAAX2HC/oqh7S+NcuruTOfoiPmjN36KnRxF5UK74WULsGKYzbMd4r
        YOQps4723amUoaiyAL4LHcbev1MuQcLMM33PENI=
X-Google-Smtp-Source: APXvYqwBp6adm5weu+GWXNCkfHpW8Y+IoSyFLjf5cfbP/PaEIxxl/U+Jc+iea5XGqI8tCLuc2gpWdG+I9k9FQOgGoK8=
X-Received: by 2002:a2e:252:: with SMTP id 79mr20001435ljc.188.1570504536637;
 Mon, 07 Oct 2019 20:15:36 -0700 (PDT)
MIME-Version: 1.0
References: <20191007082636.14686-1-anton.ivanov@cambridgegreys.com>
In-Reply-To: <20191007082636.14686-1-anton.ivanov@cambridgegreys.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Mon, 7 Oct 2019 20:15:24 -0700
Message-ID: <CAADnVQJ0tJkgLV=t7zONfJ2jCe8BGnsUzn8zYEeVAL+4f_mCEg@mail.gmail.com>
Subject: Re: [PATCH] samples: Trivial - fix spelling mistake in usage
To:     Anton Ivanov <anton.ivanov@cambridgegreys.com>
Cc:     bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>, Yonghong Song <yhs@fb.com>,
        Network Development <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 7, 2019 at 1:51 AM Anton Ivanov
<anton.ivanov@cambridgegreys.com> wrote:
>
> Signed-off-by: Anton Ivanov <anton.ivanov@cambridgegreys.com>

Please add some text to commit log even for trivial patches.
I fixed it up this time and applied.
