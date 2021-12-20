Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E640647B360
	for <lists+netdev@lfdr.de>; Mon, 20 Dec 2021 20:04:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240659AbhLTTEO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Dec 2021 14:04:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235151AbhLTTEN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Dec 2021 14:04:13 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C39CC061574;
        Mon, 20 Dec 2021 11:04:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2E4D7612C8;
        Mon, 20 Dec 2021 19:04:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67500C36AE7;
        Mon, 20 Dec 2021 19:04:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1640027052;
        bh=TcpK9u8Z+5d6+oiBVnBxvQlRqM4lFld8cf67xDqD7MY=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=qU6srJYklyy2gvRq0H/nlYf56OFU0Q5Y/14lK4w6D2gC9ZoUsqIT/N4284AutPjIt
         MzWB1tOqw4Ycxu999x4ebJcrGXCqnqwTEK9BZnUr4UUnMEwNJ33BcJo5QX2nRl4rcW
         DHyhmZZlOb2OLL7W7Yb3c0Ssq0WpbmchVxwqc3FiojJhkrE5XEHjec71rJ9OvVcekt
         HIRcjf7blq9sQOd3t8GQshZLU0zUZweBT//IoN4o6G6inkM7p6j/0BvFbLETjQZBsj
         K+Vs6+OeF9rfEriO98oQPWFe/PeVV6+u+AcxWjyFDquVAfvp8EOUFRO7O2+0bWZmQ0
         lKpSm8K32qGmg==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v2] rtl8xxxu: Improve the A-MPDU retransmission rate with
 RTS/CTS protection
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <20211215085819.729345-1-chris.chiu@canonical.com>
References: <20211215085819.729345-1-chris.chiu@canonical.com>
To:     Chris Chiu <chris.chiu@canonical.com>
Cc:     Jes.Sorensen@gmail.com, kvalo@codeaurora.org, davem@davemloft.net,
        kuba@kernel.org, code@reto-schneider.ch,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Chris Chiu <chris.chiu@canonical.com>
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <164002704874.16553.13864758889503854388.kvalo@kernel.org>
Date:   Mon, 20 Dec 2021 19:04:10 +0000 (UTC)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Chris Chiu <chris.chiu@canonical.com> wrote:

> The A-MPDU TX retransmission rate is always high (> 20%) even in a very
> clean environment. However, the vendor driver retransimission rate is
> < 10% in the same test bed. The difference is the vendor driver starts
> the A-MPDU TXOP with initial RTS/CTS handshake which is observed in the
> air capture and the TX descriptor. Since the driver does not know how
> many frames will be aggregated and the estimated duration, forcing the
> RTS/CTS protection for A-MPDU helps to lower the retransmission rate
> from > 20% to ~12% in the same test setup with the vendor driver.
> 
> Signed-off-by: Chris Chiu <chris.chiu@canonical.com>

Patch applied to wireless-drivers-next.git, thanks.

b250200e2ee4 rtl8xxxu: Improve the A-MPDU retransmission rate with RTS/CTS protection

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20211215085819.729345-1-chris.chiu@canonical.com/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

