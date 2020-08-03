Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D7CF23A989
	for <lists+netdev@lfdr.de>; Mon,  3 Aug 2020 17:39:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726999AbgHCPid (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Aug 2020 11:38:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726888AbgHCPid (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Aug 2020 11:38:33 -0400
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A59DAC06174A
        for <netdev@vger.kernel.org>; Mon,  3 Aug 2020 08:38:32 -0700 (PDT)
Received: by mail-wm1-x333.google.com with SMTP id g8so21699wmk.3
        for <netdev@vger.kernel.org>; Mon, 03 Aug 2020 08:38:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=5jDzwNbhr+OBWPtwLyPuSXR9TCR8x8kQIrBrZJiPTkw=;
        b=QNtYcW3bMMLOMeTlpDHsmcDks8G5msAMcqS9MwZo6wCKylS1izuVMAXTW4puBEK192
         xrv/6D/ygLw2eXKsUnDGtF+2pUjHSX0Mw8HGChjNNlHbYoU2tEEBFPf5vhO7edjt6efE
         ySI42xie+83uRCTQsfCFrlGTdNJKhwshJSfnknW2EpO41O0fe0c+TDSlZDAmI83vxp3e
         vO5ax0SK7lkEKpPhLFAFasw08ss6lOIm+sTegedYUWVxDJ/gU2KLBD0Lz+WYMFCbo3Zj
         I2RrC/k/kN7ZhkgAev/pW/DFvc+b8IxGFedXFpEAkpxDxs4/sjFJRY5P5Ehcl/NNxhVc
         Gv7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=5jDzwNbhr+OBWPtwLyPuSXR9TCR8x8kQIrBrZJiPTkw=;
        b=AsVPFHecGJRBPkkJEboF0UslD2yGXafDxfN2SjXJ0wmXL96a2s9M8ORQ5fGom0qziV
         qAJ+mZNV5gL13KeiRMjEg4l99VF1HuAYSSI1OS5bOhddytoN2YglC8o9CgZuL54cxKxF
         36FJ+8kiAYgjUK2jnG7C+niw5ueT3xV3mmvbs1m01GEWfia66J6AjxmTqCcXxMpqVOhT
         o9O5MDdOpJ52oFuvB19TQZI+9H1VyvnogJVIZ5mjBmEVnymX/jze8RD1BH3ehAyFjIpX
         dZNnswSqn0P5YDfTysDlvJakRYGdwgi1Y6j38p0iguRDcFvzyYC9/vFq/InJ4y7Z7I9K
         KtWA==
X-Gm-Message-State: AOAM5308I2P1N27rkAzH7akGWrdERi4112rTKjtT4j68cR8sNgYQD+pR
        NOditRIIy+nkp/wAu/4bnzMX4A==
X-Google-Smtp-Source: ABdhPJwnhLna76jQ32tqUhXK6KqxTtVuydaHg7KV7JkN5Z2tQgigmJkBBvBn96o5TZ/TohA7dTd4OQ==
X-Received: by 2002:a1c:a590:: with SMTP id o138mr557720wme.4.1596469111382;
        Mon, 03 Aug 2020 08:38:31 -0700 (PDT)
Received: from localhost (ip-89-176-225-97.net.upcbroadband.cz. [89.176.225.97])
        by smtp.gmail.com with ESMTPSA id c10sm23878303wro.84.2020.08.03.08.38.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Aug 2020 08:38:31 -0700 (PDT)
Date:   Mon, 3 Aug 2020 17:38:30 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Jacob Keller <jacob.e.keller@intel.com>
Cc:     netdev@vger.kernel.org
Subject: Re: [net-next v2 2/5] devlink: introduce flash update overwrite mask
Message-ID: <20200803153830.GD2290@nanopsycho>
References: <20200801002159.3300425-1-jacob.e.keller@intel.com>
 <20200801002159.3300425-3-jacob.e.keller@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200801002159.3300425-3-jacob.e.keller@intel.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sat, Aug 01, 2020 at 02:21:56AM CEST, jacob.e.keller@intel.com wrote:

[...]

>+	nla_mask = info->attrs[DEVLINK_ATTR_FLASH_UPDATE_OVERWRITE_MASK];
>+	if (nla_mask) {
>+		if (!(supported_params & DEVLINK_SUPPORT_FLASH_UPDATE_OVERWRITE_MASK)) {
>+			NL_SET_ERR_MSG_ATTR(info->extack, nla_mask,
>+					    "overwrite is not supported");
>+			return -EOPNOTSUPP;
>+		}
>+		params.overwrite_mask = nla_get_u32(nla_mask);

It's a bitfield, should be NL_ATTR_TYPE_BITFIELD32.

