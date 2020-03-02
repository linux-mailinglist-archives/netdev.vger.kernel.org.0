Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C0D3F175FA7
	for <lists+netdev@lfdr.de>; Mon,  2 Mar 2020 17:31:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727092AbgCBQa7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Mar 2020 11:30:59 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:40453 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726872AbgCBQa7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Mar 2020 11:30:59 -0500
Received: by mail-wr1-f68.google.com with SMTP id r17so481881wrj.7
        for <netdev@vger.kernel.org>; Mon, 02 Mar 2020 08:30:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=P9JW37Lq2kReTRKr0t+kUHqh9Xaesb4wiGS4OAezry0=;
        b=plCByI8r951xAKbXCpwQerC1B7jS/w8fvJslViT3RyoFGUdJsSLcZDJ5m5wDyrAsU1
         79PY3bgCEGg0mKW7i7fxgPrLRY5jvqmCu3eyde8WMT4/gDgIrfMXcfzyqHDtb0LtAdW2
         Kuj1EzYfrqYYGxwIT3lWvZ+UClyD9l/z+YLgJ7hx6OcjnNKh+r48WckDMYcC+Yi5rzwj
         u00LzvVXn7O5qXeX+wDLqmRQsUVaxcEmDsgzArziZ0oVDhcIN+CHIRZDzNMP+snioif6
         +KWlXr5sBoe7/dr8OX6OSuaOoFGsvZ975hal+hPNtS7rFEyTMBo0rFExJ88Esxs71RGy
         pv4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=P9JW37Lq2kReTRKr0t+kUHqh9Xaesb4wiGS4OAezry0=;
        b=cjarXRnO4YzV69z+PX7b9ayczie6T8fS6BgicRi17wNr3RJIJEIXZlvmXqLUbT4TL9
         QaK0eCpcp3RMDmN/ZliS7GkfoxV3u3lQv7fKb6LqyT3EiKvlKeKEXvQV1Fw+v10+v/qK
         ++x/8nnF2A/DxRGzicJLER/pqVqFbRUFYlNRTxgvNDDIvzMyJ/z73eKtRhSv8jfKCWSh
         b1RNUhoEwjMRCMOicxUS7acgIJYN/Wnw0as9V9/ih8UIQ+0FhBH7ys19QyvDxgCJB/NN
         WzhhsXrpSxZ0UustURT9i8jK1NbvHEvvmpotJ9ub+sf+0uADYrVQw7ZVfEaYgFIduWQ2
         pbQw==
X-Gm-Message-State: ANhLgQ0+qn726wb9sRTF6VWqfKj1OFCneJqgKr+FQF26pvePBh6qvb3Y
        fuG3g94mWc8KipMzdlruoqxL3g==
X-Google-Smtp-Source: ADFU+vvler/N3MF4JKsRddErXki+EQrotNg4ewobvteUuUgRjil7L+o4BJzc3U/HBwZo9S0ZwHtnYQ==
X-Received: by 2002:a5d:5401:: with SMTP id g1mr392232wrv.414.1583166658054;
        Mon, 02 Mar 2020 08:30:58 -0800 (PST)
Received: from localhost (78-136-133-133.client.nordic.tel. [78.136.133.133])
        by smtp.gmail.com with ESMTPSA id m3sm8347449wrx.9.2020.03.02.08.30.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Mar 2020 08:30:57 -0800 (PST)
Date:   Mon, 2 Mar 2020 17:30:56 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Jacob Keller <jacob.e.keller@intel.com>
Cc:     netdev@vger.kernel.org, valex@mellanox.com, linyunsheng@huawei.com,
        lihong.yang@intel.com, kuba@kernel.org
Subject: Re: [RFC PATCH v2 04/22] ice: enable initial devlink support
Message-ID: <20200302163056.GB2168@nanopsycho>
References: <20200214232223.3442651-1-jacob.e.keller@intel.com>
 <20200214232223.3442651-5-jacob.e.keller@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200214232223.3442651-5-jacob.e.keller@intel.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sat, Feb 15, 2020 at 12:22:03AM CET, jacob.e.keller@intel.com wrote:

[...]

>+int ice_devlink_create_port(struct ice_pf *pf)
>+{
>+	struct devlink *devlink = priv_to_devlink(pf);
>+	struct ice_vsi *vsi = ice_get_main_vsi(pf);
>+	struct device *dev = ice_pf_to_dev(pf);
>+	int err;
>+
>+	if (!vsi) {
>+		dev_err(dev, "%s: unable to find main VSI\n", __func__);
>+		return -EIO;
>+	}
>+
>+	devlink_port_attrs_set(&pf->devlink_port, DEVLINK_PORT_FLAVOUR_PHYSICAL,
>+			       pf->hw.pf_id, false, 0, NULL, 0);
>+	err = devlink_port_register(devlink, &pf->devlink_port, pf->hw.pf_id);
>+	if (err) {
>+		dev_err(dev, "devlink_port_register failed: %d\n", err);
>+		return err;
>+	}

You need to register_netdev here. Otherwise you'll get inconsistent udev
naming.


>+	if (vsi->netdev)
>+		devlink_port_type_eth_set(&pf->devlink_port, vsi->netdev);
>+
>+	return 0;
>+}


[...]
