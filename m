Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B81B1431F52
	for <lists+netdev@lfdr.de>; Mon, 18 Oct 2021 16:17:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232527AbhJROTu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Oct 2021 10:19:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232367AbhJROTr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Oct 2021 10:19:47 -0400
Received: from mail-il1-x130.google.com (mail-il1-x130.google.com [IPv6:2607:f8b0:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27FFDC0796F6;
        Mon, 18 Oct 2021 07:09:40 -0700 (PDT)
Received: by mail-il1-x130.google.com with SMTP id k3so15037824ilu.2;
        Mon, 18 Oct 2021 07:09:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=IMHKUU/aPTZ1B41jOo+lOELIQKcF+Y1//c1q8Tb8uNY=;
        b=qx2jRO04XPqGFon6Eo0uUqTrYWFCoxnDl3/AfstUIYnZz43zWdhg1EScAy7+zL+Ix7
         6VNXSN9ARE1moMS7Ok3sUen/ZbzPb7zlI2x4BH2SzXTIwCJKQmRF20bHOHc7GMLQpN2L
         FlMjjJ8TkICj+OInDV3Kc/G4T27O67B4BXjvXEj2CBxCnOHZMsOsM12CADWTIkYYtXgD
         cBUQf241KJmHTMhbfBBdka02SGXKlfG0Ad2sHpwNEpgZnkCc22ZFN6W4yJAgXhwAGnE1
         tKQzIL3lZWSQ7JzmFvZy4OrJoJpQacmmNm18PoWlDedLBojEFvpE0egp/oFst7gckM3z
         iR1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=IMHKUU/aPTZ1B41jOo+lOELIQKcF+Y1//c1q8Tb8uNY=;
        b=5UJIJJDA7NhSYeJSVdj354FGpr9Mf5jfp5b7db5CkcvAUpNFyLqJ+YyDbpGUsVBi5U
         67phzYYDJWdRrKvw+0yFMFJGINLoT7nxY0PI79TgSzlAYFkaZ43bew4A/HuZ7ij4GqjM
         WwIzVnT12fI7h5SwSiMn4JlmBoe5k+Q9Z25ctqQqOQ5DgRkzbo2mLrb2zJk7GnOzL77f
         Z3ej7H+58DItQzpXtna+USLV66p3vM0FnvHxkFQeGpk3PaEeT5eSN0wxy8zKPltW6E/b
         ikHBDsZK1mK/rpVm7aNCD8QbKsMrQt+YnWwVr+VT1nksajolSdz2Okl7+X9RYvjWF4LQ
         lGtA==
X-Gm-Message-State: AOAM532vmgwaif/iQBf8HO/+DuPKN74p5dQ6dDlplY/ccd/dGp+Aw63o
        QJlqClcSCOhqFoCOlA/hk+Q=
X-Google-Smtp-Source: ABdhPJxnws0Rniub6BPpOmZqIKbdjjklyZQI7NMNwfzaOBwzjGBkXKWe6/ewxnVgW1EW925Z8ZNfrQ==
X-Received: by 2002:a92:d0d1:: with SMTP id y17mr13871500ila.40.1634566179610;
        Mon, 18 Oct 2021 07:09:39 -0700 (PDT)
Received: from localhost ([172.243.157.240])
        by smtp.gmail.com with ESMTPSA id m10sm7228813ila.13.2021.10.18.07.09.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Oct 2021 07:09:38 -0700 (PDT)
Date:   Mon, 18 Oct 2021 07:09:31 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Quentin Monnet <quentin@isovalent.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        Quentin Monnet <quentin@isovalent.com>
Message-ID: <616d801bb48bc_1eb1208d8@john-XPS-13-9370.notmuch>
In-Reply-To: <20211010002400.9339-1-quentin@isovalent.com>
References: <20211010002400.9339-1-quentin@isovalent.com>
Subject: RE: [PATCH bpf-next] bpf/preload: Clean up .gitignore and
 "clean-files" target
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Quentin Monnet wrote:
> kernel/bpf/preload/Makefile was recently updated to have it install
> libbpf's headers locally instead of pulling them from tools/lib/bpf. But
> two items still need to be addressed.
> 
> First, the local .gitignore file was not adjusted to ignore the files
> generated in the new kernel/bpf/preload/libbpf output directory.
> 
> Second, the "clean-files" target is now incorrect. The old artefacts
> names were not removed from the target, while the new ones were added
> incorrectly. This is because "clean-files" expects names relative to
> $(obj), but we passed the absolute path instead. This results in the
> output and header-destination directories for libbpf (and their
> contents) not being removed from kernel/bpf/preload on "make clean" from
> the root of the repository.
> 
> This commit fixes both issues. Note that $(userprogs) needs not be added
> to "clean-files", because the cleaning infrastructure already accounts
> for it.
> 
> Cleaning the files properly also prevents make from printing the
> following message, for builds coming after a "make clean":
> "make[4]: Nothing to be done for 'install_headers'."
> 
> Fixes: bf60791741d4 ("bpf: preload: Install libbpf headers when building")
> Signed-off-by: Quentin Monnet <quentin@isovalent.com>
> ---

[...]

Acked-by: John Fastabend <john.fastabend@gmail.com>
