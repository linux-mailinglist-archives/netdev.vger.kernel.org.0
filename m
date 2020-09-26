Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3CF47279CCF
	for <lists+netdev@lfdr.de>; Sun, 27 Sep 2020 00:52:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726840AbgIZWvs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Sep 2020 18:51:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726311AbgIZWvs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 26 Sep 2020 18:51:48 -0400
Received: from mail-ej1-x642.google.com (mail-ej1-x642.google.com [IPv6:2a00:1450:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 373DFC0613CE
        for <netdev@vger.kernel.org>; Sat, 26 Sep 2020 15:51:48 -0700 (PDT)
Received: by mail-ej1-x642.google.com with SMTP id e23so3424093eja.3
        for <netdev@vger.kernel.org>; Sat, 26 Sep 2020 15:51:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=l3DaErCPSWYtVrZ7WlZ62e3IsBrTRwJTFY/M7uSgxvM=;
        b=oS+iJdDRwTZHd1M/vAX5UiUt6yotpsdC/XgC1t/Sru4xAYQEvvh4IFT7KmRcWZu0aV
         Rcw9XSzmVELwsTxnUKQCh9+chtHqZLZeNrb2DBecTRjvF02TAwao36nCN0/4owKJRia5
         bpSl0MoIU/ExmVnUbJHs/NWeBNfcnrW+A8+6UXNUDv7Lh3esZPu3yegTKB13aNpWlmmL
         ik8k5ycediTgm1/RpRQAB8h6UGKqdLAFKnrKWjz5SMRv4fnaM4OangP1lztr9bndrYzk
         0La6/qaRRdbJiRy+Xz9rCfHJsiL3ejIgkk9pVlC01BLFHJzAiBQpC5FBxLiUJqV3HuA3
         oW+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=l3DaErCPSWYtVrZ7WlZ62e3IsBrTRwJTFY/M7uSgxvM=;
        b=XblKF9JFHe78hj6Qk2K/21x5eWqbyArqJcHqmlxviTjvFkt8/r80PN9adzAd97a/SB
         fj4udWd9ndKs8hun3WLCYiwvIcmbQpjuFgEy/tP/zV61JJqclHQWKp6iaRUymPsxnGXG
         qdfKzn3x+TrFflNsIlvNVK0412xn3AlFgOvJh7x3XG+QJmyssh3HYarGttYnC0KIBINN
         fR6zJZGxgc4Uoqiql5+6vuQMGRVLLg6obOxC/hYHo2/3ANAVitK8f76t3x8JhBRuPmaZ
         JOht67Njg3b5AX3XJJnKnIx2g/cF7pGUmMAw26hhG2oz5ct2H0uU6NW8OTkDgJ/6Ijc4
         MJhw==
X-Gm-Message-State: AOAM533qAlEojdtsIVm1X9lDl0mZ6GAUX19yMeKPncatOFa6dGToMt6F
        I08n3QCdLw6SlfMhkB13n0ltBfzGhUY=
X-Google-Smtp-Source: ABdhPJxmVRCeSPYxu2oYs/vW1p0j20zZIzdhhIn31JAhZ3ycfTQzcU/4WDDsfUUwbasOSxCF8K/cwA==
X-Received: by 2002:a17:906:5509:: with SMTP id r9mr9317079ejp.12.1601160706769;
        Sat, 26 Sep 2020 15:51:46 -0700 (PDT)
Received: from skbuf ([188.25.217.212])
        by smtp.gmail.com with ESMTPSA id u15sm5398816edq.96.2020.09.26.15.51.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 26 Sep 2020 15:51:46 -0700 (PDT)
Date:   Sun, 27 Sep 2020 01:51:44 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     David Miller <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Jiri Pirko <jiri@nvidia.com>, Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH net-next v2 2/7] net: dsa: Make use of devlink port
 flavour unused
Message-ID: <20200926225144.n6bdhdvsxip57cdg@skbuf>
References: <20200926210632.3888886-1-andrew@lunn.ch>
 <20200926210632.3888886-3-andrew@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200926210632.3888886-3-andrew@lunn.ch>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Sep 26, 2020 at 11:06:27PM +0200, Andrew Lunn wrote:
> If a port is unused, still create a devlink port for it, but set the
> flavour to unused. This allows us to attach devlink regions to the
> port, etc.
>
> Signed-off-by: Andrew Lunn <andrew@lunn.ch>
> ---

Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
Tested-by: Vladimir Oltean <olteanv@gmail.com>
