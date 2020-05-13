Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 50FE21D1819
	for <lists+netdev@lfdr.de>; Wed, 13 May 2020 16:58:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733191AbgEMO6z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 May 2020 10:58:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728841AbgEMO6y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 May 2020 10:58:54 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 771BBC061A0C
        for <netdev@vger.kernel.org>; Wed, 13 May 2020 07:58:54 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id fu13so11092677pjb.5
        for <netdev@vger.kernel.org>; Wed, 13 May 2020 07:58:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=8cTaO0HGQkZMLZJDnE84KqpjNIIcRtZLdLfWnFrVAnU=;
        b=JU+XwxGQyGMgH+XRIP1ZgLAfyRclvd/IKwCOpJErhmEsYUCdf5vsy4bXDJDL/ozuEz
         1Nz9w9ojyM7xEWxZAvJRq/oS9vun/iP2Zsu89xUiOf7h29SYhnXZKOrwL/ercjUFuFHF
         eU58QD2C/HHhfnI2/krVXXyqrOOmCGZ+D8Samw/LyzkgCWQfGPzlp1nGrd8ORLp1JF8x
         p+xKRfM5MAKREQwsAeWESsZosbah/pFMUffROw/1lZ7Vjb6hmxn27SMogg/B2m7EWLEq
         Q6IXX5gig85ajpHyqkbx1rtd72899mfrWEqIUdxGa2B0KPSkDtYlLUrYsOZWhZ5DWv1p
         KNfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=8cTaO0HGQkZMLZJDnE84KqpjNIIcRtZLdLfWnFrVAnU=;
        b=TEmFqZ+cBjtSYKYqGcM+f/W2OKMNEOfeyL6yFRxka45KUyqk0xJe5dtfstOvRt3cvb
         6ifUtY2IQEpjadceVhLh4WjBjg6jZd02mgm7VseJdU9caa9X1GEOp/lOcLICbn1PB6h4
         nRO3vCoLYO70ImJs768EM6KrSwBTrKlWEGdK8JvVftL5QPLkSKtOp4LlmqHEdJ05RkKH
         W/UA6fKfhW3NDw9KVRWy0MKHkUgUnwpCgfPUf9bADC2Rbw/jMWxuopXkcPOYO6L8tNRv
         uVjwz8/n3nOZQIBM9z9kJNa3zGOstkTawvWVR6h+Mtv9B1ShDd0yjM25hINP/c9F+PP3
         RC8w==
X-Gm-Message-State: AOAM532rFp5sQR0pjhcfnDJ5h5EcxVYmRL5S7angHiqf51ns1FtMBv8M
        oJUS1mnhvMBLZbTlqIyA2hiOLdj0
X-Google-Smtp-Source: ABdhPJxuxuVr7lZQ1y1riHqe5k6Zl/2ehBcJatEC3iilMc9GzylyBLw8R497o85OlOYQYkeV7dgYRg==
X-Received: by 2002:a17:902:b183:: with SMTP id s3mr8393722plr.234.1589381933031;
        Wed, 13 May 2020 07:58:53 -0700 (PDT)
Received: from [10.230.188.43] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id a2sm2187400pfi.208.2020.05.13.07.58.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 13 May 2020 07:58:52 -0700 (PDT)
Subject: Re: [PATCH] dt-bindings: net: dsa: b53: Add missing size and address
 cells to example
To:     Kurt Kanzenbach <kurt@linutronix.de>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>, netdev@vger.kernel.org
References: <20200513140249.24900-1-kurt@linutronix.de>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <6ce7e25b-ebc3-bf0e-8f35-66ee9b8b0a53@gmail.com>
Date:   Wed, 13 May 2020 07:58:50 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Firefox/68.0 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200513140249.24900-1-kurt@linutronix.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/13/2020 7:02 AM, Kurt Kanzenbach wrote:
> Add the missing size and address cells to the b53 example. Otherwise, it may not
> compile or issue warnings if directly copied into a device tree.
> 
> Signed-off-by: Kurt Kanzenbach <kurt@linutronix.de>

Acked-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
