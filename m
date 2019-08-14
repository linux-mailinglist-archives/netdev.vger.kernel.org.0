Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C8A188D7C5
	for <lists+netdev@lfdr.de>; Wed, 14 Aug 2019 18:14:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727111AbfHNQOd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Aug 2019 12:14:33 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:33297 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725828AbfHNQOc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Aug 2019 12:14:32 -0400
Received: by mail-pg1-f193.google.com with SMTP id n190so12507317pgn.0
        for <netdev@vger.kernel.org>; Wed, 14 Aug 2019 09:14:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=5Dnb90Yh0Yi30CzUGA3KdLPS3QiA0QRvGarN3Ikt9O4=;
        b=jW9oo4hxVTILyxJZgMuRelT53ATRRwVGPuc0oUtx36nKFg8s4eDwHDND8we6VD2k38
         BGE51MZ+oncWz2Nx1r2lJB7aug8s60QZQ1mCqgxiAkfv0ftxWvz6v6sKl4/ZrpgPbxPx
         VIjG0apa89g9Od/kRkLpVhtAE3g18//kAHBPp7YyFOb4A5B8GxTZd0dzZrQaOFdh13pN
         4r1TzuElLU3olkvSvlSVGjOSOBLGml8DKu2jiQ8ToA2nU4DxtntiWqXcoDjHKG1efq60
         xlIOIg6wQ5327RVgDFB2OArWpDcSNlUXpuOzh3O6rzXBcXEhlOL10103+k+iDb2cYZMK
         9DvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=5Dnb90Yh0Yi30CzUGA3KdLPS3QiA0QRvGarN3Ikt9O4=;
        b=ZjtwBLT2zo8Fo6Dlukf6vKBMeFuqPCS0IWoxgSAExslj+JwlGRDH9anblyD7A2Osal
         TaSbcw9cj2jhewBs+V3xZvHn+ZK74cAdPp9Xcb7Ze9yWwwZ40vK90QDjupnmubVe3cZV
         4yVVh2knodWbWk020SiyMB2TKBedD0lzpgB0A766RMXHGmV6sXG5l5pMLhIAjyZDgiD2
         EmxBzaMPaIEnf6yeNPcHS0llV3tDWBlVDbvjtxw6l3ABoiLiK91c98jATRmFz81VWwUe
         HlJAQyAcQop/DeYKxTGpIOEV5VMtjqFMxrnb/NS8dYPAdWVHf2QmwXGsNwxrJArGyqNG
         fcNg==
X-Gm-Message-State: APjAAAV6jhKBb0gODmYtlxv0wGSa014gmyyLUqZQq4tUxmkoeljAMxle
        s6XcLb0inPiXHtuxj7KvCcjihg==
X-Google-Smtp-Source: APXvYqy1XQBB/YWB0o8lIKbgs6//PHjeKByn+iEcC/Pw1rqEm7h757DkL2YO7Uqi/Ug1i3OyJRMy5A==
X-Received: by 2002:a65:6108:: with SMTP id z8mr39395563pgu.289.1565799271931;
        Wed, 14 Aug 2019 09:14:31 -0700 (PDT)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id j6sm270788pfa.141.2019.08.14.09.14.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Aug 2019 09:14:31 -0700 (PDT)
Date:   Wed, 14 Aug 2019 09:14:29 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Martin Olsson <martin.olsson+netdev@sentorsecurity.com>
Cc:     Cong Wang <xiyou.wangcong@gmail.com>,
        netdev <netdev@vger.kernel.org>
Subject: Re: tc - mirred ingress not supported at the moment
Message-ID: <20190814091429.5a364c51@hermes.lan>
In-Reply-To: <CAAT+qEbDAuQWGZa5BQYMZfBRQM+mDS=CMb9GTPz6Nxz_WD0M8Q@mail.gmail.com>
References: <CAAT+qEa6Yw-tf3L_R-phzSvLiGOdW9uLhFGNTz+i9eWhBT_+DA@mail.gmail.com>
        <CAAT+qEbOx8Jh3aFS-e7U6FyHo03sdcY6UoeGzwYQbO6WRjc3PQ@mail.gmail.com>
        <CAM_iQpW-kTV1ZL-OnS2TNVcso1NbiiPn0eUz=7f5uTpFucz7sw@mail.gmail.com>
        <CAAT+qEYG5=5ny+t0VcqiYjDUQLrcj9sBR=2w-fdsE7Jjf4xOkQ@mail.gmail.com>
        <CAAT+qEbDAuQWGZa5BQYMZfBRQM+mDS=CMb9GTPz6Nxz_WD0M8Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 14 Aug 2019 11:25:25 +0200
Martin Olsson <martin.olsson+netdev@sentorsecurity.com> wrote:

> Hi Cong!
> 
> Ah sorry.
> Already implemented. Great!
> 
> Hmmm. Then why don't the manual at
> https://www.linux.org/docs/man8/tc-mirred.html to reflect the changes?
> That was the place I checked to see if ingress was still not implemented.
> In the commit you point at, the sentence "Currently only egress is
> implemented" has been removed.

The man pages on linux.org are not controlled by kernel/iproute developers.
Not sure who builds/owns these and don't care.


> Question:
> Is there any form of performance penalty if I send the mirrored
> traffic to the ingress queue of the destination interface rather than
> to the egress queue?
> I mean, in the kernel there is the possibility to perform far more
> actions on the ingress queue than on the egress, but if I leave both
> queues at their defaults, will mirrored packets to ingress use more
> CPU cycles than to the egress destination, or are they more or less
> identical?
> 
> 
> Question 2:
> Given the commit
> https://git.kernel.org/pub/scm/network/iproute2/iproute2.git/commit/?id=5eca0a3701223619a513c7209f7d9335ca1b4cfa,
> how can I see in what kernel version it was added?

Look at the tags

$ git tag --contains 5eca0a3701223619a513c7209f7d9335ca1b4cfa 
v4.10.0
v4.11.0
v4.12.0
v4.13.0
v4.14.0
v4.14.1
v4.15.0
v4.16.0
v4.17.0
v4.18.0
v4.19.0
v4.20.0
v5.0.0
v5.1.0
v5.2.0

https://stackoverflow.com/questions/27886537/how-to-find-out-which-releases-contain-a-given-git-commit
