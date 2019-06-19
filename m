Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EB4EF4C032
	for <lists+netdev@lfdr.de>; Wed, 19 Jun 2019 19:48:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729554AbfFSRsH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Jun 2019 13:48:07 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:41193 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726322AbfFSRsH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Jun 2019 13:48:07 -0400
Received: by mail-pf1-f194.google.com with SMTP id m30so22870pff.8
        for <netdev@vger.kernel.org>; Wed, 19 Jun 2019 10:48:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=nq98yKg75hsyhBFG7qxMvdx6BEsFqlQ2oL275X6Ysew=;
        b=sHHMKRmAQ9MocPDyWQV3FsBI7N2hXgW9Z0aEdJl0gBDnvjybz2Ygzp5DQ/WNdeukis
         3qlVF5Opc3uiaAF5tbiTqwSdx8UFg4A0DVSqyprV08Fnm+i5ENhrE56OHbVSl56r6k/h
         DvRfSRST1ExPjL3KdWuVOKqNUyVNq5iE1vNQg2vT03pPiO2zoW8jgX2D5wjcTAF/xhlp
         mqx9VZGUjk2WsAUoD8d9qWgFlGMkL8e1LxPZzsbVRGKgSAlhuzjjIXbhK3KIXF38vMry
         hmZP08oaI2n4Xt7WsyBVa+d+/vLAzCvKL4dgwT68IC+Jgtwr071xXreLbodGLOUYy0wi
         HMsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=nq98yKg75hsyhBFG7qxMvdx6BEsFqlQ2oL275X6Ysew=;
        b=MKBlDIyiTPDNcxHnnqK6K922KkSyfqzQ8rqNdnG7okepp48fZlle+KJjf9u0bLq6Ju
         CVHJuiO8V3P5+P5Z2FH4oxud9v1joJkpzQ5zkDviueAbfh3bE5Gh4VOCmBeScj4TiNmy
         hUt5cnnpZqjvDoC9ndIf54Id/DVBEBR+XcLGwG18d550IyQU8WuQEFOWXQdZqF3nrQte
         iQy7ZSWZjpwyzUWDrqNbBF751EfXrkJZseNWAKt50BvXV6537uiRQHMf51Bcqqp3fHOB
         j8rvouQkjaEPkRR3mWZYnVMeXG/pOtRlNRYO7h+WNoCYHmq+MRDcQA6x4rvtd94yqvvu
         7w4A==
X-Gm-Message-State: APjAAAXN/B8GiEgCxc7+peFMsgaVidLlTlWLDLyEcmJupm1PWS2aXYFQ
        sGECNXI497XEocB1cJXTkajq/w==
X-Google-Smtp-Source: APXvYqzvNWQ3H8jPHjCGZVl9lx5VJ5XiHlY4CPh3AYL0awGQ0Cg9miIsXXXXNG0taZ9S8GrXZcte8A==
X-Received: by 2002:a17:90a:fa12:: with SMTP id cm18mr12311816pjb.137.1560966486395;
        Wed, 19 Jun 2019 10:48:06 -0700 (PDT)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id v9sm24715593pgj.69.2019.06.19.10.48.05
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Wed, 19 Jun 2019 10:48:06 -0700 (PDT)
Date:   Wed, 19 Jun 2019 10:47:59 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Denis Kirjanov <kda@linux-powerpc.org>,
        David Ahern <dsahern@gmail.com>
Cc:     netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        dledford@redhat.com, mkubecek@suse.cz
Subject: Re: [PATCH iproute2 v2 2/2] uapi: update if_link.h
Message-ID: <20190619104652.4c71c33b@hermes.lan>
In-Reply-To: <20190619141414.4242-2-dkirjanov@suse.com>
References: <20190619141414.4242-1-dkirjanov@suse.com>
        <20190619141414.4242-2-dkirjanov@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 19 Jun 2019 16:14:14 +0200
Denis Kirjanov <kda@linux-powerpc.org> wrote:

> update if_link.h to commit 75345f888f700c4ab2448287e35d48c760b202e6
> ("ipoib: show VF broadcast address")
> 
> Signed-off-by: Denis Kirjanov <kda@linux-powerpc.org>

This is only on net-next so the patches should target iproute2-next.

David can update from that.
