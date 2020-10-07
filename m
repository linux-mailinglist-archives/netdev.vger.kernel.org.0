Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 78D1E285848
	for <lists+netdev@lfdr.de>; Wed,  7 Oct 2020 07:56:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727235AbgJGF4T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Oct 2020 01:56:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726218AbgJGF4T (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Oct 2020 01:56:19 -0400
Received: from mail-oi1-x229.google.com (mail-oi1-x229.google.com [IPv6:2607:f8b0:4864:20::229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4586BC061755
        for <netdev@vger.kernel.org>; Tue,  6 Oct 2020 22:56:19 -0700 (PDT)
Received: by mail-oi1-x229.google.com with SMTP id n2so1295342oij.1
        for <netdev@vger.kernel.org>; Tue, 06 Oct 2020 22:56:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=uCYIv1aG1Ow3v8NaIy9nF+T32jE5nfUoWtjKZq5rTyo=;
        b=S9xbGYRu8NICCmApzKWzDoR3WKjaR6Jr7R+V679n6ga7muUgONPfunyele7AsAv0OE
         aYUQZ9BMAdo9NxSdP5mz93yTz+3E7v8yHgAJX3125CE0S/Kflr6tXh4xwGzj1aKYPSF3
         wWXJXpexYLj+wg2ljlCVfwnx6IW047jWszywhtcWkc4QSiKBpqTVgcSOx2RxOhDz9wvn
         byshWPOBEumJbcLpRrmigNqHvGcQQu4T6W0C8NdE6XZ4QcJboWF/fCqfyN2pFqgk7Jz9
         fJ8YUUecd6Wxy1jfi7xm/J/7A7u0ti+VX3WfrCDziKJThDWOPDqbe+xuS6zpdHA72IjY
         EX6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=uCYIv1aG1Ow3v8NaIy9nF+T32jE5nfUoWtjKZq5rTyo=;
        b=p7Qu+fMtAhvtycEWt5SRm1Q4fN32VjEPDg7Whx09QeQ0Py5jXedrpH9aA9npJEsdF7
         VfbeNeHPFIbmldOkkDZwip/3w4RLAfYD/DBfxtEeDB3drlNiYaTJjPUJDmn7LS6XhhS/
         gXBsA/3JVqTS3zubYTx4fmdX/DMnQXvdad5BKr4L6TkLkHWJdLOkfcSc0wfELjmrNDJU
         jUEAIMrQqzmcDy3vMf7NqYL+b0LmBup7iZJh/IrOy6HGXsUpghFQhl3UtTO4TzAofD07
         ctSuSNi1tQpZm6jUd/O75rKCQPIhCb1IX/OtgYzDuf5CQ7dAi0OP3wdMmh/0nxDtmz5K
         ZWOA==
X-Gm-Message-State: AOAM530p3mDDhaW8ArXLZ3DnMqhNkStTXksdBl8qAYTnbWpwCxHil9Lx
        5mExT0lBjAv15mUWhX+LjyRAapSBmEW97w==
X-Google-Smtp-Source: ABdhPJwLdHcXR1PlSIvcBSZcFu2nMdLlUuWD9g/PqE6vxKO1ELl9ANMumPHOIi6BapfMheV27vx8mw==
X-Received: by 2002:aca:42c2:: with SMTP id p185mr984975oia.55.1602050178057;
        Tue, 06 Oct 2020 22:56:18 -0700 (PDT)
Received: from Davids-MBP.attlocal.net ([2600:1700:3eca:200:4df6:ae94:ee53:9573])
        by smtp.googlemail.com with ESMTPSA id v18sm1261546ooq.11.2020.10.06.22.56.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 06 Oct 2020 22:56:17 -0700 (PDT)
Subject: Re: [iproute2-next v2 1/1] devlink: display elapsed time during flash
 update
To:     Jacob Keller <jacob.e.keller@intel.com>, netdev@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        Shannon Nelson <snelson@pensando.io>
References: <20200930234012.137020-1-jacob.e.keller@intel.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <5ebd3324-1acc-8d9b-2f45-7c4878ad7acc@gmail.com>
Date:   Tue, 6 Oct 2020 22:56:15 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.12.1
MIME-Version: 1.0
In-Reply-To: <20200930234012.137020-1-jacob.e.keller@intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/30/20 4:40 PM, Jacob Keller wrote:
> @@ -3124,12 +3140,19 @@ static int cmd_dev_flash_status_cb(const struct nlmsghdr *nlh, void *data)
>  		done = mnl_attr_get_u64(tb[DEVLINK_ATTR_FLASH_UPDATE_STATUS_DONE]);
>  	if (tb[DEVLINK_ATTR_FLASH_UPDATE_STATUS_TOTAL])
>  		total = mnl_attr_get_u64(tb[DEVLINK_ATTR_FLASH_UPDATE_STATUS_TOTAL]);
> +	if (tb[DEVLINK_ATTR_FLASH_UPDATE_STATUS_TIMEOUT])
> +		ctx->status_msg_timeout = mnl_attr_get_u64(tb[DEVLINK_ATTR_FLASH_UPDATE_STATUS_TIMEOUT]);
> +	else
> +		ctx->status_msg_timeout = 0;
>  
>  	if (!nullstrcmp(msg, ctx->last_msg) &&
>  	    !nullstrcmp(component, ctx->last_component) &&
>  	    ctx->last_pc && ctx->not_first) {
>  		pr_out_tty("\b\b\b\b\b"); /* clean percentage */
>  	} else {
> +		/* only update the last status timestamp if the message changed */
> +		gettimeofday(&ctx->time_of_last_status, NULL);

gettimeofday/REALCLOCK should not be used for measuring time differences.

> +
>  		if (ctx->not_first)
>  			pr_out("\n");
>  		if (component) {
> @@ -3155,11 +3178,72 @@ static int cmd_dev_flash_status_cb(const struct nlmsghdr *nlh, void *data)
>  	return MNL_CB_STOP;
>  }
>  
> +static void cmd_dev_flash_time_elapsed(struct cmd_dev_flash_status_ctx *ctx)
> +{
> +	struct timeval now, res;
> +
> +	gettimeofday(&now, NULL);
> +	timersub(&now, &ctx->time_of_last_status, &res);
> +
