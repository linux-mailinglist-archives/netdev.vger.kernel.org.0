Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D574F6F35D5
	for <lists+netdev@lfdr.de>; Mon,  1 May 2023 20:28:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232208AbjEAS2M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 May 2023 14:28:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231467AbjEAS2L (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 May 2023 14:28:11 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64C9012F;
        Mon,  1 May 2023 11:28:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1682965690; x=1714501690;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=th2h6GixFzybR0YMeSTj9+1aYIsWbra5cua0w6goCXc=;
  b=V6Hq7uAcrl9JC2EHQ0L1v1G3xB2O/Rv/N0CfMRGu88AaWxY9yDz8P8gQ
   wuICOp+4F+uLjI3KLhfVVuOYTxFv+9ft2UWo3F7E6OVLi6cv3bjtEv+DM
   YWZUyYQ13jqxYalAQ0n/Hy0vnB53mYqrpk7DFECWOL6AeI0Px2zaqAkWQ
   G0B42Uy42awigGiwAq+/j/uU0uob8cqLniZ7Ppv0oQjdTMSVWFi/yG8K9
   Adv3p7i8573O4itZSmegNhrTQYdBZq/JjDPPgfSpEgxs+xzqWd9GLxBBE
   TpdOArxmxWrt1dEVg24xyszjyo24oTn02vKXB+5dUSnTrf/L/By4M8Vr6
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10697"; a="328573271"
X-IronPort-AV: E=Sophos;i="5.99,241,1677571200"; 
   d="scan'208";a="328573271"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 May 2023 11:28:10 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10697"; a="695867513"
X-IronPort-AV: E=Sophos;i="5.99,241,1677571200"; 
   d="scan'208";a="695867513"
Received: from smile.fi.intel.com ([10.237.72.54])
  by orsmga002.jf.intel.com with ESMTP; 01 May 2023 11:28:06 -0700
Received: from andy by smile.fi.intel.com with local (Exim 4.96)
        (envelope-from <andriy.shevchenko@linux.intel.com>)
        id 1ptYFo-007jxu-36;
        Mon, 01 May 2023 21:28:04 +0300
Date:   Mon, 1 May 2023 21:28:04 +0300
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     Andi Shyti <andi.shyti@kernel.org>
Cc:     Jiawen Wu <jiawenwu@trustnetic.com>, netdev@vger.kernel.org,
        andrew@lunn.ch, linux@armlinux.org.uk,
        jarkko.nikula@linux.intel.com, olteanv@gmail.com,
        hkallweit1@gmail.com, linux-i2c@vger.kernel.org,
        linux-gpio@vger.kernel.org, mengyuanlou@net-swift.com
Subject: Re: [PATCH net-next v4 2/8] i2c: designware: Add driver support for
 Wangxun 10Gb NIC
Message-ID: <ZFAEtI+UgPWGbJMH@smile.fi.intel.com>
References: <20230422045621.360918-1-jiawenwu@trustnetic.com>
 <20230422045621.360918-3-jiawenwu@trustnetic.com>
 <ZEQKlSIIZi9941Bh@smile.fi.intel.com>
 <20230425140859.q23mhtsk5zoc2t3d@intel.intel>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230425140859.q23mhtsk5zoc2t3d@intel.intel>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 25, 2023 at 04:08:59PM +0200, Andi Shyti wrote:
> > >  #define MODEL_MSCC_OCELOT			BIT(8)
> > >  #define MODEL_BAIKAL_BT1			BIT(9)
> > >  #define MODEL_AMD_NAVI_GPU			BIT(10)
> > > +#define MODEL_WANGXUN_SP			BIT(11)
> > >  #define MODEL_MASK				GENMASK(11, 8)
> > 
> > Yeah, maybe next one will need to transform this from bitfield to plain number.
> 
> You mean this?

No, only MODEL_XXX bits.

> -#define ACCESS_INTR_MASK                       BIT(0)
> -#define ACCESS_NO_IRQ_SUSPEND                  BIT(1)
> -#define ARBITRATION_SEMAPHORE                  BIT(2)
> -
> -#define MODEL_MSCC_OCELOT                      BIT(8)
> -#define MODEL_BAIKAL_BT1                       BIT(9)
> -#define MODEL_AMD_NAVI_GPU                     BIT(10)
> -#define MODEL_MASK                             GENMASK(11, 8)
> +#define ACCESS_INTR_MASK                       0x00
> +#define ACCESS_NO_IRQ_SUSPEND                  0x01
> +#define ARBITRATION_SEMAPHORE                  0x02
> +
> +#define MODEL_MSCC_OCELOT                      0x08
> +#define MODEL_BAIKAL_BT1                       0x09
> +#define MODEL_AMD_NAVI_GPU                     0x0a
> +#define MODEL_MASK                             0x78
> 
> I actually like more bitfield to plain numbers.

Too limited. For model we get 16 out of 4 bits, which is much better and as you
see we have a trend.

-- 
With Best Regards,
Andy Shevchenko


