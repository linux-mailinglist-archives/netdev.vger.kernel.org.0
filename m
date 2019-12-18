Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DB88F1257E7
	for <lists+netdev@lfdr.de>; Thu, 19 Dec 2019 00:41:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726652AbfLRXlq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Dec 2019 18:41:46 -0500
Received: from mail-ot1-f65.google.com ([209.85.210.65]:42836 "EHLO
        mail-ot1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725948AbfLRXlp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Dec 2019 18:41:45 -0500
Received: by mail-ot1-f65.google.com with SMTP id 66so4591104otd.9;
        Wed, 18 Dec 2019 15:41:45 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=R29Btnzag73VkeWSdz4euQtuxJFOTMdR3dZXl1nXjuI=;
        b=OpQefdOsR2Mu0IX1E5nCyTWzp5WWfFk6FEhYa6g5AknvZudkYbgIAqHDhu9hQ+gFej
         0WCvGlXEeAZoiQtntHZ2TCSn1eHMQULX+HiNMn4qRJ0WTEiNoFan5jZfZfJxnQnjl1tB
         m9E1LLRC5hHVEa7JcfvP/IAiElSATEN4BY/Q/mnzsxuADYZcqsQYJMFZxs+TRaUFke3d
         cXNbWg7JeaUZV/jnWWcs7iXTCkoNP40IxSjoW/jb3F9Q0zP0O+xH+DmH/eZSUaIZJ686
         nXVcpSudaXjpZaF+7o0wulwxvZ3tZ+muK1pOjI06+jXxtWZ5MwRpY/Z0rWmYCi1svxkF
         WqcQ==
X-Gm-Message-State: APjAAAU7IlKeeRtm00c/Sy+47UAVKQOsTzjzyruE9EinEbBg+JFqzrMA
        AHxNf1x8XUcoQ1aLs6cnp3y956q9LQ==
X-Google-Smtp-Source: APXvYqxT21uP5Hd4ruqKQC1yFjEgpvgeZ8PPRxzwneE1wkiyWFUxWmXFpMHBXDmzot1rNAsfdwbojg==
X-Received: by 2002:a9d:7a88:: with SMTP id l8mr5673731otn.187.1576712504917;
        Wed, 18 Dec 2019 15:41:44 -0800 (PST)
Received: from localhost (24-155-109-49.dyn.grandenetworks.net. [24.155.109.49])
        by smtp.gmail.com with ESMTPSA id q1sm1455743otr.40.2019.12.18.15.41.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Dec 2019 15:41:44 -0800 (PST)
Date:   Wed, 18 Dec 2019 17:41:43 -0600
From:   Rob Herring <robh@kernel.org>
To:     Matthias Kaehlcke <mka@chromium.org>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Mark Rutland <mark.rutland@arm.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        Matthias Kaehlcke <mka@chromium.org>,
        devicetree@vger.kernel.org, Rocky Liao <rjliao@codeaurora.org>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Harish Bandi <c-hbandi@codeaurora.org>,
        Balakrishna Godavarthi <bgodavar@codeaurora.org>
Subject: Re: [PATCH] dt-bindings: net: bluetooth: Add compatible string for
 WCN3991
Message-ID: <20191218234143.GA15666@bogus>
References: <20191205122241.1.I6c86a40ce133428b6fab21f24f6ff6fec7e74e62@changeid>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191205122241.1.I6c86a40ce133428b6fab21f24f6ff6fec7e74e62@changeid>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu,  5 Dec 2019 12:22:59 -0800, Matthias Kaehlcke wrote:
> Commit 7d250a062f75 ("Bluetooth: hci_qca: Add support for Qualcomm
> Bluetooth SoC WCN3991") added the compatible string 'qcom,wcn3991-bt'
> to the Qualcomm Bluetooth driver, however the string is not listed
> in the binding. Add the 'qcom,wcn3991-bt' to the supported compatible
> strings.
> 
> Signed-off-by: Matthias Kaehlcke <mka@chromium.org>
> ---
> 
>  Documentation/devicetree/bindings/net/qualcomm-bluetooth.txt | 1 +
>  1 file changed, 1 insertion(+)
> 

Applied, thanks.

Rob
