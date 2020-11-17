Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 783122B5A72
	for <lists+netdev@lfdr.de>; Tue, 17 Nov 2020 08:43:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727012AbgKQHmh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Nov 2020 02:42:37 -0500
Received: from mail-wm1-f65.google.com ([209.85.128.65]:50710 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726272AbgKQHmg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Nov 2020 02:42:36 -0500
Received: by mail-wm1-f65.google.com with SMTP id h2so2290935wmm.0;
        Mon, 16 Nov 2020 23:42:35 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=xWp1eHqxJnsfkTXNJY856jqkL7WhZdMDgB3LhjYCpkU=;
        b=M8iMefPnr9kyO6pFwDMZi3nWpF19blpXnsBPQygkVXtYAhGy8H6ePYVNZTGIWYsDi0
         YCdyI3pPTRKGAxEUZ2JdirLhyYg1gWVpD6RKqTkjitsqZsYOe2sEM4aaPdnGyDTEP2Pc
         hLjJEypnsDlKXMWTft8HFRxodMc4ASkDBZhNwA7jtQHVhko5j0yA13DkaSKR0Vbr6QZt
         Tc7S6+UfoMBaDQgYFW694CuOQMgVitP371KYWdjzIOYV+AjCTEUBbs4YB4iBlH8Y9bN4
         6KvnVsTCAi2Myq9A4c5rFkh5PMpJrMclEkPQXDInYCfr9Xv7fryp5litS67X07GaLbYb
         33xA==
X-Gm-Message-State: AOAM532KHE8F5ojJxnj+nxbalonKbFTGEmBj4U+Hkax5P54b/iVJIhCG
        8FHIZQ5DIomjYlQzcuwBIjig+D5vXQE=
X-Google-Smtp-Source: ABdhPJzALsxAg5KaT3kOTwptjvp8LII9u6EUdpnh08YKxeIcahOtj/XHoV6s7MpPfXSq2Bd30L3Jeg==
X-Received: by 2002:a05:600c:286:: with SMTP id 6mr2654961wmk.125.1605598955112;
        Mon, 16 Nov 2020 23:42:35 -0800 (PST)
Received: from kozik-lap (adsl-84-226-167-205.adslplus.ch. [84.226.167.205])
        by smtp.googlemail.com with ESMTPSA id a12sm25749440wrr.31.2020.11.16.23.42.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Nov 2020 23:42:34 -0800 (PST)
Date:   Tue, 17 Nov 2020 08:42:32 +0100
From:   "krzk@kernel.org" <krzk@kernel.org>
To:     Bongsu Jeon <bongsu.jeon@samsung.com>
Cc:     Krzysztof Opasiak <k.opasiak@samsung.com>,
        "linux-nfc@lists.01.org" <linux-nfc@lists.01.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next v2 2/3] nfc: s3fwrn5: Fix the misspelling in a
 comment
Message-ID: <20201117074232.GD3436@kozik-lap>
References: <CGME20201117011742epcms2p1fb85ba231b3a1673d97af4bc1479744f@epcms2p1>
 <20201117011742epcms2p1fb85ba231b3a1673d97af4bc1479744f@epcms2p1>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20201117011742epcms2p1fb85ba231b3a1673d97af4bc1479744f@epcms2p1>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 17, 2020 at 10:17:42AM +0900, Bongsu Jeon wrote:
> stucture should be replaced by structure.
> 
> Signed-off-by: Bongsu Jeon <bongsu.jeon@samsung.com>

I already reviewed it.

Reviewed-by: Krzysztof Kozlowski <krzk@kernel.org>

Best regards,
Krzysztof
