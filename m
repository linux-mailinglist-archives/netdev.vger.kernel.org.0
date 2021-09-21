Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 79C45413BD9
	for <lists+netdev@lfdr.de>; Tue, 21 Sep 2021 22:55:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235176AbhIUU5F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Sep 2021 16:57:05 -0400
Received: from mail-oi1-f179.google.com ([209.85.167.179]:37571 "EHLO
        mail-oi1-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234707AbhIUU5F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Sep 2021 16:57:05 -0400
Received: by mail-oi1-f179.google.com with SMTP id w206so1107206oiw.4;
        Tue, 21 Sep 2021 13:55:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=sHoBdlJO01sxOMRM+J4Stj1FzbSZtHaqO294d5ta4QQ=;
        b=bmEX71q5Q33d1sJwFv8lkrhAXODioXSVkMopi1g6h7Fuy9BRz6M9a2ukTdvANWNHj2
         lCcXukUd3qjO9PEo4WxUAY+4099c/uas5X9qVaT83qMIq4+IPJ1rCcDp/mZKVDm0zrr2
         +EwBIaLGL28icnHTGs9Rg4hwPdNFyvAiCzxDxhssI3W9wR46HnLQwnKPwqVNf88XtoAr
         mVLIw8rNtpw6sPKmtATJRCHubBWcJvwVXxg5sz5dk4b0XwccdDY0f+aIoIAzzqYMZd38
         7FLzWgc2RukWhHGklJ2Pkqp0sNa9zg/rrzAhv9gjnPRQcoc3ipKVHgSY6XiZe3+Og3Zl
         mQiw==
X-Gm-Message-State: AOAM533tFNYCHAqBZmLbbdY1STCc4lXCHN9UEM/yYUgGI7qIzoYYdwx1
        /ekKxbmbnoRhpt7r8l0VZg==
X-Google-Smtp-Source: ABdhPJzEj5QvACfG7FbAsfxxHQOz2neHdHjywbpPOexWfWS6iBsECUWogZBo4qSsJCCmSJqMGipTGg==
X-Received: by 2002:a05:6808:618:: with SMTP id y24mr5377435oih.25.1632257736198;
        Tue, 21 Sep 2021 13:55:36 -0700 (PDT)
Received: from robh.at.kernel.org (rrcs-192-154-179-36.sw.biz.rr.com. [192.154.179.36])
        by smtp.gmail.com with ESMTPSA id 14sm21514oiy.53.2021.09.21.13.55.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Sep 2021 13:55:35 -0700 (PDT)
Received: (nullmailer pid 3310957 invoked by uid 1000);
        Tue, 21 Sep 2021 20:55:34 -0000
Date:   Tue, 21 Sep 2021 15:55:34 -0500
From:   Rob Herring <robh@kernel.org>
To:     Stefan Wahren <stefan.wahren@i2se.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Michael Heimpold <michael.heimpold@in-tech.com>,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>, jimmy.shen@vertexcom.com
Subject: Re: [PATCH RFC 1/3] dt-bindings: add vendor Vertexcom
Message-ID: <YUpGxqcFjcFJYCTm@robh.at.kernel.org>
References: <20210914151717.12232-1-stefan.wahren@i2se.com>
 <20210914151717.12232-2-stefan.wahren@i2se.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210914151717.12232-2-stefan.wahren@i2se.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 14 Sep 2021 17:17:15 +0200, Stefan Wahren wrote:
> Add vendor prefix for Vertexcom Technologies, Inc [1].
> 
> [1] - http://www.vertexcom.com/
> 
> Signed-off-by: Stefan Wahren <stefan.wahren@i2se.com>
> ---
>  Documentation/devicetree/bindings/vendor-prefixes.yaml | 2 ++
>  1 file changed, 2 insertions(+)
> 

Acked-by: Rob Herring <robh@kernel.org>
