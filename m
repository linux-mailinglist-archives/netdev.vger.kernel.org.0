Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B04BA28EB5C
	for <lists+netdev@lfdr.de>; Thu, 15 Oct 2020 05:02:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726671AbgJODCG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Oct 2020 23:02:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726361AbgJODCG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Oct 2020 23:02:06 -0400
Received: from mail-il1-x144.google.com (mail-il1-x144.google.com [IPv6:2607:f8b0:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 050FBC061755
        for <netdev@vger.kernel.org>; Wed, 14 Oct 2020 20:02:04 -0700 (PDT)
Received: by mail-il1-x144.google.com with SMTP id z2so944279ilh.11
        for <netdev@vger.kernel.org>; Wed, 14 Oct 2020 20:02:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=JE37yiXefAPuWdOvXCxECs8BTHKeK76YuEhnWlDbpwo=;
        b=k+4SOOKNx1rO/LBOD7BT3yOb7lmbfJwQgep7TIo5grne3cBSlnHHLzBVr2DDxyT8v2
         Twe5JLel24/2t229GtyKyKZYb+Bkm+mw/s0NDWPPittJ/EeD1bb/4YleFanrgizR8fLJ
         eZ8JFL0z3YTOYpSrXDiB0FVryT4A94S4ClVArEESMi7XQhcr1TaJ20PBNkCi3G0b2IMs
         U+Ii7tbkh8tEEmOY1FH98Qk7xDwUFZcftvHayY3s+3+5YisjHbwcuzhmKRV+q3vSnTNY
         A50YoE+vZA0UrWAm9p7puIfoTn16Z8hBDEQ7ZglGfmW5IsEw0VIeQRCqWPFBZNAPPFp5
         7DJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=JE37yiXefAPuWdOvXCxECs8BTHKeK76YuEhnWlDbpwo=;
        b=e9Mj8LEDwsZCcvRGCj15+Q4NqHQ4Dgo4woDUThs4OcAyf81vGmjjMdEmFqK3dcrylB
         NvGfLPELXTeSNYp3qffQwF93xkq8z71lNWlRB2m+l2Q+gjDN/hD/9MLWN73w3qZgo9CR
         KGK4IQ9YEu/ncg2aOePx2qT3j+4DnbQrTMeaBFGEHDdI2MQGKbm3e/1QGk4cDiTmBC+t
         Lya7NiiBUF13gbQEjXp2ugwbmg7L2Hb1OakI/cbbtLP8RCdj9smhJJ1X4FmTpWd0+oKc
         7QDEYJcvDdTNAZLMDKHN/ea1hekmYy9zhomOfWDxv43KA/U9EVuXXYTxahx7bHKyh+7N
         hf0g==
X-Gm-Message-State: AOAM5310pooji4AWAb72VfmfUDTBdIFH8Hp7De4sQ0QyLZ7AF25KMlVi
        YyfzCdolQASJmnFZJm74k0BMWlenT7pzuWT0cAHSfg==
X-Google-Smtp-Source: ABdhPJxtJ8xfLbGX5R7RGysvv/WdX3cvUvH9P/82SA5nT+JuPN/1E9QJ150Dqu8NvMgFOtDQV4i5oWT0snQaSy2PQNs=
X-Received: by 2002:a05:6e02:bf4:: with SMTP id d20mr1615013ilu.252.1602730924068;
 Wed, 14 Oct 2020 20:02:04 -0700 (PDT)
MIME-Version: 1.0
References: <CA+G9fYv=zPRGCKyhi9DeUsvyb6ZLVVXdV3hW+15XnQN2R3ircQ@mail.gmail.com>
 <20201014193034.GA14337@salvia>
In-Reply-To: <20201014193034.GA14337@salvia>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Thu, 15 Oct 2020 08:31:52 +0530
Message-ID: <CA+G9fYsnPH4nQWoY0bpdw+DS5sqO4xcxDXuu-tfEHxXEGrMyUA@mail.gmail.com>
Subject: Re: selftests: netfilter: nft_nat.sh: /dev/stdin:2:9-15: Error:
 syntax error, unexpected counter
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>, netfilter-devel@vger.kernel.org,
        Netdev <netdev@vger.kernel.org>, lkft-triage@lists.linaro.org,
        Florian Westphal <fw@strlen.de>, fabf@skynet.be,
        Shuah Khan <shuah@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Anders Roxell <anders.roxell@linaro.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 15 Oct 2020 at 01:00, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
>
> On Wed, Oct 14, 2020 at 05:19:33PM +0530, Naresh Kamboju wrote:
> > While running kselftest netfilter test on x86_64 devices linux next
> > tag 20201013 kernel
> > these errors are noticed. This not specific to kernel version we have
> > noticed these errors
> > earlier also.
> >
> > Am I missing configs ?
>
> What nftables version are you using?

nft --version
nftables v0.7 (Scrooge McDuck)

- Naresh
