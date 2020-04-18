Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 385E21AE9A3
	for <lists+netdev@lfdr.de>; Sat, 18 Apr 2020 05:25:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726039AbgDRDZi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Apr 2020 23:25:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725320AbgDRDZi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Apr 2020 23:25:38 -0400
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 247E8C061A0C;
        Fri, 17 Apr 2020 20:25:38 -0700 (PDT)
Received: by mail-pg1-x544.google.com with SMTP id o185so1534500pgo.3;
        Fri, 17 Apr 2020 20:25:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=vahrfACs2y5f37nxGcM9iphK6jP0kqTw/nGTVidSrU4=;
        b=BY4777laUdrE7cgHl1hmTc+43MZS4nROL/ue2OPhg+EJ0Iere97wciqaj6q/UhAOQ7
         /4JAS7ngMxizUAfsrdLSFNEvAMZs+AOFKQ7L+J8NbXc2wUGzPsJifL/0MQ9xg03R+oxs
         Rqn64qDr2qCzLIRLoZ0Bl1+VnL6eTE070DF6+2oSB0E4zWBE9hL/Lg4sgliFPExqFo8e
         fbMtrzxw3uzHJGA96PKVvUCcNfURuHx2SV5Gh6T1b6xep9pr6rG+p/IKZ25j+uB2X1q6
         /ZPih+Bo34xyhJwhctRXY+64AC+6l+fnXbUHUQG+dywoqhxl/xukf6kkFrjYPeR2AavT
         qQAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=vahrfACs2y5f37nxGcM9iphK6jP0kqTw/nGTVidSrU4=;
        b=rF4GqARlBRuHj8DA6E2ISZ0xL9WPQQpx6SZxuIk4ReRbzy26HYiH7OeR1dBKO1PvBD
         VwRpn0Kilbz8W0uHMTuZ0xyxpv63C3TmY59yXAcqY8KQUvEP6KEZ74vsgGl1BZeIEHdN
         4T1Twqm3FLQ8fDd9rT5dyteiz/2Iv1x434YMyO8ZYJr2miBjytbpeNXO3bQK5fTtb/Gg
         X/Q49NW3/avHVmDgH3aU5HAfWouLZZV2gWkpLwR5BYNpAvrYqneIJ4SeOAd5FtzRpXmZ
         cv8VzR8KW2pDGzzOy//58Nv8ZrnBy5s36d/aL/PLAT4KG+SaVyaIahAffqUKKlqS4BLK
         Qn+w==
X-Gm-Message-State: AGi0PuYLZVXG0lQQ4KOPJiac1jJ9799qEIYGb8kIzQFLsEZsMvcVjhQO
        yA7h3PkG1X+Aps1OPwKIc+g=
X-Google-Smtp-Source: APiQypJ+aekVZMbjelG1TXLVHBqkky4BJJ9cQ7zpGFWqJ7Qyz5lysYEg9oajKYCxduEdYeFd+un2JA==
X-Received: by 2002:a63:5f01:: with SMTP id t1mr5944884pgb.186.1587180337749;
        Fri, 17 Apr 2020 20:25:37 -0700 (PDT)
Received: from localhost (c-73-241-114-122.hsd1.ca.comcast.net. [73.241.114.122])
        by smtp.gmail.com with ESMTPSA id u13sm3776231pgf.10.2020.04.17.20.25.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Apr 2020 20:25:37 -0700 (PDT)
Date:   Fri, 17 Apr 2020 20:25:35 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     YueHaibing <yuehaibing@huawei.com>
Cc:     davem@davemloft.net, pbonzini@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] ptp_kvm: Make kvm_ptp_lock static
Message-ID: <20200418032535.GC9457@localhost>
References: <20200418015154.45976-1-yuehaibing@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200418015154.45976-1-yuehaibing@huawei.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Apr 18, 2020 at 09:51:54AM +0800, YueHaibing wrote:
> Fix sparse warning:
> 
> drivers/ptp/ptp_kvm.c:25:1: warning:
>  symbol 'kvm_ptp_lock' was not declared. Should it be static?
> 
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>

Acked-by: Richard Cochran <richardcochran@gmail.com>
