Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EE18B102FCD
	for <lists+netdev@lfdr.de>; Wed, 20 Nov 2019 00:14:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727474AbfKSXOH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Nov 2019 18:14:07 -0500
Received: from mail-lf1-f68.google.com ([209.85.167.68]:38588 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727222AbfKSXOG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Nov 2019 18:14:06 -0500
Received: by mail-lf1-f68.google.com with SMTP id q28so18550836lfa.5
        for <netdev@vger.kernel.org>; Tue, 19 Nov 2019 15:14:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=ir9irrJOMESWTUpMxjgf2j9zIILW0SvYAjvCo24hEOs=;
        b=yeBek2H2Lh83q24+IC9sstjDwUdjPe0Hy/cFCn/aNxEVZlaiEHBievvhaiiTqAJldO
         CnnDU1mg6MMoN3A/s/fPb/GLq3/y5I/auK5FCTyJf0i8HcEPGpuv3hFklYLZr6Hyb2O8
         bNw4GkI3ToqfAdiHBgz8IKnGZegIRB7kfjovriwWYyUqJDSSoptTt7c6ZWOwm9dbAeF7
         UR1eFdlf8N1u5sMvmOfbBEw39e89tEgoYakysAJhWPPuVfDjOnNsCpsVTn0aMBNSut8b
         RAFwc2GMonc3dBRheCWXUZ17OEzmJEe8qn1X6woO36L958QLne82o4jSxPqCaMdlhbsT
         K2dA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=ir9irrJOMESWTUpMxjgf2j9zIILW0SvYAjvCo24hEOs=;
        b=HzOb83JddzruRwxF+MzT9u4zhEoz6PihUNkeVdyHDTvw6cvHFosILibmO6ciWSqHSh
         iaZ5rtnP6A9KzT1MUtL2Xw/pm7qDWc7Ha9KdjA6fOt1Y95Rg3F40v2r2l4KVnZwc1LLc
         wEJxMe5kjfMFdpnmrBFGGllbr+J/F5Vwuugj5GtynVMEkUEXhJk2yTzd4BcLCQmPu53V
         msU0/uJcaJF86hXxkNUi7V0G636O2lM2jkCLuu3n0Bhq+QDJYkg/tSQ2j732yUGOlq+t
         2J20LOO+o2aR4oXUVXN0vIHMTXw/+9WgYmtCTAOu3LWBkJVozGqHUe/S3mFSMgrxkDF3
         yTGw==
X-Gm-Message-State: APjAAAWjyq7fsVg/P2G9u92gl0/3SeUNZruCbL34ttr+ZNh/QIOw2qnO
        +1plY52sX9+zkv8Cj2NpCrNVhQ==
X-Google-Smtp-Source: APXvYqwHOzNI1rbF48ly4PEH2Jq0GjpAfNRQf0Gr/4kPUrdNNRFtGVbwH61ArBAzhhCUQUNgcrAfqQ==
X-Received: by 2002:a19:7d06:: with SMTP id y6mr151844lfc.120.1574205244690;
        Tue, 19 Nov 2019 15:14:04 -0800 (PST)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id i190sm13837624lfi.45.2019.11.19.15.14.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Nov 2019 15:14:04 -0800 (PST)
Date:   Tue, 19 Nov 2019 15:13:50 -0800
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Grygorii Strashko <grygorii.strashko@ti.com>
Cc:     <netdev@vger.kernel.org>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Andrew Lunn <andrew@lunn.ch>,
        "David S . Miller" <davem@davemloft.net>,
        Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>,
        Jiri Pirko <jiri@resnulli.us>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Sekhar Nori <nsekhar@ti.com>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>,
        Murali Karicheri <m-karicheri2@ti.com>,
        Ivan Vecera <ivecera@redhat.com>,
        Rob Herring <robh+dt@kernel.org>, <devicetree@vger.kernel.org>
Subject: Re: [PATCH v7 net-next 10/13] Documentation: networking: add cpsw
 switchdev based driver documentation
Message-ID: <20191119151350.75c72c40@cakuba.netronome.com>
In-Reply-To: <20191119221925.28426-11-grygorii.strashko@ti.com>
References: <20191119221925.28426-1-grygorii.strashko@ti.com>
        <20191119221925.28426-11-grygorii.strashko@ti.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 20 Nov 2019 00:19:22 +0200, Grygorii Strashko wrote:
> diff --git a/Documentation/networking/devlink-params-ti-cpsw-switch.txt b/Documentation/networking/devlink-params-ti-cpsw-switch.txt
> new file mode 100644
> index 000000000000..4037458499f7
> --- /dev/null
> +++ b/Documentation/networking/devlink-params-ti-cpsw-switch.txt
> @@ -0,0 +1,10 @@
> +ale_bypass	[DEVICE, DRIVER-SPECIFIC]
> +		Allows to enable ALE_CONTROL(4).BYPASS mode for debug purposes.
> +		All packets will be sent to the Host port only if enabled.
> +		Type: bool
> +		Configuration mode: runtime
> +
> +switch_mode	[DEVICE, DRIVER-SPECIFIC]
> +		Enable switch mode
> +		Type: bool
> +		Configuration mode: runtime

Ah, you got it here, sorry :)
