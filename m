Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 64C362654FC
	for <lists+netdev@lfdr.de>; Fri, 11 Sep 2020 00:22:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725816AbgIJWWm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Sep 2020 18:22:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725294AbgIJWWi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Sep 2020 18:22:38 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDFD1C061756;
        Thu, 10 Sep 2020 15:22:37 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 4010C135ED631;
        Thu, 10 Sep 2020 15:05:49 -0700 (PDT)
Date:   Thu, 10 Sep 2020 15:22:35 -0700 (PDT)
Message-Id: <20200910.152235.1512682061673845419.davem@davemloft.net>
To:     krzk@kernel.org
Cc:     kuba@kernel.org, robh+dt@kernel.org, k.opasiak@samsung.com,
        kgene@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-nfc@lists.01.org, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org
Subject: Re: [PATCH v3 0/8] nfc: s3fwrn5: Few cleanups
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200910161219.6237-1-krzk@kernel.org>
References: <20200910161219.6237-1-krzk@kernel.org>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Thu, 10 Sep 2020 15:05:49 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Krzysztof Kozlowski <krzk@kernel.org>
Date: Thu, 10 Sep 2020 18:12:11 +0200

> Changes since v2:
> 1. Fix dtschema ID after rename (patch 1/8).
> 2. Apply patch 9/9 (defconfig change).
> 
> Changes since v1:
> 1. Rename dtschema file and add additionalProperties:false, as Rob
>    suggested,
> 2. Add Marek's tested-by,
> 3. New patches: #4, #5, #6, #7 and #9.

Seires applied to net-next, thanks.
