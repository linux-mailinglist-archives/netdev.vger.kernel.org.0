Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 005B924E959
	for <lists+netdev@lfdr.de>; Sat, 22 Aug 2020 21:25:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728641AbgHVTZh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 22 Aug 2020 15:25:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728633AbgHVTZf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 22 Aug 2020 15:25:35 -0400
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65E40C061573
        for <netdev@vger.kernel.org>; Sat, 22 Aug 2020 12:25:35 -0700 (PDT)
Received: by mail-pf1-x441.google.com with SMTP id d22so2754631pfn.5
        for <netdev@vger.kernel.org>; Sat, 22 Aug 2020 12:25:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=jubwHEgUJGTY0FcC8H9+yelce/MaPLkVZFVA8fh3nCk=;
        b=bxItjH7ZMvLjvpJs4A3aT84ug1pHVChC7bG2hGXnNFKv7I2XyMkWuRHWqhNpQZIV6H
         zuIn4B6qPKhwYO+IwtazBiqBNVQc5x6NEK/4nzhqJ7mgZJeYc78Is2wGKPiDSfU4W4rE
         B/HXOq3KYkkeJQ4hr0076BtAChsCvHtRcGi9tko8C59FP6U3Ohmym5P0+KL/gf8fP8uL
         m/gV7ospNX6ifduVYt8/hDY8hRw+743ZKR+aWWHKD6bZGQlQ6XV0J6rJRbVKgZ2qbl38
         Z3XUb+dshfMxLVBC1gQc8v7nrtn7gRTMfQter4IJk5AIGAJPhLyejXkyT1UrEKF1+UFa
         jhrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=jubwHEgUJGTY0FcC8H9+yelce/MaPLkVZFVA8fh3nCk=;
        b=c2k6baytMpgvhFRJTdQ9Y3MhF98WpCjKJpALxAVQArfrdSPOfnHGvfPi6Ga2Ob8Ej0
         qu6Ms3A4yLmGyJidIkUeit6dJEyr2YnvqgtAmECRL/LnejdkffraGyEh0vdKXOdFyB0X
         VtlXzkl3oQ6M6APMF0jvOWQKL+oBWNyvwuVKY9gymzAUTKGE/x52RhxTQUpJLSq69mf+
         nAZH+C5OlvUnfHafqsTI/2T5uea+hGoBcAvQeHCNDIoTbwKP6CWvjLP0VJUDzrVpLIGn
         ZNWDnpLKDDiTIKJm1CmrfOLYOjhcr9CSHBDBlJQHRME7DBzABrV1TeWy+3ulvagmwjZz
         H3ww==
X-Gm-Message-State: AOAM5315xK7djXgDqHwX13kqDAcR5SA2KOiX8sc6Wfe9bz1tqxjUoIEb
        WMoxdWOY91zMEqSDfx7zHT8=
X-Google-Smtp-Source: ABdhPJwhDoxX/cboUYIXP9IG9nzL6iDuJ4ftTXXVSwFBAUCYQXlnC2dIt2zPWbN2D+Ncu4VPnJ0QtA==
X-Received: by 2002:a62:1714:: with SMTP id 20mr7102169pfx.133.1598124334879;
        Sat, 22 Aug 2020 12:25:34 -0700 (PDT)
Received: from [192.168.1.3] (ip68-111-84-250.oc.oc.cox.net. [68.111.84.250])
        by smtp.gmail.com with ESMTPSA id p5sm994632pgm.66.2020.08.22.12.25.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 22 Aug 2020 12:25:34 -0700 (PDT)
Subject: Re: [PATCH net-next v3 1/5] net: pcs: Move XPCS into new PCS
 subdirectory
To:     Andrew Lunn <andrew@lunn.ch>, David Miller <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jose Abreu <Jose.Abreu@synopsys.com>
References: <20200822180611.2576807-1-andrew@lunn.ch>
 <20200822180611.2576807-2-andrew@lunn.ch>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <eab86cf5-08d2-892a-a000-1a34d69554af@gmail.com>
Date:   Sat, 22 Aug 2020 12:25:33 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.1.1
MIME-Version: 1.0
In-Reply-To: <20200822180611.2576807-2-andrew@lunn.ch>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 8/22/2020 11:06 AM, Andrew Lunn wrote:
> Create drivers/net/pcs and move the Synopsys DesignWare XPCS into the
> new directory. Move the header file into a subdirectory
> include/linux/pcs
> 
> Start a naming convention of all PCS files use the prefix pcs-, and
> rename the XPCS files to fit.
> 
> v2:
> Add include/linux/pcs
> 
> Cc: Jose Abreu <Jose.Abreu@synopsys.com>
> Signed-off-by: Andrew Lunn <andrew@lunn.ch>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
