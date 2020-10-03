Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC71E28222C
	for <lists+netdev@lfdr.de>; Sat,  3 Oct 2020 09:52:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725805AbgJCHwf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 3 Oct 2020 03:52:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725648AbgJCHwf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 3 Oct 2020 03:52:35 -0400
Received: from mail-wm1-x342.google.com (mail-wm1-x342.google.com [IPv6:2a00:1450:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A72F2C0613D0
        for <netdev@vger.kernel.org>; Sat,  3 Oct 2020 00:52:34 -0700 (PDT)
Received: by mail-wm1-x342.google.com with SMTP id v12so3932100wmh.3
        for <netdev@vger.kernel.org>; Sat, 03 Oct 2020 00:52:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=+e1wEjP2zKTA3i4arEFPGbCIAa6mi9SK5YGMFx2s/58=;
        b=hBEor5pS9SaMEtsRWgnVc2yZT+suI2XMURmgKtWXkNePefUE3MjXJU+AgNNsq+xQdb
         Hlx+bYZwd6uhm9jXA10jdRjM79yvr5EZC7EO3OFL2WziwDciUjELCOl1VhyrqbrpWcJM
         Qo0DGfylF9lBhobl17IAHtBNGfWzaGRzDzCZNspCTKlJczBBgGuEdIhqyJaMeSH1yHWN
         mSXUwYczvkWRJALzGsuIncpItO5fRrSnA75x2/uR9/JbuL/aB2ftAJHJmYS6+B9aHMiL
         uZ8vyKyxQcEK+gfNI5vaBd+DEE8WFldd90OPRJgYpuXUDSfAO8OH9MkTuRRzMnodSsmX
         qcIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=+e1wEjP2zKTA3i4arEFPGbCIAa6mi9SK5YGMFx2s/58=;
        b=rWkNi+ourVjDI9BUKnZdFwoaJVd9l3BFUCG1x2xWbSbTmEWlXjRrFpkiNQ7qOl3ITB
         lQJTflGGvuBmZUVjrM/9EA5YoBDangLgNYOSnR87av1h6Nu+kDzljPA7wz5SIcxF4TWz
         750qC51/EGpCSjrGlZ/OhsapklT0Gk9fR+DPU0D8lgQjDPnW3hq0qHNmL4AGdQI0DY7A
         tdeek9up0/MptTGIR4kRTXFIKSF64eAFHChZd+9+1bsJjyeEQzWsc0R0q6em/WyK/m12
         VUzcaOOBiCgRvpRiR67TJEa7dCcOp4ny41Tu3FKYZ91qNEcOLK3GxymChsp0pt970eUu
         8ktQ==
X-Gm-Message-State: AOAM530D6+JaiKJF0dLcDAMBOcc7nMtaeikmFpsp0STp3FO7jMU+leEQ
        8J1SR+Df574BhHNiqfpT0AXGLhYpe7c=
X-Google-Smtp-Source: ABdhPJz7VY8DI6UIz7dvRqbKIgT7uHgniub1SaR51nfs5fZrDt8HBBMmcn0JIsctJkEzIadCNsDM1w==
X-Received: by 2002:a1c:c342:: with SMTP id t63mr6337416wmf.145.1601711552464;
        Sat, 03 Oct 2020 00:52:32 -0700 (PDT)
Received: from skbuf ([188.26.229.171])
        by smtp.gmail.com with ESMTPSA id i9sm4332895wma.47.2020.10.03.00.52.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 03 Oct 2020 00:52:31 -0700 (PDT)
Date:   Sat, 3 Oct 2020 10:52:29 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Kurt Kanzenbach <kurt.kanzenbach@linutronix.de>
Cc:     davem@davemloft.net, f.fainelli@gmail.com,
        vivien.didelot@gmail.com, andrew@lunn.ch, netdev@vger.kernel.org
Subject: Re: [PATCH net-next 4/4] net: dsa: set
 configure_vlan_while_not_filtering to true by default
Message-ID: <20201003075229.gxlndx7eh3vggxl7@skbuf>
References: <20200907182910.1285496-1-olteanv@gmail.com>
 <20200907182910.1285496-5-olteanv@gmail.com>
 <87y2lkshhn.fsf@kurt>
 <20200908102956.ked67svjhhkxu4ku@skbuf>
 <87o8llrr0b.fsf@kurt>
 <20201002081527.d635bjrvr6hhdrns@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201002081527.d635bjrvr6hhdrns@skbuf>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Kurt,

On Fri, Oct 02, 2020 at 11:15:27AM +0300, Vladimir Oltean wrote:
> > Is this merged? I don't see it. Do I have to set
> > `configure_vlan_while_not_filtering' explicitly to true for the next
> > hellcreek version?
> 
> Yes, please set it to true. The refactoring change didn't get merged in
> time, I don't want it to interfere with your series.

Do you plan on resending hellcreek for 5.10?

Thanks,
-Vladimir
