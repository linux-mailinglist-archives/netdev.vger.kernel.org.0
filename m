Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3F58719B87A
	for <lists+netdev@lfdr.de>; Thu,  2 Apr 2020 00:35:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733134AbgDAWfG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Apr 2020 18:35:06 -0400
Received: from mail-ua1-f74.google.com ([209.85.222.74]:55045 "EHLO
        mail-ua1-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732385AbgDAWfG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Apr 2020 18:35:06 -0400
Received: by mail-ua1-f74.google.com with SMTP id v20so437361ual.21
        for <netdev@vger.kernel.org>; Wed, 01 Apr 2020 15:35:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=9KR01r6gih4jhYYFHW4WFEV8YGH4JU+wPB7AaAwETRc=;
        b=lNqO4gQEsLC49pzkLSU8cnCQVc6iGeRg/6Wz0ziknQhxjWSurZeQBfYQlziEv+BmA5
         eeOBjThcv4ld4rS6Q8KVb3RF8Suz8cSz6BsFatMUWiPPWf1yT0TEG1b83HHhncC5wqqx
         rnEkUvYYnHSEG9AKwfqswxBOXy+436Cpz8O34nI/jSRBSp3H1Ae1aqULuU2ANA4AI1vn
         2BUubrAQ4f7W8hBFDf52veqo/LjbYA1DdGTTY2YhWZ+5qK4RKEe6ISrRXOdkwxU8se8v
         Txq8J87+3hHsgFggYKO0efyeOIHqFwT7P+Npg9I5l1QhPprBCK0qV0erj+QUayOlqOLE
         rpGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=9KR01r6gih4jhYYFHW4WFEV8YGH4JU+wPB7AaAwETRc=;
        b=sbzs4CTUbbWOqxag/8AA1EhxGzDTWkvopKB4ebw/UzX7bc/Io5rdAXCyC9dRzjekJm
         lMvi//r9V5NciZf29hokbhbzGFrhWIuZ0uqPGspHqGR72w8E5V7dTnRhBgjIVyGv1R4Q
         3ssWty6r+1j5RIqY4AtR4NSTsCumFGaoeLdYbIEa+5taCVa4q9zpqTT1SXITGKJV7uS4
         hIJmzRqCcyecOHJLMIKariWOTz6S8yza6PW9BEnycChle+g4Sm6hAtHziQndbb6VhnMH
         HqBC6kZFpsJrQ+8JvSinFTH9dy3Ol4f9VjVWvIb8AkVjY+8j/UCYKj+8PdQquu1lICpp
         oXHg==
X-Gm-Message-State: AGi0PuZWOINA91sryfkVtSanHlR33uM7+coOCY0rVAUAtVVuWZ4Y/JpE
        AyhToqvU91jebnlBi0ChF67vrsgqS1cVl7Wg1ZY=
X-Google-Smtp-Source: APiQypIWtlrEX6Rjcp+suO+gRNYCoxIEp2c68OatrHaYVJczhIM61LZa5Bdjbebhzf0H9aK6vvFmnQPHyJtBYCNyfPY=
X-Received: by 2002:ac5:cce8:: with SMTP id k8mr148063vkn.5.1585780503181;
 Wed, 01 Apr 2020 15:35:03 -0700 (PDT)
Date:   Wed,  1 Apr 2020 15:35:00 -0700
In-Reply-To: <20200401.113627.1377328159361906184.davem@davemloft.net>
Message-Id: <20200401223500.224253-1-ndesaulniers@google.com>
Mime-Version: 1.0
References: <20200401.113627.1377328159361906184.davem@davemloft.net>
X-Mailer: git-send-email 2.26.0.rc2.310.g2932bb562d-goog
Subject: Re: [PATCH net-next v6 00/11] net: ethernet: ti: add networking
 support for k3 am65x/j721e soc
From:   Nick Desaulniers <ndesaulniers@google.com>
To:     davem@davemloft.net
Cc:     arnd@arndb.de, devicetree@vger.kernel.org,
        grygorii.strashko@ti.com, kishon@ti.com, kuba@kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        m-karicheri2@ti.com, netdev@vger.kernel.org, nsekhar@ti.com,
        olof@lixom.net, olteanv@gmail.com, peter.ujfalusi@ti.com,
        robh@kernel.org, rogerq@ti.com, t-kristo@ti.com,
        clang-built-linux@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>> I think the ARM64 build is now also broken on Linus' master branch,
>> after the net-next merge? I am not quite sure if the device tree
>> patches were supposed to land in mainline the way they did.
>
>There's a fix in my net tree and it will go to Linus soon.
>
>There is no clear policy for dt change integration, and honestly
>I try to deal with the situation on a case by case basis.

Yep, mainline aarch64-linux-gnu- builds are totally hosed.  DTC fails the build
very early on:
https://travis-ci.com/github/ClangBuiltLinux/continuous-integration/jobs/311246218
https://travis-ci.com/github/ClangBuiltLinux/continuous-integration/jobs/311246270
There was no failure in -next, not sure how we skipped our canary in the coal
mine.
