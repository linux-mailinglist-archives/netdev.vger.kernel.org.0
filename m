Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A235A54A713
	for <lists+netdev@lfdr.de>; Tue, 14 Jun 2022 04:55:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354266AbiFNCxX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jun 2022 22:53:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354684AbiFNCxJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jun 2022 22:53:09 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EAD96004C;
        Mon, 13 Jun 2022 19:34:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1655174056; x=1686710056;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=47svbfWKkXZf9LfactisOBeorwmkIQeKErqvocVmXSE=;
  b=X8cQ9/9l/tBYD/m4vcJnkUopw5yGZiLGp6PONiClPC7F07WvflplSJ1V
   2+1pw9Nj9P7fscwgjKq1jTZe5zGE9KWBhW7ZPCBD+jDdHdp2H5zo39csV
   sYb4repuMECE2EBgawRq12EYLsgxLV7SznmNtYON4XHGCNTPajZ578EUq
   t8o3KcWy8kW/RRQ+1FkAdbgpPiiAvSzPPCYhK57y9++SWyf8a/303QdiW
   zd2rFkyXk+7KwBKL1Aje9iyu+t6bZ9ZYkRX1sPhkn8IMh4b0lEE2boy88
   63zMehR3gVuyQMG3jb+JC7Tai9KS4R1LMQN0W3XqzJCRw2jx3dzFNGnN7
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10377"; a="267169272"
X-IronPort-AV: E=Sophos;i="5.91,298,1647327600"; 
   d="scan'208";a="267169272"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jun 2022 19:33:14 -0700
X-IronPort-AV: E=Sophos;i="5.91,298,1647327600"; 
   d="scan'208";a="588157874"
Received: from jiaqingz-mobl.ccr.corp.intel.com (HELO [10.238.1.239]) ([10.238.1.239])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jun 2022 19:33:12 -0700
Message-ID: <aff542a3-ac98-c33d-9612-63ebca180e17@linux.intel.com>
Date:   Tue, 14 Jun 2022 10:33:10 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH v2 5/6] dt-bindings: net: Add NCSI bindings
Content-Language: en-US
To:     Rob Herring <robh@kernel.org>
Cc:     OpenBMC Maillist <openbmc@lists.ozlabs.org>,
        netdev <netdev@vger.kernel.org>, devicetree@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>,
        Samuel Mendoza-Jonas <sam@mendozajonas.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <20220610165940.2326777-1-jiaqing.zhao@linux.intel.com>
 <20220610165940.2326777-6-jiaqing.zhao@linux.intel.com>
 <1654903146.313095.2450355.nullmailer@robh.at.kernel.org>
 <21c9ba6b-e84e-4545-44d2-5ffe5fea9581@linux.intel.com>
 <CAL_Jsq+y3tkfLV8UpUe6jw7Fq7YDrzwoq3FKK4jeeZEBOxhM4g@mail.gmail.com>
