Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2E780547183
	for <lists+netdev@lfdr.de>; Sat, 11 Jun 2022 05:09:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349678AbiFKDJt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jun 2022 23:09:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348522AbiFKDJs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jun 2022 23:09:48 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1EF5F10FEA;
        Fri, 10 Jun 2022 20:09:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1654916987; x=1686452987;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=Qg8gzQMxhNBn7L1OM2gvQQcbtltxGx2N/zMlmJ9N3EA=;
  b=l/kuFiqcONKE15ihd/SUR16F6HtPYue2idGjfbZkQ2UO5jCkU/eHorbS
   Lb7a1f3NhuCjkRXFU60AXt/A2M78lYb3xRwx4J3wD+eDY67My4vn90y+A
   K7fcG85d0o9cqsINExPwtT3NhH6lo00JKk+Tmq6+r8T28oaxLbJQ5FG7X
   JsMgL6WerTCXh7d3n3GRuXklRIQWHzpOKzV3KlsS71ibTdPW5KXy6gccW
   ftwY2lqWBT5nuC/OTaszJSBGA83nmVSqoKMiVnMo0zGq53XMfXM2dTcZ8
   X+dJlD+q5XdCDM5ndtP+yfk1CiZZmkpGK74B4lyAhObzRmHP4Y60XDznd
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10374"; a="341864568"
X-IronPort-AV: E=Sophos;i="5.91,292,1647327600"; 
   d="scan'208";a="341864568"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jun 2022 20:09:46 -0700
X-IronPort-AV: E=Sophos;i="5.91,292,1647327600"; 
   d="scan'208";a="638495570"
Received: from jiaqingz-mobl.ccr.corp.intel.com (HELO [10.255.31.17]) ([10.255.31.17])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jun 2022 20:09:44 -0700
Message-ID: <21c9ba6b-e84e-4545-44d2-5ffe5fea9581@linux.intel.com>
Date:   Sat, 11 Jun 2022 11:09:41 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH v2 5/6] dt-bindings: net: Add NCSI bindings
Content-Language: en-US
To:     Rob Herring <robh@kernel.org>
Cc:     openbmc@lists.ozlabs.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>,
        Samuel Mendoza-Jonas <sam@mendozajonas.com>,
        linux-kernel@vger.kernel.org
References: <20220610165940.2326777-1-jiaqing.zhao@linux.intel.com>
 <20220610165940.2326777-6-jiaqing.zhao@linux.intel.com>
 <1654903146.313095.2450355.nullmailer@robh.at.kernel.org>
From:   Jiaqing Zhao <jiaqing.zhao@linux.intel.com>
In-Reply-To: <1654903146.313095.2450355.nullmailer@robh.at.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-6.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2022-06-11 07:19, Rob Herring wrote:
> On Sat, 11 Jun 2022 00:59:39 +0800, Jiaqing Zhao wrote:
>> Add devicetree bindings for NCSI VLAN modes. This allows VLAN mode to
>> be configured in devicetree.
>>
>> Signed-off-by: Jiaqing Zhao <jiaqing.zhao@linux.intel.com>
>> ---
>>  .../devicetree/bindings/net/ncsi.yaml         | 34 +++++++++++++++++++
>>  MAINTAINERS                                   |  2 ++
>>  include/dt-bindings/net/ncsi.h                | 15 ++++++++
>>  3 files changed, 51 insertions(+)
>>  create mode 100644 Documentation/devicetree/bindings/net/ncsi.yaml
>>  create mode 100644 include/dt-bindings/net/ncsi.h
>>
> 
> My bot found errors running 'make DT_CHECKER_FLAGS=-m dt_binding_check'
> on your patch (DT_CHECKER_FLAGS is new in v5.13):
> 
> yamllint warnings/errors:
> 
> dtschema/dtc warnings/errors:
> /builds/robherring/linux-dt-review/Documentation/devicetree/bindings/net/ncsi.yaml: 'oneOf' conditional failed, one must be fixed:
> 	'unevaluatedProperties' is a required property
> 	'additionalProperties' is a required property
> 	hint: Either unevaluatedProperties or additionalProperties must be present
> 	from schema $id: http://devicetree.org/meta-schemas/core.yaml#
> /builds/robherring/linux-dt-review/Documentation/devicetree/bindings/net/ncsi.yaml: ignoring, error in schema: 
> /builds/robherring/linux-dt-review/Documentation/devicetree/bindings/net/ncsi.example.dtb: ethernet@1e660000: 'ncsi,vlan-mode' does not match any of the regexes
> 	From schema: /builds/robherring/linux-dt-review/Documentation/devicetree/bindings/vendor-prefixes.yaml

I saw vendor-prefix.yaml says do not add non-vendor prefixes to the list. Since "ncsi" is not a vendor, may I ask what is the suggested replacement for 'ncsi,vlan-mode'? Will 'ncsi-vlan-mode' be fine?

> Documentation/devicetree/bindings/net/ncsi.example.dtb:0:0: /example-0/ethernet@1e660000: failed to match any schema with compatible: ['aspeed,ast2600-mac', 'faraday,ftgmac100']
> Documentation/devicetree/bindings/net/ncsi.example.dtb:0:0: /example-0/ethernet@1e660000: failed to match any schema with compatible: ['aspeed,ast2600-mac', 'faraday,ftgmac100']

The ftgmac100 it depends on uses a txt document instead of an yaml schema. And I see there is other schemas having the same error, can this be ignored?

And I've got one more question. The ncsi driver does not has its own compatible field, instead, it is enabled by setting the "use-ncsi" property of some specific mac drivers. Though currently only ftgmac100 supports ncsi in upstream kernel, it may be used by other mac drivers in the future. What do you think is a proper way for defining the ncsi schema? Having it in a separate yaml like this patch or add the properties to all the mac yamls that supports yaml? If the former way is preferred, how should the schema be defined without "compatible"?

> doc reference errors (make refcheckdocs):
> 
> See https://patchwork.ozlabs.org/patch/
> 
> This check can fail if there are any dependencies. The base for a patch
> series is generally the most recent rc1.
> 
> If you already ran 'make dt_binding_check' and didn't see the above
> error(s), then make sure 'yamllint' is installed and dt-schema is up to
> date:
> 
> pip3 install dtschema --upgrade
> 
> Please check and re-submit.
> 
