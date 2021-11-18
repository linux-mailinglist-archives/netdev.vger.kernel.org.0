Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D09074553E5
	for <lists+netdev@lfdr.de>; Thu, 18 Nov 2021 05:42:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243026AbhKREpT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Nov 2021 23:45:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:41442 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241924AbhKREpQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 17 Nov 2021 23:45:16 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id DB08761AA9;
        Thu, 18 Nov 2021 04:42:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637210536;
        bh=ZYoUiZma9XmCfS77K5mblLfiVjWC2xPDADZTuS8Q11Y=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=OeSajbWol8nXasARQgH1pKKDG3u6uNQJrsPdLirAhwZSlnX5j4eqQneTSNU2UqL0S
         Q7uzmhMqyqff0E6n6b+YxZIAW4eRp44XO0dAxC9ODh08I3GGYc+BaDo4wEiAcwPUKn
         NBSQCbyc6ttN7hHiyxagC4qdbYdV1MFrCOtaLGZh5GyeAHdfWVYtEXsOlIYrLXCWfP
         +yZcKlxe8oT0gtvhsuiqfh6R1MAfmzoBiLXIZJWCN3GBaA4RmCEIRbR1ZZ3cIaOATR
         JvHA00pmX2NCw+EJxQNQwsFWHhSIcr7QwEm5UZuvhfXmBkjzOdAXGK9UbG9RjZYzXI
         +jz9CdL1W9gtw==
Date:   Wed, 17 Nov 2021 20:42:14 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jordy Zomer <jordy@pwning.systems>
Cc:     linux-kernel@vger.kernel.org,
        Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        "David S. Miller" <davem@davemloft.net>,
        wengjianfeng <wengjianfeng@yulong.com>, netdev@vger.kernel.org
Subject: Re: [PATCH] nfc: st-nci: Fix potential buffer overflows in
 EVT_TRANSACTION
Message-ID: <20211117204214.5fe26708@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211117171554.2731340-1-jordy@pwning.systems>
References: <20211117171554.2731340-1-jordy@pwning.systems>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 17 Nov 2021 18:15:51 +0100 Jordy Zomer wrote:
> +
> +		// Checking if the length of the AID is valid
> +		if (transaction->aid_len > sizeof(transaction->aid))
> +			return -EINVAL;
> +
> +

Please remove the double blank lines and use more common style of
multi-line comments /* */ like the rest of this file.

Same for the other patch. Thanks!
