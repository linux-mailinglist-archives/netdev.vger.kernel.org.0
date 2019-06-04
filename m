Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 99D7D349E3
	for <lists+netdev@lfdr.de>; Tue,  4 Jun 2019 16:17:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727506AbfFDOR2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jun 2019 10:17:28 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:46784 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727456AbfFDOR2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Jun 2019 10:17:28 -0400
Received: by mail-pl1-f194.google.com with SMTP id e5so6663392pls.13
        for <netdev@vger.kernel.org>; Tue, 04 Jun 2019 07:17:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=t53c+g29++aufg4ku8oGeYVqZy53q2Ilie5wLRkOmRg=;
        b=Y23DOg92uOseSKrqphJ1LBe/t1OfwAthyY36qfUO6wHN+GtJn76iApBsbrZzkyogsV
         R0PSRnKPyp00cQSi++or5XVsReQwKoCczE6fTqcQrSS8aKDiGl8LtI+VyL8/0LaEICXY
         MJ71wte3avee2EZoa1TOZ0EBZp/dBM0F9OG5sTa4n/yr06tT+ZtFj0bpRLJp78OfhXR+
         L1aINjU0UsbJc+F3f3kxR3YDDg9HgCd3N46SppbF1/ghDrcp8GJMWPSuhiJ38PQBU7Eh
         m6crbITz6op8lyMUQca/10TN+tHY1tSgMd3o0g5lpmhovQZCvnBz6KsNWyFkIwB80YzT
         kg1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=t53c+g29++aufg4ku8oGeYVqZy53q2Ilie5wLRkOmRg=;
        b=MS7CZd76BMDvNzmI2HrABWYpQQzqC5CwjqEoTSyDX6ubDusIUAJUh/y9VjLUVITlRX
         ERHIp6N9pFWPlU6LbWm4fPvGtyMwVWiT8CDINPEDPr8dBpSJAeWBafoVj4+1psO4x8ZU
         mwQu3IWgpu7rqG8ocDaH0WM7BvO0CudGPBxChlxy27NfmA8aquaZdHqeabD3zZqDIoF8
         FW8xaUDSf0L+IEn5urA3MSfcRa7fx1Eq5Y4CY/H8Mr2VRRSR0J94uGpBe371F83Q39K8
         sIfFRv07bd3TImzRnOlqDuJEl84QYLIQKOUsdtEVE3TWGk8oLjA7FF4gn+oMJcJGyiBy
         kBoQ==
X-Gm-Message-State: APjAAAW0TfiCID/ZJBuPsK54HZv7sBbn3VgCFRB8rqqVUKsT+zN6c4at
        bB/UN2d1g+0l4lt/Phl0e1+/cQAW
X-Google-Smtp-Source: APXvYqzd18Y9PoumZkrKpWO0f9BZ2oSsSBKru/9UEushvMh0gd/eJnEwCYJcAMnCwu1JA4YgDwVN6Q==
X-Received: by 2002:a17:902:12f:: with SMTP id 44mr36678969plb.137.1559657847909;
        Tue, 04 Jun 2019 07:17:27 -0700 (PDT)
Received: from localhost (c-73-222-71-142.hsd1.ca.comcast.net. [73.222.71.142])
        by smtp.gmail.com with ESMTPSA id 2sm19038983pff.174.2019.06.04.07.17.26
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 04 Jun 2019 07:17:27 -0700 (PDT)
Date:   Tue, 4 Jun 2019 07:17:24 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     Ido Schimmel <idosch@idosch.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, jiri@mellanox.com,
        shalomt@mellanox.com, petrm@mellanox.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: Re: [PATCH net-next 4/9] mlxsw: reg: Add Management UTC Register
Message-ID: <20190604141724.rwzthxdrcnvjboen@localhost>
References: <20190603121244.3398-1-idosch@idosch.org>
 <20190603121244.3398-5-idosch@idosch.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190603121244.3398-5-idosch@idosch.org>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 03, 2019 at 03:12:39PM +0300, Ido Schimmel wrote:
> From: Shalom Toledo <shalomt@mellanox.com>
> 
> The MTUTC register configures the HW UTC counter.

Why is this called the "UTC" counter?

The PTP time scale is TAI.  Is this counter intended to reflect the
Linux CLOCK_REALTIME system time?

> +/* MTUTC - Management UTC Register
> + * -------------------------------
> + * Configures the HW UTC counter.
> + */
> +#define MLXSW_REG_MTUTC_ID 0x9055
> +#define MLXSW_REG_MTUTC_LEN 0x1C

Thanks,
Richard
