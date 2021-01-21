Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A8BA2FF7AA
	for <lists+netdev@lfdr.de>; Thu, 21 Jan 2021 23:00:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725950AbhAUV61 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jan 2021 16:58:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725283AbhAUV6E (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Jan 2021 16:58:04 -0500
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C2B7C06174A
        for <netdev@vger.kernel.org>; Thu, 21 Jan 2021 13:57:23 -0800 (PST)
Received: by mail-ej1-x636.google.com with SMTP id kg20so4323359ejc.4
        for <netdev@vger.kernel.org>; Thu, 21 Jan 2021 13:57:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=lBl8QeCxL2+lDoN1uhV69WCu5HFrXcaUez0p+kY5Otg=;
        b=ou579rIQecZAlyZa6nQQDQ19Hz8lgRSZzxDA0qz2up8C2enUOrA3W9lFaYBvtHXM0A
         UtyiWTAHTkXQq1Np9MbyvK8jc7+XSxX3xYG+pqccrpPlDzugb+yPpKARufM/udDqInwv
         zyec3Rvx2H2OPlCJEpQvET7EM38JXkOAxElFCA4C+YghNpktxJKR9E6/zxT6Wddqp3/e
         Wbi5eH9hKTZJ42Q4IhvCuSFZ1nopPu0/kHaVFTGtRwYGEZt+QxdXywfvLQInX7XhEPIc
         vUPgxUHv1gAvQvdRoylQcoilSghjBduV4INxj4DHb7f9ixkppQiWC36DhITTs8yQ3clm
         cI7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=lBl8QeCxL2+lDoN1uhV69WCu5HFrXcaUez0p+kY5Otg=;
        b=XhisCBgIbGNlxKclvk2sq/6j+R2uB6pz+hIsCbeGhJkC1iPyZEbVISJ87QDBX6HIvj
         jE9F2nAg7HC7Fk7tFQfLoO0MCkQEDIIulF0P5CA8kGeAhuDKQt5fXlUdApJOCIy5jwq+
         8Z7AsjeowAULKCLdwcbsg1MhBm/B89Z3FixXzqNfXmeKa/KcXIQmiY4Zx4PqJXf9/47l
         cj5ljOpyI767vQHCOBZHpuKHFj6hoPsHhJ+otDkeNa48C99vN80i8v4lgndikKGUE1eG
         F9jy6TPyOSdGsI/i9LZ1O9Nw1K5aFO1pLIsbSg0OVS6KCv0aKBJXFYPkE1tz0d9STqFa
         yTdw==
X-Gm-Message-State: AOAM530lYfEGUdGdOGxQq1NPpY4xgpQ9abm4mmA2llAPSjRn9wTYGpdA
        p4QYE5rCfDHJ3YUU4e/mI2L4i2N8wnE=
X-Google-Smtp-Source: ABdhPJy04MFqTZEHTBEpkhuJdDH2C7jhhAUukaTTNqt8FXPbkbvFdsQs8pGZtEWkxO3a/sZsva2yeg==
X-Received: by 2002:a17:906:e106:: with SMTP id gj6mr944615ejb.337.1611266241943;
        Thu, 21 Jan 2021 13:57:21 -0800 (PST)
Received: from skbuf (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id da26sm3531545edb.36.2021.01.21.13.57.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Jan 2021 13:57:21 -0800 (PST)
Date:   Thu, 21 Jan 2021 23:57:19 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     David Ahern <dsahern@gmail.com>, netdev@vger.kernel.org
Cc:     Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Vedang Patel <vedang.patel@intel.com>
Subject: Re: [PATCH iproute2] man: tc-taprio.8: document the full offload
 feature
Message-ID: <20210121215719.fimgnp5j6ngckjkl@skbuf>
References: <20210121214708.2477352-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210121214708.2477352-1-olteanv@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 21, 2021 at 11:47:08PM +0200, Vladimir Oltean wrote:
> +Enables the full-offload feature. In this mode, taprio will pass the gate
> +control list to the NIC which will execute cyclically it in hardware.

Ugh, I meant "execute it cyclically" not "execute cyclically it".
David, could you fix this up or do I need to resend?
