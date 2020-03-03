Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 310771777AE
	for <lists+netdev@lfdr.de>; Tue,  3 Mar 2020 14:49:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729001AbgCCNrI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Mar 2020 08:47:08 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:36278 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728877AbgCCNrH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Mar 2020 08:47:07 -0500
Received: by mail-wr1-f68.google.com with SMTP id j16so4439450wrt.3
        for <netdev@vger.kernel.org>; Tue, 03 Mar 2020 05:47:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=GyVfQXQxs/Su/34p+Wl1N+fO/vG2N412L7jLzkD0EWs=;
        b=IC0s+WLWOSMLC7GoGbh3H95n8VF6eoP/AzlbWskMHCV/jdGsnE+b3+/Fdv/G64QpN+
         E6f3W4axPk1WBwfUWAzsF/e8zkoQVaHF3w0mGw+ahVBM9tdTTizCldn4vXZmnDeeukNH
         yrmtt8Xu7lS7FORskjIkHMda2PMkH1gLcHgCZBkOKXkavu8diiPVSyR1Ty1jQRX/Q1L4
         2ykNOel+kGfzrY8T/b4d5ClgscMEBKA6dVD+eHrHGnvTng/hFirqTOTHRjxReIQQ2szz
         dQSRvAJafGC9WqlDcVPDsIRUDu0HxgsJiwcG098W0hUCZRVuJ693OIzaNo3vB/YMYu9e
         k7EQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=GyVfQXQxs/Su/34p+Wl1N+fO/vG2N412L7jLzkD0EWs=;
        b=a6VhYqfWIufH4Yf6mKlHlD6RnAzf9fI6ovAyPhuySHy/t1EkUC9j8WGEwjXh7DYx+z
         zXefYiFJbuf89rkggh8aG926LggVPxZjbBLabqXhgvN49yGeJx68oEYLr6QXFK1tgfE8
         x5khVwllaUBBkna4ktrxlGSjIYIXms7AJ9Em8z9ys7XrWKRER1dlfvngEO7QuzvY6YW0
         50/UCGXQz/wC510sVnpguWMyMYGZKa9RqcbvyjZh70Gat4/+G2PLFBx/Qk8CitbySKyL
         S5TrfSbAK6AqMmL3uIYrYUE9q6Ev6t3KD3JiQzb4K9vRMM50htEnon1jjSZRwjwpgGzp
         hdyw==
X-Gm-Message-State: ANhLgQ1iugwJQeaMIsIukaol17Sty5iFSYmikpih0OmN7pw763fwfn2h
        8OpxHAxFS88xcba1W+/zqS+lWQ==
X-Google-Smtp-Source: ADFU+vud0krP2pZWiE4Su9aHRHqK+HCRNi6J9MdX5z+K+81PWn+TS/7I8a91/vQWcHRlI3tiH/IEAQ==
X-Received: by 2002:a05:6000:10c8:: with SMTP id b8mr5357440wrx.287.1583243226018;
        Tue, 03 Mar 2020 05:47:06 -0800 (PST)
Received: from localhost ([85.163.43.78])
        by smtp.gmail.com with ESMTPSA id z11sm3997507wmd.47.2020.03.03.05.47.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Mar 2020 05:47:05 -0800 (PST)
Date:   Tue, 3 Mar 2020 14:47:04 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Jacob Keller <jacob.e.keller@intel.com>
Cc:     netdev@vger.kernel.org, valex@mellanox.com, linyunsheng@huawei.com,
        lihong.yang@intel.com, kuba@kernel.org
Subject: Re: [RFC PATCH v2 04/22] ice: enable initial devlink support
Message-ID: <20200303134704.GM2178@nanopsycho>
References: <20200214232223.3442651-1-jacob.e.keller@intel.com>
 <20200214232223.3442651-5-jacob.e.keller@intel.com>
 <20200302163056.GB2168@nanopsycho>
 <12a9a9bb-12ca-7cfa-43f1-ade9d13b9651@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <12a9a9bb-12ca-7cfa-43f1-ade9d13b9651@intel.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Mon, Mar 02, 2020 at 08:29:44PM CET, jacob.e.keller@intel.com wrote:
>
>
>On 3/2/2020 8:30 AM, Jiri Pirko wrote:
>> Sat, Feb 15, 2020 at 12:22:03AM CET, jacob.e.keller@intel.com wrote:
>> 
>> [...]
>> 
>>> +int ice_devlink_create_port(struct ice_pf *pf)
>>> +{
>>> +	struct devlink *devlink = priv_to_devlink(pf);
>>> +	struct ice_vsi *vsi = ice_get_main_vsi(pf);
>>> +	struct device *dev = ice_pf_to_dev(pf);
>>> +	int err;
>>> +
>>> +	if (!vsi) {
>>> +		dev_err(dev, "%s: unable to find main VSI\n", __func__);
>>> +		return -EIO;
>>> +	}
>>> +
>>> +	devlink_port_attrs_set(&pf->devlink_port, DEVLINK_PORT_FLAVOUR_PHYSICAL,
>>> +			       pf->hw.pf_id, false, 0, NULL, 0);
>>> +	err = devlink_port_register(devlink, &pf->devlink_port, pf->hw.pf_id);
>>> +	if (err) {
>>> +		dev_err(dev, "devlink_port_register failed: %d\n", err);
>>> +		return err;
>>> +	}
>> 
>> You need to register_netdev here. Otherwise you'll get inconsistent udev
>> naming.
>> 
>
>The netdev is registered in other portion of the code, and should
>already be registered by the time we call ice_devlink_create_port. This
>check is mostly here to prevent a NULL pointer if the VSI somehow
>doesn't have a netdev associated with it.

My point is, the correct order is:
devlink_register()
devlink_port_attrs_set()
devlink_port_register()
register_netdev()
devlink_port_type_eth_set()


>
>> 
>>> +	if (vsi->netdev)
>>> +		devlink_port_type_eth_set(&pf->devlink_port, vsi->netdev);
>>> +
>>> +	return 0;
>>> +}
>> 
>> 
>> [...]
>> 
