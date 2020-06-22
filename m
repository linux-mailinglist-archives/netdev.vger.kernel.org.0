Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7BEB12043C3
	for <lists+netdev@lfdr.de>; Tue, 23 Jun 2020 00:40:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731019AbgFVWkc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Jun 2020 18:40:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730785AbgFVWkb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Jun 2020 18:40:31 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB3A0C061573;
        Mon, 22 Jun 2020 15:40:31 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 205A61296A2B7;
        Mon, 22 Jun 2020 15:40:31 -0700 (PDT)
Date:   Mon, 22 Jun 2020 15:40:30 -0700 (PDT)
Message-Id: <20200622.154030.984476700483302206.davem@davemloft.net>
To:     dmurphy@ti.com
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, hkallweit1@gmail.com,
        robh@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org
Subject: Re: [PATCH net-next v9 1/5] dt-bindings: net: Add tx and rx
 internal delays
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200619161813.2716-2-dmurphy@ti.com>
References: <20200619161813.2716-1-dmurphy@ti.com>
        <20200619161813.2716-2-dmurphy@ti.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 22 Jun 2020 15:40:31 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dan Murphy <dmurphy@ti.com>
Date: Fri, 19 Jun 2020 11:18:09 -0500

> @@ -162,6 +162,19 @@ properties:
>      description:
>        Specifies a reference to a node representing a SFP cage.
>  
> +
> +  rx-internal-delay-ps:

Do you really want two empty lines between these two sections?
