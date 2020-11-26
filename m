Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D45A02C5C6E
	for <lists+netdev@lfdr.de>; Thu, 26 Nov 2020 20:04:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405191AbgKZTDO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Nov 2020 14:03:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2403990AbgKZTDN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Nov 2020 14:03:13 -0500
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91582C0613D4;
        Thu, 26 Nov 2020 11:03:13 -0800 (PST)
Received: by mail-pg1-x541.google.com with SMTP id k11so2386164pgq.2;
        Thu, 26 Nov 2020 11:03:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=P2L/YYCOnFeIb3+K5lIGoZyvHecSdK+D5x1TJ+KPjfw=;
        b=X19cg+dGU5l8JWl+QsiEVPoZ12oJ+W8FO8y7+XZlEIK/Bgwt8q8dCM6rmu30mqOr3M
         qvnmaC/aSVAYb29oJvW1CPmG1nbIvzig4t7ikJ4TeosfcaGJZCZBFDWWoCQ0H4jHmCmE
         0SSjQwYjkfpt2OGkUhxRFHGyaoBRXIFBsw9aH8ea45PIMsiOhgqX54p5rTOttTHV0Y/O
         XBQ8ulkyqxf1PwPImzVG4UgDbMfWCn504AXCSpaf6bkzR8zH+RKGySE5DGtlyvDauo6P
         1L34FN9sYSvAYvDGLYDpsn7RBZasplj1Qq1d5xyDWQ1c6x5qIq1IDop53xFihROZ3WJi
         aVrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=P2L/YYCOnFeIb3+K5lIGoZyvHecSdK+D5x1TJ+KPjfw=;
        b=m9KGtrth1Cnp6Fy9hG41c1cfG3zeUD/eF05Yfp8J2hdQa1KuzR2EvO8rViNK2pcFew
         D7ynBoerrGpFhuy+Rk/6lS3qhz8v7UIhCmaG/njm6gSx46V8/SGud56xKn3VsppQNKcd
         i5bIbnqudOwch/y5JXhSOL/Ne/Rnowdpg6jSBuk0T8/5+CJ+e57K5fAYMjPhSK1atpKR
         5V2hEck3KmrS5zoYYqAcVMGOJbUliNVZLPRUzcAhBwArrAb6npyk/4TlK8FesBUON4pH
         Q+P+5OWhY5HTVjj7K56x3A54F6nKGxrkQbB9Tn1jdBxRyRRA8aYKFvLtWkwrXA3oJ4JQ
         Qw8Q==
X-Gm-Message-State: AOAM532Jrw2t8T0tuMHT7tb7zcwUo7rv4jPS2Ixj1Jx68wqr/xhS531K
        /1dRtZqBPN9JO8kSN7AmbbJrCPnsk7P3UFecE2YKunTL570=
X-Google-Smtp-Source: ABdhPJykCdB414DQhI0O8ejBvX0ZQHYHT87WuDey648LyB7lnU+1aMyV/eAEVICGrWszEeC747bxBKuAw8iAS//K9jQ=
X-Received: by 2002:a63:a109:: with SMTP id b9mr3578797pgf.368.1606417393194;
 Thu, 26 Nov 2020 11:03:13 -0800 (PST)
MIME-Version: 1.0
References: <20201126063557.1283-1-ms@dev.tdt.de> <20201126063557.1283-3-ms@dev.tdt.de>
In-Reply-To: <20201126063557.1283-3-ms@dev.tdt.de>
From:   Xie He <xie.he.0141@gmail.com>
Date:   Thu, 26 Nov 2020 11:03:03 -0800
Message-ID: <CAJht_EN-H0ZbKa4rcOg4riVnecTtfSqPakW-g+UCgun9cWbf_w@mail.gmail.com>
Subject: Re: [PATCH net-next v7 2/5] net/lapb: support netdev events
To:     Martin Schiller <ms@dev.tdt.de>
Cc:     Andrew Hendry <andrew.hendry@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Linux X25 <linux-x25@vger.kernel.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Acked-by: Xie He <xie.he.0141@gmail.com>
