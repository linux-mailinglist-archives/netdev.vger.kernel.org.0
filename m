Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AD6FBD190C
	for <lists+netdev@lfdr.de>; Wed,  9 Oct 2019 21:36:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731705AbfJITg2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Oct 2019 15:36:28 -0400
Received: from mail-oi1-f195.google.com ([209.85.167.195]:43300 "EHLO
        mail-oi1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729535AbfJITg2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Oct 2019 15:36:28 -0400
Received: by mail-oi1-f195.google.com with SMTP id t84so2783740oih.10;
        Wed, 09 Oct 2019 12:36:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=3ALZiESttVRTntCnP5wQuLBgagIPavNeKjGNvZQ3Lb0=;
        b=JgPmmVDKU8A9f33U1SE11On5N8OL+vHO/gdryHmAAWmYku/FFFgRlAWlqydIq44M26
         8QqNxSRijrA6A1GqyaFww56SFM22wK0HhqQRh7ZpbnyO3gmebDn16MPxYSfozpOce4gk
         ONigwcQOMsaCK2wPbdPZTQv0jPbULNtwGSsfHZ0scd4N5V1dwMlu7HHid5RZsOkQxnFx
         loVbHdgDfIfkubbi+gzGmIG1AfoRmfoAFl/wuYHo+dwngbtCJ6iKr0mSKyNI/vpA/CAL
         p31yS8UXW8DfNf2nETmyt0o3xw4CgFApuBm2L8J+du9PVjzI8C91TanQD4YimFV+aF/N
         +8yw==
X-Gm-Message-State: APjAAAVpTVAfkloU7ngnz1IzL06bUsuXcp9bAP7RVEC4JxT2dvmLwTgh
        ZtnESoSap7F4vniZmodRfA==
X-Google-Smtp-Source: APXvYqzWgSDnCdzLP+DxQOyzfZXLFwWvcWiJDR9rPlLa3N05EE5eful7TThXsqERTMmYsEQLG2TJHg==
X-Received: by 2002:aca:4e84:: with SMTP id c126mr4074684oib.131.1570649786068;
        Wed, 09 Oct 2019 12:36:26 -0700 (PDT)
Received: from localhost (24-155-109-49.dyn.grandenetworks.net. [24.155.109.49])
        by smtp.gmail.com with ESMTPSA id y30sm988435oix.36.2019.10.09.12.36.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Oct 2019 12:36:25 -0700 (PDT)
Date:   Wed, 9 Oct 2019 14:36:25 -0500
From:   Rob Herring <robh@kernel.org>
To:     Lars Poeschel <poeschel@lemonage.de>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Mark Rutland <mark.rutland@arm.com>,
        Lars Poeschel <poeschel@lemonage.de>,
        "open list:NFC SUBSYSTEM" <netdev@vger.kernel.org>,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" 
        <devicetree@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        Johan Hovold <johan@kernel.org>,
        Simon Horman <horms@verge.net.au>
Subject: Re: [PATCH v9 2/7] nfc: pn532: Add uart phy docs and rename it
Message-ID: <20191009193625.GA19348@bogus>
References: <20191008140544.17112-1-poeschel@lemonage.de>
 <20191008140544.17112-3-poeschel@lemonage.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191008140544.17112-3-poeschel@lemonage.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue,  8 Oct 2019 16:05:39 +0200, Lars Poeschel wrote:
> This adds documentation about the uart phy to the pn532 binding doc. As
> the filename "pn533-i2c.txt" is not appropriate any more, rename it to
> the more general "pn532.txt".
> This also documents the deprecation of the compatible strings ending
> with "...-i2c".
> 
> Cc: Johan Hovold <johan@kernel.org>
> Cc: Simon Horman <horms@verge.net.au>
> Signed-off-by: Lars Poeschel <poeschel@lemonage.de>
> ---
> Changes in v9:
> - Rebased the patch series on v5.4-rc2
> - Produce patch with -M4 to git format-patch to detect the rename
> - Change DT node name from pn532@24 to nfc@24 in example
> 
> Changes in v8:
> - Update existing binding doc instead of adding a new one:
>   - Add uart phy example
>   - Add general "pn532" compatible string
>   - Deprecate "...-i2c" compatible strings
>   - Rename file to a more general filename
> - Intentionally drop Rob's Reviewed-By as I guess this rather big change
>   requires a new review
> 
> Changes in v7:
> - Accidentally lost Rob's Reviewed-By
> 
> Changes in v6:
> - Rebased the patch series on v5.3-rc5
> - Picked up Rob's Reviewed-By
> 
> Changes in v4:
> - Add documentation about reg property in case of i2c
> 
> Changes in v3:
> - seperate binding doc instead of entry in trivial-devices.txt
> 
>  .../net/nfc/{pn533-i2c.txt => pn532.txt}      | 25 ++++++++++++++++---
>  1 file changed, 21 insertions(+), 4 deletions(-)
>  rename Documentation/devicetree/bindings/net/nfc/{pn533-i2c.txt => pn532.txt} (42%)
> 

Reviewed-by: Rob Herring <robh@kernel.org>
