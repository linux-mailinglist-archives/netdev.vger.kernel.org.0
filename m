Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5E40A126FDB
	for <lists+netdev@lfdr.de>; Thu, 19 Dec 2019 22:43:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727071AbfLSVnh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Dec 2019 16:43:37 -0500
Received: from mail-lf1-f68.google.com ([209.85.167.68]:44840 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726873AbfLSVnh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Dec 2019 16:43:37 -0500
Received: by mail-lf1-f68.google.com with SMTP id v201so5386912lfa.11;
        Thu, 19 Dec 2019 13:43:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=B2x1kO+jp983OlkibryiHtgzpdg4AuYFoNIdiRMNKMk=;
        b=dFuom9HGgaiG8JGCQdm7TJNGyi9n9QkOcs/dL0q/ip7/3iQX4JFa5Z3OIClG2TV/oo
         M2nidKwNK3pGqvgUn5fwf7Khq5IIe7FhZEWYdQlWBa2+njS8yd5LnjIbc0HTZdTuP6QA
         hKmo5cL+3deCZurdcRcuYhXGs2aIEPcpxqGDBLUU0bOo3XzTOv6daYYQV8eUOKRrw0l6
         VhmJy32yqg0lZ1cTfhRSPPEuKXxp9CVqVT2Smgahn9c7j4RAgXsCNKWK9DBdZBxtOP2W
         uoNY3MLk6/9uS8XXia9VysVfNfAgGJQxGhIVQ0yqqLVqtmrfVh/1Nr2jyXA6mqKIUwpd
         QVCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=B2x1kO+jp983OlkibryiHtgzpdg4AuYFoNIdiRMNKMk=;
        b=JKZkBMAvtXgnntKOR4yfyPaYkdOFMVf7zYX4MCwMNrCFZ9XqXM1Lb7AKh7xHu4WSKX
         00VzeBqnPdL5ohwdVW0cWE3D6QVkhdq4yGpjLc0Q5WkrYkAZDhn4BLrGtHEeQ1Pbecrx
         oSD2WVSTNCECv4DNcncamzDq4XjPXsIj4dW/KbqLBvOm4pbMk1opM/WUqplQeq6cXqf2
         2U4jO9mNBZk4GGvZMaTwTeOlpjzC3qiwHybwU1bfDqRWiVsRV4nsFujSkyING1Rcki7r
         FtwSEHJH/m5ehW0FZ32VxWWIrg488PSGw8oqy7aXbXAnX+x90x1a3peodWN7sjCP/Icc
         7Jng==
X-Gm-Message-State: APjAAAWaMJoO/kESkOmKdbiQlbV+v1wCdBq5Gy99iVQmdaeQEzf+7CZG
        Dr3yD3YRUbHOopRXDyyyTDRjqmdohfxNsQFlsdKOnQ==
X-Google-Smtp-Source: APXvYqxAd0RJ48HiUp5oJpRB/xO2eadeDbXZtz5NjBTEbhe+o+4RjjhJgMyH6WEOSc2O3bYbs6IsJqJNT0psfjkfk2M=
X-Received: by 2002:ac2:47ec:: with SMTP id b12mr6536580lfp.162.1576791815288;
 Thu, 19 Dec 2019 13:43:35 -0800 (PST)
MIME-Version: 1.0
References: <cover.1576789878.git.daniel@iogearbox.net>
In-Reply-To: <cover.1576789878.git.daniel@iogearbox.net>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Thu, 19 Dec 2019 13:43:23 -0800
Message-ID: <CAADnVQKmaepHe_zek_nGaAwL0KYzQ2ww-1Db14rbLUb_2BMbwA@mail.gmail.com>
Subject: Re: [PATCH bpf 0/2] Fix record_func_key to perform backtracking on r3
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 19, 2019 at 1:20 PM Daniel Borkmann <daniel@iogearbox.net> wrote:
>
> Fixes pruning behavior when record_func_key() is used. See main
> description in patch 1, test cases added in patch 2.

Applied. Thanks
