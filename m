Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 499351BA1A
	for <lists+netdev@lfdr.de>; Mon, 13 May 2019 17:31:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731144AbfEMPbb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 May 2019 11:31:31 -0400
Received: from mail-oi1-f196.google.com ([209.85.167.196]:39263 "EHLO
        mail-oi1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728760AbfEMPbb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 May 2019 11:31:31 -0400
Received: by mail-oi1-f196.google.com with SMTP id v2so6223549oie.6;
        Mon, 13 May 2019 08:31:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=FQOvA5KjBthgKljzqlnSntKijRM8U0Ek6cEPPxoji2E=;
        b=dejvX3breHRwN4An7TpReSHW8TXjWs1CDVBdaS2zxh+csl32wVGpgDTZeh313Lsjg8
         DuRpONS5wb+S7v38+97IoNelvANeWjk11K4rzDBeKVQe6v6vuqFSuklnTGdmZAbwqRWj
         nUS3xPtdSTbWzHf7kOu/IjHWKHuPNf3eiXOoB7aRiNUHCWR6jE286F9zlxF+QXgpTQUF
         5hnTGcHhj9i7G2HpcVyg4J/pro/r0JY5Cz0LxngoW4oG0gYp/PtI6tJbGxTLxa6W/aSn
         6w+iCXo6qenCGGYhYtdNQeMQEVZqgqn9mZYeonxE8IrVAmuo1IYdn2v06SUrsZTD3BJ/
         T8Xw==
X-Gm-Message-State: APjAAAVvDkrKMdhqr2KmxfFHaEgg6HPzch3uJ/9l/egqJonqaxvOMsxN
        trdnI2V6TVYRL/pCL1xi2g==
X-Google-Smtp-Source: APXvYqxPKZmpbo13eB03kaNp94tcGk2ZoALh5Nztcx9t9oH7y8OmpU0lAQiB2QW59q7pBEcpnxc4+Q==
X-Received: by 2002:aca:3b43:: with SMTP id i64mr13910509oia.121.1557761490019;
        Mon, 13 May 2019 08:31:30 -0700 (PDT)
Received: from localhost (24-155-109-49.dyn.grandenetworks.net. [24.155.109.49])
        by smtp.gmail.com with ESMTPSA id o5sm5136964otl.44.2019.05.13.08.31.29
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 13 May 2019 08:31:29 -0700 (PDT)
Date:   Mon, 13 May 2019 10:31:28 -0500
From:   Rob Herring <robh@kernel.org>
To:     Rocky Liao <rjliao@codeaurora.org>
Cc:     robh+dt@kernel.org, mark.rutland@arm.com, marcel@holtmann.org,
        johan.hedberg@gmail.com, thierry.escande@linaro.org,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-bluetooth@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, bgodavar@codeaurora.org,
        Rocky Liao <rjliao@codeaurora.org>
Subject: Re: [PATCH v4 2/2] dt-bindings: net: bluetooth: Add device property
 firmware-name for QCA6174
Message-ID: <20190513153128.GA5455@bogus>
References: <1554888476-17560-1-git-send-email-rjliao@codeaurora.org>
 <1557631185-5167-1-git-send-email-rjliao@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1557631185-5167-1-git-send-email-rjliao@codeaurora.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 12 May 2019 11:19:45 +0800, Rocky Liao wrote:
> This patch adds an optional device property "firmware-name" to allow the
> driver to load customized nvm firmware file based on this property.
> 
> Signed-off-by: Rocky Liao <rjliao@codeaurora.org>
> ---
> Changes in v4:
>   * rebased the code base and merge with latest code
> ---
>  Documentation/devicetree/bindings/net/qualcomm-bluetooth.txt | 2 ++
>  1 file changed, 2 insertions(+)
> 

Reviewed-by: Rob Herring <robh@kernel.org>
