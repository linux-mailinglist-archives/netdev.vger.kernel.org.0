Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F2F9A5A0006
	for <lists+netdev@lfdr.de>; Wed, 24 Aug 2022 19:05:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239825AbiHXRFL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Aug 2022 13:05:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239816AbiHXRFG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Aug 2022 13:05:06 -0400
Received: from mail-il1-x142.google.com (mail-il1-x142.google.com [IPv6:2607:f8b0:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F3A63DBD4;
        Wed, 24 Aug 2022 10:05:04 -0700 (PDT)
Received: by mail-il1-x142.google.com with SMTP id h8so5204785ili.11;
        Wed, 24 Aug 2022 10:05:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=cFekw/Y+IQbIDxTfIDehvXw11BmvPAaH0UtQ+bMDK5o=;
        b=n20p82n9cCCwOP4wLqQqlUignSFIAP2ipAFg88S/YrFpMb0oNTPBWVzte4mdu27ZzX
         l3qBg/eFvK7ulrLKLXNuDTkFNHnFXBvMUyQyhDr+K6kpr3hio0WKyp1rlIqdjUq6ehdA
         2/9fAUzgE9Uy6nAJ7I5vERrfub5G2BWI957e8sI2r8vxMaiUPZ/AKUM+hep5u7Nd2Egv
         rSvmfG1XNXlPDsFZ0VCQ/1PCuDoyZiy4lOEBEWs9IHARGDy6uRQqph76gmBW95BExMQ3
         3f3s7gHKvBo8Ku3QhIHV/hGpWC6/h1ZAnFcJx5tdBDjKwkma28X2Emy/cIqNl74LCWKi
         2UtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=cFekw/Y+IQbIDxTfIDehvXw11BmvPAaH0UtQ+bMDK5o=;
        b=vLlWl92lOrJF8/F+vlxVBGayt74afUsSAKSGCHGE+O8chWNeQviFPU7X465kVPoEFn
         4gDxTbPhtv3j+IWhoOFIth7pb0LGG/BH821rAporb25KhNfAGIa7Z1MJP3qOq3Y/Khvt
         W2SiYVLbZYfRk0Tfjrzo0EoLqfVNtjhX8bUJ9eR/P7mZXzjWoly2L4IfNmZXxsbvwLpX
         3yYnfhDO0bEDwTc0xwXLgv4Vfz/jihXA9h742ArKu/naoExHtVxMZEnB6mswZtyAr11n
         GBtLlWO6N6b1hu6E736cTAqraTQ5zjPrsMtHFR5MUjgm5YDkhhthUIQciCh+mwVKK5ir
         xRJw==
X-Gm-Message-State: ACgBeo1u4arum67Z9r6GzFygU1TqXIP5SustxXoCm76UrzJxj1qb8wo7
        OarvV/zy3QZotGWA8fIKtVxOjcroVulw5JCEzu2vEMCv
X-Google-Smtp-Source: AA6agR58+ewhL0I0wvERCM92p4ZRdWpiUH5HMg1PnmRSKp2ADqK61WeVh0dBKABae4U8hippyDFkiyQyM2ql/9j7SmQ=
X-Received: by 2002:a92:ca4e:0:b0:2ea:3f77:a85 with SMTP id
 q14-20020a92ca4e000000b002ea3f770a85mr1622649ilo.219.1661360703886; Wed, 24
 Aug 2022 10:05:03 -0700 (PDT)
MIME-Version: 1.0
References: <20220824150051.54eb7748@canb.auug.org.au>
In-Reply-To: <20220824150051.54eb7748@canb.auug.org.au>
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
Date:   Wed, 24 Aug 2022 19:04:26 +0200
Message-ID: <CAP01T74GyRjXRZaDA-E5CXeaoKaf+FegQFxNP9k6kt8cvbt+EA@mail.gmail.com>
Subject: Re: linux-next: Fixes tag needs some work in the bpf-next tree
To:     Stephen Rothwell <sfr@canb.auug.org.au>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 24 Aug 2022 at 07:00, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
>
> Hi all,
>
> In commit
>
>   2e5e0e8ede02 ("bpf: Fix reference state management for synchronous callbacks")
>
> Fixes tag
>
>   Fixes: 69c87ba6225 ("bpf: Add bpf_for_each_map_elem() helper")
>
> has these problem(s):
>
>   - Target SHA1 does not exist
>
> Maybe you meant
>
> Fixes: 69c087ba6225 ("bpf: Add bpf_for_each_map_elem() helper")
>

Ugh, really sorry, I must have fat fingered and pressed 'x' in vim
while editing the commit message. I always generate these using a git
fixes alias.

> --
> Cheers,
> Stephen Rothwell
