Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BFB8B417CB
	for <lists+netdev@lfdr.de>; Wed, 12 Jun 2019 00:01:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436647AbfFKWBV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Jun 2019 18:01:21 -0400
Received: from mail-qt1-f195.google.com ([209.85.160.195]:42818 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2407758AbfFKWBV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Jun 2019 18:01:21 -0400
Received: by mail-qt1-f195.google.com with SMTP id s15so16463633qtk.9;
        Tue, 11 Jun 2019 15:01:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=wVRjad9Fc8BILg/+DYBhqnoHZfByaIOMm77zfoBIfY0=;
        b=uZheCOttbqblvyIMZwReeWp+JKZkUKNnu2dE7PFC6Ayj4XeuMQmtYZ7WfswaYJbQcF
         vOGVbYTmuPxAMwyLC004S0bLmcYiboju7syJ7Mtk+B+50jjdMzQ+YrNHZh1SYSrxY+VL
         /gb2QmzjjonwcTtZyBQI1OseExiibPQbdd7ATSHuyf4ESdngBp/2CsZ8+5V5mfvir+8s
         LLf1GDzvcJYS9r6YT2OUn0qoIp/bJDutb8gsV10YK/nesxcS/Ri44EE3kKZV7VsPrXbr
         HkH1F+DJ/NG22BGf6czObAZ5M96xGGQzxOWUTwLi6vCiQkbsQIV7HNk9KwMFlwAXLq4x
         oAGQ==
X-Gm-Message-State: APjAAAUW+2mrC6Zwr9mHJnEewB70KZwGWWg6N/sVLhUr6jD2t/fwnqYF
        wKhc9t86sFPVMhWLqKvXig==
X-Google-Smtp-Source: APXvYqxq+ctalxr4J055wzK7JBghbqhScsopOPimJQptlh5w/Pu3JDApOeKWxso3z1UIm9uUmO+OTw==
X-Received: by 2002:ac8:c45:: with SMTP id l5mr50644561qti.63.1560290480260;
        Tue, 11 Jun 2019 15:01:20 -0700 (PDT)
Received: from localhost ([64.188.179.199])
        by smtp.gmail.com with ESMTPSA id g5sm8812899qta.77.2019.06.11.15.01.19
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 11 Jun 2019 15:01:19 -0700 (PDT)
Date:   Tue, 11 Jun 2019 16:01:17 -0600
From:   Rob Herring <robh@kernel.org>
To:     Rocky Liao <rjliao@codeaurora.org>
Cc:     mark.rutland@arm.com, marcel@holtmann.org, johan.hedberg@gmail.com,
        thierry.escande@linaro.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-bluetooth@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        bgodavar@codeaurora.org, c-hbandi@codeaurora.org
Subject: Re: [PATCH v6 2/2] dt-bindings: net: bluetooth: Add device property
 firmware-name for QCA6174
Message-ID: <20190611220117.GA31601@bogus>
References: <1557919203-11055-1-git-send-email-rjliao@codeaurora.org>
 <1559814055-13872-1-git-send-email-rjliao@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1559814055-13872-1-git-send-email-rjliao@codeaurora.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 06, 2019 at 05:40:55PM +0800, Rocky Liao wrote:
> This patch adds an optional device property "firmware-name" to allow the
> driver to load customized nvm firmware file based on this property.
> 
> Signed-off-by: Rocky Liao <rjliao@codeaurora.org>
> ---
> Changes in v6:
>   * Added read firmware-name property for both QCA6174 and WCN399X
> ---
>  Documentation/devicetree/bindings/net/qualcomm-bluetooth.txt | 4 ++++
>  1 file changed, 4 insertions(+)

Reviewed-by: Rob Herring <robh@kernel.org>
