Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CDBBF3E2867
	for <lists+netdev@lfdr.de>; Fri,  6 Aug 2021 12:16:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245010AbhHFKQ4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Aug 2021 06:16:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244773AbhHFKQs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Aug 2021 06:16:48 -0400
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B437C061798;
        Fri,  6 Aug 2021 03:16:28 -0700 (PDT)
Received: by mail-wr1-x42f.google.com with SMTP id k4so10436036wrc.0;
        Fri, 06 Aug 2021 03:16:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=in-reply-to:to:cc:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=ow/YCifQJGCqqdbMI3qwBTpDZquMwyp33IWsPkh/PBk=;
        b=SCGPwxQ6KgkiYy5MzVMWte93J3GhGS0pJpxCILWPJYqM9CVJfJcNEYdhe+Fa946bwf
         /QcpMwzY5VVNPjUzfBCL8vgaN7RDHvCzuCUksogEahUKF5Yp2H2sLmTsLzc7CAdxtN/9
         17vPe5rrl9EAbwuVejV68rz+kQK5WD0OjmADECeDOsMyVESHuzupIvUfz973BXqYhqV4
         mRy9o/pOzhRHZWY8KFMGYMFnxhGj0/MXjUIhATdrN1aAf2iEhn5d6ERGEeqrUwB+fR1x
         HYI83rzvM8qMImZOiHbe/q/DS3yUxoGIp4GxawwPFQb6MvdnEpo0mvCJoxuNRCgZJHa8
         a5Ww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:in-reply-to:to:cc:from:subject:message-id:date
         :user-agent:mime-version:content-language:content-transfer-encoding;
        bh=ow/YCifQJGCqqdbMI3qwBTpDZquMwyp33IWsPkh/PBk=;
        b=f6JT+77CBLPxbkN+RGj+7ytxKJYY+oY+KbuYwq91GzrusnlVeFlw3FbgvpfyQhZVLJ
         IifiegEH5flyacuV6ilmlx1MQIVG2cPCL+q/Vx4j8NSPgKTfE20k1voHmTLgv2HQaeHt
         zHHa3PD55zqqOkhBwc6m7+MVjsH8zw0dc/R8lIxtsqyuVT+9+RE53PeThUk8+4UyjMr0
         pZvC3PL7j6OXuW3H/XRuzay3FGSXB7eDQW+1jngrOWrlZQEkOfZZFIYiN8S0KLCY0Gu0
         HMfYaQLTDR7vhCh6wAtx4Wxeujv5rPdlFLuWWYxVZ0eyiLcnOUPkqhjGpEB4vFONKO91
         e7tA==
X-Gm-Message-State: AOAM530lhZ5eWr9F2y5OsoFqEw3f7bazlGTvlbF/nbvD+0XLgLPdrWI5
        2oEO72trLBuota1qfrJJMDE=
X-Google-Smtp-Source: ABdhPJwbkvbgiTRgY5IR0dovVLsrUIQhDeHx8JeQV7DNUG5VSTN/HhalGtbn44s/F/jw8PZO1ebkzQ==
X-Received: by 2002:a5d:6102:: with SMTP id v2mr9565416wrt.223.1628244987322;
        Fri, 06 Aug 2021 03:16:27 -0700 (PDT)
Received: from [192.168.0.10] (105.72.60.188.dynamic.wline.res.cust.swisscom.ch. [188.60.72.105])
        by smtp.gmail.com with ESMTPSA id z3sm11726983wmf.6.2021.08.06.03.16.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 06 Aug 2021 03:16:26 -0700 (PDT)
In-Reply-To: <20190208132954.28166-1-andrejs.cainikovs@netmodule.com>
To:     ezequiel@collabora.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-can@vger.kernel.org
From:   Andrejs Cainikovs <andrejs.cainikovs@gmail.com>
Subject: Re: [PATCH 0/2] D_CAN RX buffer size improvements
Message-ID: <4da667f3-899a-459c-2cca-6514135a1918@gmail.com>
Date:   Fri, 6 Aug 2021 12:16:26 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Ezequiel,

Sorry for a late reply. I'm the author of this patch set, and I will 
have a look at this after I obtain the hardware. I hope this is still 
relevant.

Best regards,
Andrejs.

  > Hi everyone,
  >
  > This series was recently brought to my attention, in connection to a
long-standing packet drop issue that we had on a Sitara-based product.
  >
  > I haven't tested this personally, but I've been notified that this
was backported to the v4.19 kernel, and the packet drop was fixed.
  >
  > It seems the series never managed to get upstreamed, but I think this
should be resurrected and merged (probably with after some cleanup/review).
  >
  > Thanks,
  > Ezequiel
