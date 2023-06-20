Return-Path: <netdev+bounces-12193-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 600FC73698D
	for <lists+netdev@lfdr.de>; Tue, 20 Jun 2023 12:40:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3DE131C20441
	for <lists+netdev@lfdr.de>; Tue, 20 Jun 2023 10:40:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 26ABAC2EE;
	Tue, 20 Jun 2023 10:40:47 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A8FD2F5B
	for <netdev@vger.kernel.org>; Tue, 20 Jun 2023 10:40:46 +0000 (UTC)
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09B0119A5;
	Tue, 20 Jun 2023 03:40:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1687257627; x=1718793627;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=yWHHRSpdzEQ+3edWjDGQ6AGaIlHfxAaH16a+AM9cVZY=;
  b=ehKI0vvAXo0tkPs2jhXwpKYf38amsofkaTtNV0DCVlGFqEGy1y39qN+A
   niAUVmKsLpN5juvvx0qINCKiWP4uvy4LPyQ6E/syGR94nVKYiwMrNXt/Z
   42pN7yO+I9cPj92bGCTmOLBjG+41jBz2CkFpTEQXZTJSHNHrx3yC5Ykk0
   XByncU39t7/I82u/u9qHvn3YJH7phktlHFzCmXzhckwe8RQS08LwvdwSe
   +kK0HGSuKjOg4CU6KYGVQn/GR+G6U6aQiwoabLj7zH6esuoVuOc7S2UbT
   HQJqO0Wa+W8SXdOqIwlt+ESzfJshuVxwsYC667/2k41PiyTGao9o6cV/P
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10746"; a="363247657"
X-IronPort-AV: E=Sophos;i="6.00,256,1681196400"; 
   d="scan'208";a="363247657"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jun 2023 03:40:26 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10746"; a="691380744"
X-IronPort-AV: E=Sophos;i="6.00,256,1681196400"; 
   d="scan'208";a="691380744"
Received: from unknown (HELO localhost.localdomain) ([10.226.216.116])
  by orsmga006.jf.intel.com with ESMTP; 20 Jun 2023 03:40:22 -0700
From: wen.ping.teh@intel.com
To: krzysztof.kozlowski@linaro.org
Cc: adrian.ho.yin.ng@intel.com,
	andrew@lunn.ch,
	conor+dt@kernel.org,
	devicetree@vger.kernel.org,
	dinguyen@kernel.org,
	krzysztof.kozlowski+dt@linaro.org,
	linux-clk@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	mturquette@baylibre.com,
	netdev@vger.kernel.org,
	niravkumar.l.rabara@intel.com,
	p.zabel@pengutronix.de,
	richardcochran@gmail.com,
	robh+dt@kernel.org,
	sboyd@kernel.org,
	wen.ping.teh@intel.com
Subject: Re: [PATCH 2/4] dt-bindings: clock: Add Intel Agilex5 clocks and resets
Date: Tue, 20 Jun 2023 18:39:30 +0800
Message-Id: <20230620103930.2451721-1-wen.ping.teh@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <8d5f38e6-2ca6-2c61-da29-1d4d2a3df569@linaro.org>
References: <8d5f38e6-2ca6-2c61-da29-1d4d2a3df569@linaro.org>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

>From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
>> From: Niravkumar L Rabara <niravkumar.l.rabara@intel.com>
>> 
>> Add clock and reset ID definitions for Intel Agilex5 SoCFPGA
>> 
>> Co-developed-by: Teh Wen Ping <wen.ping.teh@intel.com>
>> Signed-off-by: Teh Wen Ping <wen.ping.teh@intel.com>
>> Signed-off-by: Niravkumar L Rabara <niravkumar.l.rabara@intel.com>
>> ---
>>  .../bindings/clock/intel,agilex5.yaml         |  42 ++++++++
>>  include/dt-bindings/clock/agilex5-clock.h     | 100 ++++++++++++++++++
>>  .../dt-bindings/reset/altr,rst-mgr-agilex5.h  |  79 ++++++++++++++
>>  3 files changed, 221 insertions(+)
>>  create mode 100644 Documentation/devicetree/bindings/clock/intel,agilex5.yaml
>>  create mode 100644 include/dt-bindings/clock/agilex5-clock.h
>>  create mode 100644 include/dt-bindings/reset/altr,rst-mgr-agilex5.h
>> 
>> diff --git a/Documentation/devicetree/bindings/clock/intel,agilex5.yaml b/Documentation/devicetree/bindings/clock/intel,agilex5.yaml
>> new file mode 100644
>> index 000000000000..e408c52deefa
>> --- /dev/null
>> +++ b/Documentation/devicetree/bindings/clock/intel,agilex5.yaml
>
>Filename matching compatible, so missing "clk"
>

