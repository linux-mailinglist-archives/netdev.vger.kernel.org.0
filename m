Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 189F738C921
	for <lists+netdev@lfdr.de>; Fri, 21 May 2021 16:22:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236064AbhEUOYG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 May 2021 10:24:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229581AbhEUOYF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 May 2021 10:24:05 -0400
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3E55C061574
        for <netdev@vger.kernel.org>; Fri, 21 May 2021 07:22:40 -0700 (PDT)
Received: by mail-ed1-x531.google.com with SMTP id g7so11357172edm.4
        for <netdev@vger.kernel.org>; Fri, 21 May 2021 07:22:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=I7gtMw0BCL4rnzuK/TK4gn6xHo+O5NQafn09+KWXJvk=;
        b=jxxyuRICu16XbRi1Wr7ghhLA/kYP1zskWlJLbphdqL9D7U+Dju/MD35xxh5PUWjIJ9
         TQuH1JXK7eW+4oMomk1cf4ZFpzW1Xc8Md2Q2bpo362PdWXy13TdgB3nXZAP+GOs1VhND
         K0I5gKkMcDN74KE6gJ5A0VWDUn6JZTYVsaMiXSLR585K9maizS9n8VWFiNzKdEYXNFJS
         +auotIdMG6LZSti10YVVssgJawFIEkm5zwglZQxdvfw5psFsKdWO0UMPluJtqU9lq6aB
         TSTdXVuagT1n6jrFYDNRgbdsUSe/jEBbuTJzp3iyPy+8SHNfYZQlPX5Q62Jzmhye3wte
         hnjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=I7gtMw0BCL4rnzuK/TK4gn6xHo+O5NQafn09+KWXJvk=;
        b=sXyrbNnsTt7NC1zSJK9t9t+whdWMRqXiUGzts2pMQZlpZt8S/P02Mxo54dXF/q+PrY
         iv/tFD8EXUbWNnHiJI0eMGdBnC+pSSYo7bN7/zuIT1jRhNxN/JGfuR0iraVEAe6MB4+5
         lByPuPzRmTQd56riVQRVfp64LpG1MmS7f1/BqOw/A/9+ALjDR9zVLbQ2y3jgW/KZpCMc
         kL0PvvkLh0ma967DL/f9KT1PfFPlh8gJnHmwma/hTfqkF49F9orGWhKOgYvKerG6G9LL
         WOpQjuyIVfG6dSWM+uHsu5uAx2jQrLOr+8bASdg0UxcAXXYlRCBp2SiCE3Xsp9vUUAdz
         I+eA==
X-Gm-Message-State: AOAM530SejsoxgY89YQ/KlUM7EuO/f1bFL8DSuA/DdWft5+rp6KYrXqM
        NAGL3Ms2mOl+3sdi7003gdo=
X-Google-Smtp-Source: ABdhPJwy4dNj941sCwq3+G+xSql9MjgQaWt08RCHYDP+PBwQxjof2rbk+1dzHVHPYI7lm3jm3ZlBSg==
X-Received: by 2002:a05:6402:35cc:: with SMTP id z12mr11354365edc.154.1621606959043;
        Fri, 21 May 2021 07:22:39 -0700 (PDT)
Received: from skbuf ([188.26.52.84])
        by smtp.gmail.com with ESMTPSA id d11sm3517744ejr.58.2021.05.21.07.22.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 May 2021 07:22:38 -0700 (PDT)
Date:   Fri, 21 May 2021 17:22:37 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Ioana Ciornei <ciorneiioana@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: Re: [PATCH net-next 1/2] dpaa2-eth: setup the of_node field of the
 device
Message-ID: <20210521142237.5kttk6pwi4q6kchr@skbuf>
References: <20210521132530.2784829-1-ciorneiioana@gmail.com>
 <20210521132530.2784829-2-ciorneiioana@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210521132530.2784829-2-ciorneiioana@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 21, 2021 at 04:25:29PM +0300, Ioana Ciornei wrote:
> From: Ioana Ciornei <ioana.ciornei@nxp.com>
> 
> When the DPNI object is connected to a DPMAC, setup the of_node to point
> to the DTS device node of that specific MAC. This enables other drivers,
> for example the DSA subsystem, to find the net_device by its device
> node.
> 
> Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
> ---

Reviewed-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Tested-by: Vladimir Oltean <vladimir.oltean@nxp.com>
