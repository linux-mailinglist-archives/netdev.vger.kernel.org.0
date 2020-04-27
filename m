Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B45421BA41F
	for <lists+netdev@lfdr.de>; Mon, 27 Apr 2020 14:57:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727077AbgD0M54 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Apr 2020 08:57:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726539AbgD0M5z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Apr 2020 08:57:55 -0400
Received: from mail-io1-xd44.google.com (mail-io1-xd44.google.com [IPv6:2607:f8b0:4864:20::d44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85328C0610D5
        for <netdev@vger.kernel.org>; Mon, 27 Apr 2020 05:57:55 -0700 (PDT)
Received: by mail-io1-xd44.google.com with SMTP id y26so8784623ioj.2
        for <netdev@vger.kernel.org>; Mon, 27 Apr 2020 05:57:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=1VmN2EmTrL4m+R5MdNsTcxsZhPDUTATy2MSauojPiIQ=;
        b=rhF39KqbEVg9FlQqxaCMai91XUC7emwsyTfuZvH37HNG2UwOv1ogqPL5d/Owh0UZPn
         ZYlPOzhwidQWa18F7otwvBztkkxyunmmd+N1D0ziJmPL4gaCW1w2uM/PVkJodhpRuvLU
         5HhBBBivgtqsiJBjOqT+mBpJtKHxd1cG7jhw0TDpuN8UznzgLzAcdStwMCboubPeX4Vw
         3AZSsvKOx6xczKqBmmya1QHjFBypWv80bfUcZGrwi9EIQwIl3jGjJaeIKSp875G0yK0h
         UsrCkRHb5dHlMNdbTLV8qAZeWE2ieXqMzF37YgngSOx84rOYMQhYQtB+oD/TDHWc2yi3
         shyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=1VmN2EmTrL4m+R5MdNsTcxsZhPDUTATy2MSauojPiIQ=;
        b=t27od7absBV9FNZy14HdMJvS5vvfRyT1qoTLzv8c9Aqjh/KXLAX3Kv5NiqgLrl+p3V
         9CTpXwdiLzV/5acFVw3ZGiM940leJOC7tEXWB4PLAOpxFp+9771k3tVJ92DaWtjvGgVE
         2vFQGlGzzukdapn2YhMWAxnx5k3v0cXJYw1kD8jQ2sPi6+3AnrX4vQNuBmnelOwb1XoL
         G1jss/EpInEV+asPNxHXVvXozNMs+xRfxSoCmBEPWm/1RalmEIvxreLl7FzOlSCGzJLK
         2af2x8LdQaLCAgVbrxhFFL+7IsbS2oHyEk6hjTSL/AJ/bvUYP1aYtJr9HTxZHPxprVV4
         jgBQ==
X-Gm-Message-State: AGi0PubZ6POC+WHpLVdzaEBAn8MfVbqrowvjxl1VpE3gbrWWxOHu6QS3
        eS4dmdN+93l2GAVmV2EwLpOHi0U5
X-Google-Smtp-Source: APiQypJ+KHCcNL701H34O7ldjlTG3OBbZHec4bKBTU1DmgX9ESJ5gxBYWyE9sKBNizkrkEXzeYtKqw==
X-Received: by 2002:a02:294a:: with SMTP id p71mr20509954jap.105.1587992274812;
        Mon, 27 Apr 2020 05:57:54 -0700 (PDT)
Received: from ?IPv6:2601:282:803:7700:a88f:52f9:794e:3c1? ([2601:282:803:7700:a88f:52f9:794e:3c1])
        by smtp.googlemail.com with ESMTPSA id k24sm5021825ior.49.2020.04.27.05.57.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 27 Apr 2020 05:57:54 -0700 (PDT)
Subject: Re: [PATCH net-next v3 3/3] selftests: net: add new testcases for
 nexthop API compat mode sysctl
To:     Roopa Prabhu <roopa@cumulusnetworks.com>, davem@davemloft.net
Cc:     netdev@vger.kernel.org, rdunlap@infradead.org,
        nikolay@cumulusnetworks.com, bpoirier@cumulusnetworks.com
References: <1587958885-29540-1-git-send-email-roopa@cumulusnetworks.com>
 <1587958885-29540-4-git-send-email-roopa@cumulusnetworks.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <db7cdb35-3b00-644e-6b54-a0adce05e24a@gmail.com>
Date:   Mon, 27 Apr 2020 06:57:53 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <1587958885-29540-4-git-send-email-roopa@cumulusnetworks.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/26/20 9:41 PM, Roopa Prabhu wrote:
> From: Roopa Prabhu <roopa@cumulusnetworks.com>
> 
> New tests to check route dump and notifications with
> net.ipv4.nexthop_compat_mode on and off.
> 
> Signed-off-by: Roopa Prabhu <roopa@cumulusnetworks.com>
> ---
>  tools/testing/selftests/net/fib_nexthops.sh | 198 +++++++++++++++++++++++++++-
>  1 file changed, 196 insertions(+), 2 deletions(-)
> 

Reviewed-by: David Ahern <dsahern@gmail.com>


