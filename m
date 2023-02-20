Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 92E3569D71B
	for <lists+netdev@lfdr.de>; Tue, 21 Feb 2023 00:32:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232449AbjBTXcZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Feb 2023 18:32:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232039AbjBTXcY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Feb 2023 18:32:24 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1F691ADD6;
        Mon, 20 Feb 2023 15:32:23 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8B02FB80D5C;
        Mon, 20 Feb 2023 23:32:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09B9DC433D2;
        Mon, 20 Feb 2023 23:32:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676935941;
        bh=3C8uxzTPAOYSon5yitWkWX6C2ymLgEK0IoJ5AKUZ2hA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=RO8KOGA1nLzl9mhtpLENHDIc2Lx3LkxSOdSdxTNws6lsg89cxqKdzx9MiNV9ThJA/
         6jN8g/teGyYvyYeDLxnA5E8YbxhtE8uEgIXHpq+BmhMZIhF4ME1LXZipJpfbV0e4LW
         CbtFGeD0Iq6W/OZfs9m2zKEUEHNJR+EA1Kk2oCzJca9DmNPZ9nPBsDUdvx+Yzgl0tZ
         4Wtr1Ry+SdQwNc69yp9MqmVmf6CclsaLMlNnuKUAjUsEJtNWMESdpR0Wh1d9NQ8PMA
         /UDG0U4SHfp3Hw1/75xUBLfGBwm3QpC4uygHxii90hgziL4uDY6MwABqXYtwNrteFK
         a6cjPn99w+Brw==
Date:   Mon, 20 Feb 2023 15:32:19 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     netdev@vger.kernel.org, davem@davemloft.net,
        linux-can@vger.kernel.org, kernel@pengutronix.de
Subject: Re: [PATCH net-next 0/4] pull-request: can-next 2023-02-17 - fixed
Message-ID: <20230220153219.422a18a6@kernel.org>
In-Reply-To: <20230217141029.3734802-1-mkl@pengutronix.de>
References: <20230217141029.3734802-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 17 Feb 2023 15:10:25 +0100 Marc Kleine-Budde wrote:
> this is a pull request of 4 patches for net-next/master.
> 
> The first patch is by Yang Li and converts the ctucanfd driver to
> devm_platform_ioremap_resource().
> 
> The last 3 patches are by Frank Jungclaus, target the esd_usb driver
> and contains preparations for the upcoming support of the esd
> CAN-USB/3 hardware.

Appears pulled, thanks!
