Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1AE5F67281E
	for <lists+netdev@lfdr.de>; Wed, 18 Jan 2023 20:26:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229883AbjART0R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Jan 2023 14:26:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229947AbjART0L (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Jan 2023 14:26:11 -0500
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5DAC53E41
        for <netdev@vger.kernel.org>; Wed, 18 Jan 2023 11:26:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1674069970; x=1705605970;
  h=date:from:to:cc:subject:in-reply-to:message-id:
   references:mime-version;
  bh=1/ABRf/ZmR5hJO/SiwdFYh84ObDW3BsbAXk6hUPfI8A=;
  b=J4v47raNSYEIG80Fc6Af4qTfp6+fOttbASztL7lUAcW4bswCnogta6JM
   QNT+VGcA5K0uV7bXTrfAfGHNKR0AqQ7hAFmH4SqkM2aGzA+wvJ46P9qPu
   vFim6UmHqF2ZcYDmphSVS2qg0bpzegrXbB8dpPAeElhS+fiUAsY+53piF
   DATtnblkpetiEXBIFm2ljrZLRqgyGnQnRSqzDuuzU9qUcTpc5rVRcX+CV
   PAWdFvPwu16nZKLn61F2/qMX/iutjggh4AMCkVqsYWv6J4fhfJV5EvfId
   3zbUdtg67EriFNHBJNJsJihTmsIbE8ziuRXd8HHR+bAus2WVPINd+lqKT
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10594"; a="325129167"
X-IronPort-AV: E=Sophos;i="5.97,226,1669104000"; 
   d="scan'208";a="325129167"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jan 2023 11:26:10 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10594"; a="833715121"
X-IronPort-AV: E=Sophos;i="5.97,226,1669104000"; 
   d="scan'208";a="833715121"
Received: from tszopax-mobl2.ger.corp.intel.com ([10.252.41.243])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jan 2023 11:26:01 -0800
Date:   Wed, 18 Jan 2023 21:25:52 +0200 (EET)
From:   =?ISO-8859-15?Q?Ilpo_J=E4rvinen?= <ilpo.jarvinen@linux.intel.com>
To:     "Kumar, M Chetan" <m.chetan.kumar@linux.intel.com>
cc:     Netdev <netdev@vger.kernel.org>, kuba@kernel.org,
        davem@davemloft.net, johannes@sipsolutions.net,
        ryazanov.s.a@gmail.com, loic.poulain@linaro.org,
        ricardo.martinez@linux.intel.com,
        chiranjeevi.rapolu@linux.intel.com, haijun.liu@mediatek.com,
        edumazet@google.com, pabeni@redhat.com,
        chandrashekar.devegowda@intel.com, linuxwwan@intel.com,
        linuxwwan_5g@intel.com,
        Mishra Soumya Prakash <soumya.prakash.mishra@intel.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>
Subject: Re: [PATCH v4 net-next 4/5] net: wwan: t7xx: Enable devlink based
 fw flashing and coredump collection
In-Reply-To: <305d9f7e-ec2a-beea-fc25-a2a0073e0154@linux.intel.com>
Message-ID: <ef4667d-d9f1-8056-fc29-f609c46faa8@linux.intel.com>
References: <cover.1673842618.git.m.chetan.kumar@linux.intel.com> <b4605932b28346ba81450f15f2790016c732e043.1673842618.git.m.chetan.kumar@linux.intel.com> <87c8edd-41e0-136-d1ac-168ceff5855@linux.intel.com>
 <305d9f7e-ec2a-beea-fc25-a2a0073e0154@linux.intel.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="8323329-1709548627-1674069965=:1750"
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323329-1709548627-1674069965=:1750
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT

On Wed, 18 Jan 2023, Kumar, M Chetan wrote:

> Hi Ilpo,
> Thank you for the feedback.
> 
> On 1/17/2023 7:37 PM, Ilpo Järvinen wrote:
> > On Mon, 16 Jan 2023, m.chetan.kumar@linux.intel.com wrote:
> > 
> > > From: M Chetan Kumar <m.chetan.kumar@linux.intel.com>
> > > 
> > > Adds support for t7xx wwan device firmware flashing & coredump collection
> > > using devlink.
> > > 
> > > 1> Driver Registers with Devlink framework.
> > > 2> Implements devlink ops flash_update callback that programs modem fw.
> > > 3> Creates region & snapshot required for device coredump log collection.
> > > 
> > > On early detection of wwan device in fastboot mode driver sets up CLDMA0
> > > HW
> > > tx/rx queues for raw data transfer and then registers to devlink
> > > framework.
> > > On user space application issuing command for firmware update the driver
> > > sends fastboot flash command & firmware to program NAND.
> > > 
> > > In flashing procedure the fastboot command & response are exchanged
> > > between
> > > driver and device. Once firmware flashing is success completion status is
> > > reported to user space application.
> > > 
> > > Below is the devlink command usage for firmware flashing
> > > 
> > > $devlink dev flash pci/$BDF file ABC.img component ABC
> > > 
> > > Note: ABC.img is the firmware to be programmed to "ABC" partition.
> > > 
> > > In case of coredump collection when wwan device encounters an exception
> > > it reboots & stays in fastboot mode for coredump collection by host
> > > driver.
> > > On detecting exception state driver collects the core dump, creates the
> > > devlink region & reports an event to user space application for dump
> > > collection. The user space application invokes devlink region read command
> > > for dump collection.
> > > 
> > > Below are the devlink commands used for coredump collection.
> > > 
> > > devlink region new pci/$BDF/mr_dump
> > > devlink region read pci/$BDF/mr_dump snapshot $ID address $ADD length $LEN
> > > devlink region del pci/$BDF/mr_dump snapshot $ID
> > > 
> > > Signed-off-by: M Chetan Kumar <m.chetan.kumar@linux.intel.com>
> > > Signed-off-by: Devegowda Chandrashekar <chandrashekar.devegowda@intel.com>
> > > Signed-off-by: Mishra Soumya Prakash <soumya.prakash.mishra@intel.com>
> > > Reviewed-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
> > > --

> > > +	for (i = 0; i < total_part; i++) {
> > 
> > The whole operation below is quite fancy, I'd add some comment telling the
> > intent.
> 
> Device returns firmware name & version in string format. Using below logic to
> decode it.
>
> Will add some comment.
> 
> > 
> > > +		part_name = strsep(&data, ",");
> > > +		ver = strsep(&data, ",");
> > 
> > Can ver become NULL here?
> 
> It should not be the case. As part of component fw version query device is
> expected to send the complete list for fw components.
> 
> On safer note will add NULL check.
> 
> > 
> > > +		ver_len = strlen(ver);
> > > +		if (ver[ver_len - 2] == 0x5C && ver[ver_len - 1] == 0x6E)
> > > +			ver[ver_len - 4] = '\0';
> > 
> > Is ver_len guaranteed to be large enough?
> 
> fw version query response message will not cross 512 bytes.
> It is aligned with device implementation.

I meant the other way around, is ver_len guaranteed to large enough that 
it is safe to do ver_len - 4 (or even -1).

> > > +		ret = devlink_info_version_running_put_ext(req, part_name,
> > > ver,
> > > +
> > > DEVLINK_INFO_VERSION_TYPE_COMPONENT);
> > > +	}
> > > +
> > > +err_clear_bit:
> > > +	clear_bit(T7XX_GET_INFO, &dl->status);
> > > +	kfree(data);
> > > +	return ret;
> > > +}

