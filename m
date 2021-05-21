Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 65E3638C928
	for <lists+netdev@lfdr.de>; Fri, 21 May 2021 16:24:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235963AbhEUOZp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 May 2021 10:25:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231688AbhEUOZn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 May 2021 10:25:43 -0400
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82474C061574
        for <netdev@vger.kernel.org>; Fri, 21 May 2021 07:24:20 -0700 (PDT)
Received: by mail-ej1-x629.google.com with SMTP id u21so30693121ejo.13
        for <netdev@vger.kernel.org>; Fri, 21 May 2021 07:24:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=7HSRnH64j2wDhzw/uk66uUTVrlTEmvsn3KsRzD+ScCs=;
        b=Hl+syCopbGer3G1NX9L0adjrkIOP8GPwyZPvjnbtUNKziYblheuhN9vb0de4/eT2AP
         MNIQ/tcfWdvWUksjwLHPPYBu+nGXt+hi0fJX+SfOjnDqkpy97pH9kIGskINSOvVTc7l1
         oBMkgXlihiXU4t+OJ2ltuIaGNETtVEP0P3YymsvGzMII6IhDGgu2+cFciRn3KvRBvmWS
         76+Gu2x7xL8QRGAS1y+CuqWvmDyZU7lyG38y1I5/tgVcStSHd9AmDyT/uU+BynJPSFWF
         sMx4/BRd63w9d5uVnCXJrgMAo5lZJaxYbeQZdP9sKW8rzsm1rX4decKldCEKU+3H4XJS
         /Bcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=7HSRnH64j2wDhzw/uk66uUTVrlTEmvsn3KsRzD+ScCs=;
        b=KL2JmEE3nr947zMuS2MrRGekGTQZ5kbtXKXLy8h0P61rtW2NmbS2DlLs1qQzHI7yFE
         xY6IpLmApLU2rfCRRaa6LrFQwqTY4U42hW7eHNWQp5VuWI/RF9COz7n2WxyfnX4zUfIh
         yXvBPDwmQvLxJZFS4qwTjSrqnKfxWM+v+yl+q4wgZMvshz8enYsfyJVWJp0P6NKXyxto
         KftN6XZcIvT5mXtOQ1pXDlNaJRc63vM/wlt4uTSY1kgmJkXLWkEYloaLsnXM6/af4Ve+
         lSGRfDNtnv5Mm/Y4CpbwIu3/1oaK2/x546QB2aJQ6ZX7UOxo1bt3js1TwYy6MoFyTVUS
         9WWw==
X-Gm-Message-State: AOAM53038KosG4TSOvtWIXRD/bqbh1ATw1U51/S5rjMczYV1GfinZcC+
        bdbh6eO6l5HimE+avEDUTqc=
X-Google-Smtp-Source: ABdhPJyrJLvvpZc4I9kmwCRZYvMue6BFVPqv8GoS3QrGEgUQBp/IPvRzFoUB7jaAhZ8Oy7BvKvirNQ==
X-Received: by 2002:a17:906:b259:: with SMTP id ce25mr10508218ejb.245.1621607059129;
        Fri, 21 May 2021 07:24:19 -0700 (PDT)
Received: from skbuf ([188.26.52.84])
        by smtp.gmail.com with ESMTPSA id cn21sm4044296edb.36.2021.05.21.07.24.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 May 2021 07:24:18 -0700 (PDT)
Date:   Fri, 21 May 2021 17:24:17 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Ioana Ciornei <ciorneiioana@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: Re: [PATCH net-next 2/2] dpaa2-eth: name the debugfs directory after
 the DPNI object
Message-ID: <20210521142417.4xz3g26uts7h6ail@skbuf>
References: <20210521132530.2784829-1-ciorneiioana@gmail.com>
 <20210521132530.2784829-3-ciorneiioana@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210521132530.2784829-3-ciorneiioana@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 21, 2021 at 04:25:30PM +0300, Ioana Ciornei wrote:
> From: Ioana Ciornei <ioana.ciornei@nxp.com>
> 
> Name the debugfs directory after the DPNI object instead of the netdev
> name since this can be changed after probe by udev rules.
> 
> Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
> ---

Reviewed-by: Vladimir Oltean <vladimir.oltean@nxp.com>
