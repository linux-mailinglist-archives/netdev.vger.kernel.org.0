Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 14DBA5A35F
	for <lists+netdev@lfdr.de>; Fri, 28 Jun 2019 20:22:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726631AbfF1SWM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jun 2019 14:22:12 -0400
Received: from mail-yb1-f178.google.com ([209.85.219.178]:41292 "EHLO
        mail-yb1-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725783AbfF1SWM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Jun 2019 14:22:12 -0400
Received: by mail-yb1-f178.google.com with SMTP id y67so4415070yba.8
        for <netdev@vger.kernel.org>; Fri, 28 Jun 2019 11:22:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=KdE+9y5HIHNBUED7uN7Yu4Xl64Qc3Smz6Qsgu680RCM=;
        b=hSXZdpUTkcgkPbfqmC58pmx2OZ4uLWS+Muu7tfae2S+rMMtQj6OfQtSUBwinAF1ogk
         7SJBy2Zabeu7c0VC1gnf17DAp7Z0XXNIApEz5yuyjwxZDSwihyaPKbkxSTPvzViCw119
         eyj9OKQC5B/YnyNU3/+/Cnlq2vvnVvvZVxwGo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=KdE+9y5HIHNBUED7uN7Yu4Xl64Qc3Smz6Qsgu680RCM=;
        b=SOZW13KXwYb7zcFSWlc7l6U2t+9sTkU4qFUihmBUK4qEFa6PEC4ElGJg4Dx+/VWF2h
         GbUk+5b8M6JbyoZmkVsaxrEXtKOwj28olH0n6a1WbTeCgY1AQVHPxqMRFbsr1vHKyPmi
         SFDhbiNnM0+C4QnsNhkez7Kw2NU5ZvFPF2wQW/LdqfiNNgpQ5sUKWiEI3sEc712+NXMD
         SSDk5jCYUvykkhF4XLvbjpfnoxUN+Cj/QwcjW+uh4/qywpk6ZHXZpcdaV7qObFYLw/HY
         hgXCrfpjAOVj9id6yLb8k1AuitbC8QASonz+KImFYYgCzk+dXikCT1IDbR4ldeRxt3Kc
         P2qw==
X-Gm-Message-State: APjAAAX8jyN7hWpgWVOAkGszCogxzkT0XXNDGRlIfv6VfGaQZpGk5FJ3
        Bd/iSy5DTxyvfGpZVan0Qme/w20Ht7QVyTmLPsliBQ==
X-Google-Smtp-Source: APXvYqycdmF3cvQi3ItfK/28rf8B89NPhbOoFW/FFAvqgD90Dg5hzOIKUcCckwl6cSkes94G7oJgbXUCo/EUNDVl+pM=
X-Received: by 2002:a25:d697:: with SMTP id n145mr7237442ybg.298.1561746131304;
 Fri, 28 Jun 2019 11:22:11 -0700 (PDT)
MIME-Version: 1.0
References: <20190627194250.91296-1-maheshb@google.com>
In-Reply-To: <20190627194250.91296-1-maheshb@google.com>
From:   Michael Chan <michael.chan@broadcom.com>
Date:   Fri, 28 Jun 2019 11:22:00 -0700
Message-ID: <CACKFLi=9cY4aWLRgmsWbT9=AFQX2s5NFp35e7fWdfh35Yr2nfA@mail.gmail.com>
Subject: Re: [PATCHv2 next 0/3] blackhole device to invalidate dst
To:     Mahesh Bandewar <maheshb@google.com>
Cc:     Netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        David Miller <davem@davemloft.net>,
        Daniel Axtens <dja@axtens.net>,
        Mahesh Bandewar <mahesh@bandewar.net>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 27, 2019 at 12:42 PM Mahesh Bandewar <maheshb@google.com> wrote:

> However, Michael Chan <michael.chan@broadcom.com> had a setup
> where these fixes helped him mitigate the issue and not cause
> the crash.
>

Our lab has finished testing these patches.  The patches work in the
sense that no oversize packets are now passed to the driver with the
patches applied.  But I'm not seeing these bad packets reaching the
blackhole device and getting dropped there.  So they get dropped in
some other code paths.  I believe we saw the same results with your
earlier patches.

Thanks.
