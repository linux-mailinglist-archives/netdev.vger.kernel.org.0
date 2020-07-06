Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 62C56215C56
	for <lists+netdev@lfdr.de>; Mon,  6 Jul 2020 18:55:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729544AbgGFQzu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jul 2020 12:55:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:42022 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729495AbgGFQzu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 6 Jul 2020 12:55:50 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 532B420702;
        Mon,  6 Jul 2020 16:55:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594054549;
        bh=LWEb8AsbbtrjqHUhQsXiSvwk6k4XClZRxRM0zvFH+zo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=r/k1kSeDdCrKqYGU4rA3oi6YB/wyO6PquTY47vgan+Y7bIU28kHqodj6XAUpoqaPt
         QxkPg5ywGpAhlb8M3WwvZ6+ZgxRju/Ly7QwrUksrpKl9dRqqOSXMlgw3c654CcPXAZ
         zx6M5qT7cDP99aiOPikxdHoa5Yb9pacw8mQQrFms=
Date:   Mon, 6 Jul 2020 09:55:48 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Linus Walleij <linus.walleij@linaro.org>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        DENG Qingfang <dqfext@gmail.com>,
        Mauri Sandberg <sandberg@mailfence.com>
Subject: Re: [net-next PATCH 1/5 v3] net: dsa: tag_rtl4_a: Implement Realtek
 4 byte A tag
Message-ID: <20200706095548.258eb21d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200705231550.77946-2-linus.walleij@linaro.org>
References: <20200705231550.77946-1-linus.walleij@linaro.org>
        <20200705231550.77946-2-linus.walleij@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon,  6 Jul 2020 01:15:46 +0200 Linus Walleij wrote:
> +static struct sk_buff *rtl4a_tag_rcv(struct sk_buff *skb,
> +				     struct net_device *dev,
> +				     struct packet_type *pt)
> +{
> +	u16 protport;
> +	__be16 *p;
> +	u16 etype;
> +	u8 flags;
> +	u8 *tag;
> +	u8 prot;
> +	u8 port;

net/dsa/tag_rtl4_a.c: In function =E2=80=98rtl4a_tag_rcv=E2=80=99:
net/dsa/tag_rtl4_a.c:60:5: warning: unused variable =E2=80=98flags=E2=80=99=
 [-Wunused-variable]
   60 |  u8 flags;
      |     ^~~~~
