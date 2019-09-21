Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 77E68B9F9E
	for <lists+netdev@lfdr.de>; Sat, 21 Sep 2019 21:45:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726522AbfIUTj3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 21 Sep 2019 15:39:29 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:43223 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726023AbfIUTj3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 21 Sep 2019 15:39:29 -0400
Received: by mail-pf1-f195.google.com with SMTP id a2so6638202pfo.10;
        Sat, 21 Sep 2019 12:39:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=omljAw/L3GlDUEULdQ29ows91lLPktIC2ep28HmSHbI=;
        b=c2KNtru5DaqrEwv/IPrf+VupRkcxkybVG9KAZayh1pic31XW2SFRW2NH7HTTl1turV
         jGn+dE6HnB7e3/hej1XmPD/gK5/lxRuKMgtn2RNvQEjnkCVqwSrX+VzXHorPelA+wc2f
         8T6s9Cbo3jp8TwAO1rIIEohpHQsOlUHnNh+9wWbcxZAS7K3e6hfctw7JpDoXLDAO+z3R
         yOCH+hiN09ZnAbuLnob3lAncfXYTSEGewCWAFt0dloQOPtAL7vst18x/dBiyldESI5Rc
         lVI8lYNkrhsBsgrKXhKbLwTji+exx4zdctb6HesDaA3HKCBssiGFwywA/3v7XPlzI7Fj
         bsFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=omljAw/L3GlDUEULdQ29ows91lLPktIC2ep28HmSHbI=;
        b=XPwxjXfp4gZoj9TKgzmd8DpyfPB4aRLlghXzzN8Ci431j60nvHEKyyhxynVoXkjgzw
         uO0S7wGChVediogxf+jJ1GfiRscmQNePGg7iccwPLZzMXmKdlX6Wvnq+eqH9Usko+Rjx
         L7XIfxxF9YULkfpDBhZlKZXlRChle6eHqSArkc9vM7Rk1xR+5AtVp4ZrOdEcYLFLnrR6
         COH/2SqT9VXM7RfJd2D67iNi60Hy38zCgQplZe1mCOivU7SZ9KHgBHEcam2XN1deezxX
         hwhPNE2FXhKDwN+XL0wvQGJ71yhy1/lygqGLLsUdH46pMFp5gTDKqVA1a73adqiauecA
         LIeg==
X-Gm-Message-State: APjAAAUrgYweNs2B1sYCuGm0IAgLfKGA5wDAv6RPUQBViJkPPubx2uVI
        3Y0ti3EuRC3syCXPqj0WKSThdmuMYLU=
X-Google-Smtp-Source: APXvYqwzqjzDSgvTsUzNJVQNCX82JRE8erzFWOFIfAtQ86IQiaHPdpeQMYB3bwThfu7gAnUzEh4prg==
X-Received: by 2002:a17:90a:b001:: with SMTP id x1mr11947550pjq.114.1569094767995;
        Sat, 21 Sep 2019 12:39:27 -0700 (PDT)
Received: from [10.230.28.130] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id a17sm6558688pfc.26.2019.09.21.12.39.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 21 Sep 2019 12:39:27 -0700 (PDT)
Subject: Re: [PATCH] net: dsa: b53: Use the correct style for SPDX License
 Identifier
To:     Nishad Kamdar <nishadkamdar@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Joe Perches <joe@perches.com>,
        =?UTF-8?Q?Uwe_Kleine-K=c3=b6nig?= <u.kleine-koenig@pengutronix.de>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20190921133011.GA2994@nishad>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <75c07fb7-61de-4cb8-8ac1-26b19a660890@gmail.com>
Date:   Sat, 21 Sep 2019 12:39:25 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.0
MIME-Version: 1.0
In-Reply-To: <20190921133011.GA2994@nishad>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 9/21/2019 6:30 AM, Nishad Kamdar wrote:
> This patch corrects the SPDX License Identifier style
> in header file for Broadcom BCM53xx managed switch driver.
> For C header files Documentation/process/license-rules.rst
> mandates C-like comments (opposed to C source files where
> C++ style should be used)
> 
> Changes made by using a script provided by Joe Perches here:
> https://lkml.org/lkml/2019/2/7/46.
> 
> Suggested-by: Joe Perches <joe@perches.com>
> Signed-off-by: Nishad Kamdar <nishadkamdar@gmail.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
