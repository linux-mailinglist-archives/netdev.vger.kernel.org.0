Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A2F82534BC
	for <lists+netdev@lfdr.de>; Wed, 26 Aug 2020 18:22:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727993AbgHZQW0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Aug 2020 12:22:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726862AbgHZQWY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Aug 2020 12:22:24 -0400
Received: from mail-lf1-x130.google.com (mail-lf1-x130.google.com [IPv6:2a00:1450:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32FD3C061574;
        Wed, 26 Aug 2020 09:22:21 -0700 (PDT)
Received: by mail-lf1-x130.google.com with SMTP id k10so1313615lfm.5;
        Wed, 26 Aug 2020 09:22:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=BtT/4wVpsckCYLZ8n/zzlgxrXxVC3on9xl+ly7YJvbg=;
        b=tc4j+KoKAigY4Z31jsSv57tW3V+T42yEU2FIfYieeA5dzNcnB8hrMO44XVDwJWxYYD
         Oqz7xSHf8Mb/estAk8V0sRxEU9sTLpWC5DaqYtInGLTxCD3mEgx7b4xd7oRFKX1sSdRH
         omt55CPM+Twp0UEVoLgkOSP/TTwX3GjKwEi7TkSWAwNcCJDLnRIUYW0/H8OAbINcNxjf
         Sa+F6yVzZMkKNCuYpEg4f5Xao+gezUQr50RvfYsHetjUoNkMII9mbq5C3AnCuEct+ZE/
         3OznTVV7sJg1olYrxpgFo9wY8/PKK7/6/qWnWs/QU9qH450MuY2+bMEmmD4Ve0+yoMR8
         PbYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=BtT/4wVpsckCYLZ8n/zzlgxrXxVC3on9xl+ly7YJvbg=;
        b=jBbmkjumxy943VqQ0ba0IujkxFOBFWmKuPg19Q6+F1MFg4OunvYgnEdgy9wzKi46Dn
         IWSrS0hCDJhV7+eBDRcw9gUdE9UTiVv3lQ8s4pEyRjSbIhgEQQC1q7znDqmzWRSfujUT
         FsxmHb4aOfXVFDACQuuHrDXNqA6xda8le79AIZ1ewwfbCeavWd448rxWlTVGe6ksYL6O
         5tcVExl0umzi5ZscUALbhbVnBqakpBnUYGlufVvQ0THUfchfhSBYqw4ztL7ffv12r8uu
         rE4cC3sa8OvJ3/urDi7Hjga/nERJopCfV4xHIZpCgbuOOxaH7sk2zAmmAZev/sda30iq
         vQYA==
X-Gm-Message-State: AOAM533thep1bdiegtaGbwMEgVX2Z05YEtmtEdhscNX5LrlCXr+lB2qk
        mjz0IlHTfjzOzWnPLFViFXJj3ezVIFIp0RE0BAGCPl8V
X-Google-Smtp-Source: ABdhPJy6WsGLpYT6ef2HZAU1XlNg+2DvK0xpGmvBdrIYxBRMiBqa3AqHN/PqIRkKYIYYI+bsiT7mel1SOnHT5CZmekE=
X-Received: by 2002:a05:6512:74b:: with SMTP id c11mr7549812lfs.119.1598458938599;
 Wed, 26 Aug 2020 09:22:18 -0700 (PDT)
MIME-Version: 1.0
References: <20200826085907.43095-1-colin.king@canonical.com>
In-Reply-To: <20200826085907.43095-1-colin.king@canonical.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Wed, 26 Aug 2020 09:22:07 -0700
Message-ID: <CAADnVQL26-gaPy2yreDj=P00_Z0q6VunsP95goD6GfhhM_DuBA@mail.gmail.com>
Subject: Re: [PATCH][next] selftests/bpf: fix spelling mistake "scoket" -> "socket"
To:     Colin King <colin.king@canonical.com>
Cc:     Shuah Khan <shuah@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jiri Olsa <jolsa@kernel.org>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, kernel-janitors@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 26, 2020 at 1:59 AM Colin King <colin.king@canonical.com> wrote:
>
> From: Colin Ian King <colin.king@canonical.com>
>
> There is a spelling mistake an a check error message. Fix it.

Kinda ironic that you've made a spelling mistake in the commit log
that fixes spelling in the test.
Whatever scripts you use to detect spelling errors, please use it
on your commit messages as well.

> Signed-off-by: Colin Ian King <colin.king@canonical.com>

Applied with s/an/in/ in the commit log.
