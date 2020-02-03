Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5AAE6150095
	for <lists+netdev@lfdr.de>; Mon,  3 Feb 2020 03:31:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727223AbgBCCbs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Feb 2020 21:31:48 -0500
Received: from mail-pl1-f170.google.com ([209.85.214.170]:39324 "EHLO
        mail-pl1-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726393AbgBCCbs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Feb 2020 21:31:48 -0500
Received: by mail-pl1-f170.google.com with SMTP id g6so5225787plp.6;
        Sun, 02 Feb 2020 18:31:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=QGuievnAz+6RxT39lvMX1qmMHH1n6M4mYtCvsmu3+1Q=;
        b=pigs9eQM63p5H04ey3FdHUmFgB7MUx1wQStmMuZl4tQvK0VXrU59T+YnyD34Hy+hkC
         SherjMBhXZtgI2vuyXcBN6ms5peGiEnO2zlfegU7WV9hmziqswZKYgy9hIJ1U7mkkqcR
         cURdB6n2PgcXOzNav4ktu5w/vvQF0tZ0rdAcmjGlZ0fg6tH53uk+sfNjygrUyJTwGuF/
         VtGS0WSOTn9HrdsOvEWFeMgbIjDHUM/P0+K2I2H9VydN7fpTidCEoK3hdKWU/DXUAg47
         WZQEHORuebu+Ild+0AuRu636l5xjsao1wgQl7o8bG7rSdbribp3a8dxfubCoj9Dj0uv3
         RKJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=QGuievnAz+6RxT39lvMX1qmMHH1n6M4mYtCvsmu3+1Q=;
        b=lb4Xv9vXn11OBkLYsNxoQAO2wcNVeZG4GQqnB8yL37PCdXcpxnZdqPO2U6tvibKIhk
         CRS5DQ8RQE6PolmD75NO6pa+x43nisSSVWpGgHCGoq0YUu4p52DFGGyCxD+K28MXVZUH
         mbSJQF7SLziVzTgqqnOss17Ro0wocDwrcH6ztKfGyRl8gQRc3NskVG5LUVBDRmYL9x4f
         B8LVdk2sszVwv7vWr1IGZKzCcHGVWW1Eg5EF2vP4GQM4J9Cq3JIjjQp2xcYc/9+imq2m
         86fwa47JaZDmIbmEp9iPZ3KiHoEQJDJgbAEPy/Q/lhoBFQKLaxbyk8SvV3NlBvx5SFr2
         mUzg==
X-Gm-Message-State: APjAAAVI1Ce+LTWwYsgDltZ6T9ROvC7AgCecRlNrbRhtfwheDSYRB76g
        /h/iveGinVq/sQbjgsSYaxA=
X-Google-Smtp-Source: APXvYqxyozJBj2jyETQwABoAjw1W/SVdfZlLh2nLUobJ5ZGTKJPVGVEo6goSIvNNB10cPMltJzjyLQ==
X-Received: by 2002:a17:90a:fb41:: with SMTP id iq1mr27423768pjb.89.1580697107688;
        Sun, 02 Feb 2020 18:31:47 -0800 (PST)
Received: from localhost (c-73-241-114-122.hsd1.ca.comcast.net. [73.241.114.122])
        by smtp.gmail.com with ESMTPSA id c15sm19682924pja.30.2020.02.02.18.31.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 02 Feb 2020 18:31:47 -0800 (PST)
Date:   Sun, 2 Feb 2020 18:31:44 -0800
From:   Richard Cochran <richardcochran@gmail.com>
To:     christopher.s.hall@intel.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, hpa@zytor.com, mingo@redhat.com,
        x86@kernel.org, jacob.e.keller@intel.com, davem@davemloft.net,
        sean.v.kelley@intel.com
Subject: Re: [Intel PMC TGPIO Driver 5/5] drivers/ptp: Add PMC Time-Aware
 GPIO Driver
Message-ID: <20200203023144.GD3516@localhost>
References: <20191211214852.26317-1-christopher.s.hall@intel.com>
 <20191211214852.26317-6-christopher.s.hall@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191211214852.26317-6-christopher.s.hall@intel.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 11, 2019 at 01:48:52PM -0800, christopher.s.hall@intel.com wrote:
> +static inline u32 intel_pmc_tgpio_readl
> +(struct intel_pmc_tgpio_t *tgpio, u32 offset, unsigned int index)

Coding style is off the deep end, here and in many following
functions.

Thanks,
Richard
