Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 03F3724B9C0
	for <lists+netdev@lfdr.de>; Thu, 20 Aug 2020 13:54:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730554AbgHTLsg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Aug 2020 07:48:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730433AbgHTKD2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Aug 2020 06:03:28 -0400
Received: from mail-lj1-x242.google.com (mail-lj1-x242.google.com [IPv6:2a00:1450:4864:20::242])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 514F6C061383;
        Thu, 20 Aug 2020 03:03:19 -0700 (PDT)
Received: by mail-lj1-x242.google.com with SMTP id t6so1404834ljk.9;
        Thu, 20 Aug 2020 03:03:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:organization:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=y8UqIuhfzyLzFYWb3BCxHsLpMfuYu0DrhXjB/bVTesk=;
        b=i1ry6sXZ1liUrPQCcLBFG6+Y3xSM7sDGiX/tqWVg0OgC2aWd7lvDZ03cDz7QCIehGX
         wcu8FCxGp4n1FmsGkFH04TOE3WXypnzgDk9i0FLueQkrjgEg3uMDJ2xRxyXw7JSPlfLu
         O2ZeoFVlwLrS1h+79CkH/eoUAP0rhyt7qpTqYynIQsCtaMs9b7iVoz8dIOcA+xahwVk5
         bXUl6hnbcZf0GXjw5MBai1fV+6m3tQDnkHJz4qYIOOvgBsP4a2Z2o1TFaojJhjKJta31
         64EdYSeNig8VbhA7xtoCoP6ZTgnssymjG0D5CAWHwc5dYmTtgd5g0zc7RNdM71YfZ4Yz
         tbPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:organization
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=y8UqIuhfzyLzFYWb3BCxHsLpMfuYu0DrhXjB/bVTesk=;
        b=aVSOZ9c66KRjZCf0pg/nnzh9uS8nDgl2CFzQ96eYTQ8lhas1BqBpjmlfquWaja3q2V
         oSGtHDLeTqr+DdI+xvDbUFh8zF1Kr41VjrqMv9fZPCWLIUY0hF74t/PzXHYCtkGhzD6M
         TCFPwMBK5voInvRdYm1JEVmCX1ejvkWdxcF3mPdoVbHXFz+fy9y6imm+/9Ue074eFMtw
         MMecL4fY/fErZkdFLkAIZVUs3d/vp3BsG6WfcxDAbXepuWK+5S78q2sqrp6ZkuFaHnPe
         AitpLKx8a4M6ZmX/RsXoLq5R7UcX/8wDSoguUxL89PmhZIZFbj0EozKpWaxUHrJijU6O
         QWeg==
X-Gm-Message-State: AOAM532K0EsTU068PyxPqpXIHF7SSoUCMLKpCez51KWNi3b8/SkLwyw5
        H7AW2Y30C7E33kvoesZuaZYQ0igEFM3O5Nmb
X-Google-Smtp-Source: ABdhPJwNaTCEt/MjEP6qgrQw7SnK+G6UZ7jE/2rQEW2qcgNt2puQBOYVbW0xvgZ4GWcBWdhHHihDhQ==
X-Received: by 2002:a2e:9b08:: with SMTP id u8mr1182940lji.208.1597917797971;
        Thu, 20 Aug 2020 03:03:17 -0700 (PDT)
Received: from ?IPv6:2a00:1fa0:42ab:a165:4cb2:5f04:a1e8:63b? ([2a00:1fa0:42ab:a165:4cb2:5f04:a1e8:63b])
        by smtp.gmail.com with ESMTPSA id d6sm351128lji.110.2020.08.20.03.03.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 20 Aug 2020 03:03:17 -0700 (PDT)
Subject: Re: [PATCH v3] ravb: Fixed to be able to unload modules
To:     Yuusuke Ashizuka <ashiduka@fujitsu.com>, davem@davemloft.net,
        kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-renesas-soc@vger.kernel.org
References: <20200820094307.3977-1-ashiduka@fujitsu.com>
From:   Sergei Shtylyov <sergei.shtylyov@gmail.com>
Organization: Brain-dead Software
Message-ID: <47080d76-8fdd-9222-34c1-3d174ea6bef8@gmail.com>
Date:   Thu, 20 Aug 2020 13:03:07 +0300
User-Agent: Mozilla/5.0 (Windows NT 6.3; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <20200820094307.3977-1-ashiduka@fujitsu.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 20.08.2020 12:43, Yuusuke Ashizuka wrote:

> When this driver is built as a module, I cannot rmmod it after insmoding
> it.
> This is because that this driver calls ravb_mdio_init() at the time of

    "That" not needed here at all; perhaps can be fixed while applying...

> probe, and module->refcnt is incremented by alloc_mdio_bitbang() called
> after that.
> Therefore, even if ifup is not performed, the driver is in use and rmmod
> cannot be performed.
> 
> $ lsmod
> Module                  Size  Used by
> ravb                   40960  1
> $ rmmod ravb
> rmmod: ERROR: Module ravb is in use
> 
> Call ravb_mdio_init() at open and free_mdio_bitbang() at close, thereby
> rmmod is possible in the ifdown state.
> 
> Fixes: c156633f1353 ("Renesas Ethernet AVB driver proper")
> Signed-off-by: Yuusuke Ashizuka <ashiduka@fujitsu.com>
> Reviewed-by: Sergei Shtylyov <sergei.shtylyov@gmail.com>
[...]

MBR, Sergei
