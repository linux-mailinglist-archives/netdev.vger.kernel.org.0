Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 34C873A1C6F
	for <lists+netdev@lfdr.de>; Wed,  9 Jun 2021 20:00:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232007AbhFISCU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Jun 2021 14:02:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231994AbhFISCU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Jun 2021 14:02:20 -0400
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC324C06175F;
        Wed,  9 Jun 2021 11:00:15 -0700 (PDT)
Received: by mail-ed1-x52d.google.com with SMTP id cb9so29582156edb.1;
        Wed, 09 Jun 2021 11:00:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=XTleE4OXliqPhj12s6Rtsmrla5POTQLFghvGSQr5HlY=;
        b=JydbqUXaL9J/F6vK2vg/keJuHJoDJPklyCgJSZY0sWd3ZkBEnaKKpzhWWnJBTpxWjF
         ituGwuKNL4BPqbF1llfxwiUqG8A8I0bWnYPIKpiRl79wasyPXLvE8IyT2Q/HvWjEhs8G
         nvKhdZgVj+WuZMO7hbzhZ07GJqxwUSY51DSUezqDRzQVhGLKEqVul/HKZJDaNc+iJxUu
         aK404CWU1OGsXzyIJ/lpXNlrdUvzHG2rGCjWEzRib6g/TfUTwc7lwoNgjNizG7Re7Xln
         wb3v82Qz58+z/VuQtE4kRxEZsVmy3cG/Zni/EWS0aR7xmBqJ0gxhkUT0bV33A7k1SPf9
         pSmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=XTleE4OXliqPhj12s6Rtsmrla5POTQLFghvGSQr5HlY=;
        b=L4qPCl4yFEXFfFcXv652aUczMa7q+Z+oeBRZZndoMEkakdsOMTAoNq0yD7vmjAzmTv
         C5928Dd4nePyA6CgEbDJrHv3GhG2zOK0nRV5PavHvN7Vphnk7dkwEf9uO4Pe7Y4L7Xn5
         rNxAdxxgXB7bVkrVPMM1AXYHTX6Cqnxg+10YDVpIUsKR3A76N/eOa2LPI7aZmim01OTF
         IMYohJkJ5jaGmAZWGTzWOJSkNFSZ0zggknW1YFo4j3pLxBeOEbHGxg1ME8cl3ENxJvXU
         IbXE4WwEKLsxrVNy4Jz89UQxOwY33PG624GtFD0sKwKrNGHGwFAQm/kC5QSsgusTB6tq
         9COQ==
X-Gm-Message-State: AOAM533yQD7dL1uM4vLmW6p9FRFdsf+oUCRftlAvn6TCPqgV+75HbbFp
        AnoPCeMQbmxC82mAUC1s2bU=
X-Google-Smtp-Source: ABdhPJwAYIOfC6IQjgcc5NLlvUe7F7J/zXYAmIc5YMW9e0U2H3DwxDeGFeTwd7jKidRncN6A1Dl6uA==
X-Received: by 2002:a05:6402:11d3:: with SMTP id j19mr617576edw.247.1623261612614;
        Wed, 09 Jun 2021 11:00:12 -0700 (PDT)
Received: from skbuf ([188.26.52.84])
        by smtp.gmail.com with ESMTPSA id y25sm197963edt.17.2021.06.09.11.00.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Jun 2021 11:00:12 -0700 (PDT)
Date:   Wed, 9 Jun 2021 21:00:10 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Colin King <colin.king@canonical.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH][next] net: dsa: sja1105: Fix assigned yet unused return
 code rc
Message-ID: <20210609180010.i5atyzqpc7dnyamw@skbuf>
References: <20210609174353.298731-1-colin.king@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210609174353.298731-1-colin.king@canonical.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 09, 2021 at 06:43:53PM +0100, Colin King wrote:
> From: Colin Ian King <colin.king@canonical.com>
> 
> The return code variable rc is being set to return error values in two
> places in sja1105_mdiobus_base_tx_register and yet it is not being
> returned, the function always returns 0 instead. Fix this by replacing
> the return 0 with the return code rc.
> 
> Addresses-Coverity: ("Unused value")
> Fixes: 5a8f09748ee7 ("net: dsa: sja1105: register the MDIO buses for 100base-T1 and 100base-TX")
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> ---

Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