From:   Jiaqing Zhao <jiaqing.zhao@linux.intel.com>
In-Reply-To: <CAL_Jsq+y3tkfLV8UpUe6jw7Fq7YDrzwoq3FKK4jeeZEBOxhM4g@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-6.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2022-06-13 23:28, Rob Herring wrote:
> On Fri, Jun 10, 2022 at 9:09 PM Jiaqing Zhao
> <jiaqing.zhao@linux.intel.com> wrote:
>>
>> On 2022-06-11 07:19, Rob Herring wrote:
>>> On Sat, 11 Jun 2022 00:59:39 +0800, Jiaqing Zhao wrote:
>>>> Add devicetree bindings for NCSI VLAN modes. This allows VLAN mode to
>>>> be configured in devicetree.
>>>>
>>>> Signed-off-by: Jiaqing Zhao <jiaqing.zhao@linux.intel.com>
>>>> ---
>>>>  .../devicetree/bindings/net/ncsi.yaml         | 34 +++++++++++++++++++
>>>>  MAINTAINERS                                   |  2 ++
>>>>  include/dt-bindings/net/ncsi.h                | 15 ++++++++
>>>>  3 files changed, 51 insertions(+)
>>>>  create mode 100644 Documentation/devicetree/bindings/net/ncsi.yaml
>>>>  create mode 100644 include/dt-bindings/net/ncsi.h
>>>>
>>>
>>> My bot found errors running 'make DT_CHECKER_FLAGS=-m dt_binding_check'
>>> on your patch (DT_CHECKER_FLAGS is new in v5.13):
>>>
>>> yamllint warnings/errors:
>>>
>>> dtschema/dtc warnings/errors:
>>> /builds/robherring/linux-dt-review/Documentation/devicetree/bindings/net/ncsi.yaml: 'oneOf' conditional failed, one must be fixed:
>>>       'unevaluatedProperties' is a required property
>>>       'additionalProperties' is a required property
>>>       hint: Either unevaluatedProperties or additionalProperties must be present
>>>       from schema $id: http://devicetree.org/meta-schemas/core.yaml#
>>> /builds/robherring/linux-dt-review/Documentation/devicetree/bindings/net/ncsi.yaml: ignoring, error in schema:
>>> /builds/robherring/linux-dt-review/Documentation/devicetree/bindings/net/ncsi.example.dtb: ethernet@1e660000: 'ncsi,vlan-mode' does not match any of the regexes
>>>       From schema: /builds/robherring/linux-dt-review/Documentation/devicetree/bindings/vendor-prefixes.yaml
>>
>> I saw vendor-prefix.yaml says do not add non-vendor prefixes to the list. Since "ncsi" is not a vendor, may I ask what is the suggested replacement for 'ncsi,vlan-mode'? Will 'ncsi-vlan-mode' be fine?
> 
> I don't know. What is NCSI? Is it specific to certain MACs? Why do you
> need to set this up in DT? Network configuration is typically done in
> userspace, so putting VLAN config in DT doesn't seem right. All
> questions your commit message should answer.

NCSI is a protocol that uses an external MAC+PHY like a PHY, the
topology looks like:

         Packets + NCSI commands              Packets
     MAC-------------------------External MAC---------PHY

Some MACs like ftgmac100 driver supports using NCSI instead of PHY,
the operation mode is configured by a DT option "use-ncsi". The NCSI
external MAC has its own configuration, like VLAN filter mode of it,
and all NCSI devices uses a generic driver. So I these external mac
configurations to DT as they are device properties to kernel. Userspace
is only able to configure the "internal" MAC.

>>> Documentation/devicetree/bindings/net/ncsi.example.dtb:0:0: /example-0/ethernet@1e660000: failed to match any schema with compatible: ['aspeed,ast2600-mac', 'faraday,ftgmac100']
>>> Documentation/devicetree/bindings/net/ncsi.example.dtb:0:0: /example-0/ethernet@1e660000: failed to match any schema with compatible: ['aspeed,ast2600-mac', 'faraday,ftgmac100']
>>
>> The ftgmac100 it depends on uses a txt document instead of an yaml schema. And I see there is other schemas having the same error, can this be ignored?
> 
> No. Don't add to the list. Once all the existing warnings (~40) are
> fixed, then this will be turned on by default.

Sure, I'll put this to ftgmac100.txt instead of separate yaml file.

>>
>> And I've got one more question. The ncsi driver does not has its own compatible field, instead, it is enabled by setting the "use-ncsi" property of some specific mac drivers. Though currently only ftgmac100 supports ncsi in upstream kernel, it may be used by other mac drivers in the future. What do you think is a proper way for defining the ncsi schema? Having it in a separate yaml like this patch or add the properties to all the mac yamls that supports yaml? If the former way is preferred, how should the schema be defined without "compatible"?
> 
> If it is a function of driver support or not, then it doesn't belong in DT.
> 
> Rob

It's a hardware operation mode of the external MAC, I think it's
reasonable to put it in DT.

There is also a previous patch adding NCSI MAC config "mlx,multi-host"
in DT at https://lore.kernel.org/netdev/20200108234341.2590674-1-vijaykhemka@fb.com/T/
I referred this for my implementation, though it is undocumented.

Jiaqing
