Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 332EF439449
	for <lists+netdev@lfdr.de>; Mon, 25 Oct 2021 12:56:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231458AbhJYK60 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Oct 2021 06:58:26 -0400
Received: from mail-wr1-f46.google.com ([209.85.221.46]:36780 "EHLO
        mail-wr1-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232090AbhJYK6M (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Oct 2021 06:58:12 -0400
Received: by mail-wr1-f46.google.com with SMTP id w15so8413374wra.3
        for <netdev@vger.kernel.org>; Mon, 25 Oct 2021 03:55:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=sXc88nZOdpcAQ5BmBbT1tLuOWdfYJcmABBeYACUNHPk=;
        b=kIRfBSHYxfbfPcRPe9fJmaE9bTNl2Er8z/nu3mxqIzdAREHyFvuSaVJnkbc9Y1bGsn
         cGHoNpFdD8cCqtDWt/iZfIzXc1BXOn4AJwYQ030YLl2BCpBAE1mkdOpAXZ6udZ/CiYLj
         /JajtLFvJ+mgVAaq24IsAbICjufhKnyl9Ty3CbU1L9s8xJxs0gIMIdzVVVLxXbGSnGFn
         w30ypyTVRW5zhc9rMNBvnWQ8PU0aoRO4SoVY6tTvnky0gsCFh+jfpgLWKcjljMy74dzx
         1y0nEfqt8iPF67vJ5Q/KUc6qz8y3qpmkTfiYgBBPFKEMjScgy3Jhn0+9kFx5rkk0v3IL
         NC2w==
X-Gm-Message-State: AOAM533+rUPmRs7/sR9RpeKqgvlAdRilB6wMFHEkkYY+uiAqmIKE8mHU
        ump4BVgpMRjvzWUV6I3w9KqcrEB4y0c=
X-Google-Smtp-Source: ABdhPJzEF0JvURt5NGWDas8A4vP05aaqlxtc0/bJyQQcRIs49zfFl+1/SUkK+VBL1tNg4p0jUqJRYg==
X-Received: by 2002:adf:efc7:: with SMTP id i7mr18741951wrp.410.1635159349243;
        Mon, 25 Oct 2021 03:55:49 -0700 (PDT)
Received: from liuwe-devbox-debian-v2 ([51.145.34.42])
        by smtp.gmail.com with ESMTPSA id i9sm11898253wmb.22.2021.10.25.03.55.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Oct 2021 03:55:48 -0700 (PDT)
Date:   Mon, 25 Oct 2021 10:55:47 +0000
From:   Wei Liu <wei.liu@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, wei.liu@kernel.org,
        paul@xen.org, boris.ostrovsky@oracle.com, jgross@suse.com,
        sstabellini@kernel.org, xen-devel@lists.xenproject.org
Subject: Re: [PATCH net-next v2 01/12] net: xen: use eth_hw_addr_set()
Message-ID: <20211025105547.bmmowslozg2mdjdf@liuwe-devbox-debian-v2>
References: <20211021131214.2032925-1-kuba@kernel.org>
 <20211021131214.2032925-2-kuba@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211021131214.2032925-2-kuba@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 21, 2021 at 06:12:03AM -0700, Jakub Kicinski wrote:
> Commit 406f42fa0d3c ("net-next: When a bond have a massive amount
> of VLANs...") introduced a rbtree for faster Ethernet address look
> up. To maintain netdev->dev_addr in this tree we need to make all
> the writes to it got through appropriate helpers.
> 
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>

Acked-by: Wei Liu <wl@xen.org>
