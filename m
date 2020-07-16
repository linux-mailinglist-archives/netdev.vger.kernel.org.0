Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 17C94221D46
	for <lists+netdev@lfdr.de>; Thu, 16 Jul 2020 09:25:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728297AbgGPHX1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jul 2020 03:23:27 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:47490 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728276AbgGPHX0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jul 2020 03:23:26 -0400
Received: from mail-vs1-f71.google.com ([209.85.217.71])
        by youngberry.canonical.com with esmtps (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <paolo.pisati@canonical.com>)
        id 1jvyEm-00048x-En
        for netdev@vger.kernel.org; Thu, 16 Jul 2020 07:23:24 +0000
Received: by mail-vs1-f71.google.com with SMTP id l25so841026vsr.21
        for <netdev@vger.kernel.org>; Thu, 16 Jul 2020 00:23:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=4VmvjZDsnQSCsnAdrtuni5GNCSEbuCmNLcMY3wa2Le0=;
        b=fPghd+xqjYCeenZVJRwldMTtQKcRqiM0CVYoWiYLcYDI4Mb8YeE/Zq0GiyWl1gzTA4
         gROrxbviVADhDFdvPT4nKcLTa5TrvRHNU/UzvpaGW0k+42/3feE5qDpiDo3H7qXrHo7F
         ugj9oNk463s5z4kXv+4uEyIj3wq9Nz/IUPPsuSqGmug8A6pnYkpQd5fGU1JrQtv6GAf9
         YNaan8N8squ4wNFhSmWCsAqMhJ1ricvqoC3RIlT76OVvyLEkR007XBD8KNMHiyyJRLGu
         XfiQO0YDb5NuUjgIhu3OY36eEc39olmlgIgmGsQjrG4bGqVfdcCibz3hmysHrOT/PwVB
         HnwA==
X-Gm-Message-State: AOAM531E1ynhrgta3cYiPmZub4eaxPNvuR6KQ9JaTW1o/H2gsQwOVT+I
        JNptYNNuxEmuIxYGqzoCH8exdo5HPbbkfHcvpooqzqmzXzzZDO9l/y8wlpBAUreaztYfoKJd2nR
        nUvi3u7pi0kP5mpr2Hduukm5hSqKLvI0uOm98kg5D0+NnLtJCag==
X-Received: by 2002:a67:ea92:: with SMTP id f18mr2022725vso.223.1594884203578;
        Thu, 16 Jul 2020 00:23:23 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyS+5S514mTPFzXqUXVOTEZkeMuUy2FYfT9xaHwmafmZRwQscM2lA1wpLggKg5Y3dTj0KuOtDWJMMfXoNs0idk=
X-Received: by 2002:a67:ea92:: with SMTP id f18mr2022712vso.223.1594884203322;
 Thu, 16 Jul 2020 00:23:23 -0700 (PDT)
MIME-Version: 1.0
References: <20200714124032.49133-1-paolo.pisati@canonical.com> <20200715180144.02b83ed5@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200715180144.02b83ed5@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Paolo Pisati <paolo.pisati@canonical.com>
Date:   Thu, 16 Jul 2020 09:23:12 +0200
Message-ID: <CAMsH0TQLKba_6G5CDpY4pDpr_PWVu0yE_c+LKoa+2fm2f4bjBQ@mail.gmail.com>
Subject: Re: [PATCH] selftests: net: ip_defrag: modprobe missing
 nf_defrag_ipv6 support
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Shuah Khan <shuah@kernel.org>, netdev@vger.kernel.org,
        linux-kselftest@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 16, 2020 at 3:01 AM Jakub Kicinski <kuba@kernel.org> wrote:
>
> Any reason you add this command before set -e ?
>
> It seems we want the script to fail if module can't be loaded.

Cause if CONFIG_NF_DEFRAG_IPV6=y, the script would unnecessarily fail.

-- 
bye,
p.
