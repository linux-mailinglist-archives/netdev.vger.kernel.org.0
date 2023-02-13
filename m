Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 324FA694AB0
	for <lists+netdev@lfdr.de>; Mon, 13 Feb 2023 16:14:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230013AbjBMPOq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Feb 2023 10:14:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230127AbjBMPOp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Feb 2023 10:14:45 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A43DFC173;
        Mon, 13 Feb 2023 07:14:27 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5AB50B8125B;
        Mon, 13 Feb 2023 15:14:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE0B3C433EF;
        Mon, 13 Feb 2023 15:14:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676301265;
        bh=VT0xXETSxAQXHXHhVHYBHrJk+xsZB9f5/xKh2iMx2ys=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=sat1tq04EmzulTqD7xVVAZPa11rS/H8ZBK0OBAiMuAGcdKr6JMy0kn0/IvfQ9TwWr
         AO23HsRUJE4faH8PqdM4ON3mp9RbzDH6PY0HaJVuSFUL5hZXPPe7BA/a0a1BC0iiwU
         JJ2kIK9nyeT6cVlIl9/yRSRX94KiSqmtgTn9YGEhqlMfMF/tUZZQQw0TbBS8B1tWKJ
         tn7PBKrtuW/by4s7mx1ONbzkfPJlHGJxs0xmlTS0Ra0ONVW+721Ox8/F3VyYSCvh0n
         oJgfVPmeTwfbHapOD+SuuVEz9rU76VVW+WX27mXa4au6Hm+aIt6v4yNRouI/SKCilQ
         Ystanezs7YcJA==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v4 1/4] wifi: libertas: fix code style in Marvell structs
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <20230123053132.30710-2-doug@schmorgal.com>
References: <20230123053132.30710-2-doug@schmorgal.com>
To:     Doug Brown <doug@schmorgal.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Dan Williams <dcbw@redhat.com>,
        Simon Horman <simon.horman@corigine.com>,
        libertas-dev@lists.infradead.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, Doug Brown <doug@schmorgal.com>
User-Agent: pwcli/0.1.1-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <167630125706.12830.8359712458634632160.kvalo@kernel.org>
Date:   Mon, 13 Feb 2023 15:14:22 +0000 (UTC)
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Doug Brown <doug@schmorgal.com> wrote:

> Several of the structs are using the deprecated convention of items[1]
> for a dynamically sized trailing element. Convert these structs to the
> modern C99 style of items[]. Also fix a couple of camel case struct
> element names.
> 
> Signed-off-by: Doug Brown <doug@schmorgal.com>

4 patches applied to wireless-next.git, thanks.

53d3a735875e wifi: libertas: fix code style in Marvell structs
57db1ba35736 wifi: libertas: only add RSN/WPA IE in lbs_add_wpa_tlv
5fb2a7854a9e wifi: libertas: add new TLV type for WPS enrollee IE
e6a1c4b9884f wifi: libertas: add support for WPS enrollee IE in probe requests

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20230123053132.30710-2-doug@schmorgal.com/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