Will update in V2 patch, rename file to intel,agilex5-clk.yaml

>> @@ -0,0 +1,42 @@
>> +# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
>> +%YAML 1.2
>> +---
>> +$id: http://devicetree.org/schemas/clock/intel,agilex5.yaml#
>> +$schema: http://devicetree.org/meta-schemas/core.yaml#
>> +
>> +title: Intel SoCFPGA Agilex5 platform clock controller binding
>
>Drop "binding"
>

Will update in V2 patch.

>> +
>> +maintainers:
>> +  - Teh Wen Ping <wen.ping.teh@intel.com>
>> +  - Niravkumar L Rabara <niravkumar.l.rabara@intel.com>
>> +
>> +description:
>> +  The Intel Agilex5 Clock controller is an integrated clock controller, which
>> +  generates and supplies to all modules.
>
>"generates and supplies" what?

Will change to "generates and supplies clock" in V2 patch.

>
>> +
>> +properties:
>> +  compatible:
>> +    const: intel,agilex5-clkmgr
>
>
>Why "clkmgr", not "clk"? You did not call it Clock manager anywhere in
>the description or title.
>

The register in Agilex5 handling the clock is named clock_mgr.
Previous IntelSocFPGA, Agilex and Stratix10, are also named clkmgr.

>> +
>> +  '#clock-cells':
>> +    const: 1
>> +
>> +  reg:
>> +    maxItems: 1
>> +
>> +required:
>> +  - compatible
>> +  - reg
>> +  - '#clock-cells'
>
>Keep the same order as in properties:
>

Will update in V2 patch.

>> +
>> +additionalProperties: false
>> +
>> +examples:
>> +  # Clock controller node:
>> +  - |
>> +    clkmgr: clock-controller@10d10000 {
>> +      compatible = "intel,agilex5-clkmgr";
>> +      reg = <0x10d10000 0x1000>;
>> +      #clock-cells = <1>;
>> +    };
>> +...
>> diff --git a/include/dt-bindings/clock/agilex5-clock.h b/include/dt-bindings/clock/agilex5-clock.h
>> new file mode 100644
>> index 000000000000..4505b352cd83
>> --- /dev/null
>> +++ b/include/dt-bindings/clock/agilex5-clock.h
>
>Filename the same as binding. Missing vendor prefix, entirely different
>device name.
>

Will change filename to intel,agilex5-clock.h in V2.

>> @@ -0,0 +1,100 @@
>> +/* SPDX-License-Identifier: GPL-2.0-only OR BSD-2-Clause */
>> +/*
>> + * Copyright (C) 2022, Intel Corporation
>> + */
>
>...
>
>> +
>> +#endif	/* __AGILEX5_CLOCK_H */
>> diff --git a/include/dt-bindings/reset/altr,rst-mgr-agilex5.h b/include/dt-bindings/reset/altr,rst-mgr-agilex5.h
>> new file mode 100644
>> index 000000000000..81e5e8c89893
>> --- /dev/null
>> +++ b/include/dt-bindings/reset/altr,rst-mgr-agilex5.h
>
>Same filename as binding.
>
>But why do you need this file? Your device is not a reset controller.

Because Agilex5 device tree uses the reset definition from this file.

Best Regards,
Wen Ping

