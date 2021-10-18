Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C1714431A57
	for <lists+netdev@lfdr.de>; Mon, 18 Oct 2021 15:05:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231655AbhJRNHw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Oct 2021 09:07:52 -0400
Received: from ixit.cz ([94.230.151.217]:47528 "EHLO ixit.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231310AbhJRNHu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 18 Oct 2021 09:07:50 -0400
Received: from [10.30.101.130] (unknown [213.151.89.154])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by ixit.cz (Postfix) with ESMTPSA id 4CC4820064;
        Mon, 18 Oct 2021 15:05:36 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ixit.cz; s=dkim;
        t=1634562337;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=azWASKGxnLymoHaARibY3QNRQeYBxVaBWoZoGp3r0Qw=;
        b=1X/FdLFEPOJMI5ttEqy5WPpUwhpSQhjz+z8boDociODni/R5wXQuVA9w/qeXyM6kB2+/Yk
        AMPnQHo7e0bAzVhTtpXSjN+TsvznyiYgUqcSyhVzPJ6Hje7YLVP27EXvAGSajeYXpjO4J/
        hjtFy14Mw8QHjHKgDwBtPYDeCLuGnlQ=
Date:   Mon, 18 Oct 2021 15:04:03 +0200
From:   David Heidelberg <david@ixit.cz>
Subject: Re: [PATCH v4] dt-bindings: net: nfc: nxp,pn544: Convert txt bindings
 to yaml
To:     Rob Herring <robh@kernel.org>
Cc:     linux-kernel@vger.kernel.org,
        Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        Rob Herring <robh+dt@kernel.org>, netdev@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        ~okias/devicetree@lists.sr.ht, devicetree@vger.kernel.org
Message-Id: <RAC61R.YOBPB57076K71@ixit.cz>
In-Reply-To: <1634559233.484644.2074240.nullmailer@robh.at.kernel.org>
References: <20211017160210.85543-1-david@ixit.cz>
        <1634559233.484644.2074240.nullmailer@robh.at.kernel.org>
X-Mailer: geary/40.0
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org




On Mon, Oct 18 2021 at 07:13:53 -0500, Rob Herring <robh@kernel.org> 
wrote:
> On Sun, 17 Oct 2021 18:02:10 +0200, David Heidelberg wrote:
>>  Convert bindings for NXP PN544 NFC driver to YAML syntax.
>> 
>>  Signed-off-by: David Heidelberg <david@ixit.cz>
>>  ---
>>  v2
>>   - Krzysztof is a maintainer
>>   - pintctrl dropped
>>   - 4 space indent for example
>>   - nfc node name
>>  v3
>>   - remove whole pinctrl
>>  v4
>>   - drop clock-frequency, which is inherited by i2c bus
>> 
>>   .../bindings/net/nfc/nxp,pn544.yaml           | 56 
>> +++++++++++++++++++
>>   .../devicetree/bindings/net/nfc/pn544.txt     | 33 -----------
>>   2 files changed, 56 insertions(+), 33 deletions(-)
>>   create mode 100644 
>> Documentation/devicetree/bindings/net/nfc/nxp,pn544.yaml
>>   delete mode 100644 
>> Documentation/devicetree/bindings/net/nfc/pn544.txt
>> 
Full log is available here: https://patchwork.ozlabs.org/patch/1542257
> 
> Running 'make dtbs_check' with the schema in this patch gives the
> following warnings. Consider if they are expected or the schema is
> incorrect. These may not be new warnings.
> 
> Note that it is not yet a requirement to have 0 warnings for 
> dtbs_check.
> This will change in the future.
> 
> 
> 
> nfc@28: 'clock-frequency' does not match any of the regexes: 
> 'pinctrl-[0-9]+'
> 	arch/arm/boot/dts/tegra30-asus-nexus7-grouper-E1565.dt.yaml
> 	arch/arm/boot/dts/tegra30-asus-nexus7-grouper-PM269.dt.yaml
> 
> nfc@2a: 'clock-frequency' does not match any of the regexes: 
> 'pinctrl-[0-9]+'
> 	arch/arm/boot/dts/tegra30-asus-nexus7-tilapia-E1565.dt.yaml
> 

Patches for this are already in grate repository and will be sent to 
mainline soon! :)

> 


