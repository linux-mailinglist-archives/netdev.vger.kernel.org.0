Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 911D4302EF
	for <lists+netdev@lfdr.de>; Thu, 30 May 2019 21:41:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726720AbfE3Tlm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 May 2019 15:41:42 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:59070 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725897AbfE3Tlm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 May 2019 15:41:42 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id D536F14DA9377;
        Thu, 30 May 2019 12:41:41 -0700 (PDT)
Date:   Thu, 30 May 2019 12:41:41 -0700 (PDT)
Message-Id: <20190530.124141.171150800649105078.davem@davemloft.net>
To:     sameehj@amazon.com
Cc:     netdev@vger.kernel.org, akiyano@amazon.com, dwmw@amazon.com,
        zorik@amazon.com, matua@amazon.com, saeedb@amazon.com,
        msw@amazon.com, aliguori@amazon.com, nafea@amazon.com,
        gtzalik@amazon.com, netanel@amazon.com, alisaidi@amazon.com,
        benh@amazon.com
Subject: Re: [PATCH V1 net-next 02/11] net: ena: ethtool: add extra
 properties retrieval via get_priv_flags
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190529095004.13341-3-sameehj@amazon.com>
References: <20190529095004.13341-1-sameehj@amazon.com>
        <20190529095004.13341-3-sameehj@amazon.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 30 May 2019 12:41:42 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: <sameehj@amazon.com>
Date: Wed, 29 May 2019 12:49:55 +0300

> @@ -560,6 +564,14 @@ struct ena_admin_set_feature_mtu_desc {
>  	u32 mtu;
>  };
>  
> +struct ena_admin_get_extra_properties_strings_desc {
> +	u32 count;
> +};
> +
> +struct ena_admin_get_extra_properties_flags_desc {
> +	u32 flags;
> +};

These single entry structures are a big overkill.  If anything just do one
which is like "ena_value_desc" and has that "u32 val;"
