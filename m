Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A281D637459
	for <lists+netdev@lfdr.de>; Thu, 24 Nov 2022 09:46:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229497AbiKXIqj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Nov 2022 03:46:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229468AbiKXIqh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Nov 2022 03:46:37 -0500
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DD488FFBC
        for <netdev@vger.kernel.org>; Thu, 24 Nov 2022 00:46:35 -0800 (PST)
Received: by mail-wm1-x331.google.com with SMTP id o30so791977wms.2
        for <netdev@vger.kernel.org>; Thu, 24 Nov 2022 00:46:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Z+u5YtZG8Andcg50EZfUTzFKPGSQzXEmD3XeKkCsdyc=;
        b=gcLKPIV/DjGw46gLXcGyyTi3uWZGybSuLiCIx3aHFnZGBtKIZPphJMlG3RohqkVHvY
         IFNV8uXEuBofVEQ1TnXeiBPODOdvQpPVn4CUtpMpk3gFBUz6pOLx69yleYVO6IDtT5/a
         1VDap1Cr6gOndSu4TiYeC4fuUm1xca12Vx5OE6Zp6XlbpGLZwvE2sApjHA37naboGWXT
         WoyrADf9D0moYN8ioQnJMwPl9hOpVy1L3Fey9DY9r86loyrx7hjYgGGex4/TUwLeYxcC
         hWGuXMSUMO2oQqs0oE2Foq57xkpaeDmJ7nTbg6jX758d0QVJ2rcmF4bS38N/F0OylqPs
         Rg3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Z+u5YtZG8Andcg50EZfUTzFKPGSQzXEmD3XeKkCsdyc=;
        b=7fA7oH2n2uRhXni8pxOp44O8EYtEg1B8ZMnOeuT92N+3xVqY5ZjYqz3c/7em6KHB52
         E9wilq1KLDh+GiUJFTAV9grNPTzGbxvMQs2Au/PpL53dtLYmHVE7jnkIEe+/LsFj60he
         xg8VZ1EnhsGx3XcHH3j0vDfIliT/fJpdelhkb8XibowK1VEsOjuvCY2C9qZ1fRcellqR
         dX/j3I0e+FRelz2IvSQ0w5ZAbXNkIDqGvYgsMOsBWuYROTfMvudrbzRxRpj+D/VVFSog
         8ucLK/8spgLj6Ec325vvcPJUdGe9jNSATNHjaIRzPBFoPOjCiHW8+KSTIyDS5btLNlIH
         W14g==
X-Gm-Message-State: ANoB5pk7FJKBFyr3B0MqDj20WDVxWqeyvBJLxBHXkSVwOvsI8aNN3ezb
        pd1BQwfHYMSglmip9ibEsWWXHA==
X-Google-Smtp-Source: AA0mqf6Qg/Hg5ul6elOPop9AoyRkY/OT0S088/3c8VAk40CGJKVDJRaq8yfLws7rzaAMvF2B4EiAIQ==
X-Received: by 2002:a05:600c:3543:b0:3cf:74bb:feb1 with SMTP id i3-20020a05600c354300b003cf74bbfeb1mr22224001wmq.102.1669279593635;
        Thu, 24 Nov 2022 00:46:33 -0800 (PST)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id h17-20020a05600c315100b003cf483ee8e0sm5332371wmo.24.2022.11.24.00.46.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Nov 2022 00:46:33 -0800 (PST)
Date:   Thu, 24 Nov 2022 09:46:31 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Jacob Keller <jacob.e.keller@intel.com>
Cc:     netdev@vger.kernel.org, Jiri Pirko <jiri@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH net-next v2 2/9] devlink: report extended error message
 in region_read_dumpit
Message-ID: <Y38vZ/AuQNI0uPjl@nanopsycho>
References: <20221123203834.738606-1-jacob.e.keller@intel.com>
 <20221123203834.738606-3-jacob.e.keller@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221123203834.738606-3-jacob.e.keller@intel.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Wed, Nov 23, 2022 at 09:38:27PM CET, jacob.e.keller@intel.com wrote:

[...]


>@@ -6525,8 +6525,14 @@ static int devlink_nl_cmd_region_read_dumpit(struct sk_buff *skb,
> 
> 	devl_lock(devlink);
> 
>-	if (!attrs[DEVLINK_ATTR_REGION_NAME] ||
>-	    !attrs[DEVLINK_ATTR_REGION_SNAPSHOT_ID]) {
>+	if (!attrs[DEVLINK_ATTR_REGION_NAME]) {
>+		NL_SET_ERR_MSG(cb->extack, "No region name provided");
>+		err = -EINVAL;
>+		goto out_unlock;
>+	}
>+
>+	if (!attrs[DEVLINK_ATTR_REGION_SNAPSHOT_ID]) {
>+		NL_SET_ERR_MSG(cb->extack, "No snapshot id provided");
> 		err = -EINVAL;
> 		goto out_unlock;
> 	}
>@@ -6541,7 +6547,8 @@ static int devlink_nl_cmd_region_read_dumpit(struct sk_buff *skb,
> 		}
> 	}
> 
>-	region_name = nla_data(attrs[DEVLINK_ATTR_REGION_NAME]);
>+	region_attr = attrs[DEVLINK_ATTR_REGION_NAME];
>+	region_name = nla_data(region_attr);
> 
> 	if (port)
> 		region = devlink_port_region_get_by_name(port, region_name);
>@@ -6549,6 +6556,7 @@ static int devlink_nl_cmd_region_read_dumpit(struct sk_buff *skb,
> 		region = devlink_region_get_by_name(devlink, region_name);
> 
> 	if (!region) {
>+		NL_SET_ERR_MSG_ATTR(cb->extack, region_attr, "requested region does not exist");

Any reason why don't start the message with uppercase? It would be
consistent with the other 2 messages you just introduced.
Same goes to the message in the next patch (perhaps some others too)


> 		err = -EINVAL;
> 		goto out_unlock;
> 	}
>-- 
>2.38.1.420.g319605f8f00e
>
