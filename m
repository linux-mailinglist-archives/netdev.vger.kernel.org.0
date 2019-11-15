Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3A3CFFDF88
	for <lists+netdev@lfdr.de>; Fri, 15 Nov 2019 14:58:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727593AbfKON6s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Nov 2019 08:58:48 -0500
Received: from mail-wm1-f65.google.com ([209.85.128.65]:50296 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727412AbfKON6s (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Nov 2019 08:58:48 -0500
Received: by mail-wm1-f65.google.com with SMTP id l17so9745906wmh.0
        for <netdev@vger.kernel.org>; Fri, 15 Nov 2019 05:58:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=RWWEJMUZdORn8yPDI/Fopd7icDgebiqPvkJ4VxdZhGU=;
        b=gk7AO9xz0tBC6YBw2yk3p+ki1qAZqedtuG3yrjIt1LQYJUzrxbj5e6/ktgrNnQzCCb
         cQBzdinN1PNmTiR98F0ar/X78E0bjlhjlkCpPpJGBoRxA95g9l1hGUiEckqb7bavjIoo
         eNf0xAu0ObkDD0mDJx6vuvP5QSuBcdxlKmXfd6FhGxvjJboBPT0PWTFgrZh1ckO7AylB
         /AZjjsvyfnM2antzFp4GB4Ad+b1OPdcB6gz2OaBcmGVRO62C5OVfhcCgZ23OjImdBCYx
         omIEee20c8rrEYF9+kRc69ryJTR0BCvjJCI+9qa72G7+a/oZiSE4LmG+dmrdmYmWAUf7
         ndYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=RWWEJMUZdORn8yPDI/Fopd7icDgebiqPvkJ4VxdZhGU=;
        b=CDp5f+KBOZXkf5j6BRsyAGCJAwjj49JSRAtBvym99G04jtRqX8/UAggfwGFzq2j5+Y
         iiNyjBxIE9ZGlvULjUgqRb20o4tie7HNks5wGCgsUOnxbtcFqn54eqCTbMsRbEb4x92I
         HclulorCLBPgmOlTBk8AOdRHGkKzykRoUjEUFBvtLWKTEIMPfnvtTHBcIcv/9KDzqzvW
         DTcfdznrZgpFFIROgyv8JqhtiDaEKI/u0S1ak5shHR/Py6++9TW49vTOEoh/6nzjMtKK
         kMnosNSiAWdB4vZy9iNkIwb+mXTTJb9xMohG+/enLs74AjJFeXkZ4ot/AkpCm+c59rEZ
         ZmTA==
X-Gm-Message-State: APjAAAW6AH6EYeIzbtNM0hlQeYx8+JODnx424q26jTZrMKKUm1FEY0tt
        6emtVX496c4ABdQJ1/UUQOOU/A==
X-Google-Smtp-Source: APXvYqwtAqyj929A434YUA5SY20CGPeyfwrNtjZlpQKDPLLVHxVVhC7FHZxy5s9Tyx+2sRdhGX4RrA==
X-Received: by 2002:a1c:3dc4:: with SMTP id k187mr14368539wma.167.1573826326191;
        Fri, 15 Nov 2019 05:58:46 -0800 (PST)
Received: from localhost (ip-94-113-220-175.net.upcbroadband.cz. [94.113.220.175])
        by smtp.gmail.com with ESMTPSA id u4sm11401340wrq.22.2019.11.15.05.58.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Nov 2019 05:58:45 -0800 (PST)
Date:   Fri, 15 Nov 2019 14:58:45 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Rahul Lakkireddy <rahul.lakkireddy@chelsio.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, nirranjan@chelsio.com,
        vishal@chelsio.com, dt@chelsio.com
Subject: Re: [PATCH net-next v3 1/2] cxgb4: add TC-MATCHALL classifier egress
 offload
Message-ID: <20191115135845.GC2158@nanopsycho>
References: <cover.1573818408.git.rahul.lakkireddy@chelsio.com>
 <5b5af4a7ec3a6c9bc878046f4670a2838bbbe718.1573818408.git.rahul.lakkireddy@chelsio.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5b5af4a7ec3a6c9bc878046f4670a2838bbbe718.1573818408.git.rahul.lakkireddy@chelsio.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fri, Nov 15, 2019 at 01:14:20PM CET, rahul.lakkireddy@chelsio.com wrote:

[...]


>+static int cxgb4_matchall_egress_validate(struct net_device *dev,
>+					  struct tc_cls_matchall_offload *cls)
>+{
>+	struct netlink_ext_ack *extack = cls->common.extack;
>+	struct flow_action *actions = &cls->rule->action;
>+	struct port_info *pi = netdev2pinfo(dev);
>+	struct flow_action_entry *entry;
>+	u64 max_link_rate;
>+	u32 i, speed;
>+	int ret;
>+
>+	if (cls->common.prio != 1) {
>+		NL_SET_ERR_MSG_MOD(extack,
>+				   "Egress MATCHALL offload must have prio 1");

I don't understand why you need it to be prio 1.
