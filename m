Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E11372454E3
	for <lists+netdev@lfdr.de>; Sun, 16 Aug 2020 01:26:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728589AbgHOXZ4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 Aug 2020 19:25:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726021AbgHOXZ4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 15 Aug 2020 19:25:56 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 433A7C061786;
        Sat, 15 Aug 2020 16:25:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:Subject:Sender
        :Reply-To:Content-ID:Content-Description;
        bh=thSB2duN5RGwr8Q6zOeYxAh5uO9v+2fWgViJOQmw1Dk=; b=Z4yowwp4zbGQeTVglQC+C9iE/u
        bxcKFv5nygjuGgfRtqI0EY7F47Q4fxKtcgzo0rgmZU9ROSJOarJRdI+lJflYXNDt3EdwWI01zmgV0
        eh09woCU3ErCWKlMJAeQz9zDsefj50aG4ZELi2sHOtfLGS8asgOAb15RuepmpO/6dSA4FHJUpk35n
        CgjoiTh1+7tdzxBLoE1uPiHPvgiRWjPLoQp4vk60flN7K+dVLuDLVDUZd8aAhzcWecTTyVGrrPzOF
        /hRZGQplXgxiPBnFy5GJjPAOc6eq3fPFQL9XJudgUU2r5H+RdHI1cOJbIZWlwRBmd/hVH1fWajYRq
        hUN4oziQ==;
Received: from [2601:1c0:6280:3f0::19c2]
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1k75YQ-0004jH-39; Sat, 15 Aug 2020 23:25:40 +0000
Subject: Re: [PATCH v5 3/6] can: ctucanfd: add support for CTU CAN FD
 open-source IP core - bus independent part.
To:     Pavel Pisa <pisa@cmp.felk.cvut.cz>, linux-can@vger.kernel.org,
        devicetree@vger.kernel.org, Marc Kleine-Budde <mkl@pengutronix.de>,
        Oliver Hartkopp <socketcan@hartkopp.net>
Cc:     Wolfgang Grandegger <wg@grandegger.com>,
        David Miller <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>, mark.rutland@arm.com,
        Carsten Emde <c.emde@osadl.org>, armbru@redhat.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Marin Jerabek <martin.jerabek01@gmail.com>,
        Ondrej Ille <ondrej.ille@gmail.com>,
        Jiri Novak <jnovak@fel.cvut.cz>,
        Jaroslav Beran <jara.beran@gmail.com>,
        Petr Porazil <porazil@pikron.com>
References: <cover.1597518433.git.ppisa@pikron.com>
 <b634e83c1883e631092bdaca3519e906077f2f8b.1597518433.git.ppisa@pikron.com>
From:   Randy Dunlap <rdunlap@infradead.org>
Message-ID: <45598c29-722d-93d4-bea2-7ed40ca13050@infradead.org>
Date:   Sat, 15 Aug 2020 16:25:33 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <b634e83c1883e631092bdaca3519e906077f2f8b.1597518433.git.ppisa@pikron.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/15/20 12:43 PM, Pavel Pisa wrote:
> diff --git a/drivers/net/can/ctucanfd/Kconfig b/drivers/net/can/ctucanfd/Kconfig
> new file mode 100644
> index 000000000000..d8da44d7f926
> --- /dev/null
> +++ b/drivers/net/can/ctucanfd/Kconfig
> @@ -0,0 +1,15 @@
> +config CAN_CTUCANFD
> +	tristate "CTU CAN-FD IP core"
> +	help
> +	  This driver adds support for the CTU CAN FD open-source IP core.
> +	  More documentation and core sources at project page
> +	  (https://gitlab.fel.cvut.cz/canbus/ctucanfd_ip_core).
> +	  The core integration to Xilinx Zynq system as platform driver
> +	  is available (https://gitlab.fel.cvut.cz/canbus/zynq/zynq-can-sja1000-top).
> +	  Implementation on Intel FGA based PCI Express board is available

   Is that                        FPGA-based
   ?

> +	  from project (https://gitlab.fel.cvut.cz/canbus/pcie-ctu_can_fd).
> +	  Guidepost CTU FEE CAN bus projects page http://canbus.pages.fel.cvut.cz/ .
> +
> +if CAN_CTUCANFD
> +
> +endif


-- 
~Randy

