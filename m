Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 16CDE28C74A
	for <lists+netdev@lfdr.de>; Tue, 13 Oct 2020 04:48:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727867AbgJMCsQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Oct 2020 22:48:16 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:37280 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727075AbgJMCsP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Oct 2020 22:48:15 -0400
Received: from mail-lj1-f197.google.com ([209.85.208.197])
        by youngberry.canonical.com with esmtps (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <po-hsu.lin@canonical.com>)
        id 1kSAMG-0007wU-HQ
        for netdev@vger.kernel.org; Tue, 13 Oct 2020 02:48:12 +0000
Received: by mail-lj1-f197.google.com with SMTP id n24so7077877ljc.9
        for <netdev@vger.kernel.org>; Mon, 12 Oct 2020 19:48:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=G9YMzKKemL4yEtTpZq3swTQnWFUcuccAdAOgQPyZkCE=;
        b=IgjsMKDdFs93Qvk9WttZWA/yElOeaduKCdipxQiCPs8syN+rJtVzZbqK8liZXzDuv0
         1AN8lXsu/gg9F/mr2b6TLkFa5jLccTXNxkMerruYAmp8lc6GOZk/t2ZuTDJykge+p57g
         uv6vL/htjOAEzqvMIj5V+DbikH9BYEizouXuMw7J4ieDD3nCIlkLotpd+Iod1eRDrPq5
         56bP3+buKAGwbBQgJe+wW/+jgL2EXl4mjOewUPMUbw7WBuSvxhia2Fr6BF78eMG9r3eI
         gEu9uWXSmr/LzdKywJxnO3MnB/e/SGcSEqzPAyjf+uVNBcsuE+1E81HXtktdFLwqcMnL
         zqqA==
X-Gm-Message-State: AOAM531kgDvSeD0aK3rLsuFriBY/pwcnpMlxMLPZRKm3j50XVc9WU/cq
        B41MBtvXAFDt2bEgICn/F4N0TFHZQA44jv8+H9WL/uUD1F9c0E4aC3bGc0VHSHnztOcHlGaWYw6
        CpF5tMsvKxDSRlxEbcevbq2QB6S5G0SBz/O9oDuhJwvP9P0Y4
X-Received: by 2002:a2e:b610:: with SMTP id r16mr2368429ljn.145.1602557291843;
        Mon, 12 Oct 2020 19:48:11 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxrY7bJ1GyblOrZbBZ/9DUes654EWYmtWMOXL+aPPrxh6huWVRZ0454gyfaETS768LcE/4Wi7MmDRY5X70GNrk=
X-Received: by 2002:a2e:b610:: with SMTP id r16mr2368423ljn.145.1602557291594;
 Mon, 12 Oct 2020 19:48:11 -0700 (PDT)
MIME-Version: 1.0
References: <20200907035010.9154-1-po-hsu.lin@canonical.com>
 <20200907131217.61643ada@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CAMy_GT-kaqkcdR+0q5eKoW3CJn7dZSCfr+UxRf6e5iRzZMiKTA@mail.gmail.com>
 <CAMy_GT-0ad7dnWZ=sVt7kZQSMeKQ-9AXdxTe+LqD4uuFnVd+Vw@mail.gmail.com>
 <CAMy_GT9hALtE9-qBU95QCR7=VN8hwRps4U=hDjsWeKzssnMbKg@mail.gmail.com> <20201012082819.1c51b4cf@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201012082819.1c51b4cf@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Po-Hsu Lin <po-hsu.lin@canonical.com>
Date:   Tue, 13 Oct 2020 10:48:01 +0800
Message-ID: <CAMy_GT-_7oh_fwsN4-9VMdf=cSBNL0jwE9AWa9-Dr09x_zam1A@mail.gmail.com>
Subject: Re: [PATCHv3] selftests: rtnetlink: load fou module for
 kci_test_encap_fou() test
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     David Miller <davem@davemloft.net>,
        Shuah Khan <skhan@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-kselftest@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 12, 2020 at 11:28 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Mon, 12 Oct 2020 13:56:15 +0800 Po-Hsu Lin wrote:
> > Is there any update on this patch?
>
> You received feedback. Don't remove modules after tests, something else
> could be using them.

Hello Jakub,
I have my feedback regarding your input [1], so I guess it's not
persuasive enough?
Thanks

[1] https://marc.info/?l=linux-kernel&m=159954826414645&w=2