> > > +static void t7xx_devlink_uninit(struct t7xx_port *port)
> > > +{
> > > +	struct t7xx_devlink *dl = port->t7xx_dev->dl;
> > > +	int i;
> > > +
> > > +	vfree(dl->regions[T7XX_MRDUMP_INDEX].buf);
> > > +
> > > +	dl->mode = T7XX_NORMAL_MODE;
> > > +	destroy_workqueue(dl->wq);
> > > +
> > > +	BUILD_BUG_ON(ARRAY_SIZE(t7xx_devlink_region_infos) >
> > > ARRAY_SIZE(dl->regions));
> > 
> > The same BUILD_BUG_ON again? Maybe just make a single static_assert()
> > outside of the functions.
> 
> Should i change it as below ? please suggest.
> 
> static_assert(ARRAY_SIZE(t7xx_devlink_region_infos) ==
>               (sizeof(typeof_member(struct t7xx_devlink, regions)) /
>                sizeof(struct t7xx_devlink_region)));
> static void t7xx_devlink_uninit(struct t7xx_port *port)
> {
> ..

I see, it's not that easy so perhaps just leave it as is.

I guess something like this might work but seems bit hacky to me 
(untested):

static_assert(ARRAY_SIZE(t7xx_devlink_region_infos) ==
	      ARRAY_SIZE(((struct t7xx_devlink *)NULL)->regions));

-- 
 i.

--8323329-1709548627-1674069965=:1750--
