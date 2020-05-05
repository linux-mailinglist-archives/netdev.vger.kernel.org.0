Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 93F7C1C615D
	for <lists+netdev@lfdr.de>; Tue,  5 May 2020 21:50:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729203AbgEETtz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 May 2020 15:49:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728804AbgEETtz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 May 2020 15:49:55 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1FA2C061A0F;
        Tue,  5 May 2020 12:49:55 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 3F6C4128061A8;
        Tue,  5 May 2020 12:49:55 -0700 (PDT)
Date:   Tue, 05 May 2020 12:49:54 -0700 (PDT)
Message-Id: <20200505.124954.501631438927946921.davem@davemloft.net>
To:     grygorii.strashko@ti.com
Cc:     robh+dt@kernel.org, netdev@vger.kernel.org, nsekhar@ti.com,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        robh@kernel.org
Subject: Re: [PATCH net-next] dt-binding: net: ti: am65x-cpts: fix
 dt_binding_check fail
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200505101935.12897-1-grygorii.strashko@ti.com>
References: <20200505101935.12897-1-grygorii.strashko@ti.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 05 May 2020 12:49:55 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Grygorii Strashko <grygorii.strashko@ti.com>
Date: Tue, 5 May 2020 13:19:35 +0300

> Fix dt_binding_check fail:
> Fix Documentation/devicetree/bindings/net/ti,k3-am654-cpts.yaml: $id: relative path/filename doesn't match actual path or filename
> 	expected: http://devicetree.org/schemas/net/ti,k3-am654-cpts.yaml#
> Unknown file referenced: [Errno 2] No such file or directory: '/usr/local/lib/python3.6/dist-packages/dtschema/schemas/net/ti,am654-cpts.yaml'
>  Documentation/devicetree/bindings/net/ti,k3-am654-cpts.yaml: $id: relative path/filename doesn't match actual path or filename
>  expected: http://devicetree.org/schemas/net/ti,k3-am654-cpts.yaml#
> Unknown file referenced: [Errno 2] No such file or directory: '/usr/local/lib/python3.6/dist-packages/dtschema/schemas/net/ti,am654-cpts.yaml'
> 
> Cc: Rob Herring <robh@kernel.org>
> Fixes: 6e87ac748e94 ("dt-binding: ti: am65x: document common platform time sync cpts module")
> Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>

Applied.
