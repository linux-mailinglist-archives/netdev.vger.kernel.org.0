Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 90F0E57A260
	for <lists+netdev@lfdr.de>; Tue, 19 Jul 2022 16:50:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238302AbiGSOuH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jul 2022 10:50:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238614AbiGSOtt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Jul 2022 10:49:49 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BF12DF65;
        Tue, 19 Jul 2022 07:49:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1658242187; x=1689778187;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=hHKtJ6+Dxw4RZU20X6JIbyKBSqc3/xUJvDskXuGrQIc=;
  b=Lc+qJn4qMJQJDWWaDlCmrIPKgBmUkq9tjBUc/+ESu/N20pEntfpo0bYM
   YE74x8lRrex7wrg06u9oznax2BsPv6TzIeTmQIUyxQakaJLxvfGgm4NGE
   xFWdgwSaNawk9D5xZzeBcXROccqbodpYY9FmQbjL0Tb96K3LBXPwV9Uoe
   VVXoasAwcv9qKVDZFTwF4t+CYwzTJMnLnTbBDa99h8XpWh0adH0vPdG4a
   vvSP4afxeEmexsC3BwxeFFyBi4cCXRDiubiKnIIYOAiapVIfzqAJA324y
   5AMO6SlZvniyEJrpLy/0RkYXa8THxuNjbDYeKCTteKGXXKaSvFgEdb3oF
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10413"; a="287661303"
X-IronPort-AV: E=Sophos;i="5.92,284,1650956400"; 
   d="scan'208";a="287661303"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jul 2022 07:49:47 -0700
X-IronPort-AV: E=Sophos;i="5.92,284,1650956400"; 
   d="scan'208";a="594852649"
Received: from kckollur-mobl1.amr.corp.intel.com (HELO [10.212.118.182]) ([10.212.118.182])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jul 2022 07:49:45 -0700
Message-ID: <95fc3b8f-7556-371d-2817-7e0d811de24a@linux.intel.com>
Date:   Tue, 19 Jul 2022 09:49:44 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.11.0
Subject: Re: [PATCH] docs: driver-api: firmware: add driver firmware
 guidelines.
Content-Language: en-US
To:     Dave Airlie <airlied@gmail.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>
Cc:     alsa-devel@alsa-project.org,
        "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Linux Wireless List <linux-wireless@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, linux-block@vger.kernel.org,
        "Luis R. Rodriguez" <mcgrof@kernel.org>,
        Daniel Vetter <daniel@ffwll.ch>,
        Network Development <netdev@vger.kernel.org>,
        "dri-devel@lists.sf.net" <dri-devel@lists.sf.net>,
        Dave Airlie <airlied@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>
References: <20220718072144.2699487-1-airlied@gmail.com>
 <YtWeUOJewho7p/vM@intel.com>
 <CAPM=9tyhOfOz1tn7uNsg_0EzvrBHcSoY+8bignNb2zfgZr6iRw@mail.gmail.com>
From:   Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
In-Reply-To: <CAPM=9tyhOfOz1tn7uNsg_0EzvrBHcSoY+8bignNb2zfgZr6iRw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/18/22 19:29, Dave Airlie wrote:
>>> +* Firmware should be versioned with at least a major/minor version. It
>>> +  is suggested that the firmware files in linux-firmware be named with
>>> +  some device specific name, and just the major version. The
>>> +  major/minor/patch versions should be stored in a header in the
>>> +  firmware file for the driver to detect any non-ABI fixes/issues. The
>>> +  firmware files in linux-firmware should be overwritten with the newest
>>> +  compatible major version. Newer major version firmware should remain
>>> +  compatible with all kernels that load that major number.
>>
>> would symbolic links be acceptable in the linux-firmware.git where
>> the <fmw>_<major>.bin is a sym link to <fwm>_<major>.<minor>.bin
>>
>> or having the <fwm>_<major>.bin really to be the overwritten every minor
>> update?
> 
> I don't think providing multiple minor versions of fw in
> linux-firmware is that interesting.
> Like if the major is the same, surely you always want the newer ones.
> As long as the
> ABI doesn't break. Otherwise we are just wasting disk space with fws
> nobody will be using.

It was my understanding that once a firmware file is in linux-firmware
it's there forever. There are tons of existing symlinks to point to the
latest version, but the previous versions are not removed/overwritten.

see random examples:
ls -lR /lib/firmware  | grep t4fw
ls -lR /lib/firmware  | grep fw_release


