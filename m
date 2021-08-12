Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E9BBB3EA5B5
	for <lists+netdev@lfdr.de>; Thu, 12 Aug 2021 15:30:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236700AbhHLNau (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Aug 2021 09:30:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235375AbhHLNas (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Aug 2021 09:30:48 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97455C0613D9
        for <netdev@vger.kernel.org>; Thu, 12 Aug 2021 06:30:23 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id 28-20020a17090a031cb0290178dcd8a4d1so8012929pje.0
        for <netdev@vger.kernel.org>; Thu, 12 Aug 2021 06:30:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:cc:subject:message-id:mime-version:content-disposition
         :user-agent;
        bh=pN8gn6XDJx8X4O5FCMjgKbbXidE6R/vdaeWWGFTiI50=;
        b=zueqilLqDz8ee1JyiPaJSWJglZoALSJFcmYT8Yc9pyvtcVQQ1OQOSMqgc6v6kDad6q
         9Aw5bD2xsoas6IoQ8l/Va0qJgIUbO4J94GjDass8cA/d1Gd3RPXgVraKac2ArwdGj6Tm
         TM6XzJ5zTQ5RuH8XDmFbtLeB3ZmvWaKsK0chys3KMauQr3ux86r9paNi5MgC4MDXR+Td
         TBpgbrw7hDCdSsNe36K6AtoririIxUOh7Bw2yp3Yf6PqXSNRVUujLZujc8sFnhc9gsU9
         IZAXViUL5Q9esWTtoEqCznYDFth039XhtGSTxfpGswqgL2cc0sBSvQcwgp//AxY8h3S1
         APlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:cc:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=pN8gn6XDJx8X4O5FCMjgKbbXidE6R/vdaeWWGFTiI50=;
        b=bjQ8/YmuN90jTfVNSQLlAZP5ufuk7ClAzYa/pa5Rwjb4pDGWuHYIsxmtcOpbeGG94R
         8qPOxzxdlExi1nbKROo4tmzOE50vM8wKRPOWR4miIofWf2HWLy4bXcIN13EjhGSjo7df
         snUEABAL4MViJJty2dQPHJd/py8Qjf18c6NA6Gex7WaxLtxz3TMEfJ4bTs+177OsSu29
         /XJnvv0p8IfQ35zmHoshs/H3zpeQFh4GxXEylAXLY2H2tL8C5vAugPLK6pM6Qq9U3qMt
         oi4/cLIDLzMOREtLnfynIBtFqvmrMHg98Dpj/IQIQ3EbxFXWpZh5DfBqRsXlYE+k3FcX
         LpvA==
X-Gm-Message-State: AOAM5302w5JPvGaqCfmBvNAf1sTH9kxc1Y/0BjRbNhyBxA+BEYin3RS+
        rIub6TE8WqVWApcYWnuvl2zx360v0qV+
X-Google-Smtp-Source: ABdhPJyXnJ7FAdR0bmSAQM2pPs0oaZ4uhdYDU1t6xU5Hn+jp3ax4FRGvd3Y8kv7FbShfz3C/zlQQcw==
X-Received: by 2002:a62:878a:0:b029:3e0:7810:ec36 with SMTP id i132-20020a62878a0000b02903e07810ec36mr4181500pfe.4.1628775022859;
        Thu, 12 Aug 2021 06:30:22 -0700 (PDT)
Received: from workstation ([120.138.12.52])
        by smtp.gmail.com with ESMTPSA id 136sm3872129pge.77.2021.08.12.06.30.21
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 12 Aug 2021 06:30:22 -0700 (PDT)
Date:   Thu, 12 Aug 2021 19:00:19 +0530
From:   Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Cc:     netdev@vger.kernel.org, richard.laing@alliedtelesis.co.nz,
        linux-arm-msm@vger.kernel.org
Subject: Conflict between char-misc and netdev
Message-ID: <20210812133019.GA7897@workstation>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.9.4 (2018-02-28)
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jakub, Dave,

Due to the below commit in netdev there is a conflict between char-misc
and netdev trees:

5c2c85315948 ("bus: mhi: pci-generic: configurable network interface MRU")

Jakub, I noticed that you fixed the conflict locally in netdev:

d2e11fd2b7fc ("Merge git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net")

But the commit touches the MHI bus and it should've been merged into mhi
tree then it goes via char-misc. It was unfortunate that neither
linux-arm-msm nor me were CCed to the patch :/

Could you please revert the commit?

Thanks,
Mani
