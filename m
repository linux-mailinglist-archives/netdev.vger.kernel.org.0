Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 107A3D17E9
	for <lists+netdev@lfdr.de>; Wed,  9 Oct 2019 20:58:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731234AbfJIS6O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Oct 2019 14:58:14 -0400
Received: from mail-qt1-f196.google.com ([209.85.160.196]:46809 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729535AbfJIS6O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Oct 2019 14:58:14 -0400
Received: by mail-qt1-f196.google.com with SMTP id u22so4883748qtq.13
        for <netdev@vger.kernel.org>; Wed, 09 Oct 2019 11:58:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=WckHyLuLfvmH0ByNBUogLAcMNwQZXHspjWto9XtrKHE=;
        b=BnbsuEHTHGtTwuaM7SDhWeIDRxYc8Fg5bNo990yCtcB7PNH8XqxNb7zsyR8b99gr4k
         ezpJbgSDPPufyLeLjEnl2TDTgS+9Pt4MI6fLjmK0SdXMgUlfnZlk+FSigPKIHHzNZXSF
         fxq2xRTve+TIgs3cjXbgX6k/0wMv2iU/0NSj8QiWO3cb68Tx71vEfM84UOdmpDTtU/qv
         8HhMNELV17PbFduhdLMab3vj6wfi+Y0qR6PAULDXwRyAjllbjrLynL5mbbg8DxlTNRl8
         oi8mtun6jpXicJGQzW6oPiYFUhK2duwMBWee+5qXLhVymaZ2kzxAzS5tX/SdqjWa5G02
         7acA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=WckHyLuLfvmH0ByNBUogLAcMNwQZXHspjWto9XtrKHE=;
        b=pjW23G9GGfvYiBlodf8zCrBTcDUef0MRz236TZQo69JAkRvZjSPtU7DlsZDq+fLkAC
         9Gg+VIHXmWibyiS9nYDkQHp38Yu2DqB6N4IDk+CN2TaJ8F2/Rx3LBLgBitj2zjA8ruQG
         Yzd5jH/CgUsw2KD5oSFX9eFSpJGFww2AQzxiGhNBSbMYMjKU846ehGaqXtyFUBbMFsmx
         5G0wAGb8Lrb1QgYfzr/+qJsBj5pWHS6hy/lbkAmsmDWRPCJ4ZdeI2W4ea+hvMM0QAUct
         g9xG8QgEelbxcMVLBeefhbSPc32iU41BRErMP58j+apU2OszknSNc9hQa6/9zCaSZ7EJ
         g6Ww==
X-Gm-Message-State: APjAAAW52OIUdpfKbw7mZfNbmrcgEl3LQ5A4qN4SETnl+H+mQpK30X/I
        E/5BZLvrlLrUo/xdGG7CaBuqkg==
X-Google-Smtp-Source: APXvYqzxyO/3zuz4ilVbrEORGakaKgPnUMVEuaYThlCn4uNO7nYm8C2KSh4AZf/bNvgMRFi+7O8gIA==
X-Received: by 2002:a0c:f985:: with SMTP id t5mr5157823qvn.95.1570647492699;
        Wed, 09 Oct 2019 11:58:12 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id d45sm1483179qtc.70.2019.10.09.11.58.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Oct 2019 11:58:12 -0700 (PDT)
Date:   Wed, 9 Oct 2019 11:57:59 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Jacob Keller <jacob.e.keller@intel.com>
Cc:     netdev@vger.kernel.org
Subject: Re: [net] net: update net_dim documentation after rename
Message-ID: <20191009115759.04196ba2@cakuba.netronome.com>
In-Reply-To: <20191008175941.12913-1-jacob.e.keller@intel.com>
References: <20191008175941.12913-1-jacob.e.keller@intel.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue,  8 Oct 2019 10:59:41 -0700, Jacob Keller wrote:
> Commit 8960b38932be ("linux/dim: Rename externally used net_dim
> members") renamed the net_dim API, removing the "net_" prefix from the
> structures and functions. The patch didn't update the net_dim.txt
> documentation file.
> 
> Fix the documentation so that its examples match the current code.
> 
> Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>

For net patches we will need a Fixes tag pointing to the commit which
caused the divergence. Please also make sure to CC the authors and
maintainers so they get a chance to review your patch.

> @@ -132,13 +132,13 @@ usage is not complete but it should make the outline of the usage clear.
>  
>  my_driver.c:
>  
> -#include <linux/net_dim.h>
> +#include <linux/dim.h>
>  
>  /* Callback for net DIM to schedule on a decision to change moderation */
>  void my_driver_do_dim_work(struct work_struct *work)
>  {
> -	/* Get struct net_dim from struct work_struct */
> -	struct net_dim *dim = container_of(work, struct net_dim,
> +	/* Get struct dim from struct work_struct */
> +	struct dim *dim = container_of(work, struct dim,
>  					   work);

nit: looks like you broke the alignment here 

>  	/* Do interrupt moderation related stuff */
>  	...
