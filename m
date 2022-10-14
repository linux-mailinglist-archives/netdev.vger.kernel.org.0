Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4F9F95FF28C
	for <lists+netdev@lfdr.de>; Fri, 14 Oct 2022 18:50:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231201AbiJNQuf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Oct 2022 12:50:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230417AbiJNQub (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Oct 2022 12:50:31 -0400
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7EC25208C
        for <netdev@vger.kernel.org>; Fri, 14 Oct 2022 09:50:22 -0700 (PDT)
Received: by mail-pf1-x432.google.com with SMTP id p14so5426732pfq.5
        for <netdev@vger.kernel.org>; Fri, 14 Oct 2022 09:50:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:to:from:cc
         :in-reply-to:subject:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=RXs8pGXtGGZWzXsw4rZ+LS2EAkzqKLgAwtWpxGx92fU=;
        b=fttFUz+vxtraLRPbXbj3FKm0IZ9ARAZnSS6vv/CpioswqaUGc2WlbiSpyUSk+1nU1/
         luOh02QiD1Iflia0SkTTTUXHBeGh1ks5OEB9XPvZ2wZn5L7n1NVPCHbWcJho/5YCCojE
         VdYKJgr0K5MJom5sx6sIUr18wcSJLP/VyQfP+ywSQD0C2sQuYSX+vPUK57XQ+jIm33hy
         R9jNjgVzXuNGjF+KDbV2u2Re3Xn2Q2NcvBirDKBfqGmsN/AVwNIusT0ugCg7Ck16LrGX
         n+4oSwQDJY+tbTLLExEj8WsBpPeejE1IG6rMbaZQuwoWvPFkA7XDNt47FDOAEMyv62X6
         6QmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:to:from:cc
         :in-reply-to:subject:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RXs8pGXtGGZWzXsw4rZ+LS2EAkzqKLgAwtWpxGx92fU=;
        b=XiSyCi+2Ai8bK9wF9hPXZF6bti7BPL4VRefAcsdFRC+E2L3aHrLC7bLUmxquiUpbeb
         ubbMJ+N4OySMat3Q/MI5+IIO0Tg3OTuVkaGGvRQQiRsKtl9Jty2zcCzr4IyiEVt/rHi0
         WZwQYah4a5dOpB/fR5qIay8wvPQHfOGemY1tXaa1NzH413NaXN9xyQ/lEFHEfDNk1mRo
         beUlNw67Hueq5gUmgFvN1izuzxelBNiyx6gzDIFKC42eO+BDra0qL7YhP13RQhDlVqka
         o2VauuxIWMEUWV7iWXLARFFsyGsRBu7YfzXcfKO0kBY91lHUhJnqidabSsDIxl5g4G+F
         kx1g==
X-Gm-Message-State: ACrzQf3SSRVco7cETDv+FNVCI1pET86BkIOPWw3wjyRvBtqdcM8jti9i
        VapBNqhmxWz7eoXKjN64EQ8H4mc6zmJjBdUM
X-Google-Smtp-Source: AMsMyM5S9FfuTscYk1rWNAgrhHrGOzoBMP/C/g49+m/RbzrY6zhImlSUl23Oz0HPujc59lXNjdSqzQ==
X-Received: by 2002:aa7:8895:0:b0:565:e8b7:8494 with SMTP id z21-20020aa78895000000b00565e8b78494mr6131922pfe.82.1665766222208;
        Fri, 14 Oct 2022 09:50:22 -0700 (PDT)
Received: from localhost ([50.221.140.188])
        by smtp.gmail.com with ESMTPSA id k24-20020a170902761800b001782aab6318sm1969958pll.68.2022.10.14.09.50.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Oct 2022 09:50:21 -0700 (PDT)
Date:   Fri, 14 Oct 2022 09:50:21 -0700 (PDT)
X-Google-Original-Date: Fri, 14 Oct 2022 09:50:27 PDT (-0700)
Subject:     Re: [PATCH] MAINTAINERS: git://github -> https://github.com for petkan
In-Reply-To: <166573561445.14465.3335360255597249102.git-patchwork-notify@kernel.org>
CC:     petkan@nucleusys.com, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Conor Dooley <conor.dooley@microchip.com>
From:   Palmer Dabbelt <palmer@rivosinc.com>
To:     patchwork-bot+netdevbpf@kernel.org
Message-ID: <mhng-f9587376-2d54-4ff5-ae71-0992b080ff1a@palmer-ri-x1c9a>
Mime-Version: 1.0 (MHng)
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 14 Oct 2022 01:20:14 PDT (-0700), patchwork-bot+netdevbpf@kernel.org wrote:
> Hello:
>
> This patch was applied to netdev/net.git (master)
> by David S. Miller <davem@davemloft.net>:
>
> On Thu, 13 Oct 2022 14:46:36 -0700 you wrote:
>> Github deprecated the git:// links about a year ago, so let's move to
>> the https:// URLs instead.
>>
>> Reported-by: Conor Dooley <conor.dooley@microchip.com>
>> Link: https://github.blog/2021-09-01-improving-git-protocol-security-github/
>> Signed-off-by: Palmer Dabbelt <palmer@rivosinc.com>
>>
>> [...]
>
> Here is the summary with links:
>   - MAINTAINERS: git://github -> https://github.com for petkan
>     https://git.kernel.org/netdev/net/c/9a9a5d80ec98
>
> You are awesome, thank you!

I made a typo in the subject: "git://github -> https://github.com" 
doesn't match.  No big deal, but I figured I'd point it out.
