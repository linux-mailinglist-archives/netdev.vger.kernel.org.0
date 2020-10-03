Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 91B62282226
	for <lists+netdev@lfdr.de>; Sat,  3 Oct 2020 09:51:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725763AbgJCHvF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 3 Oct 2020 03:51:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725648AbgJCHvF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 3 Oct 2020 03:51:05 -0400
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA60AC0613E7
        for <netdev@vger.kernel.org>; Sat,  3 Oct 2020 00:51:02 -0700 (PDT)
Received: by mail-wr1-x443.google.com with SMTP id e16so4193647wrm.2
        for <netdev@vger.kernel.org>; Sat, 03 Oct 2020 00:51:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=k2ZUOGVbagWt3EpJ+oMKDCHsZP+OazieIj8l7AmZJ0o=;
        b=aXqNSfWiHGjdLU5AaDEHEnYaGYd29JMQZBGj4SAc3fivAPJhvOQ1hlBv9nsFlCsE4S
         lNRg2sUIqzH2OK8cuErFg9zmzFo/nVEUmMn59Mwo8pkCkffJLfQEzcc4Wk08p16+Rrew
         T8VK+7W1zwKNUivTBp8VvU2FW4ZSB/IhLTp0QNw/o119wqUWRrhRDahYonDP5LqUUgjD
         Fy2Z/cQnmmRaDWg5wjdCUlLyHieo3GgcjZ5Zvzk6j55261psIQKf6bqxFx1zZ1woJccE
         hbbG9MhIx3WBEzpfWdza/0PX0I/0uklTCDXFl3JW5htWa4zdZb4Cla9SDlNSsLYRD6oH
         W36Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=k2ZUOGVbagWt3EpJ+oMKDCHsZP+OazieIj8l7AmZJ0o=;
        b=HuCSR6Bt0TUi+8BCn7w8A3ncUttoHLAlDEkvQFMlCj2dIppaiY8glMJdBQEkZ8QBzO
         3337OKPD2omo9KUf84WxpQ5OXcHkYaYP7MN20OzSmhvt47uAYi3hp2y7dmVtFyxEQqn5
         HMLvE8Sa2Ghjh89IPwWAdewzBnsD5F4oSmDEtyIeBmLFeqKL17urwSd337qn3qkgrEg9
         T6M+eT7CZnRF5F1mq0LV5heU5BJJCwOOG2n9hL2qWq5TcbP2E+QParYZ0Ilh8GwHVIXm
         8zEs3jxfUEB+3oEkUKmpBJOw1YPnDTUhfeVav5rs8EttB1t7fHpQ7vqQpSdBfSvjitl9
         QTrg==
X-Gm-Message-State: AOAM5320lSQNPqNoqAI18AxQ/yxavDiQu1nSkfokmiigqQFuPmPt7Qql
        sxLVnhT/RTQ9JNkrTGM19d0qsg==
X-Google-Smtp-Source: ABdhPJxqRdPBhZAazHT0CqKubKS6w7Wua5O77b+z73+GAnYSU8NRh0JXhEPyMM5koPK2G9pe7W5IYA==
X-Received: by 2002:adf:f504:: with SMTP id q4mr6938574wro.353.1601711461444;
        Sat, 03 Oct 2020 00:51:01 -0700 (PDT)
Received: from localhost ([86.61.181.4])
        by smtp.gmail.com with ESMTPSA id i14sm4780622wro.96.2020.10.03.00.51.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 03 Oct 2020 00:51:00 -0700 (PDT)
Date:   Sat, 3 Oct 2020 09:51:00 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Moshe Shemesh <moshe@mellanox.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Jiri Pirko <jiri@nvidia.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 03/16] devlink: Add devlink reload limit option
Message-ID: <20201003075100.GC3159@nanopsycho.orion>
References: <1601560759-11030-1-git-send-email-moshe@mellanox.com>
 <1601560759-11030-4-git-send-email-moshe@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1601560759-11030-4-git-send-email-moshe@mellanox.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thu, Oct 01, 2020 at 03:59:06PM CEST, moshe@mellanox.com wrote:

[...]

> enum devlink_attr {
> 	/* don't change the order or add anything between, this is ABI! */
> 	DEVLINK_ATTR_UNSPEC,
>@@ -507,6 +524,7 @@ enum devlink_attr {
> 
> 	DEVLINK_ATTR_RELOAD_ACTION,		/* u8 */
> 	DEVLINK_ATTR_RELOAD_ACTIONS_PERFORMED,	/* u64 */
>+	DEVLINK_ATTR_RELOAD_LIMIT,	/* u8 */

Hmm, why there could be specified only single "limit"? I believe this
should be a bitfield. Same for the internal api to the driver.

[...]
