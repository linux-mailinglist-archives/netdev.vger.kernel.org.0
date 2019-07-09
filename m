Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 93A62639F6
	for <lists+netdev@lfdr.de>; Tue,  9 Jul 2019 19:11:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726358AbfGIRL1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Jul 2019 13:11:27 -0400
Received: from mail-io1-f66.google.com ([209.85.166.66]:45052 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725816AbfGIRL1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Jul 2019 13:11:27 -0400
Received: by mail-io1-f66.google.com with SMTP id s7so44740057iob.11
        for <netdev@vger.kernel.org>; Tue, 09 Jul 2019 10:11:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=9V2AhubGADCemWnbMd9CL+plTqOeKoqckAOhU8vlB/w=;
        b=TSGhfiV3Us4v2GPLU00vKLm41RteiuJh4WBfCihMIbkALAA3K2z0muyxaQFyKsVJ8O
         QzSJdvVf3pGQe2gCNKCVvkVqaHkMDk1QMSpt6wVZcTiG7eOwFHLaoas5LXx/fMMCk4C8
         jg0VEn6RIOwIJArvgfJio56w7UwMbBPyF8WfTegz9Z2wzXdAVbdkl1QPg1NObrNwamYF
         Qf8gtWB2Mpwe8Z14UqhPjJzwb3dDiAzj6iSqxK+wokZWslifOJWDnPoX2MHpImD7ITaj
         Nuk3EG76hq9THNb+Q6VLqMn2rsUkQl8IolMdIZp2N/KD67rxMLF5YO76rPbpzM/BwrWH
         OcPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=9V2AhubGADCemWnbMd9CL+plTqOeKoqckAOhU8vlB/w=;
        b=QEIaNoXxmcD6PII/o0VB2y7vy3XK3j6hVRNUWOwNLBSXkbUCzETVARuNZ40NDYs5Bv
         xIHNah+UmE/fCA/iPtMOETpn7oPa+MY/KV7OatzPq59T8rLc9qIdg+hTNdnZow+DkeN4
         /NGRfONaM5McnBe7pCpN6o16ySuEpH9kGV1ADQ0fBWVpNS2XgYPSsSeUth70snG2Fp0y
         zE3TAAUOPGEjmlpGtLuqnsNTdzl5aubuvgZDD+l3EPDOfz7q18BNOst2iVuxVOjYILoW
         EbukKUPPSe7JWl0XFadG+3rUYNHazM8ahL20nLfUzA9KocCKDteSvFI3MtdxyTVLhR99
         eGyw==
X-Gm-Message-State: APjAAAVnfgeyJOEuzzjOPCnAQlREd6nBF+UogF1XD4azLXFxeVm3IeoR
        Aj+qTCCtOE5/M1R/bOMb2oI=
X-Google-Smtp-Source: APXvYqwf05xZUa8WVJEj++tIA5HstMDvJDV/I2yu0ll5qz3rpOfJ1WXNl2/L/y5UtotYLdFBvE15zg==
X-Received: by 2002:a02:bb05:: with SMTP id y5mr28171281jan.93.1562692286862;
        Tue, 09 Jul 2019 10:11:26 -0700 (PDT)
Received: from ?IPv6:2601:282:800:fd80:c0e1:11bc:b0c5:7f? ([2601:282:800:fd80:c0e1:11bc:b0c5:7f])
        by smtp.googlemail.com with ESMTPSA id v3sm12245265iom.53.2019.07.09.10.11.25
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 09 Jul 2019 10:11:25 -0700 (PDT)
Subject: Re: [PATCH net-next iproute2] devlink: Show devlink port number
To:     Parav Pandit <parav@mellanox.com>, netdev@vger.kernel.org
Cc:     stephen@networkplumber.org, jiri@mellanox.com, dsahern@kernel.org
References: <20190709163352.20371-1-parav@mellanox.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <cb5ec628-9274-5c09-1412-2c80b12890e2@gmail.com>
Date:   Tue, 9 Jul 2019 11:11:24 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:52.0)
 Gecko/20100101 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <20190709163352.20371-1-parav@mellanox.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/9/19 10:33 AM, Parav Pandit wrote:
> @@ -2806,6 +2806,11 @@ static void pr_out_port(struct dl *dl, struct nlattr **tb)
>  
>  		pr_out_str(dl, "flavour", port_flavour_name(port_flavour));
>  	}
> +	if (tb[DEVLINK_ATTR_PORT_NUMBER]) {
> +		uint32_t port_number =
> +			mnl_attr_get_u32(tb[DEVLINK_ATTR_PORT_NUMBER]);

declare and assign separately; nothing is gained when it is split across
lines like that.

> +		pr_out_uint(dl, "port", port_number);
> +	}
>  	if (tb[DEVLINK_ATTR_PORT_SPLIT_GROUP])
>  		pr_out_uint(dl, "split_group",
>  			    mnl_attr_get_u32(tb[DEVLINK_ATTR_PORT_SPLIT_GROUP]));

