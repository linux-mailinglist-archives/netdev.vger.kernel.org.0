Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DE0DAC4386
	for <lists+netdev@lfdr.de>; Wed,  2 Oct 2019 00:09:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728702AbfJAWJK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Oct 2019 18:09:10 -0400
Received: from mail-io1-f66.google.com ([209.85.166.66]:33038 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727939AbfJAWJK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Oct 2019 18:09:10 -0400
Received: by mail-io1-f66.google.com with SMTP id z19so52286113ior.0;
        Tue, 01 Oct 2019 15:09:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:from:to:cc:subject:references
         :mime-version:content-disposition:in-reply-to;
        bh=5//jtefmaJ97Y9W3Pk3QhG7cK96EetPPEWG2vT77tjg=;
        b=FWUJNUjvredINOph0LKSO3N8V1uR0zqm6Mb7r4DGGfNgRHcbHOrgnynAWRhCyO+c2r
         HxRw8JBoxJM4Xj8ad0r7j+nvk+7VpoI5HDISGNhQ5LGSIu3lf/m1b50PcZCkDBrgygEb
         rFeDurZlcXjFEW1/o6wfz+zIE4lMth6s8zi9ay8hVbZUnpqI84cAtbKg+TEI2LTIesHE
         clxZT/hLlLx1xjCoIX0L/JbdRhLy+RwwDrHhiPZC5jrWuhn9Z+v8pMoWrZGnMHT621JL
         99yXSXmQSyKw7Xc4qvyXfcWDLlHrkE15a/Uur/KM/yCYHRsqQYmHDPPvU0lPUG/cdpF6
         Ruig==
X-Gm-Message-State: APjAAAVIKNXxwD+rl4n49KpkfG5pCZ905R+v6HDSOToZyYJpw28zj0B8
        dpqmyNyN7Lsik7G/3NfeZA==
X-Google-Smtp-Source: APXvYqwOEoRGKu2K7r6IWzeo9k0HQ6duIkNv4Ictjw6+GHKk96Azxq9Q+dg98oVjdyrtmqkwyg4jMA==
X-Received: by 2002:a6b:4f0c:: with SMTP id d12mr427307iob.214.1569967749050;
        Tue, 01 Oct 2019 15:09:09 -0700 (PDT)
Received: from localhost ([2607:fb90:1780:6fbf:9c38:e932:436b:4079])
        by smtp.gmail.com with ESMTPSA id t4sm6596166iln.82.2019.10.01.15.09.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Oct 2019 15:09:08 -0700 (PDT)
Message-ID: <5d93ce84.1c69fb81.8e964.4dc1@mx.google.com>
Date:   Tue, 01 Oct 2019 17:09:06 -0500
From:   Rob Herring <robh@kernel.org>
To:     vincent.cheng.xh@renesas.com
Cc:     mark.rutland@arm.com, richardcochran@gmail.com,
        devicetree@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] dt-bindings: ptp: Add binding doc for IDT
 ClockMatrix based PTP clock
References: <1568837198-27211-1-git-send-email-vincent.cheng.xh@renesas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1568837198-27211-1-git-send-email-vincent.cheng.xh@renesas.com>
X-Mutt-References: <1568837198-27211-1-git-send-email-vincent.cheng.xh@renesas.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 18, 2019 at 04:06:37PM -0400, vincent.cheng.xh@renesas.com wrote:
> From: Vincent Cheng <vincent.cheng.xh@renesas.com>
> 
> Add device tree binding doc for the IDT ClockMatrix PTP clock driver.

Bindings are for h/w, not drivers...

> 
> Signed-off-by: Vincent Cheng <vincent.cheng.xh@renesas.com>
> ---
>  Documentation/devicetree/bindings/ptp/ptp-idtcm.txt | 15 +++++++++++++++
>  1 file changed, 15 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/ptp/ptp-idtcm.txt

Please make this a DT schema.

> 
> diff --git a/Documentation/devicetree/bindings/ptp/ptp-idtcm.txt b/Documentation/devicetree/bindings/ptp/ptp-idtcm.txt
> new file mode 100644
> index 0000000..4eaa34d
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/ptp/ptp-idtcm.txt
> @@ -0,0 +1,15 @@
> +* IDT ClockMatrix (TM) PTP clock
> +
> +Required properties:
> +
> +  - compatible  Should be "idt,8a3400x-ptp" for System Synchronizer
> +                Should be "idt,8a3401x-ptp" for Port Synchronizer
> +                Should be "idt,8a3404x-ptp" for Universal Frequency Translator (UFT)

If PTP is the only function of the chip, you don't need to append 
'-ptp'.

What's the 'x' for? We generally don't use wildcards in compatible 
strings.

> +  - reg         I2C slave address of the device
> +
> +Example:
> +
> +	phc@5b {
> +		compatible = "idt,8a3400x-ptp";
> +		reg = <0x5b>;
> +	};
> -- 
> 2.7.4
> 

