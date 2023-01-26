Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 033B367D9FC
	for <lists+netdev@lfdr.de>; Fri, 27 Jan 2023 00:55:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232884AbjAZXzE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Jan 2023 18:55:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233576AbjAZXzB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Jan 2023 18:55:01 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96D79442D3;
        Thu, 26 Jan 2023 15:55:00 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3754DB81ED5;
        Thu, 26 Jan 2023 23:54:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C1F0C433D2;
        Thu, 26 Jan 2023 23:54:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674777297;
        bh=YzzzRHDL4QVRmpFOYM6QjRQ1DxLWZ3rVbZKMIqqZg+U=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=BWG0lT9TORJXN19/EG8sRb+l0wdAvpItKkRM7s1b+XgPTkpd/qdWHf2NtRjkyYUju
         +hKJ/taqIlLKS4hlcsUOy0g4WePVWDxoVvUsbBmQofJat5QQ5arl0hST/mh1N8qH/C
         x23/96voQVjM/oVENaYhR4ClJVyYAmkoGI1OzNjO5kmqVUohJtQaZ8VAQp41ZegZ8C
         Ezo4swR7Y4vq1yb9hE1PxLlGjhgnNrEhY1Zbl6/MU9tlE7zgTrMyk9sL/cQF5GuxQv
         FkXBXjadYmIjL5fxehiO++w6EeAv5VynVaxpSgG9oDKK5u9ipKuIWgtkoqG6sr8vJM
         eeb2DrZ0TqvAA==
Date:   Thu, 26 Jan 2023 15:54:56 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Arnd Bergmann <arnd@kernel.org>
Cc:     Ludovic Desroches <ludovic.desroches@microchip.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        linux-gpio@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Beznea <claudiu.beznea@microchip.com>,
        linux-kernel@vger.kernel.org, linux-mmc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, netdev@vger.kernel.org
Subject: Re: [PATCH] mmc: atmel: convert to gpio descriptos
Message-ID: <20230126155456.78e44420@kernel.org>
In-Reply-To: <20230126135034.3320638-1-arnd@kernel.org>
References: <20230126135034.3320638-1-arnd@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 26 Jan 2023 14:50:04 +0100 Arnd Bergmann wrote:
> Subject: [PATCH] mmc: atmel: convert to gpio descriptos

nit: descriptoRs
