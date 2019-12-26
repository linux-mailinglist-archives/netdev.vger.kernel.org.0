Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9620812AF7A
	for <lists+netdev@lfdr.de>; Thu, 26 Dec 2019 23:58:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726933AbfLZW6d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Dec 2019 17:58:33 -0500
Received: from mail-il1-f193.google.com ([209.85.166.193]:34052 "EHLO
        mail-il1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726806AbfLZW6d (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Dec 2019 17:58:33 -0500
Received: by mail-il1-f193.google.com with SMTP id s15so21193724iln.1;
        Thu, 26 Dec 2019 14:58:32 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=19umCU1foW27C6F1T/aG75qtQ/YsllKFioJd6vrnCos=;
        b=OscQeAk0ebhm4cTkwX6UvGpwbi1otWfW3HlA8rLAKUUqPB7c0c1owRcSAESZQ6njRD
         qBNhLYYzkOEx60bKWwiLYw3z7V1jotKpGVLs8iAAZfwJ7RLOKOVdA8xpDx9bnflzLsmw
         8lm9JiIiDqsTwR9OmlKgPl0c+itwiKPo2eT64HGIWQrwUZtTRk7PkfSE+OLF/284yTn6
         c4zTBT7+HJNlarrO03PX/M0bBevs6ZFEnyzIRLZ8HsZn2UarL8kqzWv/fmrWkb2x8+5h
         tHMiUfVUCqIaLSr6z/eK4t5O5HTjhmLaynMjAHyH1t1Jpyk4HGf0B5yjnNVqAhjlwZXB
         KY8Q==
X-Gm-Message-State: APjAAAUTU9JOFdQbHqPJ9g4HKju7T8UTzYu4bKe8n3K0Prnv1bxWKdB+
        wffW+n90NuNw51yL8+UKiw==
X-Google-Smtp-Source: APXvYqwI86xFoCX7YL80LZzMdEiLjiACERhaXHMCudrl3qXRjT+KzMJ9HPYZBlZkEjwH0sMKqSGASQ==
X-Received: by 2002:a92:9107:: with SMTP id t7mr41848417ild.51.1577401112315;
        Thu, 26 Dec 2019 14:58:32 -0800 (PST)
Received: from localhost ([64.188.179.250])
        by smtp.gmail.com with ESMTPSA id 75sm12647588ila.61.2019.12.26.14.58.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Dec 2019 14:58:31 -0800 (PST)
Date:   Thu, 26 Dec 2019 15:58:31 -0700
From:   Rob Herring <robh@kernel.org>
To:     Richard Cochran <richardcochran@gmail.com>
Cc:     netdev@vger.kernel.org, David Miller <davem@davemloft.net>,
        devicetree@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jacob Keller <jacob.e.keller@intel.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Miroslav Lichvar <mlichvar@redhat.com>,
        Murali Karicheri <m-karicheri2@ti.com>,
        Willem de Bruijn <willemb@google.com>,
        Wingman Kwok <w-kwok2@ti.com>
Subject: Re: [PATCH V9 net-next 09/12] dt-bindings: ptp: Introduce MII time
 stamping devices.
Message-ID: <20191226225831.GA22533@bogus>
References: <cover.1577326042.git.richardcochran@gmail.com>
 <ee2e7db95bfc8a30c7f398f051a073aaf38bb7f6.1577326042.git.richardcochran@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ee2e7db95bfc8a30c7f398f051a073aaf38bb7f6.1577326042.git.richardcochran@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 25 Dec 2019 18:16:17 -0800, Richard Cochran wrote:
> This patch add a new binding that allows non-PHY MII time stamping
> devices to find their buses.  The new documentation covers both the
> generic binding and one upcoming user.
> 
> Signed-off-by: Richard Cochran <richardcochran@gmail.com>
> Reviewed-by: Andrew Lunn <andrew@lunn.ch>
> ---
>  .../devicetree/bindings/ptp/ptp-ines.txt      | 35 ++++++++++++++++
>  .../devicetree/bindings/ptp/timestamper.txt   | 42 +++++++++++++++++++
>  2 files changed, 77 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/ptp/ptp-ines.txt
>  create mode 100644 Documentation/devicetree/bindings/ptp/timestamper.txt
> 

Reviewed-by: Rob Herring <robh@kernel.org>
