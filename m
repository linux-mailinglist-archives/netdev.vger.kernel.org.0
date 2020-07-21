Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 670132273C5
	for <lists+netdev@lfdr.de>; Tue, 21 Jul 2020 02:27:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728099AbgGUA1X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jul 2020 20:27:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726546AbgGUA1U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jul 2020 20:27:20 -0400
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D538CC061794
        for <netdev@vger.kernel.org>; Mon, 20 Jul 2020 17:27:19 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id a23so8289998pfk.13
        for <netdev@vger.kernel.org>; Mon, 20 Jul 2020 17:27:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=A0H0VXDZXRX1mfXMuCZTUnDDeRTH8o7afUE55rVwCR4=;
        b=ldXzXLBxSWxtzOFbwPKlq43UJHustFXmBhfYgqDuZWXdsy36qnxGGuOSFrIlJQoj4a
         lvAdxFh3O0rKm3Lz2qUX3h75mW3ZBbmF8LK6/ihg8nypDsR/paAql1z6GNVJnN8EpFab
         AJ5I1It1HlEC9lYVXPvBv4gueYoLOA4/JD0eTp/GIJ4lrJ5CGWVPdDgtY8fPSbFWg/Uw
         rkBhqSX+PFDmy2J+nZ6b23RSNxUMR+5kufss9rPCl2ggLUEeXhjB3EpMgvCunvZiBlkz
         kx373DqhLvhDJT01ZJDPs1gstawpTOz13WzN7xrmvF9pMjJ7/IjUGjov9uJ7/hSwd6nq
         WjQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=A0H0VXDZXRX1mfXMuCZTUnDDeRTH8o7afUE55rVwCR4=;
        b=fHNolmYDHNVv0qFujbOBjmTSdTz1R8CFQNLeAlZJosaVAGoJgzSiBpV70H/rj0GY13
         sITFsqp53ysbBRKqpmlZH9ib3zfUUzH+T1YgjQq5Wxz0RHBAo9bXcbFSAps0lJRphTCP
         qTKbOFFXGhcjMMVhoxn7sCKO0JqoPvcUwea5sOfaiOXgZQQBh2E3/AlAmB98S1kmr2M2
         V4vrV0EHF75drNOVzVziFhGBBxHDb9T6jWfW+xe2F33UPO00W0yIG7lIXrGB+YQDHQLf
         rw20BEK37uuFL+yAjr0U+XLG8IwItIgfPE4yuE6h0/JIFZ7+6n2j18QLovfppfY1Pcrc
         vMQA==
X-Gm-Message-State: AOAM531SFA6GvFLR4aJccDaG1NeKpfJXZA6I8kDWh57FYWUjnO5VFab+
        WhIzFsM+uNFodwXcG8WY2Kc=
X-Google-Smtp-Source: ABdhPJxy/R/l0i40ZTKlglWfR5JtI5qZ9+wYUISuTxE2eL01l4t+IXwL9LZsePL68jLp2y0RlNcY8g==
X-Received: by 2002:a63:8c4a:: with SMTP id q10mr20912275pgn.431.1595291239405;
        Mon, 20 Jul 2020 17:27:19 -0700 (PDT)
Received: from hoboy (c-73-241-114-122.hsd1.ca.comcast.net. [73.241.114.122])
        by smtp.gmail.com with ESMTPSA id z66sm17821010pfb.162.2020.07.20.17.27.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Jul 2020 17:27:18 -0700 (PDT)
Date:   Mon, 20 Jul 2020 17:27:16 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        jacob.e.keller@intel.com, yangbo.lu@nxp.com,
        xiaoliang.yang_1@nxp.com, po.liu@nxp.com,
        UNGLinuxDriver@microchip.com
Subject: Re: [PATCH net-next 1/2] testptp: promote 'perout' variable to
 int64_t
Message-ID: <20200721002716.GC21585@hoboy>
References: <20200720175559.1234818-1-olteanv@gmail.com>
 <20200720175559.1234818-2-olteanv@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200720175559.1234818-2-olteanv@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 20, 2020 at 08:55:58PM +0300, Vladimir Oltean wrote:
> Since 'perout' holds the nanosecond value of the signal's period, it
> should be a 64-bit value. Current assumption is that it cannot be larger
> than 1 second.
> 
> Signed-off-by: Vladimir Oltean <olteanv@gmail.com>

Acked-by: Richard Cochran <richardcochran@gmail.com>
