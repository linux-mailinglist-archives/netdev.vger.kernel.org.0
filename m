Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 34E8CDA50F
	for <lists+netdev@lfdr.de>; Thu, 17 Oct 2019 07:18:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390553AbfJQFSF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Oct 2019 01:18:05 -0400
Received: from mail-il1-f176.google.com ([209.85.166.176]:46370 "EHLO
        mail-il1-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728999AbfJQFSF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Oct 2019 01:18:05 -0400
Received: by mail-il1-f176.google.com with SMTP id c4so760857ilq.13
        for <netdev@vger.kernel.org>; Wed, 16 Oct 2019 22:18:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=Y3fXrEj6Q5yGSk3WJTRbPppP3FaNHdsfCgPGtmogobI=;
        b=Sr8mo8JMusOkKHemrBzQZDiSoFErbCybJhybq5AaZfjFJzri/6BmYte26eUr5RNjSS
         NsBwdGtfJ+RUYrMzG4UxdDp9io0AdGkYpJPgNVvZvArXlOm5y1o3JKeIilb8DURJVPQQ
         XepSCMzWJ+hSFwwCf88xyYy4QPxvn+OceFPeFYcFCS2cgyY5/ZOOfSKmRKxEQRdTrY/f
         +AzbuwEbngZQlCGdhHbuPF5BCum9NOuZr+JSr24iaTcMl/3gil3ZZkIlfk3BHKIaUlU5
         S18JqOuLIzOXJlv7GbcS8m/kGFvzAfB2yYWMzvlzBAJQpw+MWzWVGF45Q3ObS8ER28PM
         KdNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=Y3fXrEj6Q5yGSk3WJTRbPppP3FaNHdsfCgPGtmogobI=;
        b=b0+tOPagrKkaAx3ZqN3s9MftoyfZzQCE1dKSVHKbTyc4Z1WJAlZoRlqzr2SFilSz5i
         IffRlpXUsxpqcza54VEhvdhwT7UjKFRyyZabx0gbUcZHR2p3GyyKnVXppnNsbFU2KVo9
         jmdYE0rUApURssv14yKRcUHUvKaIaj19ERcGrt8MUOoK0UOQm6hHR4cRZ/bX3sIrds3q
         uzD8zw/KHqi3QypuOi3wST8VqBmfGpDnZlMzEGp2Wu+rhdwXrdejwvGlz+SFEW2YtuZ7
         XpDwpSgcA4ws03X0K7YgRSMnsZDNHq1ctUlj1XfeBbTVayhUPQEqJtPN+8EIrBklQX02
         8Sjg==
X-Gm-Message-State: APjAAAWuQjaoVnjzjSUSjqUeCq83qBEWuqRuQKYipT5bHdBcZK/5dyJi
        pqv8M+Lh2zDPBAo2ZwB52ZpOljtPBgD/SahBJkfydxWd25o=
X-Google-Smtp-Source: APXvYqydrI/Y511iXQiX1mbBXE4Yzf0JP6P3jVzwkSfMGhBWa8TUbw+/xMskGzW23wKEZBhjaelwIv2IA7RqQk8S5xQ=
X-Received: by 2002:a92:6e0d:: with SMTP id j13mr1724974ilc.43.1571289484232;
 Wed, 16 Oct 2019 22:18:04 -0700 (PDT)
MIME-Version: 1.0
From:   Thayne <astrothayne@gmail.com>
Date:   Wed, 16 Oct 2019 23:17:53 -0600
Message-ID: <CALbpH+jEOPxfpTXiWwbPKKwueJW5W5Nxb1vyagyk9Tyj6H_Pfg@mail.gmail.com>
Subject: Documentation for filters in ss
To:     netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The man page for ss(8)  states:

> Please take a look at the official documentation for details regarding filters.

However, I have been unable to find any documentation on the filters
for ss, official or otherwise.

There was some documentation that was removed in commit
d77ce080d33370d90de8b123cd143e9599dc1ca6
(https://git.kernel.org/pub/scm/network/iproute2/iproute2.git/commit/?id=d77ce080d33370d90de8b123cd143e9599dc1ca6)
which I presume is the official documentation referred to?

The man page should probably be updated to either document the filter
syntax directly or point to where information about it can be found.
