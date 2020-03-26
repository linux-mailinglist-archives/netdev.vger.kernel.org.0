Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 316F0193B58
	for <lists+netdev@lfdr.de>; Thu, 26 Mar 2020 09:54:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726422AbgCZIyn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Mar 2020 04:54:43 -0400
Received: from mail-wm1-f53.google.com ([209.85.128.53]:35282 "EHLO
        mail-wm1-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726292AbgCZIyn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Mar 2020 04:54:43 -0400
Received: by mail-wm1-f53.google.com with SMTP id m3so6049609wmi.0
        for <netdev@vger.kernel.org>; Thu, 26 Mar 2020 01:54:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=ZIipjHigDA9cSj86qvGrzuk6ZSEvOk2H1r8er3Cz4+k=;
        b=YNzoV4hkZUcVBNXpbMd4Eay7RR1sOQh/fST5pRQ1FDfO0eb5sPdmgL4G1rNxX8O3iw
         YjhxpG5krBhjsAZRZDn2QwejItFYiC07t6mOZqjI9xXzvQeNYqSxDUa3kytzv3FoS4pn
         EPVKZIhsetdeMatqB8dCqvoyrYnWdbj3I2R6T5fO15rpUVaXV7ZhOEFXvjBVG5FXjvnr
         P1LgKv/fM2Y0ZW3oOVEMbI3RedAXDiH2SyzPjVRlvD9voiFxCuy+5Rnbum58eL/wjVl+
         UdVUspFCCX56wVpRcKtZnb4HhRn0bwn22Jmiwzir/BZgemBpMWNIEQU7KBkz2PwBePm4
         kmhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ZIipjHigDA9cSj86qvGrzuk6ZSEvOk2H1r8er3Cz4+k=;
        b=pJtwSkTReMZfhi1QzHRJgRErzzUd0pAh5E4ndi6wnkFJIRF1ieNPFfsHmXGE/Fk/Mb
         B3qAsgh7vhZnXCBnwhKEk1yevQHFXP/xjeGYy9Wc0Uxnjqrp9e9Dd2ypRkKe1ltw1aOY
         VlUZdV8u71vJGi1VFT5W4VNu1DHQt2m5W02IlSlfwflJKweLYoI7nKkhiNsnsQE6g4Qi
         g/WcrrrtXCTSoUsDsh9bS7Syj0izGO4ozv8uRCRxSsYdiQ7Lhu7/jtNr/53+044658Le
         fUfjBg/3pv3ac2GpI3BzWX4ncyEBQAknDdPnM0s8AOaPxG/uBEVTipwxUuFEAPFlquBq
         E8yQ==
X-Gm-Message-State: ANhLgQ2bPqZTq5Nvh4iEIXvhOuiZiudtlJ9p5UQEZM9LzSsRg7Oe+lFQ
        POWw4tsASPcbQ2wUdt2T+QU74g==
X-Google-Smtp-Source: ADFU+vv1OQxY4N6cE+v6BBcWDHtERjqr6WzKXXVju37HpecBCeBL7nHe93/9EaEqgL+FeOWTaquLmw==
X-Received: by 2002:a1c:2c85:: with SMTP id s127mr2031776wms.18.1585212881096;
        Thu, 26 Mar 2020 01:54:41 -0700 (PDT)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id t2sm2479863wml.30.2020.03.26.01.54.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Mar 2020 01:54:40 -0700 (PDT)
Date:   Thu, 26 Mar 2020 09:54:40 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Jacob Keller <jacob.e.keller@intel.com>
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>
Subject: Re: [net-next v2 00/11] implement DEVLINK_CMD_REGION_NEW
Message-ID: <20200326085440.GA4694@nanopsycho.orion>
References: <20200326035157.2211090-1-jacob.e.keller@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200326035157.2211090-1-jacob.e.keller@intel.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thu, Mar 26, 2020 at 04:51:46AM CET, jacob.e.keller@intel.com wrote:

[...]

> * devlink: implement DEVLINK_CMD_REGION_NEW
>
>   Added a WARN_ON to the check in snapshot_id_insert in case the id already
>   exists.
>
>   Removed an unnecessary "if (err) { return err; }" construction
>
>   Use -ENOSPC instead of -ENOMEM when max_snapshots is reached.
>
>   Cleanup label names to match style of the other labels in the file,
>   naming after the failure cause rather than the cleanup step. Also fix a
>   bug in the label ordering.
>
>   Call the new devlink_region_snapshot_id_put function in the mlx4 and
>   netdevsim drivers.

This belongs to a different patch. This would not happen if you'd have
per-patch changelog :)

[...]
