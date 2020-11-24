Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D8302C3432
	for <lists+netdev@lfdr.de>; Tue, 24 Nov 2020 23:48:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728013AbgKXWrX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Nov 2020 17:47:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:56502 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726546AbgKXWrX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 24 Nov 2020 17:47:23 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3D69E206F7;
        Tue, 24 Nov 2020 22:47:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1606258042;
        bh=j7dE/X3pN76ALwr+9rLM+WgE9O8WkcLEkKzskJ9PPzE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=aO0/HqqVklMx1LF3C/Bpsjsw9vD3slXmL7727trxTojZeLi6DAuEN1PDfkLomHnKm
         4EFTYzbKmcoSNjGxcp5FPI0wf5oQaEWuYIk8nc4EJMG3lWM411FbhwufJp77Fyh48u
         JYDBKdwHzNWUi6gjycZC6VIg+J10zpQVyjE+nPNI=
Date:   Tue, 24 Nov 2020 14:47:21 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Rikard Falkeborn <rikard.falkeborn@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Alex Elder <elder@kernel.org>,
        Kalle Valo <kvalo@codeaurora.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, ath10k@lists.infradead.org,
        linux-wireless@vger.kernel.org
Subject: Re: [PATCH net-next 1/2] soc: qcom: ipa: Constify static qmi
 structs
Message-ID: <20201124144721.3e80698c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201122234031.33432-2-rikard.falkeborn@gmail.com>
References: <20201122234031.33432-1-rikard.falkeborn@gmail.com>
        <20201122234031.33432-2-rikard.falkeborn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 23 Nov 2020 00:40:30 +0100 Rikard Falkeborn wrote:
> These are only used as input arguments to qmi_handle_init() which
> accepts const pointers to both qmi_ops and qmi_msg_handler. Make them
> const to allow the compiler to put them in read-only memory.
> 
> Signed-off-by: Rikard Falkeborn <rikard.falkeborn@gmail.com>

I can take this one if Alex acks it.

The other patch is probably best handled by Kalle.
